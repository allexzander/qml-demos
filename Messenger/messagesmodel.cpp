#include "messagesmodel.hpp"

MessagesModel* MessagesModel::s_instance = nullptr;

MessagesModel::MessagesModel(QObject* parent)
    : QAbstractListModel(parent)
{
    s_instance = this;
}

MessagesModel* MessagesModel::instance()
{
    return s_instance;
}

int MessagesModel::rowCount(const QModelIndex&) const
{
    return m_messages.size();
}

QVariant MessagesModel::data(const QModelIndex& idx, int role) const
{
    if (!idx.isValid() || idx.row() < 0 || idx.row() >= m_messages.size()) {
        return {};
    }

    const auto& m = m_messages[idx.row()];
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

void MessagesModel::setMessages(const QVector<Message>& messages) {
    beginResetModel();
    m_messages = messages;
    endResetModel();
}
