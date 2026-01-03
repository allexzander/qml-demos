#include "booksproxymodel.hpp"
#include "booksmodel.hpp"

BooksProxyModel::BooksProxyModel(QObject* parent)
    : QSortFilterProxyModel(parent)
{
    // Default sort: newest first
    setDynamicSortFilter(true);
    applySorting();
}

void BooksProxyModel::setLimit(int value)
{
    if (m_limit == value)
        return;

    beginResetModel();
    m_limit = value;
    endResetModel();

    emit limitChanged();
}

void BooksProxyModel::setOffset(int value)
{
    value = qMax(0, value);

    if (m_offset == value)
        return;

    beginResetModel();
    m_offset = value;
    endResetModel();

    emit offsetChanged();
}

void BooksProxyModel::setCategoryFilterEnabled(bool enabled)
{
    if (m_categoryFilterEnabled == enabled)
        return;

    beginFilterChange();
    m_categoryFilterEnabled = enabled;
    endFilterChange();

    emit categoryFilterEnabledChanged();
}

void BooksProxyModel::setCategoryFilter(BookEnums::Category category)
{
    // If you set a category, we assume filtering becomes enabled.
    // If you want "All", call clearCategoryFilter().
    if (m_categoryFilterEnabled && m_categoryFilter == category)
        return;

    beginFilterChange();
    m_categoryFilter = category;
    m_categoryFilterEnabled = true;
    endFilterChange();

    emit categoryFilterChanged();
    emit categoryFilterEnabledChanged();
}

void BooksProxyModel::clearCategoryFilter()
{
    if (!m_categoryFilterEnabled)
        return;

    beginFilterChange();
    m_categoryFilterEnabled = false;
    endFilterChange();

    emit categoryFilterEnabledChanged();
}

void BooksProxyModel::setSortKey(BooksModel::SortKey key)
{
    if (m_sortKey == key)
        return;

    m_sortKey = key;
    emit sortKeyChanged();

    applySorting();
}

void BooksProxyModel::setSortOrder(Qt::SortOrder order)
{
    if (m_sortOrder == order)
        return;

    m_sortOrder = order;
    emit sortOrderChanged();

    applySorting();
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

    const int shiftedRow = proxyIndex.row() + m_offset;
    return QSortFilterProxyModel::mapToSource(
        QSortFilterProxyModel::index(shiftedRow, proxyIndex.column(), proxyIndex.parent()));
}

QModelIndex BooksProxyModel::mapFromSource(const QModelIndex& sourceIndex) const
{
    if (!sourceIndex.isValid())
        return {};

    const int proxyRow = sourceIndex.row() - m_offset;
    if (proxyRow < 0)
        return {};

    return QSortFilterProxyModel::index(proxyRow, sourceIndex.column(), sourceIndex.parent());
}

bool BooksProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const
{
    if (!m_categoryFilterEnabled)
        return true;

    const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!idx.isValid())
        return false;

    const QVariant categoryData = idx.data(BooksModel::CategoryRole);
    if (!categoryData.isValid())
        return false;

    return categoryData.value<BookEnums::Category>() == m_categoryFilter;
}

bool BooksProxyModel::lessThan(const QModelIndex& left, const QModelIndex& right) const
{
    // Compare values by the sort role currently configured
    const int role = sortRole();

    const QVariant a = sourceModel()->data(left, role);
    const QVariant b = sourceModel()->data(right, role);

    // Date
    if (role == BooksModel::AddedAtRole)
        return a.toDateTime() < b.toDateTime();

    // Title/Author (QString)
    if (role == BooksModel::TitleRole || role == BooksModel::AuthorRole)
        return QString::localeAwareCompare(a.toString(), b.toString()) < 0;

    // Numeric
    if (a.canConvert<double>() && b.canConvert<double>())
        return a.toDouble() < b.toDouble();

    // Fallback
    return QString::localeAwareCompare(a.toString(), b.toString()) < 0;
}

int BooksProxyModel::sortRoleForKey(BooksModel::SortKey key) const
{
    switch (key) {
    case BooksModel::SortKey::Title:  return BooksModel::TitleRole;
    case BooksModel::SortKey::Author: return BooksModel::AuthorRole;
    case BooksModel::SortKey::Date:   return BooksModel::AddedAtRole;
    }
    return BooksModel::AddedAtRole;
}

void BooksProxyModel::applySorting()
{
    setSortRole(sortRoleForKey(m_sortKey));
    sort(0, m_sortOrder); // triggers lessThan()
}
