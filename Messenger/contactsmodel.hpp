#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QVector>
#include <QUuid>
#include <QtQml/qqml.h>

struct Contact {
    Q_GADGET
    Q_PROPERTY(QString id MEMBER id)
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(QString avatarUrl MEMBER avatarUrl)

public:
    QString id;
    QString name;
    QString avatarUrl;
};

class ContactsModel final : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString currentUserId READ currentUserId WRITE setCurrentUserId NOTIFY currentUserIdChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        AvatarUrlRole
    };
    Q_ENUM(Roles)

    explicit ContactsModel(QObject* parent = nullptr);
    static ContactsModel* instance();

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex&, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString currentUserId() const;
    void setCurrentUserId(const QString& id);

    QString nameById(const QString& id) const;
    QString avatarById(const QString& id) const;

signals:
    void currentUserIdChanged();

private:
    void loadDummyData();

    inline QString generateUuid()
    {
        return QUuid::createUuid().toString(QUuid::WithoutBraces);
    }

private:
    static ContactsModel* s_instance;
    QString m_currentUserId;
    QVector<Contact> m_contacts;
};
