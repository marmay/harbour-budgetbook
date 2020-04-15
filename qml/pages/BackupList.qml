/*
 * Budgetbook Copyright (C) Markus Mayr <markus.mayr@outlook.com>
 * BackupList.qml Copyright (C) 2020 Matti Viljanen <matti.viljanen@kapsi.fi>
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

    signal backupRestored()

    PageHeader {
        id: header
        title: "Restore backup"
    }

    Notification {
        id: backupNotification
        isTransient: true
    }

    SilicaListView {
        id: backupList
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        model: BackupManager.backupList

        delegate: ListItem {
            id: backupListItem
            menu: contextMenu

            ListView.onRemove: RemoveAnimation {
                target: backupListItem
            }

            RemorseItem {
                id: restoreRemorse
                onTriggered: {
                    BackupManager.dateString = display
                    var success = BackupManager.restoreBackup()
                    if(success) {
                        backupNotification.previewSummary = qsTr("Backup restored successfully")
                        backupNotification.publish()
                        backupRestored()
                        pageStack.navigateBack()
                    }
                    else {
                        backupNotification.previewSummary = qsTr("Restoring backup failed")
                        backupNotification.publish()
                    }
                }
            }

            RemorseItem {
                id: deleteRemorse
                onTriggered: {
                    BackupManager.dateString = display
                    var success = BackupManager.deleteBackup()
                    if(success) {
                    }
                    else {
                        backupNotification.previewSummary = qsTr("Deleting backup failed")
                        backupNotification.publish()
                    }
                }
            }

            Icon {
                id: icon
                source: "image://theme/icon-m-backup"
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                }
            }

            Label {
                id: label
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: icon.right
                    right: parent.right
                    leftMargin: Theme.paddingSmall
                    rightMargin: Theme.paddingMedium
                }
                truncationMode: TruncationMode.Fade

                Component.onCompleted: {
                    var date = Date.fromLocaleString(Qt.locale(), display, "yyyyMMdd-hhmmss")
                    text = date.toLocaleString(Qt.locale("fi"), Locale.ShortFormat)
                }
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("Restore backup")
                        onClicked: {
                            restoreRemorse.execute(backupListItem, qsTr("Restoring backup"))
                        }
                    }
                    MenuItem {
                        text: qsTr("Delete backup")
                        onClicked: {
                            deleteRemorse.execute(backupListItem, qsTr("Deleting backup"))
                        }
                    }
                }
            }
        }
    }

    ViewPlaceholder {
        enabled: backupList.count === 0
        text: qsTr("No backups.")
        hintText: qsTr("Create backups in Settings page.")
    }
}
