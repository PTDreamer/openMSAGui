import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Imagine 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4


Item {
    id: button
    implicitWidth: buttonText.implicitWidth + 5
    implicitHeight: buttonText.implicitHeight
    property string text: ""
    property int multiplier: -1
    property var label_value: 0
    property alias checked: buttonText.checked
    Button {
        id: buttonText
        checkable: true
        implicitWidth: 90
        implicitHeight: 60
        icon.name: "placeholder"
        icon.width: 44
        icon.height: 44
        display: Button.TextUnderIcon
        Label {
            text: button.text + "\n" + getLabel()
            clip: true
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
        }
    }
    function getLabel() {
        if(multiplier === -1)
            return label_value
        else if(multiplier === 1)
            return label_value + "Hz"
        else if(multiplier === 1000)
            return label_value + "KHz"
        else if(multiplier === 1000000)
            return label_value + "MHz"
        else if(multiplier === 1000000000)
            return label_value + "GHz"
        else if(multiplier === 0)
            return label_value + "Steps"
    }
}
