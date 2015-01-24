import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Database.js" as Database
import "../pages"

Flow {
    property var _pageStack : null
    property var selectedTags : []

    spacing: Theme.paddingSmall

    function clear() {
        selectedTags = [];
        repeater.model = null;
        repeater.model = Database.getTags();
    }

    Repeater {
        id: repeater
        model: Database.getTags()
        delegate: Rectangle {
            function contains(list, item) {
                for (var i = 0; i < list.length; ++i) {
                    if (list[i] === item)
                        return true;
                }
                return false;
            }

            property bool selected : contains(selectedTags, modelData.id);

            width: inner.width + 3 * Theme.paddingSmall
            height: inner.height + Theme.paddingSmall


            radius: 2 * Theme.paddingSmall
            border.color: Theme.primaryColor
            border.width: 1
            color: selected ? Theme.secondaryColor : '#00000000'

            Behavior on color {
                animation: ColorAnimation { duration: 100 }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!selected) {
                        selectedTags.push({ id: modelData.id, name: modelData.name });
                        selectedTagsChanged();
                    }
                    else {
                        selectedTags = selectedTags.filter(function (item) { return item.id !== modelData.id });
                    }
                    selected = !selected;
                }
            }

            Label {
                id: inner
                anchors.centerIn: parent
                text: modelData.name
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.primaryColor
            }
        }
    }

    Rectangle {
        width: innerAddTag.width + 3 * Theme.paddingSmall
        height: innerAddTag.height + Theme.paddingSmall
        radius: 2 * Theme.paddingSmall
        border.color: Theme.primaryColor
        border.width: 1
        color: '#00000000'

        Label {
            id: innerAddTag
            anchors.centerIn: parent
            text: qsTr("Add tag ...")
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var addTagDialog = _pageStack.push("../pages/AddTag.qml");
                addTagDialog.accepted.connect(function () {
                    repeater.model = Database.getTags();
                });
            }
        }
    }
}
