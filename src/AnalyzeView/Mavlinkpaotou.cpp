﻿#include "Mavlinkpaotou.h"
#include "QGCApplication.h"
#include "UAS.h"
#include "MAVLinkInspectorController.h"
#include "MultiVehicleManager.h"
#include <QtCharts/QLineSeries>

Mavlinkpaotou::Mavlinkpaotou()
    : QStringListModel(),
    _cursor_home_pos{-1},
    _cursor{0},
    _vehicle{nullptr}
{
    auto *manager = qgcApp()->toolbox()->multiVehicleManager();
    connect(manager, &MultiVehicleManager::activeVehicleChanged, this, &Mavlinkpaotou::_setActiveVehicle);
    _setActiveVehicle(manager->activeVehicle());
    MAVLinkProtocol* mavlinkProtocol = qgcApp()->toolbox()->mavlinkProtocol();
    connect(mavlinkProtocol, &MAVLinkProtocol::messageReceived, this, &Mavlinkpaotou::_receiveMessage);
}

Mavlinkpaotou::~Mavlinkpaotou()
{
    if (_vehicle)
    {
        QByteArray msg;
        _sendSerialData(msg, true);
    }
}

void Mavlinkpaotou::sendCommand(QString command)
{
    _history.append(command);
    command.append("\n");
    _sendSerialData(qPrintable(command));
    _cursor_home_pos = -1;
    _cursor = rowCount();
}

QString Mavlinkpaotou::historyUp(const QString& current)
{
    return _history.up(current);
}

QString Mavlinkpaotou::historyDown(const QString& current)
{
    return _history.down(current);
}

void Mavlinkpaotou::_setActiveVehicle(Vehicle* vehicle)
{
    for (auto &con : _uas_connections)
    {
        disconnect(con);
    }
    _uas_connections.clear();

    _vehicle = vehicle;

    if (_vehicle)
    {
        _incoming_buffer.clear();
        // Reset the model
        setStringList(QStringList());
        _cursor = 0;
        _cursor_home_pos = -1;
        _uas_connections << connect(_vehicle, &Vehicle::mavlinkSerialControl, this, &Mavlinkpaotou::_receiveData);
    }
}

void
Mavlinkpaotou::_receiveData(uint8_t device, uint8_t, uint16_t, uint32_t, QByteArray data)
{
    if (device != SERIAL_CONTROL_DEV_SHELL)
    {
        return;
    }

    // Append incoming data and parse for ANSI codes
    _incoming_buffer.append(data);
    while(!_incoming_buffer.isEmpty())
    {
        bool newline = false;
        int idx = _incoming_buffer.indexOf('\n');
        if (idx == -1)
        {
            // Read the whole incoming buffer
            idx = _incoming_buffer.size();
        }
        else
        {
            newline = true;
        }

        QByteArray fragment = _incoming_buffer.mid(0, idx);
        if (_processANSItext(fragment))
        {
            writeLine(_cursor, fragment);
            if (newline)
            {
                _cursor++;
            }
            _incoming_buffer.remove(0, idx + (newline ? 1 : 0));
        }
        else
        {
            // ANSI processing failed, need more data
            return;
        }
    }
}

void Mavlinkpaotou::_receiveMessage(LinkInterface* link, mavlink_message_t message)
{
    if (message.msgid == MAVLINK_MSG_ID_PAOTOU_MAVLINK) {
       // qDebug() << "Received PAOTOU_MAVLINK message";
        // 可以在这里处理接收到的消息
    }
}

void Mavlinkpaotou::_sendcom(int enable, int qian, int hou,
                             int zuo, int you, int tongdao1,
                             int tongdao2, int tongdao3, int tongdao4,
                             int all)
{
    if (!_vehicle)
    {
        qWarning() << "No active vehicle";
        return;
    }

    WeakLinkInterfacePtr weakLink = _vehicle->vehicleLinkManager()->primaryLink();
    if (!weakLink.expired())
    {
        SharedLinkInterfacePtr sharedLink = weakLink.lock();

        if (!sharedLink)
        {
            qCDebug(VehicleLog) << "_handlePing: primary link gone!";
            return;
        }

        // 打包PAOTOU_MAVLINK消息
        mavlink_message_t msg;
        mavlink_msg_paotou_mavlink_pack_chan(
            _vehicle->id(),                       // 系统ID
            0,
            sharedLink->mavlinkChannel(),
            &msg,
            enable,
            qian,
            hou,
            zuo,
            you,
            tongdao1,
            tongdao2,
            tongdao3,
            tongdao4,
            all
            );
        qDebug() << "Message length:" << msg.len << "bytes";
        _vehicle->sendMessageOnLinkThreadSafe(sharedLink.get(), msg);
        qDebug() << "Sent PAOTOU_MAVLINK command:"
                 << "sys ID:" << _vehicle->id()
                 << "Channel:" <<  sharedLink->mavlinkChannel()
                 << "Params:" << enable << qian << hou
                 << zuo << you << tongdao1
                 << tongdao2 << tongdao3 << tongdao4
                 << all;
    }
}

