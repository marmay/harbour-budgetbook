#include "backupmanager.h"

BackupManager::BackupManager(QObject *parent) : QObject(parent)
{
    backupListModel = new QStringListModel(this);
}

void BackupManager::setPaths(QString newDatabasePath, QString newHomePath)
{
    databasePath = newDatabasePath;
    homePath = newHomePath;
}

bool BackupManager::makeBackup()
{
    QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd-HHmmss");
    QString destination = QDir::homePath() + QDir::separator() + "harbour-budgetbook_" + timestamp + ".bak";

    QDir sourceDir = QDir(databasePath);

    return JlCompress::compressDir(destination, databasePath, false, QDir::Files);
}

bool BackupManager::restoreBackup()
{
    return JlCompress::extractDir(QDir::homePath() + QDir::separator() + "harbour-budgetbook_" + dateString + ".bak", databasePath).count() > 0;
}

bool BackupManager::deleteBackup()
{
    bool success = QFile::remove(QDir::homePath() + QDir::separator() + "harbour-budgetbook_" + dateString + ".bak");
    if(success) {
        int id = backupListModel->stringList().indexOf(dateString);
        backupListModel->removeRows(id, 1);
    }
    return success;
}

void BackupManager::setDateString(QString newString) {
    dateString = newString;
}

QString BackupManager::getDateString() {
    return dateString;
}

QStringListModel* BackupManager::getBackupList()
{
    QDir homeDir(QDir::homePath());

    QStringList files = homeDir.entryList(QStringList("harbour-budgetbook_*.bak"), QDir::Files, QDir::Name);

    QStringList backupList;
    QRegularExpression regex("([0-9]{8}-[0-9]{6})");

    foreach(QString f, files) {
        QRegularExpressionMatch caps = regex.match(f);

        if(caps.hasMatch())
            backupList << caps.captured(1);
    }

    backupListModel->setStringList(QStringList(backupList));

    return backupListModel;
}
