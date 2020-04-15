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
import "../stats"

Page {
    id: page

    property alias from : stat.from
    property alias to: stat.to
    property alias title: label.text

    Component.onCompleted: statRenderTimer.start()

    Timer {
        id: statRenderTimer
        triggeredOnStart: false
        repeat: false
        interval: 500
        onTriggered: {
            stat._updating = false
            stat.update()
            placeholder.enabled = false
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height + Theme.paddingLarge*2

        Column {
            id: column
            x: Theme.paddingLarge
            width: page.width - Theme.paddingLarge*2
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Statistics")
            }

            Label {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ByCategory {
                id: stat
                width: column.width
                _updating: true // to postpone drawing

                ViewPlaceholder {
                    id: placeholder
                    enabled: true
                    BusyIndicator {
                        anchors.centerIn: parent
                        size: BusyIndicatorSize.Large
                        running: parent.enabled
                    }
                }
            }
        }
    }
}
