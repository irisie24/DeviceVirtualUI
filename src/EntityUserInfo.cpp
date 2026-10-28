#include "EntityUserInfo.hpp"

EntityUserInfo* userinfoEntityPtr = nullptr;

EntityUserInfo::EntityUserInfo(QSqlDatabase *db, QString tabname) : DataEntity(db, tabname)
{
    userinfoEntityPtr = this;
}

EntityUserInfo::~EntityUserInfo()
{
}

bool EntityUserInfo::createTable()
{
    QString sqlString = QString(R"SQL(CREATE TABLE IF NOT EXISTS %1 ("UserId" TEXT NOT NULL PRIMARY KEY, "PassCode1" TEXT NOT NULL, "PassCode2" TEXT NOT NULL, "IsFirstLogin" INTEGER NOT NULL, UNIQUE ("UserId")))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString);
}

bool EntityUserInfo::createUserInfo(const UserInfo &rec)
{
    QString sqlString = QString(R"SQL(INSERT INTO %1 ("UserId", "PassCode1", "PassCode2", "IsFirstLogin") VALUES (?, ?, ?, ?))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString,
                        QVariantList() << rec.UserId_ << rec.PassCode1_ << rec.PassCode2_
                                       << (rec.IsFirstLogin_ ? 1 : 0));
}

UserInfo EntityUserInfo::fromRecord(const QSqlRecord &rec)
{
    UserInfo struc;

    struc.UserId_ = rec.value("UserId").toString();
    struc.PassCode1_ = rec.value("PassCode1").toString();
    struc.PassCode2_ = rec.value("PassCode2").toString();
    struc.IsFirstLogin_ = rec.value("IsFirstLogin").toInt() != 0;

    return struc;
}

bool EntityUserInfo::allUserInfo(QList<UserInfo> &list)
{
    QList<QSqlRecord> *reclist = getAllRecords();

    if(reclist == nullptr)
    {
        return false;
    }

    for(int ctr = 0; ctr < reclist->count(); ctr++)
    {
        list.append(fromRecord(reclist->at(ctr)));
    }

    return true;
}

bool EntityUserInfo::selectedUserInfo(QList<UserInfo> &list, QString keyname, QVariant value)
{
    QList<QSqlRecord> *reclist = getSelectedRecords(keyname, value);

    if(reclist == nullptr)
    {
        return false;
    }

    for(int ctr = 0; ctr < reclist->count(); ctr++)
    {
        list.append(fromRecord(reclist->at(ctr)));
    }

    return true;
}