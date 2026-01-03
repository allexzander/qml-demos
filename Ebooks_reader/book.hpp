#pragma once

#include <QString>
#include <QDateTime>
#include <QUuid>
#include <QtQml>
#include "bookEnums.hpp"

struct Book
{
    Q_GADGET
    QML_VALUE_TYPE(book)

public:
    Book() = default;

    QUuid id;

    QString title;
    QString author;
    BookEnums::Category category;

    QString coverSource;

    qreal progress = 0.0;          // 0.0 – 1.0
    int remainingSeconds = 0;      // seconds

    // State
    QDateTime addedAt;
    BookEnums::Location location;
};

Q_DECLARE_METATYPE(Book)
