#pragma once

#include "qmlhelpers.h"
#include <QAbstractListModel>
#include <QVector>

class DeviceList : public QAbstractListModel
{
public:
    enum CallModelRoles {
        FriendlyName = Qt::UserRole + 1,
        MacAddress
    };
    struct DeviceInfo {
        QString friendlyName;
        QString macAddress;
    };
    DeviceList(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int,QByteArray> roleNames() const override;
private:
    bool isValidIndex(int idx) const {
        return ((0 <= idx) && (idx < _deviceInfo.size()));
    }
    QVector<DeviceInfo> _deviceInfo;
};
