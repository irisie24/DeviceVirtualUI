#include "Controller.hpp"
#include "Help.hpp"
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

    appVerion_ = csa_version;
    appVerion_ += ", Qt Version ";
    appVerion_ += qVersion();

    traceString_ = "";

    isAppConnected_ = false;

    lastPage_ = "";
    isDarkTheme_ = true;
    isDemoMode_ = true;
    isTraceEnabled_ = false;
    isDumpRxTxEnabled_ = false;

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

    controllerPtr = this;
}

void Controller::InitializeSysten()
{
    Help::LoadHelpStrings(0, helpStringList_);
    emit HelpStringsChanged();

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

void Controller::invokeChangePage(int ipage)
{
    //emit pageAction(ipage);
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

void Controller::invokeLoadHelpStrings(uint32_t index)
{
    helpStringList_.clear();

    Help::LoadHelpStrings(index, helpStringList_);

    emit HelpStringsChanged();
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

QList<QString> Controller::getHelpStrings()
{
    return helpStringList_;
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
    Logger::GetInstance()->write(str.toStdString(), LogInfo);
    str = QDateTime::currentDateTime().toString("yy-MM-dd hh:mm:ss ") + str + "\n";
    if(traceString_.length() > 1024*1024)
    {
        traceString_.clear();
    }

    traceString_ = str + traceString_;
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

    foreach(Device d , devicelist)
    {
        devices_.append(d);
    }

    emit DeviceListChanged();
}

QList<Device> Controller::getDeviceList()
{
    return devices_;
}

void Controller::setSensingFlowList(QList<SensingFlow> sensingFlowlist)
{
    sensingFlows_.clear();

    foreach(SensingFlow s , sensingFlowlist)
    {
        sensingFlows_.append(s);
    }

    emit SensingFlowListChanged();
}

QList<SensingFlow> Controller::getSensingFlowList()
{
    return sensingFlows_;
}

void Controller::setActuationRuleList(QList<ActuationRule> actuationRulelist)
{
    actuationRules_.clear();

    foreach(ActuationRule a , actuationRulelist)
    {
        actuationRules_.append(a);
    }

    emit ActuationRuleListChanged();
}

QList<ActuationRule> Controller::getActuationRuleList()
{
    return actuationRules_;
}

void Controller::initializeDatabase()
{
    users_.append(UserInfo(true, "USER001", "1234", "1234"));

    devices_.append(Device("DEV-001", "USER001", "Boiler Temperature Probe", "Acme", "T-100", 3, true, 1900000000ULL, SimulationModeRealtime, 15000ULL, 0ULL, 2257ULL, 8836ULL, 1100ULL, MarkovTwoState, "degC", 10));
    devices_.append(Device("DEV-002", "USER001", "Line Pressure Transducer", "Borealis", "P-250", 5, false, 1895000000ULL,SimulationModeDataset, 40000ULL, 500ULL, 1908ULL, 7288ULL, 1400ULL, Bernoulli, "bar", 10));
    devices_.append(Device("DEV-003", "USER001", "Coolant Flow Meter", "Cirrus", "F-30", 2, true, 1910000000ULL, SimulationModeRealtime, 9000ULL, 100ULL, 1308ULL, 8027ULL, 600ULL, PoissonOnset, "cusec", 10));
    devices_.append(Device("DEV-004", "USER001", "Motor Vibration Sensor", "Delta", "V-8", 4, true, 1905000000ULL, SimulationModeDataset, 2000ULL, 0ULL, 2861ULL, 7721ULL, 21600ULL, HiddenMarkov, "khz", 10));
    devices_.append(Device("DEV-005", "USER001", "Tank Level Switch", "Eon", "L-5", 1, false, 1890000000ULL, SimulationModeRealtime, 1000ULL, 0ULL, 1297ULL, 7759ULL, 92000ULL, DeterministicPattern, "cm", 10));

    sensingFlows_.append(SensingFlow("10001", "DEV-001", 1, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10002", "DEV-001", 2, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10003", "DEV-002", 1, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10004", "DEV-002", 2, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10005", "DEV-003", 1, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10006", "DEV-003", 2, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10007", "DEV-004", 1, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10008", "DEV-004", 2, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10009", "DEV-005", 1, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));
    sensingFlows_.append(SensingFlow("10010", "DEV-005", 2, 100, 300, 1790812800, 1793404800, 18, 35, "degC", "Boiler.csv"));

    actuationRules_.append(ActuationRule("10001", "DEV-001",  1, 40, 100, 3, "/dev/USB0", 5, false, " "," "));
    actuationRules_.append(ActuationRule("10002", "DEV-001",  2, 40, 100, 4, "/dev/USB0", 7, false, " "," "));
    actuationRules_.append(ActuationRule("10003", "DEV-002",  1, 40, 100, 3, "/dev/USB0", 5, false, " "," "));
    actuationRules_.append(ActuationRule("10004", "DEV-002",  2, 40, 100, 4, "/dev/USB0", 7, false, " "," "));
    actuationRules_.append(ActuationRule("10005", "DEV-003",  1, 40, 100, 3, "/dev/USB0", 5, false, " "," "));
    actuationRules_.append(ActuationRule("10006", "DEV-003",  2, 40, 100, 4, "/dev/USB0", 7, false, " "," "));
    actuationRules_.append(ActuationRule("10007", "DEV-004",  1, 40, 100, 3, "/dev/USB0", 5, false, " "," "));
    actuationRules_.append(ActuationRule("10008", "DEV-004",  2, 40, 100, 4, "/dev/USB0", 7, false, " "," "));
    actuationRules_.append(ActuationRule("10009", "DEV-005",  1, 40, 100, 3, "/dev/USB0", 5, false, " "," "));
    actuationRules_.append(ActuationRule("10010", "DEV-005",  2, 40, 100, 4, "/dev/USB0", 7, false, " "," "));


}

void Controller::generateDashboardData()
{

}
