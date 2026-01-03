#include "booksproxymodel.hpp"
#include "booksmodel.hpp"

BooksProxyModel::BooksProxyModel(QObject* parent)
    : QSortFilterProxyModel(parent)
{
}

void BooksProxyModel::setLimit(int value)
{
    if (m_limit == value)
        return;

    m_limit = value;
    emit limitChanged();

    invalidate();
}

void BooksProxyModel::setOffset(int value)
{
    value = qMax(0, value);

    if (m_offset == value)
        return;

    m_offset = value;
    emit offsetChanged();

    invalidate();
}

void BooksProxyModel::setCategoryFilter(BookEnums::Category category)
{
    m_categoryFilter = category;
    m_categoryFilterEnabled = true;

    emit categoryFilterChanged();
    invalidateFilter();
}

int BooksProxyModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    const int total = QSortFilterProxyModel::rowCount(parent);

    if (total <= m_offset)
        return 0;

    const int available = total - m_offset;

    if (m_limit < 0)
        return available;

    return qMin(m_limit, available);
}

QModelIndex BooksProxyModel::mapToSource(const QModelIndex& proxyIndex) const
{
    if (!proxyIndex.isValid())
        return {};

    const int sourceRow = proxyIndex.row() + m_offset;

    return QSortFilterProxyModel::mapToSource(
        QSortFilterProxyModel::index(
            sourceRow,
            proxyIndex.column(),
            proxyIndex.parent()
            )
        );
}

QModelIndex BooksProxyModel::mapFromSource(const QModelIndex& sourceIndex) const
{
    if (!sourceIndex.isValid())
        return {};

    const int proxyRow = sourceIndex.row() - m_offset;

    if (proxyRow < 0)
        return {};

    return QSortFilterProxyModel::index(
        proxyRow,
        sourceIndex.column(),
        sourceIndex.parent()
        );
}

bool BooksProxyModel::filterAcceptsRow(int sourceRow,
                                       const QModelIndex& sourceParent) const
{
    if (!m_categoryFilterEnabled)
        return true;

    QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!idx.isValid())
        return false;

    QVariant categoryData = idx.data(BooksModel::CategoryRole);
    if (!categoryData.isValid())
        return false;

    return categoryData.value<BookEnums::Category>() == m_categoryFilter;
}
