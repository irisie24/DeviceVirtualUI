#include "Mqtt.hpp"
#include <QEventLoop>
#include <QTimer>
#include <QDebug>

namespace
{
constexpr std::uint8_t kConnect = 0x10;
constexpr std::uint8_t kConnAck = 0x20;
constexpr std::uint8_t kPublish = 0x30;
constexpr std::uint8_t kSubscribe = 0x80;
constexpr std::uint8_t kSubAck = 0x90;
constexpr std::uint8_t kUnsubscribe = 0xA0;
constexpr std::uint8_t kUnsubAck = 0xB0;
constexpr std::uint8_t kPingReq = 0xC0;
constexpr std::uint8_t kPingResp = 0xD0;
constexpr std::uint8_t kDisconnect = 0xE0;

void encodeRemainingLength(QByteArray &packet, quint32 value)
{
    do
    {
        quint8 byte = value % 128;
        value /= 128;

        if (value > 0)
        {
            byte |= 0x80;
        }

        packet.append(static_cast<char>(byte));
    } while (value > 0);
}

QByteArray encodeStringPayload(const QString &value)
{
    QByteArray packet;
    QByteArray utf8Value = value.toUtf8();
    const auto length = static_cast<quint16>(utf8Value.size());

    packet.append(static_cast<char>((length >> 8) & 0xFF));
    packet.append(static_cast<char>(length & 0xFF));
    packet.append(utf8Value);
    return packet;
}
}

Mqtt::Mqtt(QObject *parent)
    : QObject(parent)
    , m_port(1883)
    , m_socket(new QTcpSocket(this))
    , m_isConnected(false)
    , m_qos(1)
    , m_timeout(30)
    , m_nextPacketId(1)
{
    QObject::connect(m_socket, &QTcpSocket::connected, this, &Mqtt::onSocketConnected);
    QObject::connect(m_socket, &QTcpSocket::disconnected, this, &Mqtt::onSocketDisconnected);
    QObject::connect(m_socket, &QTcpSocket::readyRead, this, &Mqtt::onReadyRead);
    QObject::connect(m_socket, &QTcpSocket::errorOccurred, this, &Mqtt::onSocketError);
}

Mqtt::Mqtt(const QString &brokerAddress, int port, const QString &clientId,
                       const QString &username, const QString &password, QObject *parent)
    : QObject(parent)
    , m_brokerAddress(brokerAddress)
    , m_port(port)
    , m_clientId(clientId)
    , m_username(username)
    , m_password(password)
    , m_socket(new QTcpSocket(this))
    , m_isConnected(false)
    , m_qos(1)
    , m_timeout(30)
    , m_nextPacketId(1)
{
    QObject::connect(m_socket, &QTcpSocket::connected, this, &Mqtt::onSocketConnected);
    QObject::connect(m_socket, &QTcpSocket::disconnected, this, &Mqtt::onSocketDisconnected);
    QObject::connect(m_socket, &QTcpSocket::readyRead, this, &Mqtt::onReadyRead);
    QObject::connect(m_socket, &QTcpSocket::errorOccurred, this, &Mqtt::onSocketError);
}

void Mqtt::Initialize(const QString &brokerAddress, int port, const QString &clientId,
                            const QString &username, const QString &password)
{
    m_brokerAddress = brokerAddress;
    m_port = port;
    m_clientId = clientId;
    m_username = username;
    m_password = password;
    m_isConnected = false;
    m_qos = 1;
    m_timeout = 30;
    m_nextPacketId = 1;
}

Mqtt::~Mqtt()
{
    disconnect();
}

bool Mqtt::isConnected() const
{
    return m_isConnected;
}

void Mqtt::connect(int qos, int timeout)
{
    m_qos = qos;
    m_timeout = timeout;
    m_readBuffer.clear();

    if (m_socket->state() != QAbstractSocket::UnconnectedState)
    {
        disconnect();
    }

    m_socket->connectToHost(m_brokerAddress, static_cast<quint16>(m_port));

    // Use a local event loop to synchronously wait for connection and CONNACK within timeout
    QEventLoop loop;
    QTimer timer;
    timer.setSingleShot(true);

    QObject::connect(this, &Mqtt::connected, &loop, &QEventLoop::quit);
    QObject::connect(&timer, &QTimer::timeout, &loop, &QEventLoop::quit);
    QObject::connect(m_socket, &QAbstractSocket::errorOccurred, &loop, [&loop](QAbstractSocket::SocketError) {
        loop.quit();
    });

    timer.start(timeout * 1000);
    loop.exec();

    if (!m_isConnected)
    {
        disconnect();
    }
}

