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

.pragma library
.import "Database.js" as Database

function stringToFloat(s) {
    return Number.fromLocaleString(Qt.locale(), s);
}

function floatToCurrencyString(f) {
    var locale = Qt.locale();
    return Number(f).toLocaleCurrencyString(locale, Database.getPrimaryCurrency().symbol);
}

function floatToCurrencyStringWithCurrency(f, cur) {
    var locale = Qt.locale();
    return Number(f).toLocaleCurrencyString(locale, Database.getCurrencyById(cur).symbol);
}

/*
 * Returns the date that corresponds to the first day of the given month.
 * off specifies the offset from the current month, so
 * firstOfMonth( 0 ) returns the first of the current month,
 * firstOfMonth( 1 ) the first of the next month,
 * firstOfMonth( -1 ) the first of the last month and so on.
 *
 * Date is returned as Javascript Date object.
 */
function firstOfMonth(off) {
    var tmp = new Date();
    var year = tmp.getFullYear();
    var month = tmp.getMonth();

    while( off <= -12 )
    {
        year -= 1;
        off += 12;
    }

    while( off >= 12 )
    {
        year += 1;
        off -= 12;
    }

    if( off < 0 && - off > month )
    {
        year -= 1;
        off += 12;
    }

    if( off > 0 && off + month >= 12 )
    {
        year += 1;
        off -= 12;
    }

    month += off;

    return new Date(year, month, 1, 0, 0, 0, 0);
}
