#ifndef CONTROLLER_
#define CONTROLLER_

#include <QObject>
#include <QGuiApplication>
#include <QDateTime>
#include <QString>
#include <QStringList>
#include <QList>

#include <QUuid>
#include <QPalette>

#include "ApplicationTheme.hpp"
#include "EntityUserInfo.hpp"
#include "EntityDevice.hpp"
#include "EntitySensingFlow.hpp"
#include "EntityActuationRule.hpp"
#include "Logger.hpp"

typedef enum ScanMode
{
    PairingCode=0,
    STSToken=1
}ScanMode;

class Controller : public QObject
{
    Q_OBJECT

public:
    explicit Controller(QGuiApplication* appPtr, QObject *parent = nullptr);

    void InitializeSysten();
    void Trace(QString str);
    void ClearTrace();
    void initializeDatabase();
    void generateDashboardData();

    Q_INVOKABLE void invokeThemeUpdate();
    Q_INVOKABLE void invokeChangePage(int ipage);
    Q_INVOKABLE void invokeApplicationInitialization();

    Q_INVOKABLE void invokeCancel();
    Q_INVOKABLE void invokeExit();

    Q_INVOKABLE void invokeLogin(QString pin);
    Q_INVOKABLE void invokeChangePassword(QString userid, QString pass);

    Q_INVOKABLE void invokeCreateUserStage1(QString userid);
    Q_INVOKABLE void invokeCreateUserStage2(QString passcode);
    Q_INVOKABLE void invokeCreateUserStage3(QString passcode);

    Q_INVOKABLE void invokeResetPasscodeStage1(QString userid);
    Q_INVOKABLE void invokeResetPasscodeStage2(QString passcode);
    Q_INVOKABLE void invokeResetPasscodeStage3(QString passcode);

    Q_INVOKABLE void invokeSaveCurrentPage(QString page);
    Q_INVOKABLE QString invokeRetreiveLastPage();
    Q_INVOKABLE void invokeLoadHelpStrings(uint32_t index);

    Q_PROPERTY (QString AppVersion READ getAppVersion NOTIFY AppVersionChanged)
    QString getAppVersion();

    Q_PROPERTY (bool IsDarkTheme READ getIsDarkTheme WRITE setIsDarkTheme NOTIFY IsDarkThemeChanged)
    bool getIsDarkTheme();
    void setIsDarkTheme(bool isdarktheme);

    Q_PROPERTY (bool IsDemoMode READ getIsDemoMode WRITE setIsDemoMode NOTIFY IsDemoModeChanged)
    bool getIsDemoMode();
    void setIsDemoMode(bool isdemomode);

    Q_PROPERTY (bool IsAppConnected READ getIsAppConnected WRITE setIsAppConnected NOTIFY IsAppConnectedChanged)
    void setIsAppConnected(bool isappconnected);
    bool getIsAppConnected();

    Q_PROPERTY (UserInfo CurrentUser READ getCurrentUser WRITE setCurrentUser NOTIFY CurrentUserChanged)
    void setCurrentUser(UserInfo iuser);
    UserInfo getCurrentUser();

    Q_PROPERTY (QList<QString> HelpStrings READ getHelpStrings NOTIFY HelpStringsChanged)
    QList<QString> getHelpStrings();

    Q_PROPERTY (bool IsFirstRun READ getIsFirstRun WRITE setIsFirstRun NOTIFY IsFirstRunChanged)
    void setIsFirstRun(bool isfirstrun);
    bool getIsFirstRun();

     Q_PROPERTY (QString AppSyncTime READ getAppSyncTime NOTIFY AppSyncTimeChanged)
    QString getAppSyncTime();

    Q_PROPERTY (ApplicationTheme Theme READ getTheme NOTIFY ThemeChanged)
    ApplicationTheme getTheme();

    Q_PROPERTY (QString TraceString READ getTraceString NOTIFY TraceStringChanged)
    QString getTraceString();

