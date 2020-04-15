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
import "../elements"
import "../Database.js" as Database
import "../Utility.js" as Utility

Column {
    property date from : Utility.firstOfMonth(0)
    property date to : Utility.firstOfMonth(1)
    property bool _updating: false

    Component.onCompleted: update()

    property ListModel newModel: ListModel {}

    function update() {
        if(!_updating) {
            _updating = true

            var db = Database.openDatabase();
            var colors = ["#2F9235", "#246D70", "#BA763B", "#BA3F3B", "#025608", "#024042", "#6E3403", "#6E0603",
                          "#50AF56", "#3E8386", "#DE9D66", "#DE6966"];
            var runningTotal = 0.0

            newModel.clear()
            legendModel.clear()
            db.readTransaction(function (tx) {
                var rs = tx.executeSql(
                            "SELECT categories.name AS name, SUM(invoice_items.pri_price) AS price \
                         FROM invoices INNER JOIN invoice_items ON invoices.id = invoice_items.invoice \
                              INNER JOIN categories ON invoice_items.category = categories.id \
                         WHERE invoices.at >= ? AND invoices.at < ? \
                         GROUP BY categories.id ORDER BY price DESC",
                            [from.getTime() / 1000, to.getTime() / 1000]);

                for (var i = 0; i < rs.rows.length; ++i) {
                    runningTotal = runningTotal + rs.rows.item(i).price
                    newModel.append({ "cLabel": rs.rows.item(i).name, "cValue": rs.rows.item(i).price, "cColor": colors[i], "runningTotal": runningTotal})
                    legendModel.append({"label": rs.rows.item(i).name, "value": rs.rows.item(i).price, "itemColor": colors[i] })
                }
            });
            chart.totalValue = runningTotal
            chart.model = newModel

            db.readTransaction(function (tx) {
                var rs = tx.executeSql(
                            "SELECT SUM(invoice_items.pri_price) AS price " +
                            "FROM invoices INNER JOIN invoice_items ON invoices.id = invoice_items.invoice " +
                            "WHERE invoices.at >= ? AND invoices.at <= ?",
                            [from.getTime() / 1000, to.getTime() / 1000]);
                if (rs.rows.length === 1 && rs.rows.item(0).price) {
                    totalLabel.total = rs.rows.item(0).price;
                    totalLabel.text = Utility.floatToCurrencyString(totalLabel.total);
                }
                else {
                    totalLabel.text = qsTr("Please add more bills!");
                }
            });
            _updating = false;
        }
    }

    spacing: Theme.paddingLarge

    Item {
        width: parent.width
        height: parent.width * 0.8

        DoughnutChart {
            id: chart
            width: parent.width * 0.8
            height: width
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            Label {
                id: totalLabel
                property double total : 0.
                width: 0.8 * parent.width
                anchors.centerIn: parent
                text: total > 0.0 ? Utility.floatToCurrencyString(total) : ""
                wrapMode: Label.WordWrap
                horizontalAlignment: Label.AlignHCenter
                font.pixelSize: Theme.fontSizeLarge
            }
        }
    }

    ListModel {
        id: legendModel
    }

    Flow {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 2 * Theme.paddingLarge
        spacing: Theme.paddingLarge

        Repeater {
            model: legendModel
            delegate: Row {
                height: Theme.fontSizeSmall
                spacing: Theme.paddingSmall

                Rectangle {
                    width: Theme.fontSizeSmall
                    height: width
                    color: itemColor
                    border.width: Theme.paddingSmall / 3.0
                    border.color: Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: label + " (" + Utility.floatToCurrencyString(value) + ")"
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
