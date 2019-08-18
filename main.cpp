/**
 ******************************************************************************
 *
 * @file       main.cpp
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      main.cpp file
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

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QIcon>
#include "datasource.h"
#include <markerx.h>
#include <QQuickWindow>
#include <markerfactory.h>
#include "settings.h"

int main(int argc, char *argv[])
{
	QQuickStyle::setStyle("Imagine");
	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
	QApplication app(argc, argv);
	app.setWindowIcon(QIcon(":/icons/smith_chart_red.png"));
	app.setOrganizationName("JBTech");
	app.setApplicationName("openMSAGui");
	app.setApplicationVersion("1.0.0");

	QIcon::setThemeName("automotive");
	QQmlApplicationEngine engine;
	settings m_settings;
	DataSource dataSource(&m_settings, &engine);
	qmlRegisterType<markerX>("JBstuff",	1,	0,	"Marker");
	engine.rootContext()->setContextProperty("dataSource", &dataSource);
	engine.rootContext()->setContextProperty("AppSettings",&m_settings);

	engine.load(QUrl("qrc:/qml/main.qml"));
	if (engine.rootObjects().isEmpty())
		return -1;

	QObject *scope = engine.rootObjects().at(0)->findChild<QObject*>("scope");
	dataSource.setScope(scope);
	dataSource.setButtons(engine.rootObjects().at(0)->findChild<QObject*>("buttons"));

	markerFactory factory(&engine, scope);
	factory.addMarker(0);
	return app.exec();
}
