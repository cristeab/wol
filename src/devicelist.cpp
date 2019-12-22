#include "devicelist.h"
#include <thread>
#include <QApplication>
#include <QSettings>
#include <QDebug>

DeviceList::DeviceList(QObject *parent) : QAbstractListModel(parent)
{
    setObjectName("deviceList");
    load();

    DeviceInfo devInfo;
    devInfo.friendlyName = "Media";
    devInfo.macAddress = "c0:3f:d5:67:56:ad";
    _deviceInfo.append(devInfo);
    devInfo.friendlyName = "Dell";
    devInfo.macAddress = "b8:ca:3a:ad:4c:21";
    _deviceInfo.append(devInfo);
}

int DeviceList::rowCount(const QModelIndex& /*parent*/) const
{
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

void DeviceList::remove(int index)
{
    if (isValidIndex(index)) {
        emit layoutAboutToBeChanged();
        _deviceInfo.remove(index);
        emit layoutChanged();
    }
}

void DeviceList::append(const QString &name, const QString &mac)
{
    emit layoutAboutToBeChanged();
    DeviceInfo devInfo;
    devInfo.friendlyName = name;
    devInfo.macAddress = mac;
    _deviceInfo.append(devInfo);
    emit layoutChanged();
}

void DeviceList::edit(int index, const QString &name, const QString &mac)
{
    if (isValidIndex(index)) {
        emit layoutAboutToBeChanged();
        _deviceInfo[index] = { name, mac };
        emit layoutChanged();
    } else {
        qWarning() << "Invalid index" << index;
    }
    std::thread th(&DeviceList::save, this);
    th.detach();
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
    for (int i = 0; i < _deviceInfo.size(); ++i) {
        settings.setArrayIndex(i);
        settings.setValue("friendlyName", _deviceInfo.at(i).friendlyName);
        settings.setValue("macAddress", _deviceInfo.at(i).macAddress);
    }
    settings.endArray();
}

void DeviceList::load()
{
    QSettings settings(qApp->organizationName(), qApp->applicationName());
    int size = settings.beginReadArray("deviceInfo");
    _deviceInfo.clear();
    emit layoutAboutToBeChanged();
    for (int i = 0; i < size; ++i) {
        settings.setArrayIndex(i);
        DeviceInfo di;
        di.friendlyName = settings.value("friendlyName").toString();
        di.macAddress = settings.value("macAddress").toString();
        _deviceInfo.append(di);
    }
    emit layoutChanged();
    settings.endArray();
}