void Mqtt::disconnect()
{
    if (m_socket->state() != QAbstractSocket::UnconnectedState)
    {
        QByteArray packet;
        packet.append(static_cast<char>(kDisconnect));
        packet.append(static_cast<char>(0x00));
        m_socket->write(packet);
        m_socket->flush();
        m_socket->disconnectFromHost();
    }

    if (m_isConnected)
    {
        m_isConnected = false;
        emit disconnected();
    }
}

void Mqtt::onSocketConnected()
{
    const auto connectPacket = buildConnectPacket(m_qos, m_timeout);
    sendPacket(connectPacket);
}

void Mqtt::onSocketDisconnected()
{
    bool wasConnected = m_isConnected;
    m_isConnected = false;
    m_readBuffer.clear();

    if (wasConnected)
    {
        emit disconnected();
    }
}

void Mqtt::onSocketError(QAbstractSocket::SocketError socketError)
{
    Q_UNUSED(socketError);
    qWarning() << "MqttClient socket error:" << m_socket->errorString();
}

void Mqtt::sendPacket(const QByteArray &data)
{
    if (m_socket->state() == QAbstractSocket::ConnectedState)
    {
        m_socket->write(data);
        m_socket->flush();
    }
}

void Mqtt::onReadyRead()
{
    m_readBuffer.append(m_socket->readAll());

    while (true)
    {
        if (m_readBuffer.size() < 2)
        {
            break;
        }

        int index = 0;
        quint8 fixedHeader = static_cast<quint8>(m_readBuffer.at(index++));

        quint32 remainingLength = 0;
        quint32 multiplier = 1;
        int remainingLengthBytesCount = 0;
        bool remLenFinished = false;

        for (int i = 0; i < 4; ++i)
        {
            if (index >= m_readBuffer.size())
            {
                break;
            }
            quint8 byte = static_cast<quint8>(m_readBuffer.at(index++));
            remainingLength += (static_cast<quint32>(byte & 0x7F) * multiplier);
            remainingLengthBytesCount++;
            if ((byte & 0x80) == 0)
            {
                remLenFinished = true;
                break;
            }
            multiplier *= 128;
        }

        if (!remLenFinished)
        {
            break;
        }

        int totalPacketSize = index + remainingLength;
        if (m_readBuffer.size() < totalPacketSize)
        {
            break;
        }

        QByteArray packet = m_readBuffer.left(totalPacketSize);
        m_readBuffer.remove(0, totalPacketSize);

        const quint8 messageType = fixedHeader & 0xF0;

        if (messageType == kConnAck)
        {
            m_isConnected = true;
            emit connected();
        }
        else if (messageType == kPublish)
        {
            parseIncomingPacket(packet);
        }
    }
}

QByteArray Mqtt::buildConnectPacket(int qos, int keepAliveSeconds)
{
    Q_UNUSED(qos);
    QByteArray payload;
    payload.append(static_cast<char>(0x00));
    payload.append(static_cast<char>(0x04));
    payload.append('M');
    payload.append('Q');
    payload.append('T');
    payload.append('T');
    payload.append(static_cast<char>(0x04));

    quint8 connectFlags = 0x02;
    if (!m_username.isEmpty())
    {
        connectFlags |= 0x80;
    }
    if (!m_password.isEmpty())
    {
        connectFlags |= 0x40;
    }

    payload.append(static_cast<char>(connectFlags));
    payload.append(static_cast<char>((keepAliveSeconds >> 8) & 0xFF));
    payload.append(static_cast<char>(keepAliveSeconds & 0xFF));

    payload.append(encodeStringPayload(m_clientId));

    if (!m_username.isEmpty())
    {
        payload.append(encodeStringPayload(m_username));
    }

    if (!m_password.isEmpty())
    {
        payload.append(encodeStringPayload(m_password));
    }

    QByteArray packet;
    packet.append(static_cast<char>(kConnect));
    encodeRemainingLength(packet, static_cast<quint32>(payload.size()));
    packet.append(payload);
    return packet;
}

