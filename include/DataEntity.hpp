#ifndef DATA_ENTITY_H
#define DATA_ENTITY_H

#include <QtSql>
#include <QList>
#include <QString>
#include <QVariant>
#include <cstdint>

class DataEntity
{
public:
    DataEntity(QSqlDatabase* db, QString tabname);
    virtual ~DataEntity();
    DataEntity(const DataEntity&) = delete;
    DataEntity& operator=(const DataEntity&) = delete;

    void clear();
    bool truncate();

    // The getters return a pointer to the internal record list, valid until the next getter call.
    // On failure they return nullptr and lastError() holds the reason.
    // 'str' is an optional caller-supplied base statement (trusted text, never user input).
    QList<QSqlRecord>* getAllRecords(QString str = QString());
    QList<QSqlRecord>* getSelectedRecords(QString keyname, QVariant value, QString str = QString());
    QList<QSqlRecord>* getCustomRecords(QString str, const QVariantList &binds = QVariantList());

    bool remove(QString keyname, QVariant value);
    bool update(QString uniquekeyname, QVariant uniquevalue, QString keyname, QVariant value);
    virtual bool createTable()=0;

    // Invalid QVariant when the table is empty, the query fails, or the identifier is rejected
    QVariant maximumValue(QString keyname);
    QVariant maximumValue(QString keyname, QString filter, QVariant filterval);

    QString lastError() const;

protected:
    // Runs one statement with bound values (?). Values are never spliced into the SQL text.
    bool executeQuery(const QString &querystring, const QVariantList &binds = QVariantList());

    void normalizeDateString(QString &str);
    void normalizeDateString(uint32_t val, QString &str);
    // Deprecated: splices values into SQL text. Kept only for derived classes not yet moved to bound values.
    void substitueValue(QVariant &var, QString &str);
    QString getDayofWeek(QString str);
    QString getMonth(QString str);
    QString getFloatString(const float val);

    QSqlDatabase*       _Database;
    QString             _TableName;
    QList<QSqlRecord>   _RecordList;

private:
    bool runQuery(const QString &sql, const QVariantList &binds, QList<QSqlRecord> *out);
    bool checkIdentifier(const QString &name);

    QString             _LastError;
};

#endif
