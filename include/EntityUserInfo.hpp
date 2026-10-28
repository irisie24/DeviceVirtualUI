#ifndef ENTITY_USER_INFO
#define ENTITY_USER_INFO

#include <QObject>
#include <QtSql>
#include "DataEntity.hpp"

class UserInfo
{
public:
    Q_GADGET

public:
    bool    IsFirstLogin_ = false;
    QString UserId_;
    QString PassCode1_;
    QString PassCode2_;

public:
    Q_PROPERTY(bool IsFirstLogin MEMBER IsFirstLogin_)
    Q_PROPERTY(QString UserId MEMBER UserId_)
    Q_PROPERTY(QString PassCode1 MEMBER PassCode1_)
    Q_PROPERTY(QString PassCode2 MEMBER PassCode2_)

public:
    UserInfo()
    {
    }

    UserInfo(bool iIsFirstLogin, QString iUserId, QString iPassCode1, QString iPassCode2)
    {
        IsFirstLogin_ = iIsFirstLogin;
        UserId_ = iUserId;
        PassCode1_ = iPassCode1;
        PassCode2_ = iPassCode2;
    }
};

// Table: "Users"
class EntityUserInfo : public DataEntity
{
public:
    EntityUserInfo(QSqlDatabase* db, QString tabname);
    virtual ~EntityUserInfo();
    bool createTable();
    bool createUserInfo(const UserInfo &rec);
    bool allUserInfo(QList<UserInfo> &list);
    bool selectedUserInfo(QList<UserInfo> &list, QString keyname, QVariant value);
private:
    static UserInfo fromRecord(const QSqlRecord &rec);
};

extern EntityUserInfo* userinfoEntityPtr;

#endif
