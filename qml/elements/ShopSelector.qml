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
    label: qsTr("Shop");
    buildModel: Database.getShops;
    modelDataToLabel: function (shop) { return shop.name; }

    selectHeader: qsTr("Select Shop");

    addText: qsTr("Add Shop");
    addDialog: Component {
        Dialog {
            id: page

            signal added(var name)

            onAccepted: {
                if (name.text !== "") {
                    Database.addShop(name.text, shopTypeSelector.value, categorySelector.value);
                    added(Database.getShopByName(name.text));
                }
            }

            Column {
                id: column

                x: Theme.paddingLarge
                width: page.width - 2 * Theme.paddingLarge
                spacing: Theme.paddingLarge
                PageHeader {
                    title: qsTr("New Shop")
                }

                TextField {
                    id: name
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    placeholderText: qsTr("Shop name")
                }

                ShopTypeSelector {
                    id: shopTypeSelector
                    width: parent.width
                }

                CategorySelector {
                    id: categorySelector
                    width: parent.width
                }
            }
        }
    }
}
