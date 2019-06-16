#pragma once

#include "qmlhelpers.h"
#include <QAbstractListModel>

class DeviceList : public QAbstractListModel
{
public:
    enum CallModelRoles {
        FriendlyName = Qt::UserRole + 1,
        MacAddress
    };
    DeviceList();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int,QByteArray> roleNames() const override;
};
