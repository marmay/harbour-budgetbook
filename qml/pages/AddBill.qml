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

Dialog {
    id: page

    QtObject {
        id: d

        property double total : 0;
        property var shop : shopSelector.value;
        property var date : new Date();
    }

    onAccepted: {
        var items = [];
        var numberItems = objects.count;
        for (var i = 0; i < numberItems; ++i) {
            items.push({ category: objects.get(i).category,
                           price: objects.get(i).price, tags: []});
            for (var j = 0; j < objects.get(i).tags.count; ++j) {
                items[i].tags.push(objects.get(i).tags.get(j));
            }
        }
        Database.addBill(d.shop, d.date, items);
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            x: Theme.paddingLarge
            width: parent.width - 2 * Theme.paddingLarge
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("New Bill");
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("Total:") + " " + Utility.floatToCurrencyString(d.total)
            }

            ShopSelector {
                id: shopSelector
                width: parent.width
                onValueChanged: {
                    var shop = Database.getShopByName(value.name);
                    categorySelector.value = shop.category;
                }
            }

            Button {
                id: datePicker
                text: d.date.toLocaleDateString();

                onClicked: {
                    var dialog = pageStack.push(pickerComponent, {});
                    dialog.accepted.connect(function() {
                        d.date = dialog.date;
                    });
                }

                Component {
                    id: pickerComponent
                    DatePickerDialog {}
                }
            }

            Separator {
                width: parent.width
            }

            ListModel {
                id: objects
            }

            Repeater {
                id: rep
                model: objects

                Row {
                    width: column.width
                    height: l.height

                    Label {
                        function tagsToString(list) {
                            if (list.count === 0) return "";
                            var str = " (" + list.get(0).name;
                            for (var i = 1; i < list.count; ++i) {
                                str += ", " + list.get(i).name;
                            }
                            str += ")";
                            return str;
                        }

                        id: l
                        width: 0.55 * parent.width
                        text: category.name + tagsToString(tags)
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        width: 0.25 * parent.width
                        text: Utility.floatToCurrencyString(price)
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    IconButton {
                        icon.source: "image://theme/icon-m-remove"
                        icon.width: parent.height
                        icon.height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            d.total -= objects.get(index).price;
                            objects.remove(index);
                        }
                    }
                }
            }

            Separator {
                width: parent.width
            }

            Row {
                id: addMenu
                width: parent.width

                CategorySelector {
                    id: categorySelector

                    // For proper vertical alignment
                    anchors {
                        verticalCenter: price.top
                        verticalCenterOffset: price.textVerticalCenterOffset
                    }
                    width: parent.width - Theme.paddingSmall - price.width
                }

                TextField {
                    id: price

                    // Approximate 9-number-length
                    Label {
                        id: widthHelper
                        visible: false
                        text: "123456789"
                        font.pixelSize: price.font.pixelSize
                    }
                    width: textLeftMargin + widthHelper.width + textRightMargin

                    placeholderText: qsTr("Price")
                    inputMethodHints: Qt.ImhFormattedNumbersOnly | Qt.ImhNoPredictiveText
                    validator: IntValidator { }
                    EnterKey.enabled: text.length > 0 && acceptableInput == true
                    EnterKey.iconSource: "image://theme/icon-m-add"
                    EnterKey.onClicked: {
                        objects.append({ category: categorySelector.value, price: Utility.stringToFloat(price.text),
                                           tags: tagSelector.selectedTags });
                        tagSelector.clear();
                        price.text = "";
                        d.total = 0.;
                        for (var i = 0; i < objects.count; ++i) {
                            d.total += objects.get(i).price;
                        }
                    }
                }
            }

            TagSelector {
                id: tagSelector
                width: parent.width
                height: 60
                _pageStack: pageStack
            }

            Item {
                height: page.height / 2
            }
        }
    }
}
