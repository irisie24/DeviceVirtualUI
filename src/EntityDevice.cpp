#include "EntityDevice.hpp"

EntityDevice* deviceEntityPtr = nullptr;

EntityDevice::EntityDevice(QSqlDatabase *db, QString tabname) : DataEntity(db, tabname)
{
    deviceEntityPtr = this;
}

EntityDevice::~EntityDevice()
{
}

bool EntityDevice::createTable()
{
    QString sqlString =
        "CREATE TABLE IF NOT EXISTS _table_ ( "
        "device_id text NOT NULL PRIMARY KEY, "
        "device_name text NOT NULL, "
        "make text NOT NULL, "
        "model text NOT NULL, "
        "number_of_flows bigint NOT NULL, "
        "repeat_flow_sequence boolean NOT NULL, "
        "flow_sequence_end bigint NOT NULL, "
        "mode integer NOT NULL, "
        "operating_max bigint NOT NULL, "
        "operating_min bigint NOT NULL, "
        "latitude bigint NOT NULL, "
        "longitude bigint NOT NULL, "
        "altitude bigint NOT NULL, "
        "gen_model integer NOT NULL )";

    sqlString.replace("_table_", _TableName);

    return executeQuery(sqlString);
}

bool EntityDevice::createDevice(const Device &rec)
{
    return executeQuery(
        "insert into " + _TableName +
        " (device_id, device_name, make, model, number_of_flows, repeat_flow_sequence, "
        "flow_sequence_end, mode, operating_max, operating_min, latitude, longitude, "
        "altitude, gen_model) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        QVariantList() << rec.DeviceId_ << rec.DeviceName_ << rec.Make_ << rec.Model_
                       << rec.NumberOfFlows_ << rec.RepeatFlowSequence_ << rec.FlowSequenceEnd_
                       << rec.Mode_ << rec.OperatingMax_ << rec.OperatingMin_
                       << rec.Latitude_ << rec.Longitude_ << rec.Altitude_ << rec.GenModel_);
}

Device EntityDevice::fromRecord(const QSqlRecord &rec)
{
    Device struc;

    struc.DeviceId_ = rec.value("device_id").toString();
    struc.DeviceName_ = rec.value("device_name").toString();
    struc.Make_ = rec.value("make").toString();
    struc.Model_ = rec.value("model").toString();
    struc.NumberOfFlows_ = rec.value("number_of_flows").toUInt();
    struc.RepeatFlowSequence_ = rec.value("repeat_flow_sequence").toBool();
    struc.FlowSequenceEnd_ = rec.value("flow_sequence_end").toULongLong();
    struc.Mode_ = rec.value("mode").toInt();
    struc.OperatingMax_ = rec.value("operating_max").toULongLong();
    struc.OperatingMin_ = rec.value("operating_min").toULongLong();
    struc.Latitude_ = rec.value("latitude").toULongLong();
    struc.Longitude_ = rec.value("longitude").toULongLong();
    struc.Altitude_ = rec.value("altitude").toULongLong();
    struc.GenModel_ = rec.value("gen_model").toInt();

    return struc;
}

bool EntityDevice::allDevice(QList<Device> &list)
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

bool EntityDevice::selectedDevice(QList<Device> &list, QString keyname, QVariant value)
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
