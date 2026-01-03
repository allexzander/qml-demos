#pragma once

#include <QAbstractListModel>
#include <QtQml>
#include "book.hpp"

class BooksModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit BooksModel(QObject* parent = nullptr);

    enum Roles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        SubTitleRole,
        AuthorRole,
        CategoryRole,
        CoverRole,
        ProgressRole,
        RemainingRole,
        AddedAtRole,
        LocationRole,
        LocationStringRole,
        SizeRole
    };
    Q_ENUM(Roles)


    enum class SortKey {
        Title,
        Author,
        Date
    };
    Q_ENUM(SortKey)

    int rowCount(const QModelIndex& parent = {}) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    void generateDummyDataFromCovers();
    static QString locationToString(BookEnums::Location location);

private:
    QList<Book> m_allBooks;
};
