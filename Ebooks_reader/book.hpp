#pragma once

#include <QString>
#include <QDateTime>
#include <QUuid>
#include <QtQml>
#include "bookenums.hpp"

struct Book
{
    Q_GADGET
    QML_VALUE_TYPE(book)

public:
    Book() = default;

    QUuid id;

    QString title;
    QString subtitle;
    QString author;
    BookEnums::Category category;

    quint64 size = 0;

    QString coverSource;

    qreal progress = 0.0;
    int remainingSeconds = 0;

    QDateTime addedAt;
    BookEnums::Location location;
};

Q_DECLARE_METATYPE(Book)
