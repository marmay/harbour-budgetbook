import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Statistics")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Browse Bills")
                onClicked: pageStack.push(Qt.resolvedUrl("BillBrowser.qml"))
            }
        }
    }
}
