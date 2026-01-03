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
    case SubTitleRole:  return b.subtitle;
    case AuthorRole:    return b.author;
    case CategoryRole:  return QVariant::fromValue(b.category);
    case CoverRole:     return b.coverSource;
    case ProgressRole:  return b.progress;
    case RemainingRole: return b.remainingSeconds;
    case AddedAtRole:   return b.addedAt;
    case LocationRole:  return QVariant::fromValue(b.location);
    case LocationStringRole: return locationToString(b.location);
    case SizeRole:      return b.size;
    default:
        return {};
    }
}

QHash<int, QByteArray> BooksModel::roleNames() const
{
    return {
        { IdRole,        "id" },
        { TitleRole,     "title" },
        { SubTitleRole,  "subtitle" },
        { AuthorRole,    "author" },
        { CategoryRole,  "category" },
        { CoverRole,     "bookCoverSource" }, // 👈 matches QML
        { ProgressRole,  "progress" },
        { RemainingRole, "remaining" },
        { AddedAtRole,   "addedAt" },
        { LocationRole,  "location" },
        { LocationStringRole,  "locationString" },
        { SizeRole,      "size" }
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
        quint64 size;
        int coverIndex;
    };

    static const QList<Seed> seeds = {
        { "Faye and the Ether", "Nicole Bailey", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1024 * 1024 * 5, 1 },
        { "The Palace of Lost Memories", "C. J. Archer", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1024 * 1024 * 3, 2 },
        { "A Spirited Manor", "Kate Danley", BookEnums::Category::Mystery, BookEnums::Location::AudioBooks, 1024 * 1024 * 11, 3 },
        { "Dragon Bones", "Ines Johnson", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1024 * 1024 * 5, 4 },
        { "Naruto Vol. 5", "Masashi Kishimoto", BookEnums::Category::Manga, BookEnums::Location::EBooks, 1024 * 1024 * 2, 5 },
        { "The Beast Player", "Nahoko Uehashi", BookEnums::Category::Manga, BookEnums::Location::EBooks, 1024 * 1024 * 4, 6 },
        { "One Piece Vol. 62", "Eiichiro Oda", BookEnums::Category::Manga, BookEnums::Location::EBooks, 1024 * 1024 * 1, 7 },
        { "Jigsaw: Sonora", "David Alyn Gordon", BookEnums::Category::Adventure, BookEnums::Location::OneDrive, 1024 * 1024 * 8, 8 },
        { "A Journey to the Moon", "Max Born", BookEnums::Category::Kids, BookEnums::Location::EBooks, 1024 * 1024 * 6, 9 },
        { "A Journey to the Moon", "Max Born", BookEnums::Category::Kids, BookEnums::Location::AudioBooks, 1024 * 1024 * 5, 10 },

        { "Embers of the Republic", "Matthew Jordan", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1024 * 1024 * 16, 11 },
        { "The Battle for the Fae King Throne", "Trif Premade", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1024 * 1024 * 9, 12 },
        { "A Game of Thrones", "George R. R. Martin", BookEnums::Category::Fantasy, BookEnums::Location::EBooks, 1024 * 1024 * 7, 13 },
        { "It", "Stephen King", BookEnums::Category::Horror, BookEnums::Location::AudioBooks, 1024 * 1024 * 8, 14 },
        { "From Grave With Love", "Sam Norton", BookEnums::Category::Thriller, BookEnums::Location::EBooks, 1024 * 1024 * 5, 15 },
        { "The Sleeping City", "Hollis Heide", BookEnums::Category::Horror, BookEnums::Location::EBooks, 1024 * 1024 * 20, 16 },
        { "1984", "George Orwell", BookEnums::Category::Dystopian, BookEnums::Location::EBooks, 1024 * 1024 * 4, 17 },
        { "The Shining", "Stephen King", BookEnums::Category::Horror, BookEnums::Location::AudioBooks, 1024 * 1024 * 3, 18 },
        { "Fahrenheit 451", "Ray Bradbury", BookEnums::Category::Dystopian, BookEnums::Location::EBooks, 1024 * 1024 * 17, 19 },
        { "The Duke’s Regret", "Catherine Kullmann", BookEnums::Category::HistoricalFiction, BookEnums::Location::OneDrive, 1024 * 1024 * 8, 20 }
    };

    int dayOffset = 0;

    for (const auto& s : seeds) {
        Book b;
        b.id = QUuid::createUuid();
        b.title = s.title;
        b.author = s.author;
        b.category = s.category;
        b.location = s.location;

        b.size = s.size;

        b.coverSource = QString("assets/books/book%1.jpg").arg(s.coverIndex);

        b.progress = qBound(0.0, (s.coverIndex % 6) * 0.15, 1.0);

        b.remainingSeconds = qMax(0, 18000 - s.coverIndex * 900);

        b.addedAt = QDateTime::currentDateTime().addDays(-dayOffset++);

        m_allBooks.push_back(b);
    }
}

QString BooksModel::locationToString(BookEnums::Location location)
{
    switch (location) {
    case BookEnums::Location::EBooks:
        return QStringLiteral("E-Books");
    case BookEnums::Location::AudioBooks:
        return QStringLiteral("Audiobooks");
    case BookEnums::Location::OneDrive:
        return QStringLiteral("OneDrive");
    case BookEnums::Location::PDF:
        return QStringLiteral("PDF");
    case BookEnums::Location::ePUB:
        return QStringLiteral("ePUB");
    }

    return QStringLiteral("Unknown");
}

