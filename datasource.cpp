/**
 ******************************************************************************
 *
 * @file       datasource.cpp
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief       file
 * @see        The GNU Public License (GPL) Version 3
 * @defgroup
 * @{
 *
 *****************************************************************************/
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, see <http://www.gnu.org/licenses/>
 */

#include "datasource.h"
#include <QtCharts/QXYSeries>
#include <QtCharts/QAreaSeries>
#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QtCore/QDebug>
#include <QtCore/QtMath>

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

DataSource::DataSource(settings *settings, QObject *parent) :
    QObject(parent),
	m_index(-1),
	m_settings(settings),
	suspendChangesSignal(false),
	scope(nullptr),
	buttons(nullptr),
	newScanConfig(false)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();

	client = new ComProtocol(this, 0);
	updateSettings();
	bool connected = client->connectToServer();
    qDebug() << "Is client connected:" << connected;
	connect(m_settings, &settings::appSettingsChanged, this, &DataSource::updateSettings);
	connect(client, &ComProtocol::packetReceived, this, &DataSource::packetReceived);
}

void DataSource::update(QAbstractSeries *series)
{
	if (series && !m_data.isEmpty()) {
		QXYSeries *xySeries = static_cast<QXYSeries *>(series);
		QVector<QPointF> points = m_data.at(0);
		QList<QPointF> pp = xySeries->points();
		// Use replace instead of clear + append, it's optimized for performance
		xySeries->replace(points);
	}
}
void DataSource::update2(QAbstractSeries *series)
{
	if (series) {
		QXYSeries *xySeries = static_cast<QXYSeries *>(series);
		m_index++;
		if (m_index > m_data.count() - 1)
			m_index = 0;
		if(m_data.size() <= 1)
			return;
		QVector<QPointF> points = m_data.at(1);
		QList<QPointF> pp = xySeries->points();
		// Use replace instead of clear + append, it's optimized for performance
		xySeries->replace(points);
	}
}

void DataSource::handleScanChanges(int meta)
{
	if(!suspendChangesSignal && buttons) {
		qDebug() << "handleScanChanges";
		QStringList error;
		QStringList fatalerror;
		//items: ["SA", "VNA\nTransmission", "VNA\nReflection", "SNA"]
		uint scanType = buttons->property("scanType").toUInt();
		qDebug() << "scantype:" << scanType;
		bool isStartStopMode =buttons->property("isStartStopMode").toBool();
		quint32 freqStartMult = buttons->property("freq_start_mult").toUInt();
		double freqStartVal = buttons->property("freq_start_val").toDouble();
		quint32 freqStopMult = buttons->property("freq_stop_mult").toUInt();
		double freqStopVal = buttons->property("freq_stop_val").toDouble();
		quint32 freqCenterMult = buttons->property("freq_center_mult").toUInt();
		double freqCenterVal = buttons->property("freq_center_val").toDouble();
		quint32 freqSpanMult = buttons->property("freq_span_mult").toUInt();
		double freqSpanVal = buttons->property("freq_span_val").toDouble();
		quint32 freqStepMult = buttons->property("freq_step_mult").toUInt();
		double freqStepVal = buttons->property("freq_step_val").toDouble();
		bool stepModeAuto = buttons->property("frequencyStepModeAuto").toBool();
		uint scanInvi = buttons->property("scanInverted").toUInt();
		bool scanInv = scanInvi == 1;
		quint32 sgOffsetMult = buttons->property("sg_freq_or_offset_mult").toUInt();
		double sgOffsetVal = buttons->property("sg_freq_or_offset_val").toDouble();
		double startFreq = freqStartVal * freqStartMult / 1000000;
		double stopFreq = freqStopVal * freqStopMult / 1000000;
		double centerFreq = freqCenterVal * freqCenterMult / 1000000;
		double spanFreq = freqSpanVal * freqSpanMult / 1000000;
		double stepFreq;
		quint32 stepNumber = 0;

		if(isStartStopMode == false || (isStartStopMode == true && meta == 1)) {
			startFreq = centerFreq - spanFreq / 2;
			stopFreq = centerFreq + spanFreq / 2;
		} else {
			spanFreq = stopFreq - startFreq;
			centerFreq = startFreq + spanFreq / 2;
		}

		if(freqStepMult != 0) {
			stepFreq = freqStepVal * freqStepMult;
			stepNumber = (stopFreq - startFreq) / stepFreq;
		}
		else if(freqSpanVal != 0) {
			stepFreq = (stopFreq - startFreq) / freqStepVal;
			stepNumber = freqStepVal;
		}
		else {
			stepFreq = 0;
		}

		if(startFreq > stopFreq) {
			error.append(tr("Start frequency is higher than stop frequency"));
			fatalerror.append(tr("No command will be performed until the errors are fixed"));
		}
		if(finalFiltersBW.size() && finalFiltersBW.value(currentFinalFilter) < stepFreq) {
			error.append(tr("Step frequency is higher than the current final filter/nbandwidth, signals may be lost"));
		}
		handleErrors(error, fatalerror);
		if(fatalerror.length())
			return;
		ComProtocol::msg_scan_config cfg;
		cfg.start = startFreq;
		cfg.stop = stopFreq;
		cfg.step_freq = stepFreq;;
		cfg.start_multi = freqStartMult;
		cfg.stop_multi = freqStopMult;
		cfg.step_freq_multi = freqStepMult;
		cfg.center_freq = centerFreq;
		cfg.center_freq_multi = freqCenterMult;
		cfg.span_freq = spanFreq;
		cfg.span_freq_multi = freqSpanMult;
		cfg.steps_number = stepNumber;
		//cfg.scanType = ComProtocol::scanType_t(scanType);
		cfg.isStepInSteps = (buttons->property("freq_step_mult").toUInt() == 0);
		cfg.stepModeAuto =stepModeAuto;
		cfg.isInvertedScan = scanInv;
		//cfg.band;
		uint sgType = buttons->property("siggen_function").toUInt();
		cfg.TGreversed = sgType == 3;
		//items: ["SA", "VNA\nTransmission", "VNA\nReflection", "SNA"]
		if(ComProtocol::scanType_t(scanType) == 0) {
			switch (sgType) {
			case 0:
				cfg.scanType = ComProtocol::SA;
				break;
			case 1:
				cfg.scanType = ComProtocol::SA_SG;
				break;
			case 2:
				cfg.scanType = ComProtocol::SA_TG;
			}
		}//items: ["SA", "VNA\nTransmission", "VNA\nReflection", "SNA"]
		else if (ComProtocol::scanType_t(scanType) == 1) {
			cfg.scanType = ComProtocol::VNA_Trans;
		}
		else if (ComProtocol::scanType_t(scanType) == 2) {
			cfg.scanType = ComProtocol::VNA_Rec;
		}
		else if (ComProtocol::scanType_t(scanType) == 3) {
			cfg.scanType = ComProtocol::SNA;
		}
		cfg.TGoffset = sgOffsetVal * sgOffsetMult / 1000000; //tracking generator offset
		cfg.TGoffset_multi = sgOffsetMult;
		cfg.SGout = sgOffsetVal * sgOffsetMult / 1000000; //signal generator output frequency
		cfg.SGout_multi = sgOffsetMult;
		cfg.band = -1; //TODO
		client->sendMessage(ComProtocol::SCAN_CONFIG, ComProtocol::MESSAGE_SEND, &cfg);
	}
}

