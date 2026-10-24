#include "DataEntity.hpp"

#include <QDate>
#include <QDateTime>
#include <QRegularExpression>
#include <cstdio>

DataEntity::DataEntity(QSqlDatabase *db, QString tabname)
    : _Database(db), _TableName(tabname)
{
}

DataEntity::~DataEntity()
{
}

void DataEntity::clear()
{
    _RecordList.clear();
}

bool DataEntity::truncate()
{
    return executeQuery("delete from " + _TableName);
}

QList<QSqlRecord>* DataEntity::getAllRecords(QString str)
{
    _RecordList.clear();

    QString querystring = str.isEmpty() ? "select * from " + _TableName : str;

    return runQuery(querystring, QVariantList(), &_RecordList) ? &_RecordList : nullptr;
}

QList<QSqlRecord>* DataEntity::getSelectedRecords(QString keyname, QVariant value, QString str)
{
    _RecordList.clear();

    if(!checkIdentifier(keyname))
    {
        return nullptr;
    }

    QString querystring = str.isEmpty() ? "select * from " + _TableName : str;
    querystring += " where " + keyname + " = ?";

    return runQuery(querystring, QVariantList() << value, &_RecordList) ? &_RecordList : nullptr;
}

QList<QSqlRecord>* DataEntity::getCustomRecords(QString str, const QVariantList &binds)
{
    _RecordList.clear();

    return runQuery(str, binds, &_RecordList) ? &_RecordList : nullptr;
}

bool DataEntity::remove(QString keyname, QVariant value)
{
    if(!checkIdentifier(keyname))
    {
        return false;
    }

    return executeQuery("delete from " + _TableName + " where " + keyname + " = ?",
                        QVariantList() << value);
}

bool DataEntity::update(QString uniquekeyname, QVariant uniquevalue, QString keyname, QVariant value)
{
    if(!checkIdentifier(uniquekeyname) || !checkIdentifier(keyname))
    {
        return false;
    }

    return executeQuery("update " + _TableName + " set " + keyname + " = ? where " + uniquekeyname + " = ?",
                        QVariantList() << value << uniquevalue);
}

bool DataEntity::executeQuery(const QString &querystring, const QVariantList &binds)
{
    return runQuery(querystring, binds, nullptr);
}

QVariant DataEntity::maximumValue(QString keyname)
{
    QVariant retval;

    if(!checkIdentifier(keyname))
    {
        return retval;
    }

    QList<QSqlRecord> rows;

    if(runQuery("select max(" + keyname + ") from " + _TableName, QVariantList(), &rows) && !rows.isEmpty())
    {
        QVariant v = rows.first().value(0);

        if(!v.isNull())
        {
            retval = v;
        }
    }

    return retval;
}

QVariant DataEntity::maximumValue(QString keyname, QString filter, QVariant filterval)
{
    QVariant retval;

    if(!checkIdentifier(keyname) || !checkIdentifier(filter))
    {
        return retval;
    }

    QList<QSqlRecord> rows;

    if(runQuery("select max(" + keyname + ") from " + _TableName + " where " + filter + " = ?",
                 QVariantList() << filterval, &rows) && !rows.isEmpty())
    {
        QVariant v = rows.first().value(0);

        if(!v.isNull())
        {
            retval = v;
        }
    }

    return retval;
}

QString DataEntity::lastError() const
{
    return _LastError;
}

bool DataEntity::runQuery(const QString &sql, const QVariantList &binds, QList<QSqlRecord> *out)
{
    _LastError.clear();

    if(_Database == nullptr || !_Database->isOpen())
    {
        _LastError = "database is not open";
        return false;
    }

    QSqlQuery query(*_Database);   // no SQL text here, so nothing executes before prepare/bind

    if(binds.isEmpty())
    {
        // No values to bind, so run it directly. The PostgreSQL driver cannot prepare DDL (CREATE, DROP, ...).
        if(!query.exec(sql))
        {
            _LastError = query.lastError().text();
            return false;
        }

        if(out != nullptr)
        {
            while(query.next())
            {
                out->append(query.record());
            }
        }

        return true;
    }

    if(!query.prepare(sql))
    {
        _LastError = query.lastError().text();
        return false;
    }

    for(const QVariant &v : binds)
    {
        // Qt binds a null QString as SQL NULL. These tables store "no value" as '', so bind it that way.
        // A true NULL is still available by passing a plain QVariant().
        // (Qt 6: QVariant::isNull() is false for a variant holding a null QString, so test the string.)
        if(v.metaType().id() == QMetaType::QString && v.toString().isNull())
        {
            query.addBindValue(QString(""));
        }
        else
        {
            query.addBindValue(v);
        }
    }

    if(!query.exec())
    {
        _LastError = query.lastError().text();
        return false;
    }

    if(out != nullptr)
    {
        while(query.next())
        {
            out->append(query.record());
        }
    }

    return true;
}

bool DataEntity::checkIdentifier(const QString &name)
{
    // Column names cannot be bound, so only plain identifiers are allowed into SQL text
    static const QRegularExpression identifier("\\A[A-Za-z_][A-Za-z0-9_]*\\z");

    if(!identifier.match(name).hasMatch())
    {
        _LastError = "invalid identifier: " + name;
        return false;
    }

    return true;
}

void DataEntity::substitueValue(QVariant &var, QString &str)
{
    switch(var.typeId())
    {
    case QMetaType::Char:
    case QMetaType::QString:
    {
        str = "'" + var.toString() + "'";
    }
    break;

    case QMetaType::Double:
    case QMetaType::Int:
    case QMetaType::LongLong:
    case QMetaType::UInt:
    case QMetaType::ULongLong:
    {
        str = var.toString();
    }
    break;

    default:
    {
    }
    break;
    }
}

QString DataEntity::getFloatString(const float val)
{
    char temp[25] = {0};
    snprintf(temp, 24, "%0.4f", val);
    return temp;
}

void DataEntity::normalizeDateString(QString &str)
{
    QDate dt = QDate::fromString(str, "dd/MM/yyyy");
    str = dt.toString("yyyy-MM-dd");
}

void DataEntity::normalizeDateString(uint32_t val, QString &str)
{
    QDateTime dt = QDateTime::fromSecsSinceEpoch(val);
    str = dt.toString("yyyy-MM-dd");
}

QString DataEntity::getDayofWeek(QString str)
{
    if(str == "0")
    {
        return "Sun";
    }

    if(str == "1")
    {
        return "Mon";
    }

    if(str == "2")
    {
        return "Tue";
    }

    if(str == "3")
    {
        return "Wed";
    }

    if(str == "4")
    {
        return "Thu";
    }

    if(str == "5")
    {
        return "Fri";
    }

    if(str == "6")
    {
        return "Sat";
    }

    return "";
}

QString DataEntity::getMonth(QString str)
{
    if(str == "01")
    {
        return "Jan";
    }

    if(str == "02")
    {
        return "Feb";
    }

    if(str == "03")
    {
        return "Mar";
    }

    if(str == "04")
    {
        return "Apr";
    }

    if(str == "05")
    {
        return "May";
    }

    if(str == "06")
    {
        return "Jun";
    }

    if(str == "07")
    {
        return "Jul";
    }

    if(str == "08")
    {
        return "Aug";
    }

    if(str == "09")
    {
        return "Sep";
    }

    if(str == "10")
    {
        return "Oct";
    }

    if(str == "11")
    {
        return "Nov";
    }

    if(str == "12")
    {
        return "Dec";
    }

    return "";
}