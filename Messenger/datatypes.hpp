#pragma once

#include <QtQml/qqml.h>

struct Message {
    Q_GADGET
    QML_VALUE_TYPE(message)

    Q_PROPERTY(QString id MEMBER id)
    Q_PROPERTY(QString userId MEMBER userId)
    Q_PROPERTY(QString text MEMBER text)
    Q_PROPERTY(QString mediaUrl MEMBER mediaUrl)
    Q_PROPERTY(qint64 timestampMs MEMBER timestampMs)
    Q_PROPERTY(bool isLastInSeries MEMBER isLastInSeries)

public:
    QString id;
    QString userId;
    QString text;
    QString mediaUrl;
    qint64 timestampMs = 0;
    bool isLastInSeries = false;
};
