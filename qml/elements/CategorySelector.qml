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

Selector {
    label: qsTr("Category");
    buildModel: Database.getCategories;
    modelDataToLabel: function (category) { return category.name; }

    selectHeader: qsTr("Select Category");

    addText: qsTr("Add Category");
    addDialog: Component {
        Dialog {
            id: page

            signal added(var category)

            onAccepted: {
                if (name.text !== "") {
                    Database.addCategory(name.text);
                    added(Database.getCategoryByName(name.text));
                }
            }

            Column {
                id: column

                width: page.width
                spacing: Theme.paddingLarge
                PageHeader {
                    title: qsTr("New Category")
                }

                TextField {
                    id: name
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 2 * Theme.paddingLarge
                    placeholderText: qsTr("Category name")
                }
            }
        }
    }
}
