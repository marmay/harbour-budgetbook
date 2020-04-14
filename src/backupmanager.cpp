#include "backupmanager.h"

BackupManager::BackupManager(QObject *parent) : QObject(parent)
{

}

BackupManager::BackupManager(QString newdb) : QObject()
{
    databaseDir = newdb;
}

bool BackupManager::makeBackup()
{
    QString timestamp = QDateTime::currentDateTime().toString("_yyyyMMdd-HHmmss");
    QString destination = QDir::homePath() + QDir::separator() + "harbour-budgetbook" + timestamp + ".bak";

    QDir sourceDir = QDir(databaseDir);

    return JlCompress::compressDir(destination, databaseDir, false, QDir::Files);
}

QString BackupManager::checkRestoreBackup()
{
    backupFile = getLastBackup();
    return backupFile;
}

bool BackupManager::doRestoreBackup()
{
    return JlCompress::extractDir(backupFile, databaseDir).count() > 0;
}

QString BackupManager::getLastBackup()
{
    QDir homeDir(QDir::homePath());
    QStringList backups = homeDir.entryList(QStringList("harbour-budgetbook_*.bak"), QDir::Files, QDir::Name);

    if(backups.count() == 0)
        return QString();

    QFile backup(homeDir.path() + QDir::separator() + backups.last());
    if(backup.exists() && (JlCompress::getFileList(backup.fileName()).count() == 2))
        return backup.fileName();

    return QString();
}
