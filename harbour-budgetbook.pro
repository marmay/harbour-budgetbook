# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-budgetbook

CONFIG += sailfishapp

SOURCES += \
    src/backupmanager.cpp \
    src/harbour-budgetbook.cpp

HEADERS += \
    src/backupmanager.h

LIBS += -lz

include(3rdparty/quazip/quazip/quazip.pri)

DISTFILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    translations/*.ts \
    qml/Database.js \
    qml/harbour-budgetbook.qml \
    rpm/harbour-budgetbook.changes \
    rpm/harbour-budgetbook.yaml \
    rpm/harbour-budgetbook.spec \
    harbour-budgetbook.desktop \
    qml/stats/ByCategory.qml \
    qml/elements/ShopSelector.qml \
    qml/elements/CategorySelector.qml \
    qml/elements/ShopTypeSelector.qml \
    qml/Utility.js \
    qml/pages/AddBill.qml \
    qml/elements/Selector.qml \
    qml/pages/BillBrowser.qml \
    qml/elements/TagSelector.qml \
    qml/pages/AddTag.qml \
    qml/pages/Settings.qml \
    qml/pages/CurrencySettings.qml \
    qml/elements/CurrencySelector.qml \
    qml/elements/DateSelector.qml \
    qml/elements/DoughnutChart.qml \
    qml/pages/ByCategoryPage.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += \
    translations/cs.ts \
    translations/de.ts \
    translations/en.ts \
    translations/fi.ts \
    translations/nl.ts \
    translations/sv.ts \
    translations/zh_CN.ts \
    translations/zh_TW.ts

