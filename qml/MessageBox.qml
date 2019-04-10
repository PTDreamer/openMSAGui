import QtQuick 2.0


import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Imagine 2.12
import QtQuick.Controls 2.5

Item {
    id:msg_id
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100
    anchors.horizontalCenter: parent.horizontalCenter
    width: outline.width
    height: outline.height
    property string text: "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    property string errorText: ""
    visible: text.length > 0 || errorText > 0
    Rectangle {
        id:outline
        width: 500
        height: 100
        anchors.fill: parent
        color: "transparent"
        border.color: "white";
        Rectangle {
            anchors.fill: parent
            color: "grey"
            opacity: 0.6
        }
        Item {
            anchors.fill: parent
            anchors.margins: 10
        Text {
            opacity: 1
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height / 2
            id: message
            text: msg_id.text;
        }
        Text {
            opacity: 1
            color: "red"
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height / 2
            id: messageError
            text: msg_id.errorText;
        }
        }
    }
}
