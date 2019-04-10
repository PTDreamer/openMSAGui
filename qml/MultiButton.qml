/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Imagine 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4


Item {
    id: button

    property string text: "Option: "
    property variant items: ["first","second"]
    property int currentSelection: 0
    signal selectionChanged(variant selection)

    signal clicked

    implicitWidth: buttonText.implicitWidth + 5
    implicitHeight: buttonText.implicitHeight

    Button {
        id: buttonText
        implicitWidth: 90
        implicitHeight: 60

        icon.name: "placeholder"
        icon.width: 44
        icon.height: 44
        display: Button.TextUnderIcon
        Label {
        text: button.text + button.items[currentSelection]
        clip: true
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        }
        onClicked: {
            //rootItem.visible = !rootItem.visible
            if(rootItem.state == "Invisible")
                rootItem.state = "Visible"
            else
                rootItem.state = "Invisible"
        }
    }
    Item {
        state: "Invisible"
        id:rootItem
        states: [
            State{
                name: "Visible"
                PropertyChanges{target: rootItem; opacity: 1.0}
                PropertyChanges{target: rootItem; visible: true}
            },
            State{
                name:"Invisible"
                PropertyChanges{target: rootItem; opacity: 0.0}
                PropertyChanges{target: rootItem; visible: false}
            }
        ]
        transitions: [
                Transition {
                    from: "Visible"
                    to: "Invisible"

                    SequentialAnimation{
                       NumberAnimation {
                           target: rootItem
                           property: "opacity"
                           duration: 500
                           easing.type: Easing.InOutQuad
                       }
                       NumberAnimation {
                           target: rootItem
                           property: "visible"
                           duration: 0
                       }
                    }
                },
                Transition {
                    from: "Invisible"
                    to: "Visible"
                    SequentialAnimation{
                       NumberAnimation {
                           target: rootItem
                           property: "visible"
                           duration: 0
                       }
                       NumberAnimation {
                           target: rootItem
                           property: "opacity"
                           duration: 500
                           easing.type: Easing.InOutQuad
                       }
                    }
                }
            ]
    Column {
        id: options
    Repeater {
        model: items.length
        Button {
            implicitWidth: buttonText.implicitWidth + 10
            text: button.items[index]
            anchors.right: parent.left
            onClicked:  {
                rootItem.state = "Invisible"
                currentSelection = index
                selectionChanged(button.items[index]);
            }
        }
    }
    }
}
}
