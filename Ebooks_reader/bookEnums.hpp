#pragma once
#include <QtQml>

class BookEnums : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Book)
    QML_UNCREATABLE("Enums only")

public:
    enum class Category {
        Fantasy,
        Horror,
        Thriller,
        Dystopian,
        Manga,
        Kids,
        Mystery,
        HistoricalFiction,
        Adventure
    };
    Q_ENUM(Category)

    enum class Location {
        EBooks,
        AudioBooks,
        OneDrive
    };
    Q_ENUM(Location)
};
