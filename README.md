BudgetBook for Sailfish OS
==========================

An application for devices running Jolla's Sailfish OS that enables users to
keep track of their expenses.

Cloning and compiling
---------------------

You have to get the QChart submodule before compiling:

    git submodule init
    git submodule update

If you deploy the project as an RPM package, you will get this verification error:

    ERROR [/usr/share/harbour-budgetbook/qml/QChart/.git] Source control directories must not be included

To fix it, delete the file `qml/QChart/.git` from the project. The commands above will recreate it.
