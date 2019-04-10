import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12
Item {
    id: fullkeyboard
    property double value: 0
    property double multiplier: 0
    property double base_value: 0
    signal submit (var totalValue, var baseValue, var multiplier)
    signal canceled()
    signal keyPressed(var value)

    anchors.fill: parent
    width: numericKeyboard.width
    height: numericKeyboard.height
    focus: false
    Keys.onPressed: keyPressed(event.key)
    state: "idle"
    states: [
        State {
            name: "idle"
            PropertyChanges {
                target: fullkeyboard
                z: -1
                focus: false
            }
            PropertyChanges {
                target: numericKeyboard
                visible: false
            }
            PropertyChanges {
                target: unitSelector_id
                visible: false
            }
            StateChangeScript {
                script: {
                    keyPressed.disconnect(unitSelector_id.handleKey)
                    keyPressed.disconnect(numericKeyboard.handleKey)
                }
            }
        },
        State {
            name: "getNumbers"
            StateChangeScript {
                script: {
                    display.clear()
                    keyPressed.connect(numericKeyboard.handleKey)
                    keyPressed.disconnect(unitSelector_id.handleKey)
                }
            }
            PropertyChanges {
                target: fullkeyboard
                z: 10
                focus: true
            }
            PropertyChanges {
                target: numericKeyboard
                visible: true
            }
            PropertyChanges {
                target: unitSelector_id
                visible: false
            }
        },
        State {
            name: "getNumbersWithSteps"
            StateChangeScript {
                script: {
                    keyPressed.connect(numericKeyboard.handleKey)
                    keyPressed.disconnect(unitSelector_id.handleKey)
                    unitSelector_id.showSteps = true
                    unitSelector_id.showSteps2 = true
                }
            }
            PropertyChanges {
                target: fullkeyboard
                z: 10
                focus: true
            }
            PropertyChanges {
                target: numericKeyboard
                visible: true
            }
            PropertyChanges {
                target: unitSelector_id
                visible: false
            }
        },
        State {
            name: "getUnits"
            PropertyChanges {
                target: numericKeyboard
                visible: false
            }
            PropertyChanges {
                target: fullkeyboard
                z: 10
                focus: true
            }
            PropertyChanges {
                target: unitSelector_id
                visible: true
            }
            StateChangeScript {
                script: {
                    keyPressed.connect(unitSelector_id.handleKey)
                    keyPressed.disconnect(numericKeyboard.handleKey)
                    console.log("getUnits" + unitSelector_id.showSteps)
                }
            }
        },
        State {
            name: "finished"
            PropertyChanges {
                target: numericKeyboard
                visible: false
            }
            PropertyChanges {
                target: unitSelector_id
                visible: false
            }
            PropertyChanges {
                target: fullkeyboard
                focus: false
                z: -1
            }
            StateChangeScript {
                script : {
                    fullkeyboard.value = unitSelector_id.retval * numericKeyboard.retvalue
                    fullkeyboard.base_value = numericKeyboard.retvalue
                    fullkeyboard.multiplier = unitSelector_id.retval
                    console.log("AAA"+fullkeyboard.value)
                    keyPressed.disconnect(unitSelector_id.handleKey)
                    keyPressed.disconnect(numericKeyboard.handleKey)
                    console.log(unitSelector_id.retval  + '*' + numericKeyboard.retvalue)
                    fullkeyboard.submit(unitSelector_id.retval * numericKeyboard.retvalue, numericKeyboard.retvalue, unitSelector_id.retval);
                    unitSelector_id.showSteps = false
                }
            }
        },
        State {
            name: "canceled"
            PropertyChanges {
                target: fullkeyboard
            }
            PropertyChanges {
                target: numericKeyboard
                z: -1
                visible: false
            }
            PropertyChanges {
                target: unitSelector_id
                visible: false
            }
            PropertyChanges {
                target: fullkeyboard
                focus: false
            }
            StateChangeScript {
                script: {
                    script : fullkeyboard.canceled()
                    keyPressed.disconnect(unitSelector_id.handleKey)
                    keyPressed.disconnect(numericKeyboard.handleKey)
                    unitSelector_id.showSteps = false
                }
            }
        }
    ]
    MouseArea {
        onClicked: {
            if(fullkeyboard.state != "canceled")
                fullkeyboard.state = "canceled"
            console.log("numericKeyboard");
        }
        x: 0 - parent.parent.x
        y:0 - parent.parent.y
        width: window.width
        height: window.height
        visible: fullkeyboard.state == "canceled" ? false : true
        Rectangle{
            id:numericKeyboard
            color: "black"
            width: icol.width + 20
            height: igrid.height + rect.height + 20
            property double retvalue: 0
            anchors.centerIn: parent
            MouseArea {
                anchors.fill: parent
            }
            function handleKey(x) {
                var ch = igrid.children
                for (var i = 0; i < ch.length; i++) {
                    if(ch[i].text.charCodeAt(0) === x)
                        ch[i].onKey()
                    else if(ch[i].text === "C" && x === Qt.Key_Backspace)
                        ch[i].onKey()
                    else if(ch[i].text === "X" && x === Qt.Key_Escape)
                        ch[i].onKey()
                    else if(ch[i].text === "✔" && (x === Qt.Key_Enter || x === Qt.Key_Return))
                        ch[i].onKey()
                }
            }

            Column {
                id:icol
                anchors.centerIn: parent
                spacing: 5
                Rectangle {
                    id:rect
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: igrid.width + 10
                    height: 40
                    border.color: "green"
                    border.width: 3
                    radius: 10
                    Text {
                        id: display
                        property int maxDigits : 10
                        anchors.centerIn: parent
                        font.pointSize: parent.height - 20
                        text: qsTr("")
                        function appendDigit(digit) {
                            display.text = text + digit
                        }
                        function removeLast() {
                            console.log("removelast")
                            display.text = display.text.substring(0, display.text.length - 1)
                        }
                        function clear() {
                            display.text = ""
                        }
                        function getText() {
                            return display.text
                        }
                        function submit() {
                            numericKeyboard.retvalue = (parseFloat(display.text))
                            console.log(numericKeyboard.retvalue)
                            fullkeyboard.state = "getUnits"
                            console.log("SUBMIT" + numericKeyboard.retvalue)
                        }
                        function cancel() {
                            fullkeyboard.state = "canceled"
                            console.log("canceled")
                        }
                    }
                }

                Grid {
                    id:igrid
                    columns: 3
                    columnSpacing: 25
                    rowSpacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    signal buttonPressed
                    NumericKeyboardButton { text: "1" }
                    NumericKeyboardButton { text: "2" }
                    NumericKeyboardButton { text: "3" }
                    NumericKeyboardButton { text: "4" }
                    NumericKeyboardButton { text: "5" }
                    NumericKeyboardButton { text: "6" }
                    NumericKeyboardButton { text: "7" }
                    NumericKeyboardButton { text: "8" }
                    NumericKeyboardButton { text: "9" }
                    NumericKeyboardButton { text: "."; id:dotkey ; dimmable:true}
                    NumericKeyboardButton { text: "0" }
                    NumericKeyboardButton { text: "-"; id:minuskey ; dimmable:true}
                    NumericKeyboardButton { text: "C"; color: "#6da43d"; operator: true }
                    NumericKeyboardButton { id:submitkey; text: "✔"; color: "#6da43d"; operator: true; dimmable: true; dimmed:true}
                    NumericKeyboardButton { text: "X"; color: "#6da43d"; operator: true }

                }
            }
        }
        MouseArea {
            onClicked: {
                if(fullkeyboard.state != "canceled")
                    fullkeyboard.state = "canceled"
                console.log("unitSelector_id");
            }
            x:0 - parent.parent.x
            y:0 - parent.parent.y
            width: window.width
            height: window.height
            visible: fullkeyboard.state == "canceled" || fullkeyboard.state !="getUnits" ? false : true

        UnitSelector {
            id:unitSelector_id
            visible: false
            property int retval: 0
            anchors.centerIn: parent
            onSubmit: {
                retval = value
                fullkeyboard.state = "finished"
            }
            onCancel: {
                retval = value
                fullkeyboard.state = "canceled"
            }
        }
        }
    }
}
