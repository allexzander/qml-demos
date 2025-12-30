#pragma once

#include <QAbstractListModel>
#include <QStringList>
#include <QVector>
#include <QUuid>
#include <QtQml/qqml.h>
#include "datatypes.hpp"
#include "messagesmodel.hpp"

struct Conversation {
    Q_GADGET
    QML_VALUE_TYPE(conversation)

    Q_PROPERTY(QString id MEMBER id)
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(bool isRead MEMBER isRead)
    Q_PROPERTY(bool isGroup MEMBER isGroup)

public:
    QString id;
    QString name;
    bool isRead;
    QStringList participantIds;
    bool isGroup = false;
};

class ConversationsModel final : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString currentConversationId
                   READ currentConversationId
                       WRITE setCurrentConversationId
                           NOTIFY currentConversationIdChanged)
    Q_PROPERTY(Conversation currentConversation
                   READ currentConversation
                       NOTIFY currentConversationChanged)

    Q_PROPERTY(MessagesModel* messagesModel
                   READ messagesModel
                       NOTIFY messagesModelChanged)

    Q_PROPERTY(QVariantList currentConversationAvatarUrls
                   READ currentConversationAvatarUrls
                       NOTIFY currentConversationChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        DisplayTitleRole,
        LastMessageRole,
        LastMessageTsRole,
        IsReadRole,
        AvatarUrlsRole
    };
    Q_ENUM(Roles)

    explicit ConversationsModel(QObject* parent = nullptr);
    static ConversationsModel* instance();

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex&, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString currentConversationId() const;
    void setCurrentConversationId(const QString& id);

    Conversation currentConversation() const;
    const Conversation* conversationById(const QString& id) const;
    Conversation* conversationById(const QString& id);

    QVariantList currentConversationAvatarUrls() const;
    MessagesModel* messagesModel() const;

    Q_INVOKABLE void markCurrentConversationRead();
    Q_INVOKABLE void sendMessage(const QString& message);

    Q_INVOKABLE void handleMessageReceived(const QString& conversationId, const QString& senderUserId, const QString& text);

signals:
    void currentConversationIdChanged();
    void currentConversationChanged();
    void currentConversationAvatarUrlsChanged();
    void messagesModelChanged();

private:
    void loadDummyData();

    void scheduleDummyReply(const QString& conversationId);

    inline QString generateUuid()
    {
        return QUuid::createUuid().toString(QUuid::WithoutBraces);
    }

private:
    static ConversationsModel* s_instance;
    QString m_currentConversationId;
    QVector<Conversation> m_conversations;
    MessagesModel* m_messagesModel = nullptr;
};
