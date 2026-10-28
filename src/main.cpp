#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include "DeviceVirtualApp.hpp"
#include "Controller.hpp"

int main(int argc, char *argv[])
{
    Q_INIT_RESOURCE(DeviceVirtualUI);

    DeviceVirtualApp  app(argc, argv);
    Controller controller(&app);
    
    const QUrl urlMain("qrc:///qml/MainWindow.qml");

    qRegisterMetaType<QList<Device>>("QList<Device>");

    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("applicationData", &controller);
    engine.load(urlMain);
    
    if(!app.Initialize())
    {
        return -1;
    }

    controller.InitializeSysten();

    return app.exec();
}
