#pragma once

#include <QAbstractListModel>
#include <QtQml/qqml.h>
#include <QHash>
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

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex&, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setMessages(const QString& conversationId, const QVector<Message>& messages);
    void addMessage(const QString& conversationId, const Message& message);

    void setCurrentConversationId(const QString& conversationId);

    const QVector<Message> messagesForConversation(const QString& conversationId) const;

private:
    QHash<QString, QVector<Message>> m_messages;
    QString m_currentConversationId;
};
