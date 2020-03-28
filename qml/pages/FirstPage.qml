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
import "../Database.js" as Database
import "../Utility.js" as Utility
import "../stats"
import "../elements"

Page {
    id: page

    property int monthDelta: 0

    Component.onCompleted: {
        monthLabel.text = stat.from.toLocaleString(Qt.locale(), "MMMM yyyy")
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"));
            }
            MenuItem {
                text: qsTr("Browse Bills")
                onClicked: pageStack.push(Qt.resolvedUrl("BillBrowser.qml"))
            }
            MenuItem {
                text: qsTr("Add Bill")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("AddBill.qml"))
                    dialog.accepted.connect(function() {
                        stat.update()
                    })
                }
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("Overall statistics")
                onClicked: pageStack.push(Qt.resolvedUrl("ByCategoryPage.qml"),
                                          { title: qsTr("Overall statistics"),
                                              from: new Date("2015-01-01"),
                                              to: new Date("2099-01-01") });
            }
        }

        contentHeight: column.height + Theme.paddingLarge*2

        Column {
            id: column
            x: Theme.paddingLarge
            width: page.width - Theme.paddingLarge*2
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("BudgetBook")
            }

            Label {
                id: monthLabel
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: parent.width
                height: buttonItem.height

                Item {
                    id: buttonItem
                    width: prevMonthButton.width + Theme.paddingLarge + nextMonthButton.width
                    height: prevMonthButton.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        id: prevMonthButton
                        anchors.left: parent.left
                        text: "<<"
                        onClicked: {
                            monthDelta = monthDelta - 1
                            stat.from = Utility.firstOfMonth(monthDelta)
                            stat.to = Utility.firstOfMonth(monthDelta+1)
                            monthLabel.text = stat.from.toLocaleString(Qt.locale(), "MMMM yyyy")
                            stat.update()
                        }
                    }
                    Button {
                        id: nextMonthButton
                        anchors.right: parent.right
                        text: ">>"
                        onClicked: {
                            monthDelta = monthDelta + 1
                            stat.from = Utility.firstOfMonth(monthDelta)
                            stat.to = Utility.firstOfMonth(monthDelta+1)
                            monthLabel.text = stat.from.toLocaleString(Qt.locale(), "MMMM yyyy")
                            stat.update()
                        }
                    }
                }
            }

            ByCategory {
                id: stat
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
            }
        }
    }
}


