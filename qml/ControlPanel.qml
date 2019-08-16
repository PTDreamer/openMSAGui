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
import QtQuick.Layouts 1.12
import QtQuick.Controls.Imagine 2.12
import QtQuick.Controls 2.5

Item {
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

    property alias sg_freq_or_offset_val: sg_freq_or_offset.label_value
    property alias sg_freq_or_offset_mult: sg_freq_or_offset.multiplier
    property alias isSg_freq_or_offset_requested: sg_freq_or_offset.checked

    property int siggen_function: 0

    property int scanType: scanTypeButton.currentSelection
    property bool frequencyStepModeAuto: true
    property int scanInverted: inv_scan.currentSelection
    Layout.fillHeight: true
    signal refreshRateChanged(variant rate);
    signal center_frequency_requested(var value)
    signal frequency_span_requested(var value)
    signal start_frequency_requested(var value)
    signal stop_frequency_requested(var value)
    signal frequency_step_requested(var value)
    signal sg_frequency_requested(var value)

    property bool isStartStopMode: (freq_mode.currentSelection == 1)
    anchors.right: parent.right
    height: parent.height
    width: 100
    z: 2
    Item {
        id:baseBar
        width: but1.height // width as TabBar height before rotation
          height: parent.height
          anchors.right: slayout.left
    TabBar {
        width: parent.height
        height: but1.height
          id: bar
          transform: [
              Rotation { origin.x: 0; origin.y: 0; angle: -90} // rotate around the upper left corner counterclockwise
              ,Translate { y: 200; x: 0 } // move to the bottom of the base
          ]
          TabButton {
              width: 100
              id: but1
              text: qsTr("MSA")
          }
          TabButton {
              width: 100
              id: secondBtn
              text: qsTr("TG")
          }

      }
    }
    StackLayout {
        id: slayout
        anchors.right: parent.right
        anchors.top: parent.top
         width: freq_mode.width
         currentIndex: bar.currentIndex
         Item {
             id: msa
             ColumnLayout {
                 spacing: 0
                MultiButton {
                    id: scanTypeButton
                    text: "Mode\n"
                    items: ["SA", "VNA\nTransmission", "VNA\nReflection", "SNA"]
                    currentSelection: 0
                    onSelectionChanged: dataSource.handleScanChanges();
                }

                MultiButton {
                    id:freq_mode
                    text: "Frequency Mode\n"
                    items: ["Center-Span", "Start-Stop"]
                    currentSelection: 0;
                    onSelectionChanged: dataSource.handleScanChanges(1);
                }
                ButtonWithLabelAndValue {
                    id:freq_center
                    text: "Center"
                    onCheckedChanged: center_frequency_requested(checked)
                    visible: freq_mode.currentSelection == 0 ? true : false
                    onLabel_valueChanged:  dataSource.handleScanChanges();
                }
                ButtonWithLabelAndValue {
                    id:freq_span
                    text: "Span"
                    onCheckedChanged: frequency_span_requested(checked)
                    visible: freq_mode.currentSelection == 0 ? true : false
                    onLabel_valueChanged:  dataSource.handleScanChanges();
                }
                ButtonWithLabelAndValue {
                    id:freq_start
                    text: "Frequency\nStart"
                    onCheckedChanged: start_frequency_requested(checked)
                    visible: freq_mode.currentSelection == 1 ? true : false
                    onLabel_valueChanged:  dataSource.handleScanChanges();
                }
                ButtonWithLabelAndValue {
                    id:freq_stop
                    text: "Frequency\nStop"
                    onCheckedChanged: stop_frequency_requested(checked)
                    visible: freq_mode.currentSelection == 1 ? true : false
                    onLabel_valueChanged:  dataSource.handleScanChanges();
                }
                ButtonWithLabelAndValue {
                    id:freq_step
                    text: "Frequency\nStep"
                    onCheckedChanged: frequency_step_requested(checked)
                    onLabel_valueChanged:  dataSource.handleScanChanges();
                }
                MultiButton {
                    text: "Frequency\nStep mode\n"
                    items: ["Manual", "Auto"]
                    currentSelection: (frequencyStepModeAuto) ? 1 : 0;
                    onSelectionChanged: dataSource.handleScanChanges();
                }
                MultiButton {
                    id:inv_scan
                    text: "Scan\nDirection\n"
                    items: ["Normal", "Inverted"]
                    currentSelection: 0;
                    onSelectionChanged: dataSource.handleScanChanges();
                }
                MultiButton {
                    id: finalFilter
                    text: "Filter\n"
                    items: dataSource.finalFilters
                    currentSelection: 0
                    onSelectionChanged: dataSource.handleScanChanges();
                }
             }
         }
         Item {
             id: tg
             ColumnLayout {
                 spacing: 0
                MultiButton {
                    id:siggen
                    text: "SigGen\n"
                    items: ["Off", "SG", "TG", "TG-Inv"];
                    currentSelection: siggen_function
                    onSelectionChanged: dataSource.handleScanChanges();
                }
                ButtonWithLabelAndValue {
                    id:sg_freq_or_offset
                    text: (siggen.currentSelection == 1) ? "SG Frequency\n" : "TG offset";
                    onLabel_valueChanged:  dataSource.handleScanChanges();
                    visible: (siggen.currentSelection != 0)
                    onCheckedChanged: sg_frequency_requested(checked);
                }
             }
         }
    }
}
