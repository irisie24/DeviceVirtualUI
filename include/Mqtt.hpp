#ifndef MQTT_HPP
#define MQTT_HPP

#include <QObject>
#include <QTcpSocket>
#include <QString>
#include <QByteArray>
#include <atomic>

class Mqtt : public QObject
{
    Q_OBJECT

public:
    explicit Mqtt(QObject *parent = nullptr);
    Mqtt(const QString &brokerAddress, int port, const QString &clientId,
               const QString &username, const QString &password, QObject *parent = nullptr);
    ~Mqtt() override;

    void Initialize(const QString &brokerAddress, int port, const QString &clientId,
                    const QString &username, const QString &password);
    void connect(int qos = 1, int timeout = 30);
    void disconnect();

    void publish(const QString &topic, const QString &message);
    void subscribe(const QString &topic);
    void unsubscribe(const QString &topic);

    bool isConnected() const;

signals:
    void connected();
    void disconnected();
    void messageReceived(const QString &topic, const QString &message);

private slots:
    void onReadyRead();
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketError(QAbstractSocket::SocketError socketError);

private:
    void sendPacket(const QByteArray &data);
    QByteArray buildConnectPacket(int qos, int keepAliveSeconds);
    QByteArray buildPublishPacket(const QString &topic, const QString &message, int qos);
    QByteArray buildSubscribePacket(const QString &topic, int qos);
    QByteArray buildUnsubscribePacket(const QString &topic);
    void parseIncomingPacket(const QByteArray &packet);

    QString m_brokerAddress;
    int m_port;
    QString m_clientId;
    QString m_username;
    QString m_password;

    QTcpSocket *m_socket;
    bool m_isConnected;
    int m_qos;
    int m_timeout;
    std::atomic<int> m_nextPacketId;
    QByteArray m_readBuffer;
};

#endif // MQTTCLIENT_HPP