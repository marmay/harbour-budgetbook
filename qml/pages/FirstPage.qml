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

    onStatusChanged: {
        if (status === PageStatus.Activating)
        {
            stat.update();
        }
    }

    onVisibleChanged: {
        if (visible === true)
        {
            stat.update();
        }
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
                onClicked: pageStack.push(Qt.resolvedUrl("AddBill.qml"))
            }
        }

        PushUpMenu {
            MenuItem {
                text:qsTr("Previous month statistics")
                onClicked: pageStack.push(Qt.resolvedUrl("ByCategory.qml"),
                                          { title: qsTr("Previous month statistics"),
                                              from: Utility.firstOfMonth( -1 ),
                                              to: Utility.firstOfMonth( 0 ) })
            }
            MenuItem {
                text: qsTr("Overall statistics")
                onClicked: pageStack.push(Qt.resolvedUrl("ByCategory.qml"),
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
                text: qsTr("Current month statistics")
                font.pixelSize: Theme.fontSizeSmall
            }

            ByCategory {
                id: stat
                width: column.width
                from: Utility.firstOfMonth(0)
                to: Utility.firstOfMonth(1)
            }
        }
    }
}


