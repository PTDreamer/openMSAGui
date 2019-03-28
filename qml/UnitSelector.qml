import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12
Rectangle{
    signal submit(var value)
    signal cancel
    id:unitSelector
    color: "black"
    width: irow.width + 20
    height: irow.height + 20
    //property bool showSteps: false
    property alias showSteps: stepUnit.visible
    onVisibleChanged: {
        if(visible) {
            var ch = irow.children
            var options=[]
            var ii = 0
            var currentOption
            for (var c = 0; c < ch.length; c++) {
                if(!ch[c].isSubmit && !ch[c].isCancel)
                {
                    if(ii == 0) {
                        ch[c].checked = true
                        ii = 1
                    }
                    else
                        ch[c].checked = false
                }
            }
        }
    }

    function handleKey(x) {
        var ch = irow.children
        var options=[]
        var ii = 0
        var currentOption
        for (var c = 0; c < ch.length; c++) {
            if(!ch[c].isSubmit && !ch[c].isCancel && ch[c].visible)
            {
                options[ii] = ch[c]
                if(ch[c].checked)
                    currentOption = ii
                ++ii
            }
        }
        if(x === Qt.Key_Left) {
            currentOption = currentOption - 1
            if(currentOption < 0)
                currentOption = options.length -1
            options[currentOption].onKey()
        }
        else if(x === Qt.Key_Right) {
            currentOption = currentOption + 1
            if(currentOption > options.length -1)
                currentOption = 0
            options[currentOption].onKey()
        }
        else {
            for (var i = 0; i < ch.length; i++) {
                if(ch[i].text.charCodeAt(0) === x || ch[i].text.toLowerCase().charCodeAt(0) === x) {
                    ch[i].onKey()
                    break;
                }
                else if(ch[i].text === "X" && x === Qt.Key_Escape) {
                    ch[i].onKey()
                    break;
                }
                else if(ch[i].text === "✔" && (x === Qt.Key_Enter || x === Qt.Key_Return)) {
                    ch[i].onKey()
                    break;
                }

            }
        }
    }
    MouseArea {
        anchors.fill: parent
    }

    Row {
        id:irow
        spacing: 30
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -10
        anchors.verticalCenter: parent.verticalCenter
        UnitSelectorButton { text: "Hz"; checkbox: true; checked: true}
        UnitSelectorButton { text: "KHz"; checkbox: true; multiplier: 1000}
        UnitSelectorButton { text: "MHz"; checkbox: true; multiplier: 1000000}
        UnitSelectorButton { text: "GHz"; checkbox: true; multiplier: 1000000000}
        UnitSelectorButton { id:stepUnit; visible:false ;text: "Steps"; checkbox: true; multiplier: 0}
        UnitSelectorButton { isSubmit: true; text: "✔"; color: "#6da43d"}
        UnitSelectorButton { text: "X"; color: "#6da43d"; isCancel: true}
    }
}
