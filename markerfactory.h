/**
 ******************************************************************************
 *
 * @file       markerfactory.h
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      markerfactory.h file
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
#ifndef MARKERFACTORY_H
#define MARKERFACTORY_H

#include <QObject>
#include "markerx.h"
#include <QQmlApplicationEngine>

class markerFactory : public QObject
{
	Q_OBJECT
public:
	explicit markerFactory(QQmlApplicationEngine *parent, QObject *scope);
	void addMarker(qreal frequency);
	bool removeMarker(qreal frequency);
	void removeAllMarkers();
signals:

public slots:
private:
	QHash<qreal, markerX*>markers;
	QQmlApplicationEngine *engine;
	QObject *m_scope;
};

#endif // MARKERFACTORY_H
