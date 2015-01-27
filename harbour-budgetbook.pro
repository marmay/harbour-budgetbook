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
    src/harbour-budgetbook.cpp \
    src/model/billmodel.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    translations/*.ts \
    qml/Database.js \
    qml/harbour-budgetbook.qml \
    rpm/harbour-budgetbook.changes.in \
    rpm/harbour-budgetbook.yaml \
    rpm/harbour-budgetbook.spec \
    harbour-budgetbook.desktop \
    qml/stats/ByCategory.qml \
    qml/QChart/QChart.js \
    qml/QChart/QChart.qml \
    qml/QChart/LICENSE \
    qml/QChart/qmldir \
    qml/elements/ShopSelector.qml \
    qml/elements/CategorySelector.qml \
    qml/elements/ShopTypeSelector.qml \
    qml/Utility.js \
    qml/pages/AddBill.qml \
    qml/elements/Selector.qml \
    qml/pages/Statistics.qml \
    qml/pages/BillBrowser.qml \
    qml/elements/TagSelector.qml \
    qml/pages/AddTag.qml \
    qml/pages/Settings.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-budgetbook-de.ts

HEADERS += \
    src/model/billmodel.h

