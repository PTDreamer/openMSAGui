/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

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

DataSource::DataSource(QObject *parent) :
    QObject(parent),
	m_index(-1),
	scope(nullptr),
	buttons(nullptr),
	newScanConfig(false)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();

    generateData(0, 5, 1024);

	client = new ComProtocol(this, 3);
    client->setServerPort(1234);
	client->setServerAddress("127.0.0.1");
    client->setAutoClientReconnection(true);
	bool connected = client->connectToServer();
    qDebug() << "Is client connected:" << connected;

	connect(client, &ComProtocol::packetReceived, this, &DataSource::packetReceived);
}

void DataSource::update(QAbstractSeries *series)
{
	if (series) {
		QXYSeries *xySeries = static_cast<QXYSeries *>(series);
		m_index++;
		if (m_index > m_data.count() - 1)
			m_index = 0;

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
    ComProtocol::msg_dual_dac dd;
    ComProtocol::messageType ttype;
    ComProtocol::messageCommandType command;
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
		case ComProtocol::SCAN_CONFIG:
			foreach (QVector<QPointF> row, m_data)
				row.clear();
			ComProtocol::msg_scan_config cfg;
			client->unpackMessage(array, ttype, command, msgNumber, &cfg);
			scope->setProperty("startFrequency", cfg.start);
			scope->setProperty("stopFrequency", cfg.stop);
			scanStepMHZ = cfg.step_freq;
			scanStarMHZ = cfg.start;
			newScanConfig = true;
			qDebug() << cfg.start << cfg.stop;
			QVector<QPointF> v;
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
			//TODO isInverted
		break;
	}
}

void DataSource::generateData(int type, int rowCount, int colCount)
{
	foreach (QVector<QPointF> row, m_data)
		row.clear();
	m_data.clear();

	QVector<QPointF> v;
	for(int x = 0; x < 2000; ++x) {
		QPointF p;
		p.setX(x);
		p.setY(0);
		v.append(p);
	}
	m_data.append(v);
	return;
    // Remove previous data
    foreach (QVector<QPointF> row, m_data)
        row.clear();
    m_data.clear();

    // Append the new data depending on the type
    for (int i(0); i < rowCount; i++) {
        QVector<QPointF> points;
        points.reserve(colCount);
        for (int j(0); j < colCount; j++) {
            qreal x(0);
            qreal y(0);
            switch (type) {
            case 0:
                // data with sin + random component
                y = qSin(3.14159265358979 / 50 * j) + 0.5 + (qreal) rand() / (qreal) RAND_MAX;
                x = j;
                break;
            case 1:
                // linear data
                x = j;
                y = (qreal) i / 10;
                break;
            default:
                // unknown, do nothing
                break;
            }
            points.append(QPointF(x, y));
        }
        m_data.append(points);
    }
}
