#include "booksmodel.hpp"

BooksModel::BooksModel(QObject* parent)
    : QAbstractListModel(parent)
{
    generateDummyDataFromCovers();
}

int BooksModel::rowCount(const QModelIndex&) const
{
    return m_allBooks.size();
}

QVariant BooksModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_allBooks.size())
        return {};

    const Book& b = m_allBooks.at(index.row());

    switch (role) {
    case IdRole:        return b.id.toString();
    case TitleRole:     return b.title;
    case AuthorRole:    return b.author;
    case CategoryRole:  return QVariant::fromValue(b.category);
    case CoverRole:     return b.coverSource;
    case ProgressRole:  return b.progress;
    case RemainingRole: return b.remainingSeconds;
    case AddedAtRole:   return b.addedAt;
    case LocationRole:  return QVariant::fromValue(b.location);
    default:
        return {};
    }
}

QHash<int, QByteArray> BooksModel::roleNames() const
{
    return {
        { IdRole,        "id" },
        { TitleRole,     "title" },
        { AuthorRole,    "author" },
        { CategoryRole,  "category" },
        { CoverRole,     "bookCoverSource" }, // 👈 matches QML
        { ProgressRole,  "progress" },
        { RemainingRole, "remaining" },
        { AddedAtRole,   "addedAt" },
        { LocationRole,  "location" }
    };
}

void BooksModel::generateDummyDataFromCovers()
{
    m_allBooks.clear();

    struct Seed {
        const char* title;
        const char* author;
        BookEnums::Category category;
        BookEnums::Location location;
        int coverIndex;
    };

    static const QList<Seed> seeds = {
        { "Faye and the Ether", "Nicole Bailey", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1 },
        { "The Palace of Lost Memories", "C. J. Archer", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 2 },
        { "A Spirited Manor", "Kate Danley", BookEnums::Category::Mystery, BookEnums::Location::AudioBooks, 3 },
        { "Dragon Bones", "Ines Johnson", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 4 },
        { "Naruto Vol. 5", "Masashi Kishimoto", BookEnums::Category::Manga, BookEnums::Location::EBooks, 5 },
        { "The Beast Player", "Nahoko Uehashi", BookEnums::Category::Manga, BookEnums::Location::EBooks, 6 },
        { "One Piece Vol. 62", "Eiichiro Oda", BookEnums::Category::Manga, BookEnums::Location::EBooks, 7 },
        { "Jigsaw: Sonora", "David Alyn Gordon", BookEnums::Category::Adventure, BookEnums::Location::OneDrive, 8 },
        { "A Journey to the Moon", "Max Born", BookEnums::Category::Kids, BookEnums::Location::EBooks, 9 },
        { "A Journey to the Moon", "Max Born", BookEnums::Category::Kids, BookEnums::Location::AudioBooks, 10 },

        { "Embers of the Republic", "Matthew Jordan", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 11 },
        { "The Battle for the Fae King Throne", "Trif Premade", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 12 },
        { "A Game of Thrones", "George R. R. Martin", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 13 },
        { "It", "Stephen King", BookEnums::Category::Horror, BookEnums::Location::AudioBooks, 14 },
        { "From Grave With Love", "Sam Norton", BookEnums::Category::Thriller, BookEnums::Location::EBooks, 15 },
        { "The Sleeping City", "Hollis Heide", BookEnums::Category::Horror, BookEnums::Location::EBooks, 16 },
        { "1984", "George Orwell", BookEnums::Category::Dystopian, BookEnums::Location::EBooks, 17 },
        { "The Shining", "Stephen King", BookEnums::Category::Horror, BookEnums::Location::AudioBooks, 18 },
        { "Fahrenheit 451", "Ray Bradbury", BookEnums::Category::Dystopian, BookEnums::Location::EBooks, 19 },
        { "The Duke’s Regret", "Catherine Kullmann", BookEnums::Category::HistoricalFiction, BookEnums::Location::OneDrive, 20 }
    };

    int dayOffset = 0;

    for (const auto& s : seeds) {
        Book b;
        b.id = QUuid::createUuid();
        b.title = s.title;
        b.author = s.author;
        b.category = s.category;
        b.location = s.location;

        b.coverSource = QString("assets/books/book%1.jpg").arg(s.coverIndex);

        b.progress = qBound(0.0, (s.coverIndex % 6) * 0.15, 1.0);

        b.remainingSeconds = qMax(0, 18000 - s.coverIndex * 900);

        b.addedAt = QDateTime::currentDateTime().addDays(-dayOffset++);

        m_allBooks.push_back(b);
    }
}
