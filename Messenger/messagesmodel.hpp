#pragma once

#include <QAbstractListModel>
#include <QtQml/qqml.h>
#include "datatypes.hpp"

#include "contactsmodel.hpp"

class MessagesModel final : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        TextRole,
        MediaUrlRole,
        UserIdRole,
        IsMineRole,
        AvatarRole,
        TimestampRole,
        IsLastInSeriesRole
    };
    Q_ENUM(Roles)

    explicit MessagesModel(QObject* parent = nullptr);
    static MessagesModel* instance();

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex&, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setMessages(const QVector<Message>& messages);

private:
    QVector<Message> m_messages;
    static MessagesModel* s_instance;
};
