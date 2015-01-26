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

Item {
    id: item
    property alias label : _label.text
    property var buildModel
    property var modelDataToLabel : function (m) { return m; }
    property var model : buildModel()
    property string addText
    property string selectHeader
    property Component addDialog
    property var value : model.length >= 1 ? model[0] : null

    width: parent.width
    height: _row.height

    Component {
        id: _dialog

        Dialog {
            id: _innerDialog
            property var current
            property alias model : listView.model
            property var buildModel
            property var modelDataToLabel
            property string title
            property string addText
            property Component addDialog

            Component.onCompleted: { model = buildModel(); }

            property Item _currentItem

            SilicaListView {
                id: listView
                anchors.fill: parent

                PullDownMenu {
                    visible: addText !== null && addDialog !== null
                    MenuItem {
                        text: addText
                        onClicked: {
                            var page = pageStack.push(addDialog);
                            page.added.connect(function (item) {
                                current = item;
                                model = buildModel();
                            });
                        }
                    }
                }

                header: PageHeader {
                    id: _header
                    title: _innerDialog.title
                }
                delegate: BackgroundItem {
                    property var value : modelDataToLabel(modelData)

                    id: item
                    width: listView.width
                    height: _entry.height + Theme.paddingLarge
                    onClicked: {
                        if (_currentItem !== item) {
                            _currentItem.highlighted = false;
                            _currentItem = item;
                            current = modelData;
                            item.highlighted = true;
                        }
                        _innerDialog.accept();
                    }
                    Component.onCompleted: {
                        if (modelDataToLabel(modelData) === modelDataToLabel(current))
                        {
                            highlighted = true;
                            _currentItem = item;
                            current = modelData;
                        }
                    }

                    Label {
                        id: _entry
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelDataToLabel(modelData);
                        x: Theme.paddingLarge
                        width: parent.width - 2 * Theme.paddingLarge
                        truncationMode: TruncationMode.Fade
                        color: item.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }

                    VerticalScrollDecorator {}
                }
            }
        }
    }

    Item {
        width: parent.width
        height: _row.height

        Row {
            id: _row
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.paddingLarge

            Label {
                id: _label
            }

            Label {
                id: _valueLabel
                text: modelDataToLabel(value)
                color: Theme.highlightColor
                truncationMode: TruncationMode.Fade
                width: parent.width - _label.width - Theme.paddingLarge
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var page = pageStack.push(_dialog, { modelDataToLabel: modelDataToLabel,
                                                        addText: item.addText, addDialog: item.addDialog,
                                                        current: value, title: selectHeader, buildModel: buildModel });
                page.accepted.connect(function() {
                    if (page.current !== null) {
                        item.value = page.current;
                    }
                } );
            }
        }
    }
}