void
Mavlinkpaotou::_sendSerialData(QByteArray data, bool close)
{

    // if (!_vehicle)
    // {
    //     qWarning() << "Internal error";
    //     return;
    // }

    // WeakLinkInterfacePtr weakLink = _vehicle->vehicleLinkManager()->primaryLink();
    // if (!weakLink.expired()) {
    //     SharedLinkInterfacePtr sharedLink = weakLink.lock();

    //     if (!sharedLink) {
    //         qCDebug(VehicleLog) << "_handlePing: primary link gone!";
    //         return;
    //     }
    // }



}

bool
Mavlinkpaotou::_processANSItext(QByteArray &line)
{
    // 保持原有实现不变
    for (int i = 0; i < line.size(); i++)
    {
        if (line.at(i) == '\x1B')
        {
            // For ANSI codes we expect at least 3 incoming chars
            if (i < line.size() - 2 && line.at(i+1) == '[')
            {
                // Parse ANSI code
                switch(line.at(i+2))
                {
                default:
                    continue;
                case 'H':
                    if (_cursor_home_pos == -1)
                    {
                        // Assign new home position if home is unset
                        _cursor_home_pos = _cursor;
                    }
                    else
                    {
                        // Rewind write cursor position to home
                        _cursor = _cursor_home_pos;
                    }
                    break;
                case 'K':
                    // Erase the current line to the end
                    if (_cursor < rowCount())
                    {
                        setData(index(_cursor), "");
                    }
                    break;
                case '2':
                    // Check for sufficient buffer size
                    if ( i >= line.size() - 3)
                    {
                        return false;
                    }

                    if (line.at(i+3) == 'J' && _cursor_home_pos != -1)
                    {
                        // Erase everything and rewind to home
                        bool blocked = blockSignals(true);
                        for (int j = _cursor_home_pos; j < rowCount(); j++)
                        {
                            setData(index(j), "");
                        }
                        blockSignals(blocked);
                        QVector<int> roles;
                        roles.reserve(2);
                        roles.append(Qt::DisplayRole);
                        roles.append(Qt::EditRole);
                        emit dataChanged(index(_cursor), index(rowCount()), roles);
                    }
                    // Even if we didn't understand this ANSI code, remove the 4th char
                    line.remove(i+3,1);
                    break;
                }
                // Remove the parsed ANSI code and decrement the bufferpos
                line.remove(i, 3);
                i--;
            }
            else
            {
                // We can reasonably expect a control code was fragemented
                // Stop parsing here and wait for it to come in
                return false;
            }
        }
    }
    return true;
}

void
Mavlinkpaotou::writeLine(int line, const QByteArray &text)
{
    // 保持原有实现不变
    auto rc = rowCount();
    if (line >= rc)
    {
        insertRows(rc, 1 + line - rc);
    }
    auto idx = index(line);
    setData(idx, data(idx, Qt::DisplayRole).toString() + text);
}

void Mavlinkpaotou::CommandHistory::append(const QString& command)
{
    // 保持原有实现不变
    if (command.length() > 0)
    {
        // do not append duplicates
        if (_history.length() == 0 || _history.last() != command)
        {
            if (_history.length() >= maxHistoryLength)
            {
                _history.removeFirst();
            }
            _history.append(command);
        }
    }
    _index = _history.length();
}

QString Mavlinkpaotou::CommandHistory::up(const QString& current)
{
    // 保持原有实现不变
    if (_index <= 0)
    {
        return current;
    }

    --_index;
    if (_index < _history.length())
    {
        return _history[_index];
    }
    return "";
}

QString Mavlinkpaotou::CommandHistory::down(const QString& current)
{
    // 保持原有实现不变
    if (_index >= _history.length())
    {
        return current;
    }

    ++_index;
    if (_index < _history.length())
    {
        return _history[_index];
    }
    return "";
}
