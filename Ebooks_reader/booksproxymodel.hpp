#pragma once

#include <QSortFilterProxyModel>
#include <QtQml>
#include "book.hpp"

class BooksProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int limit READ limit WRITE setLimit NOTIFY limitChanged)
    Q_PROPERTY(int offset READ offset WRITE setOffset NOTIFY offsetChanged)
    Q_PROPERTY(BookEnums::Category categoryFilter
                   READ categoryFilter
                       WRITE setCategoryFilter
                           NOTIFY categoryFilterChanged)

public:
    explicit BooksProxyModel(QObject* parent = nullptr);

    int limit() const { return m_limit; }
    void setLimit(int value);

    int offset() const { return m_offset; }
    void setOffset(int value);

    BookEnums::Category categoryFilter() const { return m_categoryFilter; }
    void setCategoryFilter(BookEnums::Category category);

protected:
    int rowCount(const QModelIndex& parent = {}) const override;

    QModelIndex mapToSource(const QModelIndex& proxyIndex) const override;
    QModelIndex mapFromSource(const QModelIndex& sourceIndex) const override;

    bool filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const override;

signals:
    void limitChanged();
    void offsetChanged();
    void categoryFilterChanged();

private:
    int m_limit = -1;
    int m_offset = 0;

    BookEnums::Category m_categoryFilter{};
    bool m_categoryFilterEnabled = false;
};

