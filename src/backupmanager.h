#ifndef BACKUPMANAGER_H
#define BACKUPMANAGER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QStringListModel>
#include <QFile>
#include <QDir>
#include <QDateTime>
#include <QStandardPaths>
#include <QRegularExpression>
#include <QDebug>

#include "zlib.h"
#include "JlCompress.h"

class BackupManager : public QObject
{
    Q_OBJECT


public:
    BackupManager(QObject *parent = 0);
    BackupManager(QString newdb);

    void setPaths(QString newDatabasePath, QString newHomePath);

    Q_PROPERTY(QString dateString READ getDateString WRITE setDateString NOTIFY dateStringChanged)
    Q_PROPERTY(QStringListModel* backupList READ getBackupList NOTIFY backupListChanged)

    Q_INVOKABLE bool makeBackup();
    Q_INVOKABLE bool restoreBackup();
    Q_INVOKABLE bool deleteBackup();

    void setDateString(QString newString);

    QString getDateString();

    QStringListModel* getBackupList();

private:
    QString dateString;
    QString databasePath;
    QString homePath;
    QStringListModel* backupListModel;

signals:
    void dateStringChanged(QString);
    void backupListChanged(QStringListModel*);

};

#endif // BACKUPMANAGER_H
