#include "desktopcleaner.h"
#include <iostream>
#include <QDebug>
#include <QFile>
#include <QDirIterator>
#include <QDir>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

DesktopCleaner::DesktopCleaner(QObject *parent) : QObject(parent)
{
    this->setDesktopPath("C:/Users/Александр/Desktop/DesktopBackup");
    this->setMode(0);
}

void DesktopCleaner::executeTransition(QString params)
{
    //updateFilesMoved();
    _filesMoved = 0;
    qDebug() << desktopPath << backupDirectory;

    switch (this->transitionMode) {
        case Format:
            formatTransition(params);
            break;

        case Size:
            sizeTransition(params);
            break;

        case Name:
            nameTransition(params);
            break;
    }

    qDebug() << "transition done with parameters " << params;
}

void DesktopCleaner::setMode(int mode)
{
    switch (mode) {
        case 0:
            transitionMode = Format;
        break;

        case 1:
            transitionMode = Size;
        break;

        case 2:
            transitionMode = Name;
        break;
    }

    qDebug() << transitionMode;
}

void DesktopCleaner::setDesktopPath(QString pathQML)
{
    this->desktopPath = pathQML;
    this->backupDirectory = desktopPath + "/DesktopCleanerBackup";
    qDebug() << desktopPath;
}

bool DesktopCleaner::checkProcessing()
{
    return m_isProcessing;
}

int DesktopCleaner::checkFilesMove()
{
    return _filesMoved;
}

QString DesktopCleaner::checkMessage()
{
    return _messageList.join(", ");
}

void DesktopCleaner::setProcessing(bool value)
{
    if (m_isProcessing == value)
        return;
    m_isProcessing = value;
    emit isProcessingChanged(value);
}

void DesktopCleaner::updateFilesMoved()
{
    _filesMoved++;

}

void DesktopCleaner::updateMessage(QString directoryName)
{
    _messageList.append(directoryName);
}

void DesktopCleaner::formatTransition(QString params)
{
    QStringList paramsList = params.split(' ');
    QDirIterator it(desktopPath, QDirIterator::NoIteratorFlags);
    qDebug() << paramsList;
    bool specific;
    if (paramsList.length() == 0)
        specific = false;
    else specific = true;

    while (it.hasNext()) {
        qDebug() << it.next();
        QString suffix = it.fileInfo().suffix();

        if ((specific && paramsList.contains(suffix, Qt::CaseInsensitive)) || !specific)
        {
            qDebug() << "moved";
            QString path = desktopPath + "/" + suffix;
            QString oldFile = it.filePath();
            moveFile(oldFile, path);
        }
    }
}

void DesktopCleaner::sizeTransition(QString params)
{
    int num1, num2;
    bool isKB1, isKB2;
    bool secondParam = params[0] == "t";
    setSizeValues(params, &num1, &isKB1, secondParam, &num2, &isKB2);
    bool isLess = params[0] == "l";

    qDebug() << params << num1 << num2 << secondParam;
    return;
    QDirIterator it(desktopPath, QDirIterator::NoIteratorFlags);

    while (it.hasNext()) {
        qDebug() << it.next();

        if(!secondParam)
        {
            sizeSingleCon(&it, isLess, num1, isKB1);
        }
        else
        {
            sizeTwoCons(&it, num1, isKB1, num2, isKB2);
        }
    }
}

void DesktopCleaner::sizeSingleCon(QDirIterator* it, bool isLess, int con, bool isKB)
{
    int fileSize = it->fileInfo().size();

    if ((isLess && fileSize <= con) ||
            (!isLess && fileSize >= con))
      {
          QString pathTitle = isLess ? "/До " : "/От ";
          con /= isKB ? 1024 : 1024 * 1024;
          QString unit = isKB ? "KB" : "MB";
          QString path = desktopPath + pathTitle + QString::number(con) + unit;
          QString oldFile = it->filePath();
          moveFile(oldFile, path);
    }
}

void DesktopCleaner::sizeTwoCons(QDirIterator* it, int con1, bool isKB1, int con2, bool isKB2)
{
    int fileSize = it->fileInfo().size();

    if (fileSize >= con1 && fileSize <= con2)
    {
        QString unit1 = isKB1 ? "KB" : "MB";
        QString unit2 = isKB2 ? "KB" : "MB";
        con1 /= isKB1 ? 1024 : 1024 * 1024;
        con2 /= isKB2 ? 1024 : 1024 * 1024;
        QString path = desktopPath + "/От " + QString::number(con1) + unit1 + " до " + QString::number(con2) + unit2;
        QString oldFile = it->filePath();
        moveFile(oldFile, path);
    }
}

void DesktopCleaner::setSizeValues(QString params, int *num1, bool *isKB1, bool secondParam, int *num2, bool *isKB2)
{
    *isKB1 = params[1] == "K";

    QString num1Str;
    QString num2Str;
    int index = 2;
    for (; index < params.length(); index++){
        if(params[index] == " "){
            break;
        }
        num1Str += params[index];
    }

    *num1 = num1Str.toInt() * 1024;
    if (!*isKB1)
        *num1 *=  1024;

    if (secondParam){
        QString num2Str;
        *isKB2 = params[params.length() - 1] == "K";

        for (index++; index < params.length(); index++){
            if(!params[index].isNumber()){
                break;
            }
            num2Str += params[index];
        }

        *num2 = num2Str.toInt() * 1024;
        if (!*isKB2)
            *num2 *= 1024;
    }


}

void DesktopCleaner::nameTransition(QString params)
{
    QStringList paramsList = params.split('%');
    QDirIterator it(desktopPath, QDirIterator::NoIteratorFlags);
    qDebug() << paramsList;

    while (it.hasNext()) {
        qDebug() << it.next();
        QString name = it.fileInfo().fileName();

        for (int i = 0; i < paramsList.length(); i++) {
            QStringList words = paramsList[i].split(" ");
            int wordsMet = 0;
            for (int j = 0; j < words.length(); j++)
            {
                if (name.contains(words[j], Qt::CaseInsensitive))
                {
                    wordsMet++;

                }
            }

            if (wordsMet == words.length())
            {
                QString folderName = paramsList[i];
                QString oldFile = it.filePath();
                QString path = desktopPath + "/" + folderName;
                moveFile(oldFile, path);
            }
        }
    }
}

void DesktopCleaner::moveFile(QString oldFile, QString directoryName)
{
    if (!QDir(directoryName).exists())
        QDir().mkpath(directoryName);

    QString fileName = oldFile.split('/').last();
    QString newFile = directoryName + "/" + fileName;
    QFile::copy(oldFile, newFile);

    if (!QDir(backupDirectory).exists())
        QDir().mkpath(backupDirectory);
    QString backupFile = backupDirectory + "/" + fileName;
    QFile::copy(oldFile, backupFile);

    updateFilesMoved();
    updateMessage(directoryName);
    QFile::remove(oldFile);
}