QByteArray Mqtt::buildPublishPacket(const QString &topic, const QString &message, int qos)
{
    QByteArray packet;
    quint8 flags = 0x00;
    if (qos > 0)
    {
        flags = 0x02;
    }

    packet.append(static_cast<char>(kPublish | flags));

    QByteArray payload;
    payload.append(encodeStringPayload(topic));

    if (qos > 0)
    {
        const quint16 packetId = static_cast<quint16>(m_nextPacketId.fetch_add(1, std::memory_order_relaxed));
        payload.append(static_cast<char>((packetId >> 8) & 0xFF));
        payload.append(static_cast<char>(packetId & 0xFF));
    }

    payload.append(message.toUtf8());

    QByteArray remLenBytes;
    encodeRemainingLength(remLenBytes, static_cast<quint32>(payload.size()));

    packet.append(remLenBytes);
    packet.append(payload);
    return packet;
}

QByteArray Mqtt::buildSubscribePacket(const QString &topic, int qos)
{
    QByteArray packet;
    packet.append(static_cast<char>(kSubscribe | 0x02));

    const quint16 packetId = static_cast<quint16>(m_nextPacketId.fetch_add(1, std::memory_order_relaxed));
    QByteArray payload;

    payload.append(static_cast<char>((packetId >> 8) & 0xFF));
    payload.append(static_cast<char>(packetId & 0xFF));
    payload.append(encodeStringPayload(topic));
    payload.append(static_cast<char>(qos));

    QByteArray remLenBytes;
    encodeRemainingLength(remLenBytes, static_cast<quint32>(payload.size()));

    packet.append(remLenBytes);
    packet.append(payload);
    return packet;
}

QByteArray Mqtt::buildUnsubscribePacket(const QString &topic)
{
    QByteArray packet;
    packet.append(static_cast<char>(kUnsubscribe | 0x02));

    const quint16 packetId = static_cast<quint16>(m_nextPacketId.fetch_add(1, std::memory_order_relaxed));
    QByteArray payload;

    payload.append(static_cast<char>((packetId >> 8) & 0xFF));
    payload.append(static_cast<char>(packetId & 0xFF));
    payload.append(encodeStringPayload(topic));

    QByteArray remLenBytes;
    encodeRemainingLength(remLenBytes, static_cast<quint32>(payload.size()));

    packet.append(remLenBytes);
    packet.append(payload);
    return packet;
}

void Mqtt::parseIncomingPacket(const QByteArray &packet)
{
    if (packet.size() < 5)
    {
        return;
    }

    const quint8 messageType = static_cast<quint8>(packet.at(0) & 0xF0);
    if (messageType != kPublish)
    {
        return;
    }

    int idx = 1;
    quint32 remainingLength = 0;
    quint32 multiplier = 1;

    while (true)
    {
        if (idx >= packet.size())
        {
            return;
        }

        quint8 byte = static_cast<quint8>(packet.at(idx++));
        remainingLength += (static_cast<quint32>(byte & 0x7F) * multiplier);
        if ((byte & 0x80) == 0)
        {
            break;
        }
        multiplier *= 128;
    }

    if (idx + 2 > packet.size())
    {
        return;
    }

    const quint16 topicLength = static_cast<quint16>((static_cast<quint16>(packet.at(idx)) << 8) |
                                                     static_cast<quint16>(packet.at(idx + 1)));
    idx += 2;

    if (idx + topicLength > packet.size())
    {
        return;
    }

    QString topic = QString::fromUtf8(packet.constData() + idx, topicLength);
    idx += topicLength;

    const quint8 qosFlags = static_cast<quint8>(packet.at(0) & 0x06);
    if (qosFlags != 0)
    {
        idx += 2;
    }

    QString message = QString::fromUtf8(packet.constData() + idx, packet.size() - idx);
    emit messageReceived(topic, message);
}

void Mqtt::publish(const QString &topic, const QString &message)
{
    if (!m_isConnected)
    {
        return;
    }

    const auto packet = buildPublishPacket(topic, message, m_qos);
    sendPacket(packet);
}

void Mqtt::subscribe(const QString &topic)
{
    if (!m_isConnected)
    {
        return;
    }

    const auto packet = buildSubscribePacket(topic, m_qos);
    sendPacket(packet);
}

void Mqtt::unsubscribe(const QString &topic)
{
    if (!m_isConnected)
    {
        return;
    }

    const auto packet = buildUnsubscribePacket(topic);
    sendPacket(packet);
}