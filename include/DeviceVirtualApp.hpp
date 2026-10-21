#ifndef DEVICE_VIRTUAL_APP
#define DEVICE_VIRTUAL_APP

#include <QtQuickWidgets/QQuickWidget>
#include <QGuiApplication>
#include <QPalette>
#include <QMap>
#include <QObject>
#include <QString>
#include <QQuickItem>
#include <QSettings>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickView>
#include <QFileInfo>
#include <QStandardPaths>
#include <QDir>
#include <QFile>

class DeviceVirtualApp : public QGuiApplication
{
    Q_OBJECT
public:
    explicit DeviceVirtualApp(int argc, char *argv[]);
    virtual ~DeviceVirtualApp();
    bool Initialize();
private:
};

extern DeviceVirtualApp* appptr;

#endif
