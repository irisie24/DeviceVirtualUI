#include "EntitySensingFlow.hpp"

EntityFlow* flowEntityPtr = nullptr;

EntityFlow::EntityFlow(QSqlDatabase *db, QString tabname) : DataEntity(db, tabname)
{
    flowEntityPtr = this;
}

EntityFlow::~EntityFlow()
{
}

bool EntityFlow::createTable()
{
    QString sqlString = QString(R"SQL(CREATE TABLE IF NOT EXISTS %1 ("FlowId" TEXT NOT NULL PRIMARY KEY, "DeviceId" TEXT NOT NULL REFERENCES "Devices"("DeviceId") ON DELETE CASCADE, "FlowType" INTEGER NOT NULL, "Scale" BIGINT NOT NULL, "Duration" BIGINT NOT NULL, "UnixEpochStart" BIGINT NOT NULL, "UnixEpochEnd" BIGINT NOT NULL, "Minimum" BIGINT NOT NULL, "Maximum" BIGINT NOT NULL, "UnitOfMeasurement" VARCHAR(16) NOT NULL, "DatasetFilename" TEXT NOT NULL DEFAULT ''))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString);
}

bool EntityFlow::createFlow(const SensingFlow &rec)
{
    QString sqlString = QString(R"SQL(INSERT INTO %1 ("DeviceId", "FlowType", "Scale", "Duration", "UnixEpochStart", "UnixEpochEnd", "Minimum", "Maximum", "UnitOfMeasurement", "DatasetFilename") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString,
                        QVariantList() << rec.DeviceId_ << rec.Type_ << rec.Scale_ << rec.Duration_
                                       << rec.UnixEpochStart_ << rec.UnixEpochEnd_ << rec.Minimum_
                                       << rec.Maximum_ << rec.UnitOfMeasurement_ << rec.DatasetFilename_);
}

SensingFlow EntityFlow::fromRecord(const QSqlRecord &rec)
{
    SensingFlow struc;

    struc.FlowId_ = rec.value("FlowId").toString();
    struc.DeviceId_ = rec.value("DeviceId").toString();
    struc.Type_ = rec.value("FlowType").toInt();
    struc.Scale_ = rec.value("Scale").toULongLong();
    struc.Duration_ = rec.value("Duration").toULongLong();
    struc.UnixEpochStart_ = rec.value("UnixEpochStart").toULongLong();
    struc.UnixEpochEnd_ = rec.value("UnixEpochEnd").toULongLong();
    struc.Minimum_ = rec.value("Minimum").toULongLong();
    struc.Maximum_ = rec.value("Maximum").toULongLong();
    struc.UnitOfMeasurement_ = rec.value("UnitOfMeasurement").toString();
    struc.DatasetFilename_ = rec.value("DatasetFilename").toString();

    return struc;
}

bool EntityFlow::allFlow(QList<SensingFlow> &list)
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

bool EntityFlow::selectedFlow(QList<SensingFlow> &list, QString keyname, QVariant value)
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