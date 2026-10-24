#include "EntitySensingFlow.hpp"

EntitySensingFlow* flowEntityPtr = nullptr;

EntitySensingFlow::EntitySensingFlow(QSqlDatabase *db, QString tabname) : DataEntity(db, tabname)
{
    flowEntityPtr = this;
}

EntitySensingFlow::~EntitySensingFlow()
{
}

bool EntitySensingFlow::createTable()
{
    QString sqlString =
        "CREATE TABLE IF NOT EXISTS _table_ ( "
        "flow_id bigserial NOT NULL PRIMARY KEY, "
        "device_id text NOT NULL REFERENCES device(device_id) ON DELETE CASCADE, "
        "flow_type integer NOT NULL, "
        "scale bigint NOT NULL, "
        "duration bigint NOT NULL, "
        "unix_epoch_start bigint NOT NULL, "
        "unix_epoch_end bigint NOT NULL, "
        "minimum bigint NOT NULL, "
        "maximum bigint NOT NULL, "
        "unit_of_measurement varchar(16) NOT NULL, "
        "dataset_filename text NOT NULL DEFAULT '' )";

    sqlString.replace("_table_", _TableName);

    QString indexString = "CREATE INDEX IF NOT EXISTS idx__table__device_id ON _table_ (device_id)";
    indexString.replace("_table_", _TableName);

    return executeQuery(sqlString) && executeQuery(indexString);
}

bool EntitySensingFlow::createFlow(const SensingFlow &rec)
{
    return executeQuery(
        "insert into " + _TableName +
        " (device_id, flow_type, scale, duration, unix_epoch_start, unix_epoch_end, "
        "minimum, maximum, unit_of_measurement, dataset_filename) "
        "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        QVariantList() << rec.DeviceId_ << rec.Type_ << rec.Scale_ << rec.Duration_
                       << rec.UnixEpochStart_ << rec.UnixEpochEnd_ << rec.Minimum_ << rec.Maximum_
                       << rec.UnitOfMeasurement_ << rec.DatasetFilename_);
}

SensingFlow EntitySensingFlow::fromRecord(const QSqlRecord &rec)
{
    SensingFlow struc;

    struc.FlowId_ = rec.value("flow_id").toLongLong();
    struc.DeviceId_ = rec.value("device_id").toString();
    struc.Type_ = rec.value("flow_type").toInt();
    struc.Scale_ = rec.value("scale").toULongLong();
    struc.Duration_ = rec.value("duration").toULongLong();
    struc.UnixEpochStart_ = rec.value("unix_epoch_start").toULongLong();
    struc.UnixEpochEnd_ = rec.value("unix_epoch_end").toULongLong();
    struc.Minimum_ = rec.value("minimum").toULongLong();
    struc.Maximum_ = rec.value("maximum").toULongLong();
    struc.UnitOfMeasurement_ = rec.value("unit_of_measurement").toString();
    struc.DatasetFilename_ = rec.value("dataset_filename").toString();

    return struc;
}

bool EntitySensingFlow::allFlow(QList<SensingFlow> &list)
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

bool EntitySensingFlow::selectedFlow(QList<SensingFlow> &list, QString keyname, QVariant value)
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
