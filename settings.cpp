/**
 ******************************************************************************
 *
 * @file       settings.cpp
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      settings.cpp file
 * @see        The GNU Public License (GPL) Version 3
 * @defgroup   settings
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
#include "settings.h"

settings::settings(QObject *parent) : QObject(parent)
{
	appSettings.m_ip = "127.0.0.1";
	qRegisterMetaType<appSettings_t>("appSettings_t");
	qRegisterMetaTypeStreamOperators<appSettings_t>("appSettings_t");
	getSettings();
}

void settings::saveSettings() {
	m_settings.setValue("settings", qVariantFromValue(appSettings));
	emit appSettingsChanged();
}

void settings::getSettings(bool defaults) {
	QVariant var = m_settings.value("settings");
	if (var.isValid() && !defaults) {
		appSettings = var.value<appSettings_t>();
	}
	else {
		appSettings.m_ip = "127.0.0.1";
		appSettings.m_autoReconnect = true;
		appSettings.m_port = 1234;
	}
	emit appSettingsChanged();
}

QDataStream &operator<<(QDataStream &out, const appSettings_t &obj)
{
	out << obj.m_ip << QVariant(obj.m_autoReconnect) << QVariant(obj.m_port);
	return out;
}

QDataStream &operator>>(QDataStream &in, appSettings_t &obj)
{
	QVariant rec;
	QVariant po;
   in >> obj.m_ip >> rec >> po;
   obj.m_autoReconnect = rec.toBool();
   obj.m_port = quint16(po.toUInt());
   return in;
}

appSettings_t settings::getAppSettings() const
{
	return appSettings;
}

void settings::setAppSettings(const appSettings_t &value)
{
	appSettings = value;
}
