#ifndef DATA_INTERFACE_H
#define DATA_INTERFACE_H

#include <QObject>
#include <QtSql>
#include <QStringList>

class DataInterface
{
public:
    DataInterface();
    virtual ~DataInterface();
    DataInterface(const DataInterface&) = delete;
    DataInterface& operator=(const DataInterface&) = delete;

    // SQLite local database
    void setParameters(QString dbfilename, QString dbname);
    // Full RDBMS. Supported types: QSqlDriver::SQLite, QSqlDriver::PostgreSQL
    void setParameters(QSqlDriver::DbmsType dbtype, QString server, QString dbname, QString username, QString password, quint16 port);

    // SQLite: the file is present. RDBMS: a connection can be made. Never creates anything.
    bool exists();
    // Creates the directory path and an empty file if missing. Does not truncate an existing file.
    bool createFile(const QString &dbfilename);
    bool open();
    bool isOpen();
    void close();

    // Pointer into this object; valid while this DataInterface lives, so entities must not outlive it.
    QSqlDatabase* getDatabase();
    // Live lookup, case-insensitive, so tables created after open() are seen
    bool contains(const QString &tabname);
    bool executeSQL(const QString &sqlstr);
    QString lastError() const;

private:
    void configure(QSqlDatabase &db);

    QSqlDatabase            _Database;
    QString                 _ConnName;
    QString                 _Dbfilename;
    QString                 _Dbname;
    QString                 _Server;
    QString                 _Username;
    QString                 _Password;
    quint16                 _Port = 0;
    QSqlDriver::DbmsType    _DbType = QSqlDriver::UnknownDbms;
    QString                 _LastError;
};

extern DataInterface* dataInterfacePtr;

#endif