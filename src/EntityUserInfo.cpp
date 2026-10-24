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
    QString sqlString =
        "CREATE TABLE IF NOT EXISTS _table_ ( "
        "user_id text NOT NULL PRIMARY KEY, "
        "consumer_id text NOT NULL, "
        "passcode1 text NOT NULL, "
        "passcode2 text NOT NULL, "
        "first_login integer NOT NULL, "
        "UNIQUE ( consumer_id ) )";

    sqlString.replace("_table_", _TableName);

    return executeQuery(sqlString);
}

bool EntityUserInfo::createUserInfo(const UserInfo &rec)
{
    return executeQuery(
        "insert into " + _TableName +
        " (user_id, consumer_id, passcode1, passcode2, first_login) values (?, ?, ?, ?, ?)",
        QVariantList() << rec.UserId_ << rec.ConsumerId_ << rec.PassCode1_ << rec.PassCode2_
                       << (rec.IsFirstLogin_ ? 1 : 0));
}

UserInfo EntityUserInfo::fromRecord(const QSqlRecord &rec)
{
    UserInfo struc;

    struc.UserId_ = rec.value("user_id").toString();
    struc.ConsumerId_ = rec.value("consumer_id").toString();
    struc.PassCode1_ = rec.value("passcode1").toString();
    struc.PassCode2_ = rec.value("passcode2").toString();
    struc.IsFirstLogin_ = rec.value("first_login").toInt() != 0;

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
