#include "devicelist.h"
#include <QApplication>
#include <QSettings>
#include <QDebug>

namespace {
const QVector<DeviceList::DeviceInfo> initialDevices {
    {.friendlyName = "Media", .macAddress = "c0:3f:d5:67:56:ad"},
    {.friendlyName = "Dell", .macAddress = "b8:ca:3a:ad:4c:21"}
};
}

DeviceList::DeviceList(QObject *parent) : QAbstractListModel(parent)
{
    setObjectName("deviceList");
    load();
}

int DeviceList::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return _deviceInfo.size();
}

QVariant DeviceList::data(const QModelIndex &index, int role) const
{
    const int idx = index.row();
    if (!isValidIndex(idx)) {
        qCritical() << "invalid model index";
        return QVariant();
    }
    const auto &info = _deviceInfo.at(idx);
    QVariant out;
    switch (role) {
    case FriendlyName:
        out = info.friendlyName;
        break;
    case MacAddress:
        out = info.macAddress;
        break;
    }
    return out;
}

QHash<int,QByteArray> DeviceList::roleNames() const
{
    static const auto roles = QHash<int, QByteArray> {
        { FriendlyName, "friendlyName" },
        { MacAddress, "macAddress" }
    };
    return roles;
}

void DeviceList::wol(const QString &mac)
{
    qDebug() << "Wol" << mac;
    try {
        _wol.send(mac.toStdString());
    } catch (std::exception &e) {
        qWarning() << "Cannot send WOL packet" << e.what();
    }
}

bool DeviceList::configureNetwork(const QString &broadcastAddress, int port)
{
    const bool configured = _wol.configure(broadcastAddress.toStdString(), port);
    if (!configured)
        qWarning() << "Invalid network configuration" << broadcastAddress << port;
    return configured;
}

void DeviceList::remove(int index)
{
    if (isValidIndex(index)) {
        beginRemoveRows({}, index, index);
        _deviceInfo.remove(index);
        endRemoveRows();
        save();
    }
}

void DeviceList::append(const QString &name, const QString &mac)
{
    if (name.trimmed().isEmpty()) {
        qWarning() << "Cannot append a device without a name";
        return;
    }
    const int index = _deviceInfo.size();
    beginInsertRows({}, index, index);
    _deviceInfo.append({.friendlyName = name, .macAddress = mac});
    endInsertRows();
    save();
}

void DeviceList::edit(int index, const QString &name, const QString &mac)
{
    if (isValidIndex(index)) {
        if (name.trimmed().isEmpty()) {
            qWarning() << "Cannot edit a device without a name";
            return;
        }
        _deviceInfo[index] = { .friendlyName = name, .macAddress = mac };
        const auto modelIndex = this->index(index);
        emit dataChanged(modelIndex, modelIndex, {FriendlyName, MacAddress});
        save();
    } else {
        qWarning() << "Invalid index" << index;
    }
}

QString DeviceList::friendlyName(int index) const
{
    if (isValidIndex(index)) {
        return _deviceInfo.at(index).friendlyName;
    }
    return "";
}

QString DeviceList::macAddress(int index) const
{
    if (isValidIndex(index)) {
        return _deviceInfo.at(index).macAddress;
    }
    return "";
}

void DeviceList::save()
{
    QSettings settings(qApp->organizationName(), qApp->applicationName());
    settings.beginWriteArray("deviceInfo");
    int i = 0;
    for (auto const& [friendlyName, macAddress]: std::as_const(_deviceInfo)) {
        settings.setArrayIndex(i++);
        settings.setValue("friendlyName", friendlyName);
        settings.setValue("macAddress", macAddress);
    }
    settings.endArray();
}

void DeviceList::load()
{
    QSettings settings(qApp->organizationName(), qApp->applicationName());
    const bool hasSavedDeviceList = settings.contains("deviceInfo/size");
    int size = settings.beginReadArray("deviceInfo");
    _deviceInfo.clear();
    for (int i = 0; i < size; ++i) {
        settings.setArrayIndex(i);
        _deviceInfo.append({.friendlyName = settings.value("friendlyName").toString(),
                            .macAddress = settings.value("macAddress").toString()});
    }
    settings.endArray();

    if (!hasSavedDeviceList) {
        _deviceInfo = initialDevices;
        save();
    }
}
