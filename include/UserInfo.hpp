#ifndef USER_INFO
#define USER_INFO

#include <QObject>
#include <QtSql>

class UserInfo
{
public:
    Q_GADGET

public:
    bool IsFirstLogin_;
public:
    QString UserId_;
public:
    QString ConsumerId_;
public:
    QString PassCode1_;
public:
    QString PassCode2_;
public:
    Q_PROPERTY(bool IsFirstLogin MEMBER IsFirstLogin_)
    Q_PROPERTY(QString UserId MEMBER UserId_)
    Q_PROPERTY(QString ConsumerId MEMBER ConsumerId_)
    Q_PROPERTY(QString PassCode1 MEMBER PassCode1_)
    Q_PROPERTY(QString PassCode2 MEMBER PassCode2_)

public:
    ~UserInfo();
    UserInfo();
    UserInfo(bool iIsFirstLogin, QString iUserId, QString iConsumerId, QString iPassCode1, QString iPassCode2);
    UserInfo(const UserInfo& other);
    UserInfo& operator = (const UserInfo& other);
};

#endif
