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
import "../QChart"
import "../Database.js" as Database
import "../Utility.js" as Utility

Column {
    property date from : "2015-01-01"
    property date to : "2015-01-31"

    onFromChanged: update()
    onToChanged: update()
    Component.onCompleted: update()

    function update() {
        var db = Database.openDatabase();
        var colors = ["#2F9235", "#246D70", "#BA763B", "#BA3F3B", "#025608", "#024042", "#6E3403", "#6E0603",
                        "#50AF56", "#3E8386", "#DE9D66", "#DE6966"];
        var data = [];
        legendModel.clear();
        db.readTransaction(function (tx) {
            /*
            var rs = tx.executeSql(
                        "SELECT categories.name AS name, SUM(invoice_items.price) AS price \
                         FROM invoices INNER JOIN invoice_items ON invoices.id = invoice_items.invoice \
                              INNER JOIN categories ON invoice_items.category = categories.id \
                         WHERE invoices.at >= ? AND invoices.at <= ? \
                         GROUP BY categories.id ORDER BY price DESC",
                        [from + " 00:00:00", to + " 23:59:59"]);
                        */
            var rs = tx.executeSql(
                        "SELECT categories.name AS name, SUM(invoice_items.price) AS price \
                         FROM invoice_items INNER JOIN categories ON invoice_items.category = categories.id \
                         GROUP BY categories.id ORDER BY price DESC");

            for (var i = 0; i < rs.rows.length; ++i) {
                data.push( { label: rs.rows.item(i).name, value: rs.rows.item(i).price,
                              color: colors[i] } );
                legendModel.append({ label: rs.rows.item(i).name, value: rs.rows.item(i).price, itemColor: colors[i] });
            }
        });
        chart.chartData = data;
        chart.chart = null;
        chart.requestPaint();

        totalLabel.total = Database.getTotal();
    }

    spacing: Theme.paddingLarge

    Item {
        width: parent.width
        height: width

        Chart {
            id: chart
            anchors.fill: parent
            chartType: Charts.ChartType.DOUGHNUT
            chartData: []
        }

        Label {
            id: totalLabel
            property double total : 0.
            anchors.centerIn: parent
            text: Utility.floatToCurrencyString(total)
            font.pixelSize: Theme.fontSizeLarge
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
                    border.width: 1
                    border.color: "#ffffff"
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
