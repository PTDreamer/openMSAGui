/**
 ******************************************************************************
 *
 * @file       marker.cpp
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      markerx.cpp file
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
#include "markerx.h"
#include <QDebug>
#include <QSGFlatColorMaterial>
#include <QSGGeometryNode>
#include <QTimer>

markerX::markerX(QQuickItem *parent) : QQuickItem(parent)
{
	setFlag(QQuickItem::ItemHasContents, true);
	this->setX(200);
	this->setY(200);
	this->setWidth(10);
	this->setHeight(10);
	setColor(Qt::red);
	setNumber("1");
	setLegend1("");
	setLegend2("");
	setFrequency(0);
}

QSGNode *markerX::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
	if (width() <= 0 || height() <= 0) {
		delete oldNode;
		return nullptr;
	}
	QSGGeometryNode *triangle = static_cast<QSGGeometryNode *>(oldNode);
	if (!triangle) {
		triangle = new QSGGeometryNode;
		triangle->setFlag(QSGNode::OwnsMaterial, true);
		triangle->setFlag(QSGNode::OwnsGeometry, true);
	}
	QSGGeometry *geometry
		= new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 5);
	QSGGeometry::Point2D *points = geometry->vertexDataAsPoint2D();
	points[0].x = 0;
	points[0].y = 5;
	points[1].x = 5;
	points[1].y = 10;
	points[2].x = 10;
	points[2].y = 5;
	points[3].x = 5;
	points[3].y = 0;
	points[4].x = 0;
	points[4].y = 5;
	geometry->setLineWidth(2);
	geometry->setDrawingMode(QSGGeometry::DrawLineStrip);
	triangle->setGeometry(geometry);
	QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
	material->setColor(color);
	triangle->setMaterial(material);
	return triangle;
}

void markerX::pointReplaced(int val)
{
	qDebug() << val;
}

void markerX::update()
{
	for (int x = 0; x < magSeries->points().length(); ++x) {
		if (magSeries->points().at(x).x() >= frequency) {
			currentPoint = magSeries->points().at(x);
			break;
		}
	}
	QPointF f;
	QMetaObject::invokeMethod(
		chart, "mapToPosition", Qt::AutoConnection, Q_RETURN_ARG(QPointF, f),
		Q_ARG(QPointF, currentPoint),
		Q_ARG(QAbstractSeries *, magSeries));
	this->setX(f.x() - width() / 2);
	this->setY(f.y() - height() / 2);
}

qreal markerX::getFrequency() const
{
	return frequency;
}

void markerX::setFrequency(const qreal &value)
{
	frequency = value;
}

void markerX::setChart(QObject *value)
{
	chart = value;
	QAbstractSeries *series;
	QMetaObject::invokeMethod(
		value, "series", Qt::AutoConnection,
		Q_RETURN_ARG(QAbstractSeries *, series),
		Q_ARG(
			int,
			0)); // Get first series in ChartView; series method expect an integer

	magSeries = static_cast<QXYSeries *>(series);
	connect(magSeries, &QXYSeries::pointAdded, this, &markerX::pointReplaced);
	connect(magSeries, &QXYSeries::pointsReplaced, this, &markerX::update);

	qDebug() << magSeries->points();
}

QString markerX::getNumber() const
{
	return number;
}

void markerX::setNumber(const QString &value)
{
	number = value;
	emit numberChanged(value);
}

QString markerX::getLegend2() const
{
	return legend2;
}

void markerX::setLegend2(const QString &value)
{
	legend2 = value;
	emit legend2Changed(value);
}

QString markerX::getLegend1() const
{
	return legend1;
}

void markerX::setLegend1(const QString &value)
{
	legend1 = value;
	emit legend1Changed(value);
}

QColor markerX::getColor() const
{
	return color;
}

void markerX::setColor(const QColor &value)
{
	color = value;
	emit colorChanged(value);
}
