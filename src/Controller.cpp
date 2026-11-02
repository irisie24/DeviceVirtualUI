#include "Controller.hpp"
#include "Version.hpp"

//New User creation interpage variables
QString newUserId, newPassCode1, newPassCode2;
//New User creation interpage variables

//Reset passcode interpage variables
QString resetUserId, resetPassCode1, resetPassCode2;
//Reset passcode interpage variables

Controller* controllerPtr = nullptr;

Controller::Controller(QGuiApplication *appPtr, QObject *parent)
    : QObject(parent)
{
    app = appPtr;

    appVerion_ = dv_version;
    appVerion_ += ", Qt Version ";
    appVerion_ += qVersion();

    traceString_ = "";

    isAppConnected_ = false;

    lastPage_ = "";
    isDarkTheme_ = true;
    isDemoMode_ = true;
    isTraceEnabled_ = true;
    isDumpRxTxEnabled_ = true;

    if(app->palette().window().color().value() > app->palette().windowText().color().value())
    {
        isDarkTheme_ = false;
        theme_.EnableLightMode();
    }
    else
    {
        isDarkTheme_ = true;
        theme_.EnableDarkMode();
    }

    connect(&mqttClient, &Mqtt::connected, this, &Controller::OnMqttConnected);
    connect(&mqttClient, &Mqtt::disconnected, this, &Controller::OnMqttDisconnected);
    connect(&mqttClient, &Mqtt::messageReceived, this, &Controller::OnMqttMessageReceived);
    connectToMqttBroker();

    dbInterface.setParameters(QSqlDriver::PostgreSQL, "127.0.0.1", "postgres", "postgres", "postgres", 5432);
    bool ret = dbInterface.open();

    if(ret)
    {
        Trace("Database opened");
        new EntityDevice(dbInterface.getDatabase());
        new EntitySensingFlow(dbInterface.getDatabase());
        new EntityActuationRule(dbInterface.getDatabase());
    }
    else
    {
        Trace("Database failure : could NOT open");
    }

    controllerPtr = this;
}

void Controller::InitializeSysten()
{
    emit IsDarkThemeChanged();
    emit IsDemoModeChanged();
    emit IsTraceEnabledChanged();
    emit ThemeChanged();
}

void Controller::invokeApplicationInitialization()
{
    ApplicationInitializationThread *workerThread = new ApplicationInitializationThread(this);
    connect(workerThread, &ApplicationInitializationThread::resultReady, this, &Controller::OnAppInitializationComplete);
    connect(workerThread, &ApplicationInitializationThread::finished, workerThread, &QObject::deleteLater);

    workerThread->start();
}

void ApplicationInitializationThread::run()
{
    QString result;

    controllerPtr->initializeDatabase();

    emit resultReady(result);
}

void Controller::OnAppInitializationComplete()
{
    emit initializationComplete();
    emit DeviceListChanged();
    emit DeviceNamesChanged();
    emit SensingFlowListChanged();
    emit ActuationRuleListChanged();
    emit deviceAction(true);
}

void Controller::setIsAppConnected(bool isappconnected)
{
    isAppConnected_ = isappconnected;
    emit IsAppConnectedChanged();
}

bool Controller::getIsAppConnected()
{
    return isAppConnected_;
}

void Controller::invokeCancel()
{
   emit operationCancelled();
}

void Controller::invokeExit()
{
    lastPage_ = "";
    exit(0);
}

QString  Controller::getAppSyncTime()
{
    return appSyncTime_;
}

void Controller::invokeChangePage(QString ipage)
{
    emit pageAction(ipage);
}

void Controller::invokeThemeUpdate()
{
    if(app->palette().window().color().value() > app->palette().windowText().color().value())
    {
        isDarkTheme_ = false;
    }
    else
    {
        isDarkTheme_ = true;
    }

    emit IsDarkThemeChanged();
}

void Controller::invokeSaveCurrentPage(QString page)
{
    lastPage_ = page;
}

QString Controller::invokeRetreiveLastPage()
{
    return lastPage_;
}

void Controller::invokeAddCommand()
{
    if(lastPage_ == "Devices.qml")
    {
        emit pageAction("AddDevice.qml");
    }

    if(lastPage_ == "SensingFlows.qml")
    {
        emit pageAction("AddSensingFlow.qml");
    }

    if(lastPage_ == "ActuationRules.qml")
    {
        emit pageAction("AddActuationRule.qml");
    }
}