void DataSource::updateSettings()
{
	client->setServerPort(m_settings->getAppSettings().m_port);
	client->setServerAddress(m_settings->getAppSettings().m_ip);
	client->setAutoClientReconnection(m_settings->getAppSettings().m_autoReconnect);
}

QString DataSource::getErrorText() const
{
	return ErrorText;
}

void DataSource::setErrorText(const QString &value)
{
	ErrorText = value;
}
void DataSource::handleErrors(QStringList list, QStringList fatal) {
	QString s = list.join("/n");
	QString e = fatal.join("/n");
	setInfoText(s);
	setErrorText(e);
	qDebug() << getInfoText() << getErrorText();
	emit errorTextChanged(e);
	emit infoTextChanged(s);
}
QString DataSource::getInfoText() const
{
	return InfoText;
}

void DataSource::setInfoText(const QString &value)
{
	InfoText = value;
}

QObject *DataSource::getButtons() const
{
	return buttons;
}

void DataSource::setButtons(QObject *value)
{
	buttons = value;
}
QObject *DataSource::getScope() const
{
	return scope;
}

void DataSource::setScope(QObject *value)
{
	scope = value;
}

void DataSource::connected()
{

}

void DataSource::disconnected()
{

}

void DataSource::bytesWritten(qint64 bytes)
{

}

