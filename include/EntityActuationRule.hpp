#ifndef ENTITY_ACTUATION_RULE
#define ENTITY_ACTUATION_RULE

#include <QObject>
#include <QtSql>
#include "DataEntity.hpp"

typedef enum LogicalCondition
{
    Equals,
    EqualsOrLesser,
    EqualsOrGreater,
    Lesser,
    Greater,
    Unknown
}LogicalCondition;

typedef enum PhysicalTarget
{
    GPIO,
    I2C,
    SPI,
    UART,
    BLE
}PhysicalTarget;

QString getLogicalConditionName(LogicalCondition logic);
QString getPhysicalTargetName(PhysicalTarget target);

// Actuation rule fires when logical condition is satisfied by the threshold value parameter
class ActuationRule
{
public:
    Q_GADGET

public:
    QString     RuleId_;
    QString     DeviceId_;
    int         Condition_ = Equals;         // LogicalCondition
    qint64      ValueThreshold_ = 0;
    int         TargetType_ = GPIO;          // PhysicalTarget, type of device to actuate
    QString     TargetDeviceName_;           // device to be actuated (descriptor only, traced not driven)
    qint64      TargetActionValue_ = 0;      // value written to the device being actuated
    bool        IsChained_ = false;          // chained to next or another rule
    QString     RuleIdIfConditionFalse_;     // jump here if the condition was not met (empty = none)
    QString     RuleIdIfConditionTrue_;      // jump here as second pass even if the condition was met (empty = none)
    QString     ConditionName_;      // jump here as second pass even if the condition was met (empty = none)
    QString     TargetTypeStr_;      // jump here as second pass even if the condition was met (empty = none)

public:
    Q_PROPERTY(QString RuleId MEMBER RuleId_)
    Q_PROPERTY(QString DeviceId MEMBER DeviceId_)
    Q_PROPERTY(int Condition MEMBER Condition_)
    Q_PROPERTY(qint64 ValueThreshold MEMBER ValueThreshold_)
    Q_PROPERTY(int TargetType MEMBER TargetType_)
    Q_PROPERTY(QString TargetDeviceName MEMBER TargetDeviceName_)
    Q_PROPERTY(qint64 TargetActionValue MEMBER TargetActionValue_)
    Q_PROPERTY(bool IsChained MEMBER IsChained_)
    Q_PROPERTY(QString RuleIdIfConditionFalse MEMBER RuleIdIfConditionFalse_)
    Q_PROPERTY(QString RuleIdIfConditionTrue MEMBER RuleIdIfConditionTrue_)
    Q_PROPERTY(QString ConditionName MEMBER ConditionName_)
    Q_PROPERTY(QString TargetTypeStr MEMBER TargetTypeStr_)

public:
    ActuationRule()
    {
    }

    ActuationRule(QString iRuleId, QString iDeviceId, int iCondition, qint64 iValueThreshold,
                      int iTargetType, QString iTargetDeviceName,
                      qint64 iTargetActionValue, bool iIsChained,
                      QString iRuleIdIfConditionFalse, QString iRuleIdIfConditionTrue)
    {
        RuleId_ = iRuleId;
        DeviceId_ = iDeviceId;
        Condition_ = iCondition;
        ValueThreshold_ = iValueThreshold;
        TargetType_ = iTargetType;
        TargetDeviceName_ = iTargetDeviceName;
        TargetActionValue_ = iTargetActionValue;
        IsChained_ = iIsChained;
        RuleIdIfConditionFalse_ = iRuleIdIfConditionFalse;
        RuleIdIfConditionTrue_ = iRuleIdIfConditionTrue;
        ConditionName_ = getLogicalConditionName(LogicalCondition(iCondition));
        TargetTypeStr_ = getPhysicalTargetName(PhysicalTarget(iTargetType));
    }
};

// Table: "ActuationRules"
class EntityActuationRule : public DataEntity
{
public:
    EntityActuationRule(QSqlDatabase* db);
    virtual ~EntityActuationRule();
    bool createTable();
    bool createActuationRule(const ActuationRule &rec);
    bool allActuationRule(QList<ActuationRule> &list);
    bool selectedActuationRule(QList<ActuationRule> &list, QString keyname, QVariant value);
private:
    static ActuationRule fromRecord(const QSqlRecord &rec);
};

extern EntityActuationRule* actuationRuleEntityPtr;

#endif