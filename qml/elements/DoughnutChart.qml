import QtQuick 2.0

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
    }

    ListView {
        id: listView
        width: parent.width
        height: parent.height
        model: chartData

        property int valueTotal
        property variant runningTotal: []

        delegate: Item {
            anchors {
                top: parent.top
                left: parent.left
            }
            width: parent.width
            height: parent.width

            Canvas {
                anchors.centerIn: parent
                width: parent.width
                height: width
//                property int finalWidth: root.width
//                property int finalHeight: root.height

//                width: 0
//                height: 0
//                Behavior on width {
//                    NumberAnimation { duration: 1000; easing.type: Easing.OutQuint; }
//                }
//                Behavior on height {
//                    NumberAnimation { duration: 1000; easing.type: Easing.OutQuint; }
//                }
//                Component.onCompleted: {
//                    width = finalWidth
//                    height = finalHeight
//                }

                // Context2D
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.translate(width/2, height/2)
                    ctx.fillStyle = cColor

                    var startAngle = 2*Math.PI * ((listView.runningTotal[index] - cValue) / listView.valueTotal)
                    var endAngle = startAngle + 2*Math.PI * (cValue / listView.valueTotal)

                    console.log(startAngle, endAngle)

                    ctx.strokeStyle = cColor
                    ctx.lineWidth = width/6

                    ctx.arc(0,0,width*0.35, startAngle, endAngle)
                    ctx.stroke()
                }
            }
        }
    }
}
