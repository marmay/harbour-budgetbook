import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: root
    width: parent.width
    height: dateLabel.height
    spacing: Theme.paddingLarge

    property date value: new Date()

    Label {
        id: dateLabel
        text: qsTr("Date")
    }
    Label {
        id: datePicker
        text: root.value.toLocaleDateString();
        width: parent.width - dateLabel.width - Theme.paddingSmall
        color: Theme.highlightColor
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var dialog = pageStack.push(pickerComponent);
                dialog.accepted.connect(function() {
                    root.value = dialog.date;
                });
            }

            Component {
                id: pickerComponent
                DatePickerDialog {
                    id: dialog
                    date: root.value
                }
            }
        }
    }
}
