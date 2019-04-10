import QtQuick 2.0
import "UnitSelectorLogic.js" as Keyboard
Item {
    id: button
    property alias text: textItem.text
    property color color: "#eceeea"

    property bool operator: false
    property bool dimmable: false
    property bool dimmed: false
    property bool checkbox: false
    property bool checked: false
    property int multiplier: 1
    property bool isSubmit: false
    property bool isCancel: false
    width: textItem.width
    height: textItem.height
    signal clicked
    signal submit
    signal cancel
    function onKey() {
        if(button.checkbox) {
        button.clicked()
        checked = true
        }
        if(button.isSubmit) {
            button.submit()
        console.log("SUBMIT")
        }
        else if(button.isCancel)
            button.cancel()
    }

    onClicked: {
         var siblings = parent.children
         for (var i = 0; i < siblings.length; i++) {
             if (siblings[i].checkbox === true) {
                 siblings[i].checked = false
             }
            console.log(i)
             if(siblings[i].checkbox)
                 console.log("true")
             else
                 console.log("false")
         }
    }
    onSubmit: {
        console.log("SUBMIT2")
         var siblings = parent.children
         for (var i = 0; i < siblings.length; i++) {
             if(siblings[i].checked)
                 console.log("true")
             else
                 console.log("false")
             if (siblings[i].checkbox && siblings[i].checked) {
                   unitSelector.submit(siblings[i].multiplier)
             }
         }
    }
    onCancel: unitSelector.cancel()

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
                when: checkbox && checked
                PropertyChanges {
                    target: textItem
                    color: "green"
                }
            },
            State {name: "unchecked"
                when: checkbox && !checked
                PropertyChanges {
                    target: textItem
                    color: "white"
                }
            }
        ]
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.margins: -5
        onClicked: {
            console.log("aki")
            if(button.checkbox) {
            button.clicked()
            checked = true
            }
            if(button.isSubmit) {
                button.submit()
            console.log("SUBMIT")
            }
            else if(button.isCancel)
                button.cancel()
        }
    }
}
