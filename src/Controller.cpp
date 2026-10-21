#include "Controller.hpp"
#include "Help.hpp"
#include "Version.hpp"

//New User creation interpage variables
QString newUName, newConsId, newPassCode1, newPassCode2;
//New User creation interpage variables

//Reset passcode interpage variables
QString resetConsId, resetPassCode1, resetPassCode2;
//Reset passcode interpage variables

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

    for(int x = 1; x < 6; x++)
    {
        //QThread::sleep(1);
    }

    emit resultReady(result);
}

void Controller::OnAppInitializationComplete()
{
    emit initializationComplete();
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

void Controller::invokeLoadHelpStrings(uint32_t index)
{
    helpStringList_.clear();

    Help::LoadHelpStrings(index, helpStringList_);

    emit HelpStringsChanged();
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
    if(userList_.count() < 1)
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

    foreach (auto user, userList_)
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

void Controller::invokeChangePassword(QString consumerid, QString pass)
{
    bool found = true;
    UserInfo u;
    foreach (auto user, userList_)
    {
        if(user.ConsumerId_ == consumerid)
        {
            found = true;
            u = user;
            break;
        }
    }

     currentUser_ = u;

    emit CurrentUserChanged();

    userList_.clear();

    emit pageAction(9);
}

void Controller::invokeCreateUserStage1(QString name, QString userid)
{
    bool errorset =  false;

    if(name.length() > 16 || name.length() < 4)
    {
        errorset = true;
    }

    for(int x = 0; x < name.length(); x++)
    {
        char ch = name.at(x).toLatin1();

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

    newUName = name;
    newConsId = userid;

    emit pageAction(11);
}

void Controller::invokeCreateUserStage2(QString passcode)
{
    newPassCode1 = passcode;
    emit pageAction(12);
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
    u1.ConsumerId_ = newConsId;
    u1.IsFirstLogin_ = true;
    u1.PassCode1_ = newPassCode1;
    u1.PassCode2_ = newPassCode2;
    u1.UserId_ = newUName;


    userList_.clear();

    currentUser_ = u1;
    emit CurrentUserChanged();

    emit pageAction(9);
}

void Controller::invokeResetPasscodeStage1(QString userid)
{
    resetConsId = userid;
    emit pageAction(15);
}

void Controller::invokeResetPasscodeStage2(QString passcode)
{
    resetPassCode1 = passcode;
    emit pageAction(16);
}

void Controller::invokeResetPasscodeStage3(QString passcode)
{
    resetPassCode2 = passcode;

    if(resetPassCode1 != resetPassCode2)
    {
        emit passCodeMismatch();
        return;
    }

    foreach (auto user, userList_)
    {
        if(user.ConsumerId_ == resetConsId)
        {
            break;
        }
    }


    userList_.clear();

    if(userList_.count() > 0)
    {
        currentUser_ = userList_.at(0);
    }

    emit CurrentUserChanged();
    emit pageAction(9);
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
