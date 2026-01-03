#pragma once

#include <QSortFilterProxyModel>
#include <QtQml>
#include "book.hpp"
#include "booksmodel.hpp"

class BooksProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int limit READ limit WRITE setLimit NOTIFY limitChanged)
    Q_PROPERTY(int offset READ offset WRITE setOffset NOTIFY offsetChanged)

    // Filtering
    Q_PROPERTY(bool categoryFilterEnabled READ categoryFilterEnabled WRITE setCategoryFilterEnabled NOTIFY categoryFilterEnabledChanged)
    Q_PROPERTY(BookEnums::Category categoryFilter READ categoryFilter WRITE setCategoryFilter NOTIFY categoryFilterChanged)

    // Sorting
    Q_PROPERTY(BooksModel::SortKey sortKey READ sortKey WRITE setSortKey NOTIFY sortKeyChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder NOTIFY sortOrderChanged)

public:
    explicit BooksProxyModel(QObject* parent = nullptr);

    int limit() const { return m_limit; }
    void setLimit(int value);

    int offset() const { return m_offset; }
    void setOffset(int value);

    bool categoryFilterEnabled() const { return m_categoryFilterEnabled; }
    void setCategoryFilterEnabled(bool enabled);

    BookEnums::Category categoryFilter() const { return m_categoryFilter; }
    void setCategoryFilter(BookEnums::Category category);

    Q_INVOKABLE void clearCategoryFilter(); // "All"

    BooksModel::SortKey sortKey() const { return m_sortKey; }
    void setSortKey(BooksModel::SortKey key);

    Qt::SortOrder sortOrder() const { return m_sortOrder; }
    void setSortOrder(Qt::SortOrder order);

protected:
    int rowCount(const QModelIndex& parent = {}) const override;

    QModelIndex mapToSource(const QModelIndex& proxyIndex) const override;
    QModelIndex mapFromSource(const QModelIndex& sourceIndex) const override;

    bool filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const override;
    bool lessThan(const QModelIndex& sourceLeft, const QModelIndex& sourceRight) const override;

signals:
    void limitChanged();
    void offsetChanged();

    void categoryFilterEnabledChanged();
    void categoryFilterChanged();

    void sortKeyChanged();
    void sortOrderChanged();

private:
    void applySorting();
    int sortRoleForKey(BooksModel::SortKey key) const;

private:
    int m_limit = -1;
    int m_offset = 0;

    BookEnums::Category m_categoryFilter{};
    bool m_categoryFilterEnabled = false;

    BooksModel::SortKey m_sortKey = BooksModel::SortKey::Date;
    Qt::SortOrder m_sortOrder = Qt::DescendingOrder;
};
