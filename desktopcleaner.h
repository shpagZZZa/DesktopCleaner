#ifndef DESKTOPCLEANER_H
#define DESKTOPCLEANER_H

#include <QDirIterator>
#include <QDir>
#include <QFile>
#include <QObject>

class DesktopCleaner : public QObject
{
    enum TransitionMode{
        Format,
        Size,
        Name
    };

    Q_OBJECT
    Q_PROPERTY(bool isProcessing READ checkProcessing
               WRITE setProcessing NOTIFY isProcessingChanged);
    Q_PROPERTY(int filesMoved READ checkFilesMove)
    Q_PROPERTY(QString message READ checkMessage)

public:
    explicit DesktopCleaner(QObject *parent = nullptr);
    Q_INVOKABLE void executeTransition(QString params);
    Q_INVOKABLE void setMode(int mode);
    Q_INVOKABLE void setDesktopPath(QString path);
    bool checkProcessing();
    void setProcessing(bool value);
    int checkFilesMove();
    QString checkMessage();
    QString error;

private:
    void formatTransition(QString params);
    void sizeTransition(QString params);
    void sizeSingleCon(QDirIterator* it, bool isLess, int con, bool isKB);
    void sizeTwoCons(QDirIterator* it, int con1, bool isKB1, int con2, bool isKB2);
    void setSizeValues(QString params, int* num1, bool* isKB1, bool secondParam, int* num2, bool* isKB2);
    void nameTransition(QString params);
    void moveFile(QString fileName, QString directoryName);
    void updateFilesMoved();
    void updateMessage(QString directoryName);
    TransitionMode transitionMode;
    QString desktopPath;
    QString backupDirectory;
    bool m_isProcessing = false;
    int _filesMoved = 0;
    QStringList _messageList = QStringList();

signals:
    void isProcessingChanged(bool value);
    void filesMovedChanged(int value);
    void messageChanged(QString value);

};

#endif // DESKTOPCLEANER_H
