#ifndef BACKUPMANAGER_H
#define BACKUPMANAGER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDir>
#include <QDateTime>
#include <QStandardPaths>
#include <QDebug>

#include "zlib.h"
#include "JlCompress.h"

class BackupManager : public QObject
{
    Q_OBJECT


public:
    BackupManager(QObject *parent = 0);
    BackupManager(QString newdb);

    Q_INVOKABLE bool makeBackup();
    Q_INVOKABLE QString checkRestoreBackup();
    Q_INVOKABLE bool doRestoreBackup();

private:
    QString databaseDir = "";
    QString backupFile = "";

    QString getLastBackup();
};

#endif // BACKUPMANAGER_H
