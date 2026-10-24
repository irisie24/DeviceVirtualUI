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
    QString sqlString =
        "CREATE TABLE IF NOT EXISTS _table_ ( "
        "device_id text NOT NULL REFERENCES device(device_id) ON DELETE CASCADE, "
        "rule_id text NOT NULL, "
        "condition_type integer NOT NULL, "
        "value_threshold bigint NOT NULL, "
        "scale bigint NOT NULL, "
        "target_type integer NOT NULL, "
        "target_device_name text NOT NULL, "
        "target_action_value bigint NOT NULL, "
        "is_chained boolean NOT NULL, "
        "rule_id_if_condition_false text NOT NULL DEFAULT '', "
        "rule_id_if_condition_true text NOT NULL DEFAULT '', "
        "PRIMARY KEY (device_id, rule_id) )";

    sqlString.replace("_table_", _TableName);

    return executeQuery(sqlString);
}

bool EntityActuationRule::createActuationRule(const ActuationRule &rec)
{
    return executeQuery(
        "insert into " + _TableName +
        " (device_id, rule_id, condition_type, value_threshold, scale, target_type, "
        "target_device_name, target_action_value, is_chained, "
        "rule_id_if_condition_false, rule_id_if_condition_true) "
        "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        QVariantList() << rec.DeviceId_ << rec.RuleId_ << rec.Condition_ << rec.ValueThreshold_
                       << rec.Scale_ << rec.TargetType_ << rec.TargetDeviceName_
                       << rec.TargetActionValue_ << rec.IsChained_
                       << rec.RuleIdIfConditionFalse_ << rec.RuleIdIfConditionTrue_);
}

ActuationRule EntityActuationRule::fromRecord(const QSqlRecord &rec)
{
    ActuationRule struc;

    struc.DeviceId_ = rec.value("device_id").toString();
    struc.RuleId_ = rec.value("rule_id").toString();
    struc.Condition_ = rec.value("condition_type").toInt();
    struc.ValueThreshold_ = rec.value("value_threshold").toLongLong();
    struc.Scale_ = rec.value("scale").toULongLong();
    struc.TargetType_ = rec.value("target_type").toInt();
    struc.TargetDeviceName_ = rec.value("target_device_name").toString();
    struc.TargetActionValue_ = rec.value("target_action_value").toLongLong();
    struc.IsChained_ = rec.value("is_chained").toBool();
    struc.RuleIdIfConditionFalse_ = rec.value("rule_id_if_condition_false").toString();
    struc.RuleIdIfConditionTrue_ = rec.value("rule_id_if_condition_true").toString();

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
