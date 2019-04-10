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

#ifndef DATASOURCE_H
#define DATASOURCE_H

#include <QtCore/QObject>
#include <QtCharts/QAbstractSeries>
#include <QTcpSocket>
#include <QAbstractSocket>
#include "../openmsa/shared/comprotocol.h"
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
	explicit DataSource(QObject *parent = nullptr);

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
	void generateData(int type, int rowCount, int colCount);

private:
    QQuickView *m_appViewer;
    QList<QVector<QPointF> > m_data;
    int m_index;
public slots:
	void connected();
	void disconnected();
	void bytesWritten(qint64 bytes);
    void packetReceived(ComProtocol::messageType, QByteArray);
	void update(QAbstractSeries *series);
	void update2(QAbstractSeries *series);
	void handleScanChanges(int meta = 0);
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
