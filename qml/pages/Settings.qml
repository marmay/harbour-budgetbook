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
import Nemo.Notifications 1.0
import "../Database.js" as Database

Page {
    id: page

    signal dataChanged

    onStatusChanged: {
        if (status === PageStatus.Activating)
        {
            primaryCurrency.text = Database.getPrimaryCurrency().symbol;
        }
    }

    property Item remorse

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Backup database")
                onClicked: {
                    if(BackupManager.makeBackup())
                         console.log("Success")
                    else
                        console.log("Failure")

                }
            }
            MenuItem {
                text: qsTr("Restore last backup")
                onClicked: {
                    var filename = BackupManager.checkRestoreBackup()
                    console.log(filename)
                    if(filename.length === 0) {
                        backupNotification.previewSummary = qsTr("No backups found.")
                        backupNotification.publish()
                    }
                    else {
                        remorse = Remorse.popupAction(page, qsTr("Restoring backup"), function() { restoreBackup() })
                    }
                }

                Notification {
                    id: backupNotification
                    isTransient: true
                }

                function restoreBackup() {
                    var success = BackupManager.doRestoreBackup()
                    if(success) {
                        backupNotification.previewSummary = qsTr("Backup restored successfully.")
                        backupNotification.publish()
                    }
                    else {
                        backupNotification.previewSummary = qsTr("Restoring backup failed.")
                        backupNotification.publish()
                    }
                    dataChanged()
                }
            }
        }

        Column {
            id: column
            width: parent.width - 2.0*Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter

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
