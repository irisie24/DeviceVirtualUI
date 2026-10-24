#ifndef ENTITY_DEVICE
#define ENTITY_DEVICE

#include <QObject>
#include <QtSql>
#include "DataEntity.hpp"

typedef enum SimulationMode
{
    SimulationModeDataset,
    SimulationModeRealtime
}SimulationMode;

typedef enum GeneratorModelType
{
    Bernoulli,
    MarkovTwoState,
    SemiMarkov,
    RenewalProcess,
    PoissonOnset,
    NegativeBinomialRuns,
    HiddenMarkov,
    BetaBernoulliMixture,
    BlockSegment,
    DeterministicPattern,
    ModelUnknown
}GeneratorModelType;

class Device
{
public:
    Q_GADGET

public:
    QString     DeviceId_;
    QString     DeviceName_;
    QString     Make_;
    QString     Model_;
    quint32     NumberOfFlows_ = 0;          // simulation flows configured for this device
    bool        RepeatFlowSequence_ = false; // loop all flows indefinitely
    quint64     FlowSequenceEnd_ = 0;        // UNIX epoch hard stop
    int         Mode_ = SimulationModeDataset;     // SimulationMode
    quint64     OperatingMax_ = 0;           // scale 100
    quint64     OperatingMin_ = 0;           // scale 100
    quint64     Latitude_ = 0;               // scale 100
    quint64     Longitude_ = 0;              // scale 100
    quint64     Altitude_ = 0;               // scale 100
    int         GenModel_ = ModelUnknown;    // GeneratorModelType

public:
    Q_PROPERTY(QString DeviceId MEMBER DeviceId_)
    Q_PROPERTY(QString DeviceName MEMBER DeviceName_)
    Q_PROPERTY(QString Make MEMBER Make_)
    Q_PROPERTY(QString Model MEMBER Model_)
    Q_PROPERTY(quint32 NumberOfFlows MEMBER NumberOfFlows_)
    Q_PROPERTY(bool RepeatFlowSequence MEMBER RepeatFlowSequence_)
    Q_PROPERTY(quint64 FlowSequenceEnd MEMBER FlowSequenceEnd_)
    Q_PROPERTY(int Mode MEMBER Mode_)
    Q_PROPERTY(quint64 OperatingMax MEMBER OperatingMax_)
    Q_PROPERTY(quint64 OperatingMin MEMBER OperatingMin_)
    Q_PROPERTY(quint64 Latitude MEMBER Latitude_)
    Q_PROPERTY(quint64 Longitude MEMBER Longitude_)
    Q_PROPERTY(quint64 Altitude MEMBER Altitude_)
    Q_PROPERTY(int GenModel MEMBER GenModel_)

public:
    Device()
    {
    }

    Device(QString iDeviceId, QString iDeviceName, QString iMake, QString iModel,
               quint32 iNumberOfFlows, bool iRepeatFlowSequence, quint64 iFlowSequenceEnd,
               int iMode, quint64 iOperatingMax, quint64 iOperatingMin,
               quint64 iLatitude, quint64 iLongitude, quint64 iAltitude, int iGenModel)
    {
        DeviceId_ = iDeviceId;
        DeviceName_ = iDeviceName;
        Make_ = iMake;
        Model_ = iModel;
        NumberOfFlows_ = iNumberOfFlows;
        RepeatFlowSequence_ = iRepeatFlowSequence;
        FlowSequenceEnd_ = iFlowSequenceEnd;
        Mode_ = iMode;
        OperatingMax_ = iOperatingMax;
        OperatingMin_ = iOperatingMin;
        Latitude_ = iLatitude;
        Longitude_ = iLongitude;
        Altitude_ = iAltitude;
        GenModel_ = iGenModel;
    }
};

class EntityDevice : public DataEntity
{
public:
    EntityDevice(QSqlDatabase* db, QString tabname);
    virtual ~EntityDevice();
    bool createTable();
    bool createDevice(const Device &rec);
    bool allDevice(QList<Device> &list);
    bool selectedDevice(QList<Device> &list, QString keyname, QVariant value);
private:
    static Device fromRecord(const QSqlRecord &rec);
};

extern EntityDevice* deviceEntityPtr;

#endif
