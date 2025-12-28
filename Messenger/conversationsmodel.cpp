#include "conversationsmodel.hpp"
#include <QDateTime>
#include <QRandomGenerator>

static QVariantList collectAvatarUrls(const Conversation& c,
                                      const ContactsModel* contacts)
{
    QVariantList urls;
    if (!contacts)
        return urls;

    const QString me = contacts->currentUserId();

    for (const QString& participantId : c.participantIds) {
        if (participantId == me)
            continue;

        const QString avatar = contacts->avatarById(participantId);
        if (!avatar.isEmpty())
            urls.push_back(avatar);
    }

    return urls;
}

static QString computeDisplayTitle(const Conversation& c,
                                   const ContactsModel* contacts)
{
    if (c.isGroup)
        return c.name;

    const QString me = contacts->currentUserId();

    for (const QString& participantId : c.participantIds) {
        if (participantId != me)
            return contacts->nameById(participantId);
    }

    return QStringLiteral("Chat");
}

static void processAddedMessages(QVector<Message>& messages)
{
    const int n = messages.size();
    if (n == 0)
        return;

    for (int i = 0; i < n; ++i) {
        const bool isLast =
            (i == n - 1) ||
            (messages[i].userId != messages[i + 1].userId);

        messages[i].isLastInSeries = isLast;
    }
}

static bool randomBool()
{
    return QRandomGenerator::global()->bounded(2) == 1;
}

ConversationsModel* ConversationsModel::s_instance = nullptr;

ConversationsModel::ConversationsModel(QObject* parent)
    : QAbstractListModel(parent)
{
    s_instance = this;
    m_messagesModel = new MessagesModel(this);
    loadDummyData();
    m_currentConversationId = m_conversations.first().id;
}

ConversationsModel* ConversationsModel::instance()
{
    return s_instance;
}

int ConversationsModel::rowCount(const QModelIndex&) const
{
    return m_conversations.size();
}

QVariant ConversationsModel::data(const QModelIndex& idx, int role) const
{
    if (!idx.isValid() || idx.row() >= m_conversations.size())
        return {};

    const Conversation& c = m_conversations[idx.row()];
    const auto* contacts = ContactsModel::instance();

    switch (role) {
    case IdRole:
        return c.id;

    case DisplayTitleRole:
        return computeDisplayTitle(c, contacts);

    case LastMessageRole:
        if (c.messages.isEmpty())
            return QVariant::fromValue(Message{});
        return QVariant::fromValue(c.messages.last());

    case IsReadRole:
        return c.isRead;

    case AvatarUrlsRole:
        return collectAvatarUrls(c, contacts);

    default:
        return {};
    }
}

QHash<int, QByteArray> ConversationsModel::roleNames() const
{
    return {
        { IdRole, "id" },
        { DisplayTitleRole, "title" },
        { LastMessageRole, "lastMessage" },
        { LastMessageTsRole, "lastMessageTimestampMs" },
        { IsReadRole, "isRead" },
        { AvatarUrlsRole, "avatarUrls" }
    };
}

QString ConversationsModel::currentConversationId() const
{
    return m_currentConversationId;
}

Conversation ConversationsModel::currentConversation() const
{
    const Conversation* c = conversationById(m_currentConversationId);
    return c ? *c : Conversation{};
}

void ConversationsModel::setCurrentConversationId(const QString& id)
{
    if (m_currentConversationId == id)
        return;

    m_currentConversationId = id;

    m_messagesModel->setMessages(conversationById(id)->messages);

    emit currentConversationIdChanged();
    emit currentConversationChanged();
    emit currentConversationAvatarUrlsChanged();
    emit messagesModelChanged();
}

MessagesModel* ConversationsModel::messagesModel() const
{
    return m_messagesModel;
}

void ConversationsModel::markCurrentConversationRead()
{
    for (int row = 0; row < m_conversations.size(); ++row) {
        if (m_conversations[row].id == m_currentConversationId) {

            if (m_conversations[row].isRead)
                return;

            m_conversations[row].isRead = true;

            const QModelIndex idx = index(row, 0);
            emit dataChanged(idx, idx, { IsReadRole });

            return;
        }
    }
}
const Conversation* ConversationsModel::conversationById(const QString& id) const
{
    for (const auto& c : m_conversations)
        if (c.id == id) return &c;
    return nullptr;
}

