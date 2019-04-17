/**
 ******************************************************************************
 *
 * @file       settings.h
 * @author     Jose Barros (AKA PT_Dreamer) josemanuelbarros@gmail.com 2019
 * @brief      settings.h file
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
#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

struct appSettings_t {
   Q_GADGET
public:
	QString m_ip;
	bool m_autoReconnect;
	quint16 m_port;
	Q_PROPERTY(QString ip MEMBER m_ip)
	Q_PROPERTY(bool autoReconnect MEMBER m_autoReconnect)
	Q_PROPERTY(quint16 port MEMBER m_port)
};
Q_DECLARE_METATYPE(appSettings_t)
class settings : public QObject
{
	Q_OBJECT
	Q_PROPERTY(appSettings_t AppSettings READ getAppSettings
				WRITE setAppSettings NOTIFY appSettingsChanged)

public:
	explicit settings(QObject *parent = nullptr);
	 appSettings_t getAppSettings() const;
	 void setAppSettings(const appSettings_t &value);
	 appSettings_t appSettings;

signals:
	 void appSettingsChanged();
public slots:
	 void saveSettings();
	 void getSettings(bool defaults=false);
private:
	 QSettings m_settings;
};

#endif // SETTINGS_H
