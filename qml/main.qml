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

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Imagine 2.12
import QtQuick.Window 2.12
import QtCharts 2.3
import QtQuick.Controls.Styles 1.4
import QtQml.StateMachine 1.12
//4effcf
//101ad9
//2830d7
//![1]
ApplicationWindow {
    id: window
    width: 1280
    height: 720
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    background: Rectangle {
        color: "#2b2d37"
    }
    title: "openMSA"
    Item {
        property int gettingInput: 0
        property int none: 0
        property int value: 1
        property int unit: 2

        property bool freq_steps_in_steps: controlPanel.freq_step_multiplier === 0

        //        property int scanType: 0
        id: main
        anchors.fill: parent

        ScopeView {
            id: scopeView
            objectName: "scope"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            //            anchors.left: controlPanel.right
            // anchors.right: parent.right
            anchors.left: parent.left
            height: main.height
            openGL: enabled
            antialiasing: enabled
        }
        MessageBox {
            text: dataSource.infoText
            errorText: dataSource.errorText
            anchors.horizontalCenter: scopeView.horizontalCenter
        }
    }

    ControlPanel {
        z:2
        id: controlPanel
        objectName: "buttons"
        anchors.top: parent.top
        anchors.topMargin: 10
        //    anchors.bottom: parent.bottom
        //  anchors.left: parent.left
        //  anchors.leftMargin: 500
        //      anchors.left: scopeView.right
        anchors.right: parent.right
        anchors.rightMargin: 10
        //        freq_center_mult: main.freq_center_multiplier

        //        scanType: main.scanType
        //![1]
        focus: true
        onCenter_frequency_requested: {
            if(controlPanel.isFrequency_center_requested) {
                numericKeyboard.state = "getNumbers"
                controlPanel.isFrequency_span_requested = false
                controlPanel.isFrequency_start_requested = false
                controlPanel.isFrequency_stop_requested = false
                controlPanel.isFrequency_step_requested = false
                controlPanel.isSg_freq_or_offset_requested = false
            }
        }
        onFrequency_span_requested: {
            if(controlPanel.isFrequency_span_requested) {
                numericKeyboard.state = "getNumbers"
                controlPanel.isFrequency_center_requested = false
                controlPanel.isFrequency_start_requested = false
                controlPanel.isFrequency_stop_requested = false
                controlPanel.isFrequency_step_requested = false
                controlPanel.isSg_freq_or_offset_requested = false
            }
        }
        onStart_frequency_requested: {
            if(controlPanel.isFrequency_start_requested) {
                numericKeyboard.state = "getNumbers"
                controlPanel.isFrequency_center_requested = false
                controlPanel.isFrequency_span_requested = false
                controlPanel.isFrequency_stop_requested = false
                controlPanel.isFrequency_step_requested = false
                controlPanel.isSg_freq_or_offset_requested = false
            }
        }
        onStop_frequency_requested: {
            if(controlPanel.isFrequency_stop_requested) {
                numericKeyboard.state = "getNumbers"
                controlPanel.isFrequency_center_requested = false
                controlPanel.isFrequency_span_requested = false
                controlPanel.isFrequency_start_requested = false
                controlPanel.isFrequency_step_requested = false
                controlPanel.isSg_freq_or_offset_requested = false
            }
        }
        onFrequency_step_requested: {
            if(controlPanel.isFrequency_step_requested) {
                numericKeyboard.state = "getNumbersWithSteps"
                controlPanel.isFrequency_center_requested = false
                controlPanel.isFrequency_span_requested = false
                controlPanel.isFrequency_start_requested = false
                controlPanel.isFrequency_stop_requested = false
                controlPanel.isSg_freq_or_offset_requested = false
            }
        }
        onSg_frequency_requested: {
            if(controlPanel.isSg_freq_or_offset_requested) {
                numericKeyboard.state = "getNumbers"
                controlPanel.isFrequency_center_requested = false
                controlPanel.isFrequency_span_requested = false
                controlPanel.isFrequency_start_requested = false
                controlPanel.isFrequency_stop_requested = false
                controlPanel.isFrequency_step_requested = false
            }
        }
    }
    Settings {
        id:settingsForm
        visible: false
    }
    NumericKeyboard {
        z:3
        id: numericKeyboard
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        onSubmit: {
            if(controlPanel.isFrequency_center_requested) {
                controlPanel.isFrequency_center_requested = false
                controlPanel.freq_center_val = base_value
                controlPanel.freq_center_mult = multiplier
            }
            else if(controlPanel.isFrequency_span_requested) {
                controlPanel.isFrequency_span_requested = false
                controlPanel.freq_span_val = base_value
                controlPanel.freq_span_mult = multiplier
            }
            else if(controlPanel.isFrequency_start_requested) {
                controlPanel.isFrequency_start_requested = false
                controlPanel.freq_start_val = base_value
                controlPanel.freq_start_mult = multiplier
            }
            else if(controlPanel.isFrequency_stop_requested) {
                controlPanel.isFrequency_stop_requested = false
                controlPanel.freq_stop_val = base_value
                controlPanel.freq_stop_mult = multiplier
            }
            else if(controlPanel.isFrequency_step_requested) {
                controlPanel.isFrequency_step_requested = false
                controlPanel.freq_step_val = base_value
                controlPanel.freq_step_mult = multiplier
            }
            else if(controlPanel.isSg_freq_or_offset_requested) {
                controlPanel.isSg_freq_or_offset_requested = false
                controlPanel.sg_freq_or_offset_val = base_value
                controlPanel.sg_freq_or_offset_mult = multiplier
            }
        }
        onCanceled: {
            if(controlPanel.isFrequency_center_requested)
                controlPanel.isFrequency_center_requested = false
            else if(controlPanel.isFrequency_span_requested)
                controlPanel.isFrequency_span_requested = false
            else if(controlPanel.isFrequency_start_requested)
                controlPanel.isFrequency_start_requested = false
            else if(controlPanel.isFrequency_stop_requested)
                controlPanel.isFrequency_stop_requested = false
            else if(controlPanel.isFrequency_step_requested)
                controlPanel.isFrequency_step_requested = false
            else if(controlPanel.isSg_freq_or_offset_requested)
                controlPanel.isSg_freq_or_offset_requested = false
            controlPanel.focus = true
        }
        state:"idle"
    }
    Image {
        id: settingsIcon
        source: "/icons/automotive/44x44/settings.png"
        opacity: 0
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: settingsIcon.opacity = 1
            onExited: {settingsIcon.opacity = 0
            }
            onClicked: settingsForm.visible = true
        }
        Component.onCompleted: animateOpacity.start();

    }
    NumberAnimation {
        id: animateOpacity
        target: settingsIcon
        properties: "opacity"
        from: 1.0
        to: 0.0
        loops: 3
        // easing {type: Easing.OutBack; overshoot: 500}
        duration: 1000
    }}

