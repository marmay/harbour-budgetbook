/*
 * Copyright (C) 2015 Markus Mayr <markus.mayr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2 only.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../elements"

CoverBackground {

    Item {
        anchors {
            top: parent.top
            topMargin: parent.width * 0.25
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width * 0.75
        height: miniChart.height + nameTag.anchors.topMargin + nameTag.height

        DoughnutChart {
            id: miniChart
            width: parent.width
            height: width
            smallChart: false

            ListModel {
                id: newModel
            }

            Component.onCompleted: {
                newModel.append({ "cLabel": "", "cValue": 19, "cColor": "#025608" })
                newModel.append({ "cLabel": "", "cValue": 16, "cColor": "#BA3F3B" })
                newModel.append({ "cLabel": "", "cValue": 13, "cColor": "#BA763B" })
                newModel.append({ "cLabel": "", "cValue":  8, "cColor": "#246D70" })
                newModel.append({ "cLabel": "", "cValue":  5, "cColor": "#2F9235" })
                chartData = newModel
            }
        }

        Label {
            id: nameTag
            anchors {
                top: miniChart.bottom
                topMargin: Theme.paddingMedium
                horizontalCenter: parent.horizontalCenter
            }

            text: qsTr("BudgetBook")
        }
    }

    CoverActionList {
        enabled: true
        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                if (!app.applicationActive) {
                    pageStack.push(Qt.resolvedUrl("../pages/AddBill.qml"))
                    app.activate();
                }
            }
        }
    }
}