void DataSource::packetReceived(ComProtocol::messageType type, QByteArray array)
{
	QString str;
	QStringList errorString;
	QStringList infoString;
    ComProtocol::msg_dual_dac dd;
    ComProtocol::messageType ttype;
    ComProtocol::messageCommandType command;
	bool error;
    quint32 msgNumber;
    switch (type) {
        case ComProtocol::DUAL_DAC:
			client->unpackMessage(array, ttype, command, msgNumber, &dd);
			if(m_data.length() > 1 && m_data[0].length() > dd.step && m_data[1].length() > dd.step ) {
				m_data[0][int(dd.step)].setY(dd.mag);
				m_data[0][int(dd.step)].setX(scanStarMHZ + dd.step * scanStepMHZ);
				m_data[1][int(dd.step)].setY(dd.phase);
				m_data[1][int(dd.step)].setX(scanStarMHZ + dd.step * scanStepMHZ);
			}
		break;
	case ComProtocol::ERROR_INFO:
		ComProtocol::msg_error_info err;
		error = client->unpackMessage(array, ttype, command, msgNumber, &err);
		str = QString(err.text);
		infoString.append(str);
		if(err.isCritical)
			errorString.append("The hardware is in an error state");
		handleErrors(infoString, errorString);
		break;
		case ComProtocol::SCAN_CONFIG:
			suspendChangesSignal = true;
			foreach (QVector<QPointF> row, m_data)
				row.clear();
			ComProtocol::msg_scan_config cfg;
			error = client->unpackMessage(array, ttype, command, msgNumber, &cfg);
			scope->setProperty("startFrequency", cfg.start);
			scope->setProperty("stopFrequency", cfg.stop);
			scanStepMHZ = cfg.step_freq;
			scanStarMHZ = cfg.start;
			newScanConfig = true;
			qDebug() << cfg.start << cfg.stop;
			QVector<QPointF> v;
			foreach (QVector<QPointF> row, m_data)
				row.clear();
			m_data.clear();
			for (quint32 x = 0;x < cfg.steps_number;++x) {
				QPointF p;
				p.setX(x * scanStepMHZ);
				p.setY(0);
				v.append(p);
			}
			m_data.append(v);
			m_data.append(v);
			buttons->setProperty("freq_start_mult", cfg.start_multi);
			buttons->setProperty("freq_start_val", cfg.start * 1000000 / cfg.start_multi);
			buttons->setProperty("freq_stop_mult", cfg.start_multi);
			buttons->setProperty("freq_stop_val", cfg.stop * 1000000 / cfg.stop_multi);
			buttons->setProperty("freq_center_mult", cfg.center_freq_multi);
			buttons->setProperty("freq_center_val", cfg.center_freq * 1000000 / cfg.stop_multi);
			buttons->setProperty("freq_span_mult", cfg.span_freq_multi);
			buttons->setProperty("freq_span_val", cfg.span_freq * 1000000 / cfg.span_freq_multi);
			if(!cfg.isStepInSteps) {
				buttons->setProperty("freq_step_mult", cfg.step_freq_multi);
				buttons->setProperty("freq_step_val", cfg.step_freq * 1000000 / cfg.step_freq_multi);
			}
			else {
				buttons->setProperty("freq_step_mult", 0);
				buttons->setProperty("freq_step_val", cfg.steps_number);
			}
		//	typedef enum {SA, SA_TG, SA_SG,  VNA_Trans, VNA_Rec, SNA} scanType_t;
		//items: ["SA", "VNA\nTransmission", "VNA\nReflection", "SNA"]
			switch (cfg.scanType) {
			case ComProtocol::SA:
			case ComProtocol::SA_SG:
			case ComProtocol::SA_TG:
				buttons->setProperty("scanType", 0);
				break;
			case ComProtocol::VNA_Trans:
				buttons->setProperty("scanType", 1);
				break;
			case ComProtocol::VNA_Rec:
				buttons->setProperty("scanType", 2);
				break;
			case ComProtocol::SNA:
				buttons->setProperty("scanType", 3);
				break;
			default:
				buttons->setProperty("scanType", 0);
				break;
			}
			buttons->setProperty("frequencyStepModeAuto", cfg.stepModeAuto);
			buttons->setProperty("scanInverted", int(cfg.isInvertedScan));
//			items: ["Off", "SG", "TG", "TG-Inv"];
			double dtemp = 0;
			quint32 qtemp = 0;
			switch (cfg.scanType) {
			case ComProtocol::SA:
				buttons->setProperty("siggen_function", 0);
				break;
			case ComProtocol::SA_SG:
				dtemp = cfg.SGout;
				qtemp = cfg.SGout_multi;
				dtemp = dtemp * 1000000 / qtemp;
				buttons->setProperty("sg_freq_or_offset_mult", qtemp);
				buttons->setProperty("sg_freq_or_offset_val", dtemp);
				buttons->setProperty("siggen_function", 1);
				break;
			case ComProtocol::SA_TG:
				dtemp =cfg.TGoffset;
				qtemp = cfg.TGoffset_multi;
				dtemp = dtemp * 1000000 / qtemp;
				buttons->setProperty("sg_freq_or_offset_mult", qtemp);
				buttons->setProperty("sg_freq_or_offset_val", dtemp);
				if(cfg.TGreversed)
					buttons->setProperty("siggen_function", 3);
				else
					buttons->setProperty("siggen_function", 2);

				break;
			default:
				buttons->setProperty("siggen_function", 0);
				break;
			}
			buttons->setProperty("scanInverted", cfg.isInvertedScan);
			suspendChangesSignal = false;
		break;
	}
}