bool Controller::getIsDemoMode()
{
    return isDemoMode_;
}

void Controller::setIsDemoMode(bool isdemomode)
{
    isDemoMode_ = isdemomode;
    emit IsDemoModeChanged();
}

QString Controller::getAppVersion()
{
    return appVerion_;
}

bool Controller::getIsDarkTheme()
{
    return isDarkTheme_;
}

void Controller::setIsDarkTheme(bool isdarktheme)
{
    isDarkTheme_ = isdarktheme;

    if(isDarkTheme_)
    {
        theme_.EnableDarkMode();
    }
    else
    {
        theme_.EnableLightMode();
    }

    emit IsDarkThemeChanged();
    emit ThemeChanged();
}

void Controller::setIsFirstRun(bool isfirstrun)
{
    is_first_run_ = isfirstrun;
    emit IsFirstRunChanged();
}

bool Controller::getIsFirstRun()
{
    if(users_.count() < 1)
    {
        is_first_run_ = true;
    }
    else
    {
        is_first_run_ = false;
    }

    return is_first_run_;
}

ApplicationTheme Controller::getTheme()
{
    return theme_;
}

void Controller::Trace(QString str)
{
    str = QDateTime::currentDateTime().toString("yy-MM-dd hh:mm:ss ") + str + "\n";
    if(traceString_.length() > 1024*1024)
    {
        traceString_.clear();
    }

    traceString_ = traceString_ + str;
    emit TraceStringChanged();
}

void Controller::ClearTrace()
{
    traceString_.clear();
    emit TraceStringChanged();
}

void Controller::setIsTraceEnabled(bool istraceenabled)
{
    isTraceEnabled_ = istraceenabled;
    emit IsTraceEnabledChanged();
}

bool Controller::getIsTraceEnabled()
{
    return isTraceEnabled_;
}

QString Controller::getTraceString()
{
    return traceString_;
}

void Controller::setIsDumpRxTxEnabled(bool isdumprxtxenabled)
{
    isDumpRxTxEnabled_ = isdumprxtxenabled;
    emit IsDumpRxTxEnabledChanged();
}

bool Controller::getIsDumpRxTxEnabled()
{
    return isDumpRxTxEnabled_;
}

void Controller::invokeLogin(QString pin)
{
    bool found = false;

    isTraceEnabled_ = false;
    emit IsTraceEnabledChanged();

    foreach (auto user, users_)
    {
        if(user.PassCode1_ == pin)
        {
            found = true;
            currentUser_ = user;
            break;
        }
    }

    if(found)
    {
        emit userLoginSucceeded();
        emit CurrentUserChanged();
    }
    else
    {
        emit userLoginFailed("Passcode is incorrect. Please retry.");
    }
}

void Controller::invokeChangePassword(QString userid, QString pass)
{
    bool found = true;
    UserInfo u;
    foreach (auto user, users_)
    {
        if(user.UserId_ == userid)
        {
            found = true;
            u = user;
            break;
        }
    }

     currentUser_ = u;

    emit CurrentUserChanged();

    users_.clear();

    emit pageAction("Login.qml");
}

void Controller::invokeCreateUserStage1(QString userid)
{
    bool errorset =  false;

    if(userid.length() > 16 || userid.length() < 4)
    {
        errorset = true;
    }

    for(int x = 0; x < userid.length(); x++)
    {
        char ch = userid.at(x).toLatin1();

        if(isalnum(ch) == 0)
        {
            if(ch != ' ')
            {
                errorset = true;
                break;
            }
        }
    }

    if(errorset)
    {
        emit userNameError();
        return;
    }

    newUserId = userid;

    emit pageAction("CreateUserStage2.qml");
}

void Controller::invokeCreateUserStage2(QString passcode)
{
    newPassCode1 = passcode;
    emit pageAction("CreateUserStage3.qml");
}

void Controller::invokeCreateUserStage3(QString passcode)
{
    newPassCode2 = passcode;

    if(newPassCode1 != newPassCode2)
    {
        emit passCodeMismatch();
        return;
    }

    UserInfo u1;
    u1.IsFirstLogin_ = true;
    u1.PassCode1_ = newPassCode1;
    u1.PassCode2_ = newPassCode2;
    u1.UserId_ = newUserId;


    users_.clear();

    currentUser_ = u1;
    emit CurrentUserChanged();

    emit pageAction("Login.qml");
}