    Q_PROPERTY (bool IsTraceEnabled READ getIsTraceEnabled WRITE setIsTraceEnabled NOTIFY IsTraceEnabledChanged)
    void setIsTraceEnabled(bool istraceenabled);
    bool getIsTraceEnabled();

    Q_PROPERTY (bool IsDumpRxTxEnabled READ getIsDumpRxTxEnabled WRITE setIsDumpRxTxEnabled NOTIFY IsDumpRxTxEnabledChanged)
    void setIsDumpRxTxEnabled(bool isdumprxtxenabled);
    bool getIsDumpRxTxEnabled();

    Q_PROPERTY (QList<Device> DeviceList READ getDeviceList WRITE setDeviceList NOTIFY DeviceListChanged)
    void setDeviceList(QList<Device> devicelist);
    QList<Device> getDeviceList();

    Q_PROPERTY (QList<SensingFlow> SensingFlowList READ getSensingFlowList WRITE setSensingFlowList NOTIFY SensingFlowListChanged)
    void setSensingFlowList(QList<SensingFlow> sensingFlowlist);
    QList<SensingFlow> getSensingFlowList();

    Q_PROPERTY (QList<ActuationRule> ActuationRuleList READ getActuationRuleList WRITE setActuationRuleList NOTIFY ActuationRuleListChanged)
    void setActuationRuleList(QList<ActuationRule> actuationRulelist);
    QList<ActuationRule> getActuationRuleList();

signals:

    void ThemeChanged();
    void ShowIndicatorChanged();
    void HelpStringsChanged();
    void AppSyncTimeChanged();
    void IsDarkThemeChanged();
    void IsDemoModeChanged();
    void AppVersionChanged();
    void IsTraceEnabledChanged();
    void TraceStringChanged();
    void IsDumpRxTxEnabledChanged();
    void IsCameraAccessEnabledChanged();
    void IsFirstRunChanged();

    //Property change signals
    void IsAppConnectedChanged();

    void CurrentUserChanged();

    //UI events and operations states
    void authenticationSuccessfull();
    void authenticationFailed();
    void operationCancelled();
    void pageAction(int ipage);
    void userLoginSucceeded();
    void userLoginFailed(QString reason);

    //Data related
    void deviceAction(bool fl);
    void deviceMessage(bool fl, QString str);

    //User management errors
    void userNameError();
    void passCodeMismatch();

    //Trace/progress
    void initializationComplete();

    //UI Indicators
    void progressIndicatorsOff();
    void progressIndicatorsOn();
    void networkIndicatorsOff();
    void networkIndicatorsOn();
    void updateDashboard();

    //Entities
    void DeviceListChanged();
    void SensingFlowListChanged();
    void ActuationRuleListChanged();

private slots:
    void OnAppInitializationComplete();

private:

    QGuiApplication* app;

    QList<QString> helpStringList_;
    QString helpImageUrl_;

    //Globals / Miscellanous
    bool is_first_run_;
    QString lastPage_;
    QString appVerion_;
    bool isAppConnected_;

    bool isDarkTheme_;
    bool isDemoMode_;
    bool isTraceEnabled_;
    bool isDumpRxTxEnabled_;
    ApplicationTheme theme_;
    QString traceString_;

    QString appSyncTime_;

    //Fixed objects
    UserInfo currentUser_;

    QDateTime sessionStart_;
    QDateTime sessionEnd_;

    //Entities
    QList<UserInfo> users_;
    QList<Device> devices_;
    QList<SensingFlow> sensingFlows_;
    QList<ActuationRule> actuationRules_;
};

extern Controller* controllerPtr;

class ApplicationInitializationThread : public QThread
{
    Q_OBJECT
public:
    explicit ApplicationInitializationThread(QObject *parent = nullptr) : QThread(parent) { }
protected:
    void run() override;

signals:
    void resultReady(const QString &s);
};

#endif
