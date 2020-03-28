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

        Item {
            id: miniChart
            width: parent.width
            height: width

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

            property ListModel chartData
            property variant runningTotal: []
            property real valueTotal: 0.0

            onChartDataChanged: {
                var sum = 0.0
                for (var i = 0; i < chartData.count; i++) {
                    sum = sum + chartData.get(i).cValue
                    runningTotal[i] = sum
                }
                valueTotal = sum
            }

            Canvas {
                id: pieSector
                anchors.centerIn: parent
                width: parent.width
                height: width
                renderTarget: Canvas.Image
                renderStrategy: Canvas.Immediate

                // Context2D
                property real penWidth:      Theme.paddingSmall / 2.0
                property real innerRadius:   width * 0.25
                property real outerRadius:   width * 0.50 - penWidth
                property real middleRadius:  (innerRadius + outerRadius) / 2.0
                property string borderColor: Theme.primaryColor

                onBorderColorChanged:  requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    ctx.translate(width/2, height/2)
                    ctx.rotate(-Math.PI/2.0)

                    for(var i = 0; i < miniChart.chartData.count; i++) {
                        var curr = miniChart.chartData.get(i)
                        var startAngle = 2*Math.PI * ((miniChart.runningTotal[i] - curr["cValue"]) / miniChart.valueTotal)
                        var endAngle = startAngle + 2*Math.PI * (curr["cValue"] / miniChart.valueTotal)

                        console.log(curr["cValue"] + " " + curr["cColor"])
                        console.log(borderColor)

                        ctx.fillStyle = curr["cColor"]
                        ctx.strokeStyle = curr["cColor"]
                        ctx.lineWidth = outerRadius - innerRadius
                        ctx.beginPath()
                        ctx.arc(0,0,middleRadius, startAngle, endAngle)
                        ctx.stroke()

                        ctx.strokeStyle = borderColor
                        ctx.lineWidth = penWidth
                        ctx.beginPath()
                        ctx.arc(0,0,outerRadius, startAngle, endAngle, false)
                        ctx.arc(0,0,innerRadius, endAngle, startAngle, true)
                        ctx.closePath()
                        ctx.stroke()
                    }


                }
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
