#ifndef ENTITY_FLOW
#define ENTITY_FLOW

#include <QObject>
#include <QtSql>
#include "DataEntity.hpp"

// Sensor simulation flow type
typedef enum FlowType
{
    BaseLine,
    Normal,
    Spikes,
    Dead,
    Stuck,
    Offset,
    Noise,
    DriftLinear,
    DriftStepped,
    FlowUnknown
}FlowType;

QString getFlowTypeName(FlowType ftype);

// Definition of a sensing simulation flow
// Uses the simulation mode and generational model from the device parent
class SensingFlow
{
public:
    Q_GADGET

public:
    QString     FlowId_ = 0;                 // surrogate key, assigned by the database (0 = not yet stored)
    QString     DeviceId_;
    int         Type_ = FlowUnknown;         // FlowType
    quint64     Scale_ = 0;
    quint64     Duration_ = 0;
    quint64     UnixEpochStart_ = 0;
    quint64     UnixEpochEnd_ = 0;
    quint64     Minimum_ = 0;
    quint64     Maximum_ = 0;
    QString     UnitOfMeasurement_;          // max 16 characters
    QString     DatasetFilename_;
    QString     FlowTypeName_;
    QString     UnixEpochStartStr_ = "";
    QString     UnixEpochEndStr_ = "";

public:
    Q_PROPERTY(QString FlowId MEMBER FlowId_)
    Q_PROPERTY(QString DeviceId MEMBER DeviceId_)
    Q_PROPERTY(int Type MEMBER Type_)
    Q_PROPERTY(quint64 Scale MEMBER Scale_)
    Q_PROPERTY(quint64 Duration MEMBER Duration_)
    Q_PROPERTY(quint64 UnixEpochStart MEMBER UnixEpochStart_)
    Q_PROPERTY(quint64 UnixEpochEnd MEMBER UnixEpochEnd_)
    Q_PROPERTY(quint64 Minimum MEMBER Minimum_)
    Q_PROPERTY(quint64 Maximum MEMBER Maximum_)
    Q_PROPERTY(QString UnitOfMeasurement MEMBER UnitOfMeasurement_)
    Q_PROPERTY(QString DatasetFilename MEMBER DatasetFilename_)
    Q_PROPERTY(QString FlowTypeName MEMBER FlowTypeName_)
    Q_PROPERTY(QString UnixEpochStartStr MEMBER UnixEpochStartStr_)
    Q_PROPERTY(QString UnixEpochEndStr MEMBER UnixEpochEndStr_)

public:
    SensingFlow()
    {
    }

    SensingFlow(QString iFlowId, QString iDeviceId, int iType, quint64 iScale, quint64 iDuration,
             quint64 iUnixEpochStart, quint64 iUnixEpochEnd, quint64 iMinimum, quint64 iMaximum,
             QString iUnitOfMeasurement, QString iDatasetFilename)
    {
        FlowId_ = iFlowId;
        DeviceId_ = iDeviceId;
        Type_ = iType;
        Scale_ = iScale;
        Duration_ = iDuration;
        UnixEpochStart_ = iUnixEpochStart;
        UnixEpochEnd_ = iUnixEpochEnd;
        Minimum_ = iMinimum;
        Maximum_ = iMaximum;
        UnitOfMeasurement_ = iUnitOfMeasurement;
        DatasetFilename_ = iDatasetFilename;
        FlowTypeName_ = getFlowTypeName((FlowType)iType);

        QDateTime dateTime1 = QDateTime::fromSecsSinceEpoch(iUnixEpochStart);
        UnixEpochStartStr_ = dateTime1.toString("yyyy/MM/dd hh:mm:ss");

        QDateTime dateTime2 = QDateTime::fromSecsSinceEpoch(iUnixEpochEnd);
        UnixEpochEndStr_ = dateTime1.toString("yyyy/MM/dd hh:mm:ss");
    }
};

// Table: "SensingFlows"
class EntityFlow : public DataEntity
{
public:
    EntityFlow(QSqlDatabase* db, QString tabname);
    virtual ~EntityFlow();
    bool createTable();
    bool createFlow(const SensingFlow &rec);
    bool allFlow(QList<SensingFlow> &list);
    bool selectedFlow(QList<SensingFlow> &list, QString keyname, QVariant value);
private:
    static SensingFlow fromRecord(const QSqlRecord &rec);
};

extern EntityFlow* flowEntityPtr;

#endif