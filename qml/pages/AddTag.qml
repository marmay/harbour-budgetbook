import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Database.js" as Database

Dialog {
    id: page

    onAccepted: {
        if (name.text !== "") {
            Database.addTag(name.text);
        }
    }

    Column {
        id: column

        width: page.width
        spacing: Theme.paddingLarge
        PageHeader {
            title: qsTr("New Tag")
        }

        TextField {
            id: name
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * Theme.paddingLarge
            placeholderText: qsTr("Tag name")
        }
    }
}
