#include "EntityActuationRule.hpp"

EntityActuationRule* actuationRuleEntityPtr = nullptr;

EntityActuationRule::EntityActuationRule(QSqlDatabase *db, QString tabname) : DataEntity(db, tabname)
{
    actuationRuleEntityPtr = this;
}

EntityActuationRule::~EntityActuationRule()
{
}

bool EntityActuationRule::createTable()
{
    QString sqlString = QString(R"SQL(CREATE TABLE IF NOT EXISTS %1 ("RuleId" text NOT NULL PRIMARY KEY, "DeviceId" text NOT NULL REFERENCES "Devices"("DeviceId") ON DELETE CASCADE, "ConditionType" integer NOT NULL, "ValueThreshold" bigint NOT NULL, "Scale" bigint NOT NULL, "TargetType" integer NOT NULL, "TargetDeviceName" text NOT NULL, "TargetActionValue" bigint NOT NULL, "IsChained" boolean NOT NULL, "RuleIdIfConditionFalse" text NOT NULL DEFAULT '', "RuleIdIfConditionTrue" text NOT NULL DEFAULT ''))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString);
}

bool EntityActuationRule::createActuationRule(const ActuationRule &rec)
{
    QString sqlString = QString(R"SQL(INSERT INTO %1 ("RuleId", "DeviceId", "ConditionType", "ValueThreshold", "Scale", "TargetType", "TargetDeviceName", "TargetActionValue", "IsChained", "RuleIdIfConditionFalse", "RuleIdIfConditionTrue") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString,
                        QVariantList() << rec.RuleId_ << rec.DeviceId_ << rec.Condition_ << rec.ValueThreshold_
                                       << rec.Scale_ << rec.TargetType_ << rec.TargetDeviceName_
                                       << rec.TargetActionValue_ << rec.IsChained_
                                       << rec.RuleIdIfConditionFalse_ << rec.RuleIdIfConditionTrue_);
}

ActuationRule EntityActuationRule::fromRecord(const QSqlRecord &rec)
{
    ActuationRule struc;

    struc.RuleId_ = rec.value("RuleId").toString();
    struc.DeviceId_ = rec.value("DeviceId").toString();
    struc.Condition_ = rec.value("ConditionType").toInt();
    struc.ValueThreshold_ = rec.value("ValueThreshold").toLongLong();
    struc.Scale_ = rec.value("Scale").toULongLong();
    struc.TargetType_ = rec.value("TargetType").toInt();
    struc.TargetDeviceName_ = rec.value("TargetDeviceName").toString();
    struc.TargetActionValue_ = rec.value("TargetActionValue").toLongLong();
    struc.IsChained_ = rec.value("IsChained").toBool();
    struc.RuleIdIfConditionFalse_ = rec.value("RuleIdIfConditionFalse").toString();
    struc.RuleIdIfConditionTrue_ = rec.value("RuleIdIfConditionTrue").toString();
    struc.ConditionName_ = getLogicalConditionName(LogicalCondition(struc.Condition_));

    return struc;
}

bool EntityActuationRule::allActuationRule(QList<ActuationRule> &list)
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

bool EntityActuationRule::selectedActuationRule(QList<ActuationRule> &list, QString keyname, QVariant value)
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

QString getLogicalConditionName(LogicalCondition logic)
{
    switch(logic)
    {
    case Equals:            return "Equals";
    case EqualsOrLesser:    return "Equals Or Lesser";
    case EqualsOrGreater:   return "Equals Or Greater";
    case Lesser:            return "Lesser";
    case Greater:           return "Greater";
    case Unknown:           return "Unknown";
    }

    return "Unknown";   // out-of-range value, e.g. a bad int read back from Type_
}