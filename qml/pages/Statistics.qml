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

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("January statistics")
                onClicked: pageStack.push(Qt.resolvedUrl("ByCategory.qml"),
                                          { title: qsTr("January statistics"),
                                             from: new Date("2015-01-01"),
                                               to: new Date("2015-02-01") });
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Overall statistics")
                onClicked: pageStack.push(Qt.resolvedUrl("ByCategory.qml"),
                                          { title: qsTr("Overall statistics"),
                                             from: new Date("2015-01-01"),
                                               to: new Date("2015-04-01") });
            }
        }
    }
}
