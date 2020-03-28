/*
 * DoughnutChart.qml by Matti Viljanen
 *
 * Copyright (C) 2020 Matti Viljanen <matti.viljanen@kapsi.fi>
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

Item {
    id: root
    property ListModel chartData
    property bool smallChart: true

    onChartDataChanged: {
        var sum = 0.0
        for (var i = 0; i < chartData.count; i++) {
            sum = sum + chartData.get(i).cValue
            listView.runningTotal[i] = sum
        }
        listView.valueTotal = sum
        listView.model = chartData
    }

    ListView {
        id: listView
        width: parent.width
        height: parent.height
        model: []

        property int valueTotal
        property variant runningTotal: []

        delegate: Item {
            id: pieDelegate
            anchors {
                top: parent.top
                left: parent.left
            }
            width: parent.width
            height: parent.width
            opacity: smallChart ? 0.0 : 1.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.Linear
                }
            }

            Canvas {
                id: pieSector
                anchors.centerIn: parent
                width: parent.width
                height: width
                scale: smallChart ? 0.5 : 1.0
                renderTarget: smallChart ? Canvas.FramebufferObject : Canvas.Image
                renderStrategy: smallChart ? Canvas.Threaded : Canvas.Immediate
                Behavior on scale {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutQuint
                    }
                }
                Component.onCompleted: {
                    if(smallChart) {
                        startDelay.running = true
                    }
                }

                Timer {
                    id: startDelay
                    repeat: false
                    triggeredOnStart: false
                    running: false
                    onTriggered: {
                        pieSector.scale = 1.0
                        pieDelegate.opacity = 1.0
                    }
                    interval: index * 50
                }

                // Context2D
                property real penWidth:     Theme.paddingSmall / 2.0
                property real innerRadius:  width * 0.25
                property real outerRadius:  width * 0.50 - penWidth
                property real middleRadius: (innerRadius + outerRadius) / 2.0

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.translate(width/2, height/2)
                    ctx.rotate(-Math.PI/2.0)
                    ctx.fillStyle = cColor

                    var startAngle = 2*Math.PI * ((listView.runningTotal[index] - cValue) / listView.valueTotal)
                    var endAngle = startAngle + 2*Math.PI * (cValue / listView.valueTotal)

                    ctx.strokeStyle = cColor
                    ctx.lineWidth = outerRadius - innerRadius
                    ctx.arc(0,0,middleRadius, startAngle, endAngle)
                    ctx.stroke()

                    ctx.strokeStyle = Theme.primaryColor
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
}
