import QtQuick 2.0
import JBstuff 1.0
Marker {
        Text {
            id: number;
            anchors.left: parent.right;
            anchors.bottom: parent.top;
            color: parent.color;
            text: parent.number
        }
        Text {
            id: legend2;
            anchors.right: parent.left;
            anchors.bottom: parent.top;
            color: parent.color;
            text: parent.legend2
        }
        Text {
            id: legend1;
            anchors.right: parent.left;
            anchors.bottom: legend2.top;
            color: parent.color;
            text: parent.legend1
        }
}
