/**
 ******************************************************************************
 *
 * @file       datasource.h
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      file
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

#ifndef DATASOURCE_H
#define DATASOURCE_H

#include <QtCore/QObject>
#include <QtCharts/QAbstractSeries>
#include <QTcpSocket>
#include <QAbstractSocket>
#include "../openmsa/shared/comprotocol.h"
#include "settings.h"

QT_BEGIN_NAMESPACE
class QQuickView;
QT_END_NAMESPACE

QT_CHARTS_USE_NAMESPACE

class DataSource : public QObject
{
    Q_OBJECT
	Q_PROPERTY(QString infoText READ getInfoText WRITE setInfoText NOTIFY infoTextChanged)
	Q_PROPERTY(QString errorText READ getErrorText WRITE setErrorText NOTIFY errorTextChanged)
public:
	explicit DataSource(settings *settings, QObject *parent = nullptr);

	QObject *getScope() const;
	void setScope(QObject *value);

	QObject *getButtons() const;
	void setButtons(QObject *value);

	QString getInfoText() const;
	void setInfoText(const QString &value);

	QString getErrorText() const;
	void setErrorText(const QString &value);

Q_SIGNALS:
signals:
	void infoTextChanged(QString);
	void errorTextChanged(QString);
public slots:

private:
    QQuickView *m_appViewer;
    QList<QVector<QPointF> > m_data;
    int m_index;
	settings *m_settings;
public slots:
	void connected();
	void disconnected();
	void bytesWritten(qint64 bytes);
    void packetReceived(ComProtocol::messageType, QByteArray);
	void update(QAbstractSeries *series);
	void update2(QAbstractSeries *series);
	void handleScanChanges(int meta = 0);
	void updateSettings();
private:
	bool suspendChangesSignal;
	QObject *scope;
	QObject *buttons;
    ComProtocol *client;
	bool newScanConfig;
	double scanStepMHZ;
	double scanStarMHZ;
	QHash<unsigned int, double> finalFiltersBW; // in MHz
	unsigned int currentFinalFilter;
	QString InfoText;
	QString ErrorText;
	void handleErrors(QStringList list, QStringList fatal);
};

#endif // DATASOURCE_H
