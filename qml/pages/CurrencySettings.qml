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
import "../elements"

Dialog {
    id: dialog
    property var exchangeRateValues : []

    onAccepted: {
        var db = Database.openDatabase();
        db.transaction(function (tx) {
            tx.executeSql("UPDATE currencies SET is_primary = ?", 0);
            tx.executeSql("UPDATE currencies SET is_primary = ? WHERE id = ?", [1, selector.value.id]);
            tx.executeSql("UPDATE currencies SET to_primary = ? WHERE id = ?", [1, selector.value.id]);
            tx.executeSql("UPDATE invoice_items SET pri_price = price WHERE currency = ?", selector.value.id);
            for (var i = 0; i < exchangeRateValues.length; ++i) {
                if (exchangeRateValues[i]) {
                    tx.executeSql("UPDATE currencies SET to_primary = ? WHERE id = ?",
                                  [exchangeRateValues[i].value, exchangeRateValues[i].id]);
                    tx.executeSql("UPDATE invoice_items SET pri_price = price * ? WHERE currency = ?",
                                  [exchangeRateValues[i].value, exchangeRateValues[i].id]);
                }
            }
        });
        Database.currencies = null;
    }

    Component.onCompleted: {
        updateExchangeRateModel();
    }

    function checkCanAccept()
    {
        var currencies = Database.getCurrencies();
        for (var i = 0; i < currencies.length; ++i) {
            if (currencies[i].id !== selector.value.id &&
                    (! exchangeRateValues[currencies[i].id] ||
                        ! exchangeRateValues[currencies[i].id].value))
            {
                canAccept = false;
                return;
            }
        }
        canAccept = true;
    }

    function updateExchangeRateModel()
    {
        var l = [];
        var currencies = Database.getCurrencies();
        for (var i = 0; i < currencies.length; ++i) {
            if (currencies[i].id !== selector.value.id) {
                l.push({ id: currencies[i].id, symbol: currencies[i].symbol,
                        to_primary: currencies[i].to_primary });
            }
        }
        exchangeRateValues = [];
        exchangeRates.model = l;
        checkCanAccept();
    }

    SilicaFlickable {
        x: Theme.paddingLarge
        width: parent.width - 2 * Theme.paddingLarge
        height: parent.height
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Currency Settings")
            }

            CurrencySelector {
                id: selector
                onValueChanged: {
                    updateExchangeRateModel();
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Exchange rates")
                font.pixelSize: Theme.fontSizeLarge
            }

            Repeater {
                id: exchangeRates
                delegate: Row {
                    width: parent.width

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 0.5 * parent.width
                        text: modelData.symbol + " " + qsTr("to") + " " + selector.value.symbol
                    }

                    TextField {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 0.5 * parent.width
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        placeholderText: qsTr("Exchange rate");
                        onTextChanged: {
                            exchangeRateValues[modelData.id] = {
                                id: modelData.id, value: Utility.stringToFloat(text)
                            };
                            checkCanAccept();
                        }
                    }
                }
            }
        }
    }
}
