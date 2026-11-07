#ifndef MQTT_HPP
#define MQTT_HPP

#include <QObject>
#include <QTcpSocket>
#include <QTimer>
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

    // qos:       1 or 0 (QoS 2 handshake is not implemented; subscribe clamps to 1)
    // timeout:   seconds to wait synchronously for TCP connect + CONNACK
    // keepAlive: MQTT keepalive in seconds (0 disables PINGREQ and broker timeout)
    void connect(int qos = 1, int timeout = 30, int keepAlive = 30);
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
    void onKeepAlive();

private:
    void sendPacket(const QByteArray &data);
    quint16 nextPacketId();
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
    int m_keepAlive;
    std::atomic<quint32> m_nextPacketId;
    QByteArray m_readBuffer;
    QTimer *m_keepAliveTimer;
};

#endif // MQTT_HPP
