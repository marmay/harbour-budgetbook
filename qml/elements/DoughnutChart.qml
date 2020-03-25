import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root
    property ListModel chartData

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
            anchors {
                top: parent.top
                left: parent.left
            }
            width: parent.width
            height: parent.width
            opacity: pieSector.scale

            Canvas {
                id: pieSector
                anchors.centerIn: parent
                width: parent.width
                height: width
                scale: 0.0
                renderTarget: Canvas.FramebufferObject
                renderStrategy: Canvas.Threaded
                Behavior on scale {
                    NumberAnimation { duration: 1000; easing.type: Easing.OutQuint; }
                }
                Component.onCompleted: {
                    startDelay.running = true
                }

                Timer {
                    id: startDelay
                    repeat: false
                    triggeredOnStart: false
                    running: false
                    onTriggered: { parent.scale = 1.0
                        console.log("fire" + index)
                    }
                    interval: index * 250
                }

                // Context2D
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.translate(width/2, height/2)
                    ctx.rotate(-Math.PI/2.0)
                    ctx.fillStyle = cColor

                    var startAngle = 2*Math.PI * ((listView.runningTotal[index] - cValue) / listView.valueTotal)
                    var endAngle = startAngle + 2*Math.PI * (cValue / listView.valueTotal)

                    console.log(startAngle, endAngle)

                    ctx.strokeStyle = cColor
                    ctx.lineWidth = width*0.25
                    ctx.arc(0,0,width*0.370, startAngle, endAngle)
                    ctx.stroke()

                    ctx.strokeStyle = Theme.primaryColor

                    ctx.lineWidth = width*0.005
                    ctx.beginPath()
                    ctx.arc(0,0,width*0.495, startAngle, endAngle, false)
                    ctx.arc(0,0,width*0.245, endAngle, startAngle, true)
                    ctx.closePath()
                    ctx.stroke()
                }
            }
        }
    }
}