Conversation* ConversationsModel::conversationById(const QString& id)
{
    for (auto& c : m_conversations)
        if (c.id == id) return &c;
    return nullptr;
}

QVariantList ConversationsModel::currentConversationAvatarUrls() const
{
    const Conversation* c = conversationById(m_currentConversationId);
    if (!c)
        return {};

    return collectAvatarUrls(*c, ContactsModel::instance());
}

void ConversationsModel::loadDummyData()
{
    const qint64 now = QDateTime::currentMSecsSinceEpoch();

    const auto* contacts = ContactsModel::instance();

    const int numContacts = contacts->rowCount({});

    for (int row = 0; ; ++row) {
        if (m_conversations.size() >= 2 || row >= numContacts) {
            break;
        }
        QModelIndex idx = contacts->index(row, 0);

        QString contactId = contacts->data(idx, ContactsModel::IdRole).toString();

        if (contactId == contacts->currentUserId()) {
            continue;
        }

        QString contactName = contacts->data(idx, ContactsModel::NameRole).toString();
        QString avatar = contacts->data(idx, ContactsModel::AvatarUrlRole).toString();

        Conversation conversation;
        conversation.id = generateUuid();
        conversation.name = contactName;
        conversation.participantIds = { contactId };
        conversation.isGroup = false;
        conversation.isRead = randomBool();
        conversation.messages = {
            { generateUuid(), contactId, "What's up?", "", now - 300000 },
            { generateUuid(), contactId, "Have you seen a new movie already?", "", now - 320000 },
            { generateUuid(), contacts->currentUserId(), "Not really", "", now - 350000 },
            { generateUuid(), contactId, "How about you join me then?", "", now - 200000 }
        };

        m_conversations.push_back(conversation);
    }

    for (int row = 3; ; ++row) {
        if (m_conversations.size() >= 6 || row >= numContacts) {
            break;
        }
        QModelIndex idx = contacts->index(row, 0);

        QString contactId = contacts->data(idx, ContactsModel::IdRole).toString();

        if (contactId == contacts->currentUserId()) {
            continue;
        }

        QString contactName = contacts->data(idx, ContactsModel::NameRole).toString();
        QString avatar = contacts->data(idx, ContactsModel::AvatarUrlRole).toString();

        Conversation conversation;
        conversation.id = generateUuid();
        conversation.name = contactName;
        conversation.participantIds = { contactId };
        conversation.isGroup = false;
        conversation.isRead = randomBool();
        conversation.messages = {
            { generateUuid(), contactId, "Hey! So about that transfer...", "", now - 370000 },
            { generateUuid(), contactId, "Do you mind if I send it tomorrow?", "", now - 340000 },
            { generateUuid(), contacts->currentUserId(), "Well, in fact it's quite urgent", "", now - 330000 },
            { generateUuid(), contactId, "Alright then! Nevermind, gonna do it now...", "", now - 10000 }
        };
        processAddedMessages(conversation.messages);
        m_conversations.push_back(conversation);
    }

    for (int row = 0; ; ++row) {
        if (m_conversations.size() >= 9 || row >= numContacts) {
            break;
        }
        QModelIndex idx = contacts->index(row, 0);

        QString contactId = contacts->data(idx, ContactsModel::IdRole).toString();

        if (contactId == contacts->currentUserId()) {
            continue;
        }

        QString contactName = contacts->data(idx, ContactsModel::NameRole).toString();
        QString avatar = contacts->data(idx, ContactsModel::AvatarUrlRole).toString();

        Conversation conversation;
        conversation.id = generateUuid();
        conversation.name = contactName;
        conversation.participantIds = { contactId };
        conversation.isGroup = false;
        conversation.isRead = randomBool();
        conversation.messages = {
            { generateUuid(), contacts->currentUserId(), "Hey are you there?", "", now - 80000 },
            { generateUuid(), contacts->currentUserId(), "I've got a quick question", "", now - 79000 },
            { generateUuid(), contactId, "Sorry, been on a meeting, what's it about?", "", now - 50000 },
            { generateUuid(), contactId, "NVM, solved already", "", now - 10000 }
        };
        processAddedMessages(conversation.messages);
        m_conversations.push_back(conversation);
    }


    QStringList participantIds;
    for (int row = 0; ; ++row) {
        if (participantIds.size() == 3 || row >= numContacts) {
            break;
        }
        QModelIndex idx = contacts->index(row, 0);
        QString contactId = contacts->data(idx, ContactsModel::IdRole).toString();
        if (contactId == contacts->currentUserId()) {
            continue;
        }
        participantIds.push_back(contactId);
    }

    {
        Conversation conversation;
        conversation.id = generateUuid();
        conversation.name = "Crew";
        conversation.isGroup = true;
        conversation.isRead = false;
        conversation.participantIds = participantIds;
        conversation.messages = {
            { generateUuid(), participantIds.first(), "haha", "", now - 90000 },
            { generateUuid(), contacts->currentUserId(), "hahahah", "", now - 87000 },
            { generateUuid(), contacts->currentUserId(), "Let's invite Paul?", "", now - 85000 },
            { generateUuid(), participantIds.at(1), "Ugh, that dude is boring, maybe let's meet him later?", "", now - 80000 },
            { generateUuid(), participantIds.at(1), "Last time we had to finish early coz of him ;(", "", now - 75000 },
            { generateUuid(), participantIds.at(2), "Yeah, let's hang out with fun this time :)", "", now - 73000 },
            { generateUuid(), contacts->currentUserId(), "Alrighty then!", "", now - 72000 },
            { generateUuid(), contacts->currentUserId(), "hahahah", "", now - 70000 },
            { generateUuid(), contacts->currentUserId(), "Let's invite Paul?", "", now - 68000 },
            { generateUuid(), participantIds.at(1), "Ugh, that dude is boring, maybe let's meet him later?", "", now - 66000 },
            { generateUuid(), participantIds.at(1), "Last time we had to finish early coz of him ;(", "", now - 64000 },
            { generateUuid(), participantIds.at(2), "Yeah, let's hang out with fun this time :)", "", now - 62000 },
            { generateUuid(), contacts->currentUserId(), "Alrighty then!", "", now - 60000 },
            { generateUuid(), contacts->currentUserId(), "hahahah", "", now - 58000 },
            { generateUuid(), contacts->currentUserId(), "Let's invite Paul?", "", now - 55000 },
            { generateUuid(), participantIds.at(1), "Ugh, that dude is boring, maybe let's meet him later?", "", now - 52000 },
            { generateUuid(), participantIds.at(1), "Last time we had to finish early coz of him ;(", "", now - 50000 },
            { generateUuid(), participantIds.at(2), "Yeah, let's hang out with fun this time :)", "", now - 48000 },
            { generateUuid(), contacts->currentUserId(), "Alrighty then!", "", now - 46000 },
            { generateUuid(), contacts->currentUserId(), "hahahah", "", now - 44000 },
            { generateUuid(), contacts->currentUserId(), "Let's invite Paul?", "", now - 43000 },
            { generateUuid(), participantIds.at(1), "Ugh, that dude is boring, maybe let's meet him later?", "", now - 42000 },
            { generateUuid(), participantIds.at(1), "Last time we had to finish early coz of him ;(", "", now - 40000 },
            { generateUuid(), participantIds.at(2), "Yeah, let's hang out with fun this time :)", "", now - 38000 },
            { generateUuid(), contacts->currentUserId(), "Alrighty then!", "", now - 36000 },
            { generateUuid(), contacts->currentUserId(), "hahahah", "", now - 34000 },
            { generateUuid(), contacts->currentUserId(), "Let's invite Paul?", "", now - 33000 },
            { generateUuid(), participantIds.at(1), "Ugh, that dude is boring, maybe let's meet him later?", "", now - 32000 },
            { generateUuid(), participantIds.at(1), "Last time we had to finish early coz of him ;(", "", now - 30000 },
            { generateUuid(), participantIds.at(2), "Yeah, let's hang out with fun this time :)", "", now - 28000 },
            { generateUuid(), contacts->currentUserId(), "Alrighty then!", "", now - 26000 }
        };
        processAddedMessages(conversation.messages);
        m_conversations.push_back(conversation);
    }
}