void Controller::invokeResetPasscodeStage1(QString userid)
{
    resetUserId = userid;
    emit pageAction("ResetPasscodeStage2.qml");
}

void Controller::invokeResetPasscodeStage2(QString passcode)
{
    resetPassCode1 = passcode;
    emit pageAction("ResetPasscodeStage3.qml");
}

void Controller::invokeResetPasscodeStage3(QString passcode)
{
    resetPassCode2 = passcode;

    if(resetPassCode1 != resetPassCode2)
    {
        emit passCodeMismatch();
        return;
    }

    foreach (auto user, users_)
    {
        if(user.UserId_ == resetUserId)
        {
            break;
        }
    }


    users_.clear();

    if(users_.count() > 0)
    {
        currentUser_ = users_.at(0);
    }

    emit CurrentUserChanged();
    emit pageAction("Login.qml");
}

void Controller::setCurrentUser(UserInfo iuser)
{
    currentUser_ = iuser;
    emit CurrentUserChanged();
}

UserInfo Controller::getCurrentUser()
{
    return currentUser_;
}

void Controller::setDeviceList(QList<Device> devicelist)
{
    devices_.clear();
    deviceNames_.clear();

    foreach(Device d , devicelist)
    {
        devices_.append(d);
        deviceNames_.append(" [ " + d.DeviceId_ + " ] " + d.DeviceName_);
    }

    emit DeviceListChanged();
    emit DeviceNamesChanged();
}

QList<Device> Controller::getDeviceList()
{
    return devices_;
}

QList<QString> Controller::getDeviceNames()
{
    return deviceNames_;
}

void Controller::setSensingFlowList(QList<SensingFlow> sensingFlowlist)
{
    sensingFlows_.clear();
    flowNames_.clear();

    foreach(SensingFlow s , sensingFlowlist)
    {
        sensingFlows_.append(s);
        flowNames_.append(" [ " + s.FlowId_ + " ] " + s.FlowTypeName_);
    }

    emit SensingFlowListChanged();
}

QList<SensingFlow> Controller::getSensingFlowList()
{
    return sensingFlows_;
}

QList<QString> Controller::getFlowNames()
{
    return flowNames_;
}

void Controller::setActuationRuleList(QList<ActuationRule> actuationRulelist)
{
    actuationRules_.clear();
    ruleNames_.clear();

    foreach(ActuationRule a , actuationRulelist)
    {
        actuationRules_.append(a);
        ruleNames_.append(" [ " + a.RuleId_ + " ] " + a.ConditionName_);
    }

    emit ActuationRuleListChanged();
}

QList<ActuationRule> Controller::getActuationRuleList()
{
    return actuationRules_;
}

QList<QString> Controller::getRuleNames()
{
    return ruleNames_;
}

void Controller::initializeDatabase()
{
    users_.clear();
    deviceNames_.clear();
    flowNames_.clear();
    ruleNames_.clear();
    devices_.clear();
    actuationRules_.clear();
    sensingFlows_.clear();

    users_.append(UserInfo(true, "USER001", "1234", "1234"));

    deviceEntityPtr->allDevice(devices_);

    sensingFlowEntityPtr->allFlow(sensingFlows_);

    actuationRuleEntityPtr->allActuationRule(actuationRules_);

    foreach(Device d , devices_)
    {
        deviceNames_.append(" [ " + d.DeviceId_ + " ] " + d.DeviceName_);
    }

    foreach(SensingFlow s , sensingFlows_)
    {
        flowNames_.append(" [ " + s.FlowId_ + " ] " + s.FlowTypeName_);
    }

    foreach(ActuationRule a , actuationRules_)
    {
        ruleNames_.append(" [ " + a.RuleId_ + " ] " + a.ConditionName_);
    }
}

void Controller::generateDashboardData()
{

}

void Controller::connectToMqttBroker()
{
    mqttClient.Initialize("127.0.0.1", 1883, "DeviceVrtualUI", "", "");
    mqttClient.connect(1, 3600);
}

void Controller::OnMqttConnected()
{
    Trace("MQTT Connected");
    mqttClient.subscribe("devicevirtual/telemetry");
}

void Controller::OnMqttDisconnected()
{
    Trace("MQTT Disonnected");
    QThread::sleep(5);
    mqttClient.connect(1, 3600);
}

void Controller::OnMqttMessageReceived(const QString &topic, const QString &message)
{
    Trace("MQTT Message Received => " + message);
}
