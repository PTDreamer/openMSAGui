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

ColumnLayout {
    property alias freq_center_val: freq_center.label_value
    property alias freq_center_mult: freq_center.multiplier
    property alias isFrequency_center_requested: freq_center.checked

    property alias freq_span_val: freq_span.label_value
    property alias freq_span_mult: freq_span.multiplier
    property alias isFrequency_span_requested: freq_span.checked

    property alias freq_start_val: freq_start.label_value
    property alias freq_start_mult: freq_start.multiplier
    property alias isFrequency_start_requested: freq_start.checked

    property alias freq_stop_val: freq_stop.label_value
    property alias freq_stop_mult: freq_stop.multiplier
    property alias isFrequency_stop_requested: freq_stop.checked

    property alias freq_step_val: freq_step.label_value
    property alias freq_step_mult: freq_step.multiplier
    property alias isFrequency_step_requested: freq_step.checked

    spacing: 8
    Layout.fillHeight: true
    signal animationsEnabled(bool enabled)
    signal seriesTypeChanged(string type)
    signal refreshRateChanged(variant rate);
    signal signalSourceChanged(string source, int signalCount, int sampleCount);
    signal antialiasingEnabled(bool enabled)
    signal openGlChanged(bool enabled)
    signal center_frequency_requested(var value)
    signal frequency_span_requested(var value)
    signal start_frequency_requested(var value)
    signal stop_frequency_requested(var value)
    signal frequency_step_requested(var value)

    z: 2

    MultiButton {
        id: openGLButton
        text: "Mode\n"
        items: ["SA", "VNA\nTransmission", "VNA\nReflection"]
        currentSelection: 1
        onSelectionChanged: openGlChanged(currentSelection == 1);
    }
    MultiButton {
        id:freq_mode
        text: "Frequency Mode\n"
        items: ["Center-Span", "Start-Stop"]
        currentSelection: 1
        onSelectionChanged: openGlChanged(currentSelection == 1);
    }
    ButtonWithLabelAndValue {
        id:freq_center
        text: "Center"
        onCheckedChanged: center_frequency_requested(checked)
        visible: freq_mode.currentSelection == 0 ? true : false
    }
    ButtonWithLabelAndValue {
        id:freq_span
        text: "Span"
        onCheckedChanged: frequency_span_requested(checked)
        visible: freq_mode.currentSelection == 0 ? true : false
    }
    ButtonWithLabelAndValue {
        id:freq_start
        text: "Frequency\nStart"
        onCheckedChanged: start_frequency_requested(checked)
        visible: freq_mode.currentSelection == 1 ? true : false
    }
    ButtonWithLabelAndValue {
        id:freq_stop
        text: "Frequency\nStop"
        onCheckedChanged: stop_frequency_requested(checked)
        visible: freq_mode.currentSelection == 1 ? true : false
    }
    ButtonWithLabelAndValue {
        id:freq_step
        text: "Frequency\nStep"
        onCheckedChanged: frequency_step_requested(checked)
    }
    MultiButton {
        text: "Frequency\nStep mode\n"
        items: ["Manual", "Auto"]
        currentSelection: 1
        onSelectionChanged: openGlChanged(currentSelection == 1);
    }
}
