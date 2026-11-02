#include "EntityDevice.hpp"

EntityDevice* deviceEntityPtr = nullptr;

EntityDevice::EntityDevice(QSqlDatabase *db) : DataEntity(db, "Devices")
{
    deviceEntityPtr = this;
}

EntityDevice::~EntityDevice()
{
}

bool EntityDevice::createTable()
{
    QString sqlString = QString(R"SQL(CREATE TABLE IF NOT EXISTS %1 ("DeviceId" text NOT NULL PRIMARY KEY, "UserId" text NOT NULL REFERENCES "Users"("UserId"), "DeviceName" text NOT NULL, "Make" text NOT NULL, "Model" text NOT NULL, "NumberOfFlows" bigint NOT NULL, "RepeatFlowSequence" boolean NOT NULL, "FlowSequenceEnd" bigint NOT NULL, "Mode" integer NOT NULL, "OperatingMax" bigint NOT NULL, "OperatingMin" bigint NOT NULL, "Latitude" bigint NOT NULL, "Longitude" bigint NOT NULL, "Altitude" bigint NOT NULL, "GenModel" integer NOT NULL, "UnitOfMeasurement" text NOT NULL, "Scale" bigint NOT NULL, UNIQUE ("DeviceId")))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString);
}

bool EntityDevice::createDevice(const Device &rec)
{
    QString sqlString = QString(R"SQL(INSERT INTO %1 ("DeviceId", "UserId", "DeviceName", "Make", "Model", "NumberOfFlows", "RepeatFlowSequence", "FlowSequenceEnd", "Mode", "OperatingMax", "OperatingMin", "Latitude", "Longitude", "Altitude", "GenModel", "UnitOfMeasurement", "Scale") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?))SQL")
    .arg(quotedTable());

    return executeQuery(sqlString,
                        QVariantList() << rec.DeviceId_ << rec.UserId_ << rec.DeviceName_ << rec.Make_
                                       << rec.Model_ << rec.NumberOfFlows_ << rec.RepeatFlowSequence_
                                       << rec.FlowSequenceEnd_ << rec.Mode_ << rec.OperatingMax_
                                       << rec.OperatingMin_ << rec.Latitude_ << rec.Longitude_
                                       << rec.Altitude_ << rec.GenModel_ << rec.UnitOfMeasurement_ << rec.Scale_);
}

Device EntityDevice::fromRecord(const QSqlRecord &rec)
{
    Device struc;

    struc.DeviceId_ = rec.value("DeviceId").toString();
    struc.UserId_ = rec.value("UserId").toString();
    struc.DeviceName_ = rec.value("DeviceName").toString();
    struc.Make_ = rec.value("Make").toString();
    struc.Model_ = rec.value("Model").toString();
    struc.NumberOfFlows_ = rec.value("NumberOfFlows").toUInt();
    struc.RepeatFlowSequence_ = rec.value("RepeatFlowSequence").toBool();
    struc.FlowSequenceEnd_ = rec.value("FlowSequenceEnd").toULongLong();
    struc.Mode_ = rec.value("Mode").toInt();
    struc.OperatingMax_ = rec.value("OperatingMax").toULongLong();
    struc.OperatingMin_ = rec.value("OperatingMin").toULongLong();
    struc.Latitude_ = rec.value("Latitude").toULongLong();
    struc.Longitude_ = rec.value("Longitude").toULongLong();
    struc.Altitude_ = rec.value("Altitude").toULongLong();
    struc.GenModel_ = rec.value("GenModel").toInt();
    struc.UnitOfMeasurement_ = rec.value("UnitOfMeasurement").toString();
    struc.Scale_ = rec.value("Scale").toULongLong();

    struc.ModeStr_ = getSimulationModeName((SimulationMode)struc.Mode_);
    struc.GenModelStr_ = getGeneratorModelName((GeneratorModelType)struc.GenModel_);

    QDateTime dateTime = QDateTime::fromSecsSinceEpoch(struc.FlowSequenceEnd_);
    struc.FlowSequenceEndStr_ = dateTime.toString("yyyy/MM/dd hh:mm:ss");

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

QString getSimulationModeName(SimulationMode smode)
{
    switch(smode)
    {
    case SimulationModeDataset:     return "Dataset";
    case SimulationModeRealtime:    return "Realtime";
    }

    return "Unknown";
}

QString getGeneratorModelName(GeneratorModelType gmode)
{
    switch(gmode)
    {
    case Bernoulli:             return "Bernoulli";
    case MarkovTwoState:        return "Markov (Two-State)";
    case SemiMarkov:            return "Semi-Markov";
    case RenewalProcess:        return "Renewal Process";
    case PoissonOnset:          return "Poisson Onset";
    case NegativeBinomialRuns:  return "Negative Binomial Runs";
    case HiddenMarkov:          return "Hidden Markov";
    case BetaBernoulliMixture:  return "Beta-Bernoulli Mixture";
    case BlockSegment:          return "Block Segment";
    case DeterministicPattern:  return "Deterministic Pattern";
    case ModelUnknown:          return "Unknown";
    }

    return "Unknown";
}