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

Page {

    signal dataChanged

    onStatusChanged: {
        if (status === PageStatus.Activating)
        {
            primaryCurrency.text = Database.getPrimaryCurrency().symbol;
        }
    }

    SilicaFlickable {
        x: Theme.paddingLarge
        width: parent.width - 2 * Theme.paddingLarge
        height: parent.height
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: qsTr("Settings")
            }

            Item {
                width: parent.width
                height: row.height

                Row {
                    id: row
                    spacing: Theme.paddingLarge

                    Label {
                        text: qsTr("Primary currency")
                    }

                    Label {
                        id: primaryCurrency
                        color: Theme.highlightColor
                        text: Database.getPrimaryCurrency().symbol
                        onTextChanged: dataChanged()
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: pageStack.push(Qt.resolvedUrl("CurrencySettings.qml"))
                }
            }
        }
    }
}
