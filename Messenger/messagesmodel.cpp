#include "messagesmodel.hpp"

MessagesModel::MessagesModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

int MessagesModel::rowCount(const QModelIndex&) const
{
    if (m_currentConversationId.isEmpty()) {
        return 0;
    }
    return m_messages[m_currentConversationId].size();
}

QVariant MessagesModel::data(const QModelIndex& idx, int role) const
{
    if (m_currentConversationId.isEmpty() || !idx.isValid() || idx.row() < 0) {
        return {};
    }

    const auto& messages = m_messages[m_currentConversationId];

    if (idx.row() >= messages.size()) {
        return {};
    }

    const auto& m = messages[idx.row()];

    const auto* contacts = ContactsModel::instance();
    const QString me = contacts->currentUserId();

    if (role == IdRole) return m.id;
    if (role == TextRole) return m.text;
    if (role == MediaUrlRole) return m.mediaUrl;
    if (role == UserIdRole) return m.userId;
    if (role == TimestampRole) {
        return m.timestampMs;
    }
    if (role == IsMineRole) return m.userId == me;
    if (role == AvatarRole)
        return (m.userId == me) ? QString() : contacts->avatarById(m.userId);
    if (role == IsLastInSeriesRole) {
        return m.isLastInSeries;
    }

    return {};
}

QHash<int, QByteArray> MessagesModel::roleNames() const
{
    return {
        { IdRole, "id" },
        { TextRole, "text" },
        { MediaUrlRole, "mediaUrl" },
        { UserIdRole, "userId" },
        { IsMineRole, "isMine" },
        { AvatarRole, "avatar" },
        { TimestampRole, "timestampMs" },
        { IsLastInSeriesRole, "isLastInSeries"}
    };
}

void MessagesModel::setMessages(const QString& conversationId, const QVector<Message>& messages) {
    if (conversationId == m_currentConversationId) {
        beginResetModel();
    }
    m_messages[conversationId] = messages;
    if (conversationId == m_currentConversationId) {
        endResetModel();
    }
}

void MessagesModel::addMessage(const QString& conversationId, const Message& message)
{
    if (conversationId == m_currentConversationId) {
        beginInsertRows(QModelIndex(), rowCount({}), rowCount({}));
    }
    m_messages[conversationId].push_back(message);
    if (conversationId == m_currentConversationId) {
        endInsertRows();
    }
}

void MessagesModel::setCurrentConversationId(const QString& conversationId)
{
    beginResetModel();
    m_currentConversationId = conversationId;
    endResetModel();
}

const QVector<Message> MessagesModel::messagesForConversation(const QString& conversationId) const
{
    return m_messages[conversationId];
}
