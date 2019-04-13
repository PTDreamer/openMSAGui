/**
 ******************************************************************************
 *
 * @file       markerfactory.cpp
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      markerfactory.cpp file
 * @see        The GNU Public License (GPL) Version 3
 * @defgroup   markerFactory
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
#include "markerfactory.h"

markerFactory::markerFactory(QQmlApplicationEngine *parent, QObject *scope) : QObject(parent), engine(parent)
  ,m_scope(scope)
{

}

void markerFactory::addMarker(qreal frequency)
{
	QQmlComponent component(engine, QUrl("qrc:/qml/marker.qml"));
	QQuickItem *object = qobject_cast<QQuickItem*>(component.create());
	QQmlEngine::setObjectOwnership(object, QQmlEngine::CppOwnership);

	object->setParentItem(qobject_cast<QQuickItem*>(m_scope));
	object->setParent(engine);
	markerX *x = qobject_cast<markerX*>(object);
	x->setChart(m_scope);
	x->setLegend1("WTF");
	x->setNumber("69");
	markers.insert(frequency, x);
}

bool markerFactory::removeMarker(qreal frequency)
{
	if(!markers.keys().contains(frequency))
		return false;
	delete markers.value(frequency);
	markers.remove(frequency);
}

void markerFactory::removeAllMarkers()
{
	qDeleteAll(markers);
	markers.clear();
}
