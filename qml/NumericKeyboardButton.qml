import QtQuick 2.0
import "NumericKeyboardLogic.js" as Keyboard
Item {
    id: button
    property alias text: textItem.text
    property color color: "#eceeea"

    property bool operator: false
    property bool dimmable: false
    property bool dimmed: false
    property bool checkbox: false
    property bool checked: false
    width: textItem.width
    height: textItem.height

    Text {
        id: textItem
        font.pixelSize: 48
        wrapMode: Text.WordWrap
        lineHeight: 0.75
        color: (dimmable && dimmed) ? Qt.darker(button.color) : button.color
        Behavior on color { ColorAnimation { duration: 120; easing.type: Easing.OutElastic} }
        states: [
            State {name: "pressed"
                when: mouse.pressed && !dimmed
                PropertyChanges {
                    target: textItem
                    color: "green"
                }
            },
            State {name: "checked"
                when: mouse.pressed && checkbox
                PropertyChanges {
                    target: textItem
                    color: Qt.lighter(button.color)
                }
            }
        ]
    }
    function onKey() {
        if (operator)
            Keyboard.operatorPressed(textItem.text)
        else
            Keyboard.digitPressed(textItem.text)
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.margins: -5
        onClicked: {
            if (operator)
                Keyboard.operatorPressed(parent.text)
            else
                Keyboard.digitPressed(parent.text)
        }
    }
}
