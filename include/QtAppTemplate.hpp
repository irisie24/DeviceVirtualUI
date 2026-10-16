#ifndef QT_APP_TEMPLATE
#define QT_APP_TEMPLATE

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

class QtAppTemplate : public QGuiApplication
{
    Q_OBJECT
public:
    explicit QtAppTemplate(int argc, char *argv[]);
    virtual ~QtAppTemplate();
    bool Initialize();
private:
};

extern QtAppTemplate* apptempl;

#endif
