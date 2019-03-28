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

    title: "Qt Quick Controls 2 - Imagine Style Example: Automotive"
    Item {
        property int gettingInput: 0
        property int none: 0
        property int value: 1
        property int unit: 2
        property double freq_center_total: freq_center_base * freq_center_multiplier
        property double freq_center_base: 0
        property double freq_center_multiplier: 0

        property double freq_span_total: freq_span_base * freq_span_multiplier
        property double freq_span_base: 0
        property double freq_span_multiplier: 0

        property double freq_start_total: freq_start_base * freq_start_multiplier
        property double freq_start_base: 0
        property double freq_start_multiplier: 0

        property double freq_stop_total: freq_stop_base * freq_stop_multiplier
        property double freq_stop_base: 0
        property double freq_stop_multiplier: 0

        property double freq_step_total: freq_step_base * freq_step_multiplier
        property double freq_step_base: 0
        property double freq_step_multiplier: 0
        property bool freq_steps_in_steps: freq_step_multiplier === 0

        id: main
        anchors.fill: parent

        NumericKeyboard {
            id: numericKeyboard
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            //z:10
            onSubmit: {
                if(controlPanel.isFrequency_center_requested) {
                    controlPanel.isFrequency_center_requested = false
                    main.freq_center_base = base_value
                    main.freq_center_multiplier = multiplier
                }
                else if(controlPanel.isFrequency_span_requested) {
                    controlPanel.isFrequency_span_requested = false
                    main.freq_span_base = base_value
                    main.freq_span_multiplier = multiplier
                }
                else if(controlPanel.isFrequency_start_requested) {
                    controlPanel.isFrequency_start_requested = false
                    main.freq_start_base = base_value
                    main.freq_start_multiplier = multiplier
                }
                else if(controlPanel.isFrequency_stop_requested) {
                    controlPanel.isFrequency_stop_requested = false
                    main.freq_stop_base = base_value
                    main.freq_stop_multiplier = multiplier
                }
            }
            onCanceled: {
                if(controlPanel.isFrequency_center_requested)
                    controlPanel.isFrequency_center_requested = false
                else if(controlPanel.isFrequency_span_requested)
                    controlPanel.isFrequency_span_requested = false
                controlPanel.focus = true
            }
            state:"idle"
        }

        ScopeView {
            id: scopeView
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
//            anchors.left: controlPanel.right
           // anchors.right: parent.right
            anchors.left: parent.left
            height: main.height

            onOpenGLSupportedChanged: {
                if (!openGLSupported) {
                    controlPanel.openGLButton.enabled = false
                    controlPanel.openGLButton.currentSelection = 0
                }
            }
        }
        ControlPanel {

            id: controlPanel
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
          //  anchors.left: parent.left
          //  anchors.leftMargin: 500
      //      anchors.left: scopeView.right
            anchors.right: parent.right
            anchors.rightMargin: 10
            freq_center_mult: main.freq_center_multiplier
            freq_center_val: main.freq_center_base
            freq_span_mult: main.freq_span_multiplier
            freq_span_val: main.freq_span_base
            freq_start_mult: main.freq_start_multiplier
            freq_start_val: main.freq_start_base
            freq_stop_mult: main.freq_stop_multiplier
            freq_stop_val: main.freq_stop_base
            freq_step_mult: main.freq_step_multiplier
            freq_step_val: main.freq_step_base
            //![1]
            focus: true
            onSignalSourceChanged: {
                if (source == "sin")
                    dataSource.generateData(0, signalCount, sampleCount);
                else
                    dataSource.generateData(1, signalCount, sampleCount);
                scopeView.axisX().max = sampleCount;
            }
            onSeriesTypeChanged: scopeView.changeSeriesType(type);
            onRefreshRateChanged: scopeView.changeRefreshRate(rate);
            onAntialiasingEnabled: scopeView.antialiasing = enabled;
            onOpenGlChanged: {
                scopeView.openGL = enabled;
            }
            onCenter_frequency_requested: {
                if(controlPanel.isFrequency_center_requested)
                    numericKeyboard.state = "getNumbers"
            }
            onFrequency_span_requested: {
                if(controlPanel.isFrequency_span_requested)
                    numericKeyboard.state = "getNumbers"
            }
            onStart_frequency_requested: {
                if(controlPanel.isFrequency_start_requested)
                    numericKeyboard.state = "getNumbers"
            }
            onStop_frequency_requested: {
                if(controlPanel.isFrequency_stop_requested)
                    numericKeyboard.state = "getNumbers"
            }
            onFrequency_step_requested: {
                if(controlPanel.isFrequency_step_requested)
                    numericKeyboard.state = "getNumbersWithSteps"
            }
        }
    }
}

