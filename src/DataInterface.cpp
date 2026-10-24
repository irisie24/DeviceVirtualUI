#include "DataInterface.hpp"

DataInterface* dataInterfacePtr = nullptr;

namespace
{
QString driverName(QSqlDriver::DbmsType type)
{
    switch(type)
    {
    case QSqlDriver::SQLite:        return "QSQLITE";
    case QSqlDriver::PostgreSQL:    return "QPSQL";
    default:                        return QString();
    }
}
}

DataInterface::DataInterface()
{
    // One named connection per instance, so nothing ever touches Qt's default connection
    _ConnName = QString("DataInterface_%1").arg(reinterpret_cast<quintptr>(this), 0, 16);
    dataInterfacePtr = this;
}

DataInterface::~DataInterface()
{
    if(dataInterfacePtr == this)
    {
        dataInterfacePtr = nullptr;
    }

    if(_Database.isValid())
    {
        _Database.close();
    }

    _Database = QSqlDatabase();     // drop our handle before the connection is removed

    if(QSqlDatabase::contains(_ConnName))
    {
        QSqlDatabase::removeDatabase(_ConnName);
    }
}

void DataInterface::setParameters(QString dbfilename, QString dbname)
{
    //If this overloaded version is called, it means a SQLite local database
    _Dbfilename = dbfilename;
    _Dbname = dbname;
    _DbType = QSqlDriver::SQLite;
}

void DataInterface::setParameters(QSqlDriver::DbmsType dbtype, QString server, QString dbname, QString username, QString password, quint16 port)
{
    //If this overloaded version is called, it means a full fledged RDBMS
    _DbType = dbtype;
    _Server = server;
    _Dbname = dbname;
    _Username = username;
    _Password = password;
    _Port = port;
}

void DataInterface::configure(QSqlDatabase &db)
{
    if(_DbType == QSqlDriver::SQLite)
    {
        db.setDatabaseName(_Dbfilename);
        return;
    }

    db.setHostName(_Server);
    db.setDatabaseName(_Dbname);
    db.setUserName(_Username);
    db.setPassword(_Password);

    if(_Port != 0)
    {
        db.setPort(_Port);
    }
}

bool DataInterface::open()
{
    _LastError.clear();

    QString driver = driverName(_DbType);

    if(driver.isEmpty())
    {
        _LastError = "database type is not set or not supported";
        return false;
    }

    // Rebuild the connection so the latest parameters always apply.
    // _Database stays at the same address, so entities holding getDatabase() remain valid.
    if(_Database.isValid())
    {
        _Database.close();
    }

    _Database = QSqlDatabase();

    if(QSqlDatabase::contains(_ConnName))
    {
        QSqlDatabase::removeDatabase(_ConnName);
    }

    _Database = QSqlDatabase::addDatabase(driver, _ConnName);
    configure(_Database);

    if(!_Database.open())
    {
        _LastError = _Database.lastError().text();
        return false;
    }

    return true;
}

bool DataInterface::isOpen()
{
    return _Database.isValid() && _Database.isOpen();
}

void DataInterface::close()
{
    if(_Database.isValid())
    {
        _Database.close();
    }
}

QSqlDatabase* DataInterface::getDatabase()
{
    return &_Database;
}

bool DataInterface::contains(const QString &tabname)
{
    if(!isOpen())
    {
        return false;
    }

    return _Database.tables(QSql::Tables).contains(tabname, Qt::CaseInsensitive);
}

bool DataInterface::createFile(const QString &dbfilename)
{
    _LastError.clear();

    QFileInfo finfo(dbfilename);

    if(!QDir().mkpath(finfo.absolutePath()))
    {
        _LastError = "cannot create directory " + finfo.absolutePath();
        return false;
    }

    QFile fl(dbfilename);

    if(!fl.open(QIODevice::ReadWrite))
    {
        _LastError = fl.errorString();
        return false;
    }

    fl.close();

    return true;
}

bool DataInterface::exists()
{
    _LastError.clear();

    if(_DbType == QSqlDriver::SQLite)
    {
        // Opening a missing SQLite file would create it, so test the file instead
        return QFileInfo::exists(_Dbfilename);
    }

    QString driver = driverName(_DbType);

    if(driver.isEmpty())
    {
        _LastError = "database type is not set or not supported";
        return false;
    }

    bool connected = false;
    QString probename = _ConnName + "_probe";

    {
        QSqlDatabase probe = QSqlDatabase::addDatabase(driver, probename);
        configure(probe);
        connected = probe.open();

        if(!connected)
        {
            _LastError = probe.lastError().text();
        }

        probe.close();
    }

    QSqlDatabase::removeDatabase(probename);

    return connected;
}

bool DataInterface::executeSQL(const QString &sqlstr)
{
    _LastError.clear();

    if(!isOpen())
    {
        _LastError = "database is not open";
        return false;
    }

    QSqlQuery query(_Database);     // no SQL text here, so the statement runs exactly once, below

    if(!query.exec(sqlstr))
    {
        _LastError = query.lastError().text();
        return false;
    }

    return true;
}

QString DataInterface::lastError() const
{
    return _LastError;
}