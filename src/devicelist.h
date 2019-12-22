#pragma once

#include "qmlhelpers.h"
#include "wol.h"
#include <QAbstractListModel>
#include <QVector>

class DeviceList : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_INVOKABLE void wol(const QString &mac);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void append(const QString &name, const QString &mac);
    Q_INVOKABLE void edit(int index, const QString &name, const QString &mac);
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
    Wol _wol;
};
