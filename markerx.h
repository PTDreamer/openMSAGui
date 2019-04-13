/**
 ******************************************************************************
 *
 * @file       markerx.h
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      markerx.h file
 * @see        The GNU Public License (GPL) Version 3
 * @defgroup   markerX
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
#ifndef MARKERX_H
#define MARKERX_H


#include <QQuickItem>
#include <QColor>
#include <QAbstractSeries>
#include <QXYSeries>

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QXYSeries *)
class markerX : public QQuickItem {
  Q_OBJECT
	Q_PROPERTY(QColor color READ getColor WRITE setColor NOTIFY colorChanged)
	Q_PROPERTY(QString legend1 READ getLegend1 WRITE setLegend1 NOTIFY legend1Changed)
	Q_PROPERTY(QString legend2 READ getLegend2 WRITE setLegend2 NOTIFY legend2Changed)
	Q_PROPERTY(QString number READ getNumber WRITE setNumber NOTIFY numberChanged)
	Q_PROPERTY(qreal frequency READ getFrequency WRITE setFrequency NOTIFY frequencyChanged)

public:
  markerX(QQuickItem *parent = 0);

  QColor getColor() const;
  void setColor(const QColor &value);
  QString getLegend1() const;
  void setLegend1(const QString &value);

  QString getLegend2() const;
  void setLegend2(const QString &value);
  QString getNumber() const;
  void setNumber(const QString &value);

  void setChart(QObject *value);

  qreal getFrequency() const;
  void setFrequency(const qreal &value);

signals:
  void colorChanged(QColor val);
  void legend1Changed(QString val);
  void legend2Changed(QString val);
  void numberChanged(QString val);
  void frequencyChanged(qreal value);
protected:
  QSGNode *updatePaintNode(QSGNode *oldNode,UpdatePaintNodeData *data) override;
private slots:
  void pointReplaced(int val);
  void update();
private:
  QColor color;
  QString legend1;
  QString legend2;
  QString number;
  QObject *chart;
  QXYSeries* magSeries;
  qreal frequency;
  QPointF currentPoint;
};

#endif // MARKERX_H
