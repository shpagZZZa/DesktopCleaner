#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include "desktopcleaner.h"
#include <QIcon>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    qmlRegisterType<DesktopCleaner>("DesktopCleaner", 1, 0, "DesktopCleaner");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    app.setWindowIcon(QIcon("icon.ico"));
    return app.exec();
}
