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
            property alias model : _repeater.model
            property var buildModel
            property var modelDataToLabel
            property alias title : _header.title
            property string addText
            property Component addDialog

            Component.onCompleted: { model = buildModel(); }

            property Item _currentItem

            SilicaFlickable {
                id: flickable
                anchors.fill: parent
                contentHeight: _column.height

                Column {
                    id: _column
                    width: parent.width
                    spacing: Theme.paddingLarge

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

                    PageHeader {
                        id: _header
                    }

                    Repeater {
                        id: _repeater
                        delegate: Component {
                            Label {
                                id: _entry
                                width: _column.width
                                text: modelDataToLabel(modelData);
                                Component.onCompleted: {
                                    state = modelDataToLabel(modelData) === modelDataToLabel(current) ? "selected" : "not_selected"
                                    if (state === "selected") {
                                        _currentItem = _entry;
                                        current = modelData;
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (parent.state !== "selected") {
                                            if (_currentItem) {
                                                _currentItem.state = "not_selected";
                                            }
                                            _currentItem = _entry;
                                            _entry.state = "selected";
                                        }
                                        _innerDialog.accept();
                                    }
                                }

                                states: [
                                    State {
                                        name: "selected"
                                        PropertyChanges {
                                            target: _innerDialog
                                            current: modelData
                                        }
                                        PropertyChanges {
                                            target: _entry
                                            color: Theme.highlightColor
                                        }
                                    },
                                    State {
                                        name: "not_selected"
                                        PropertyChanges {
                                            target: _entry
                                            color: Theme.primaryColor
                                        }
                                    }
                                ]
                            }
                        }
                    }
                }

                VerticalScrollDecorator {
                    flickable: flickable
                }
            }
        }
    }

    Row {
        id: _row
        width: parent.width
        spacing: Theme.paddingLarge

        Label {
            id: _label
        }

        Label {
            id: _valueLabel
            text: modelDataToLabel(value)
            color: Theme.highlightColor

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
}
