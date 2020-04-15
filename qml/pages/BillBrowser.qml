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

Page {
    id: page

    signal billRemoved

    function removeBill(idx, id)
    {
        var db = Database.openDatabase();
        db.transaction(function (tx) {
            tx.executeSql('DELETE FROM invoice_item_tags ' +
                          'WHERE invoice_item IN (' +
                          'SELECT id FROM invoice_items ' +
                          'WHERE invoice = ?)', id);
            tx.executeSql('DELETE FROM invoice_items ' +
                          'WHERE invoice = ?', id);
            tx.executeSql('DELETE FROM invoices WHERE id = ?', id);
        });
        model.remove(idx);
    }

    ListModel {
        id: model

        function update()
        {
            model.clear();
            var db = Database.openDatabase();
            db.readTransaction(function (tx) {
                var rs = tx.executeSql(
                    'SELECT invoices.id AS id, invoices.at AS date, ' +
                    'shops.name AS shop, ' +
                    'GROUP_CONCAT(categories.name) AS categories, ' +
                    'SUM(invoice_items.price) AS price, ' +
                    'invoice_items.currency AS currency ' +
                    'FROM invoices INNER JOIN shops ON invoices.shop = shops.id ' +
                    'INNER JOIN invoice_items ON invoices.id = invoice_items.invoice ' +
                    'INNER JOIN categories ON invoice_items.category = categories.id ' +
                    'GROUP BY invoices.id ORDER BY date DESC');
                for (var i = 0; i < rs.rows.length; ++i) {
                    var item = rs.rows.item(i);
                    model.append({
                        id: item.id, date: new Date(1000 * item.date).toLocaleDateString(Qt.locale(), Locale.ShortFormat),
                        shop: item.shop, categories: item.categories, price: item.price, currency: item.currency
                    });
                }
            });
        }
    }

    Component.onCompleted: model.update();

    SilicaListView {
        property Item contextMenu

        Component {
            id: contextMenuComponent
            ContextMenu {
                property Item deleteItem
                MenuItem {
                    text: qsTr("Delete")
                    onClicked: deleteItem.remove();
                }
            }
        }

        id: listView
        anchors.fill: parent
        header: PageHeader { title: qsTr("Browse Bills") }
        model: model
        section {
            property: "date"
            delegate: SectionHeader {
                text: section
            }
        }

        delegate: Item {
            id: listItem
            property bool menuOpen: listView.contextMenu !== null && listView.contextMenu.parent === listItem
            width: listView.width
            height: menuOpen ? listView.contextMenu.height + bItem.height : bItem.height

            ListView.onRemove: RemoveAnimation {
                target: listItem
            }

            BackgroundItem {
                id: bItem

                width: listView.width
                height: 2 * Theme.fontSizeLarge
                onPressAndHold: {
                    if (!listView.contextMenu)
                        listView.contextMenu = contextMenuComponent.createObject(listView);
                    listView.contextMenu.deleteItem = bItem;
                    listView.contextMenu.open(listItem);
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 2 * Theme.paddingLarge

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 0.7 * parent.width

                        Label {
                            width: parent.width
                            elide: Text.ElideRight
                            text: shop
                            font.pixelSize: Theme.fontSizeSmall
                            color: bItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }
                        Label {
                            width: parent.width
                            elide: Text.ElideRight
                            text: categories
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: bItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }
                    }

                    Label {
                        width: 0.3 * parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        text: Utility.floatToCurrencyStringWithCurrency(price, currency)
                        color: bItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                }

                function remove()
                {
                    remorse.execute(bItem, qsTr("Deleting"), function() {
                        removeBill(index, id)
                        billRemoved()
                    });
                }

                RemorseItem {
                    id: remorse
                }
            }
        }
        VerticalScrollDecorator {}
    }
}
