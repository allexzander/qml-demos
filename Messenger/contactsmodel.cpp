#include "contactsmodel.hpp"

ContactsModel* ContactsModel::s_instance = nullptr;

ContactsModel::ContactsModel(QObject* parent)
    : QAbstractListModel(parent)
{
    s_instance = this;
    m_currentUserId = generateUuid();
    loadDummyData();
}

ContactsModel* ContactsModel::instance()
{
    return s_instance;
}

int ContactsModel::rowCount(const QModelIndex&) const
{
    return m_contacts.size();
}

QVariant ContactsModel::data(const QModelIndex& idx, int role) const
{
    if (!idx.isValid() || idx.row() >= m_contacts.size())
        return {};

    const auto& c = m_contacts[idx.row()];
    if (role == IdRole) return c.id;
    if (role == NameRole) return c.name;
    if (role == AvatarUrlRole) return c.avatarUrl;
    return {};
}

QHash<int, QByteArray> ContactsModel::roleNames() const
{
    return {
        { IdRole, "id" },
        { NameRole, "name" },
        { AvatarUrlRole, "avatarUrl" }
    };
}

QString ContactsModel::currentUserId() const { return m_currentUserId; }

void ContactsModel::setCurrentUserId(const QString& id)
{
    if (m_currentUserId == id) return;
    m_currentUserId = id;
    emit currentUserIdChanged();
}

QString ContactsModel::nameById(const QString& id) const
{
    for (const auto& c : m_contacts)
        if (c.id == id) return c.name;
    return {};
}

QString ContactsModel::avatarById(const QString& id) const
{
    for (const auto& c : m_contacts)
        if (c.id == id) return c.avatarUrl;
    return {};
}

void ContactsModel::loadDummyData()
{
    static const QStringList contactNames {
        "Alice Chuang",
        "Jamie Sharpsteen",
        "James Nuemann",
        "Jamie Sharpsteen",
        "Surf Crew",
        "Hailey Cook",
        "Karan",
        "Brian",
        "Jean-Marc",
        "Susie Lee"
    };

    for (int i = 0; i < contactNames.size(); ++i) {
        Contact contact = {
            generateUuid(),
            contactNames.at(i),
            QString("assets/user_photos/user_photo_%1").arg(i + 1)
        };
        m_contacts.push_back(contact);
    }
}
