import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Imagine 2.12
import QtQuick.Window 2.12
import QtCharts 2.3
import QtQuick.Controls.Styles 1.4
import QtQml.StateMachine 1.12

Item {
    id:settingsItem
    width: 300
    height: 200
    anchors.centerIn: parent
    Rectangle {
        anchors.fill: parent
        border.color: "white";
        color: "black"
    }        z:3
    ColumnLayout{
        RowLayout {
            Layout.leftMargin: 5
            Layout.topMargin: 5
            Label {
                text: "Server IP:"
            }
            TextField {
                text: AppSettings.AppSettings.ip
                background: Rectangle {
                    radius: 2
                    border.color: "#333"
                    border.width: 1
                }
                onTextChanged: AppSettings.AppSettings.ip = text
                placeholderText: qsTr("Enter server IP")
                onEditingFinished: {
                        AppSettings.AppSettings.ip = text
                    }
                validator: RegExpValidator {
                    regExp:  /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
                }
                color: "black"
                font.pointSize: 20

            }
        }
        RowLayout {
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Label {
                text: "Server Port:"
            }
            TextField {
                text: AppSettings.AppSettings.port
                background: Rectangle {
                    radius: 2
                    border.color: "#333"
                    border.width: 1
                }
                onTextChanged: AppSettings.AppSettings.port = text
                placeholderText: qsTr("Enter server port")
                onEditingFinished: {
                        AppSettings.AppSettings.port = text
                }
                validator: RegExpValidator {
                    regExp:  /^\d+$/
                }
                color: "black"
                font.pointSize: 20
                Layout.preferredWidth: 80
            }
        }
        RowLayout {
            Layout.leftMargin: 5
            Layout.alignment: Qt.AlignLeft
            Label {
                text: qsTr("Auto Reconnect to server")
            }
            SwitchDelegate {
                checked: AppSettings.AppSettings.autoReconnect
                onCheckedChanged: AppSettings.AppSettings.autoReconnect = checked
            }
        }
    }
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        Layout.margins: 10
        Layout.alignment: Qt.AlignHCenter

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Save"
            onClicked:  {
                AppSettings.saveSettings()
                settingsItem.visible = false
            }
        }
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Cancel"
            onClicked:  {
                settingsItem.visible = false
                AppSettings.getSettings()
            }
        }
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Load Defaults"
            onClicked: AppSettings.getSettings(true)
        }
    }
}
