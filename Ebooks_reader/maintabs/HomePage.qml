import QtQuick
import QtQuick.Effects
import Config
import Ebooks_reader

Item {
    id: root

    readonly property int booksSpacing: Config.mediumMargin
    readonly property int lastReadBooksDisplayCount: Config.lastReadBooksDisplayCount

    readonly property real bookAspectRatio: Config.bookCoverAspect

    readonly property real totalSpacing: booksSpacing * (lastReadBooksDisplayCount - 1)
    readonly property real totalBooksWidth: width - totalSpacing

    // calc single book dimensions
    readonly property real bookWidth: totalBooksWidth / lastReadBooksDisplayCount
    readonly property real bookHeight: Math.min(bookWidth * bookAspectRatio, height)

    BooksProxyModel {
        id: lastReadProxy
        sourceModel: BooksModel
        limit: 4
    }

    BooksProxyModel {
        id: booksModelLeft
        sourceModel: BooksModel
        limit: 3
        offset: 9
    }

    BooksProxyModel {
        id: booksModelRight
        sourceModel: BooksModel
        categoryFilter: Book.Manga
        limit: 3
    }

    ListBooks {
        id: library
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: booksSpacing
        booksSpacing: Config.mediumMargin
        lastReadBooksDisplayCount: Config.lastReadBooksDisplayCount

        bookAspectRatio: Config.bookCoverAspect

        showProgress: true

        model: lastReadProxy
    }

    BookStack {
        id: bookStackLeft
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: library.bottom
        anchors.left: library.left
        width: root.bookWidth * 2 + root.booksSpacing
        model: booksModelLeft
        xOffsetStep: (width - bookWidth + root.booksSpacing) / (maxBooks - 1)
        bookWidth: root.bookWidth
        bookHeight: root.bookHeight
        maxBooks: Math.min(Config.maxBooksInCollectionsPreview, bookStackLeft.count)
        title: qsTr("My Books")
        subtitle: qsTr("%1 Books").arg(BooksModel.rowCount())
    }

    BookStack {
        id: bookStackRight
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: library.bottom
        anchors.right: library.right
        width: root.bookWidth * 2 + root.booksSpacing
        model: booksModelRight
        xOffsetStep: (width - bookWidth + root.booksSpacing) / (maxBooks - 1)
        bookWidth: root.bookWidth
        bookHeight: root.bookHeight
        maxBooks: Math.min(Config.maxBooksInCollectionsPreview, bookStackRight.count)
        title: qsTr("Manga")
        subtitle: qsTr("Collection")
    }

    InfoCard {
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: bookStackLeft.bottom
        anchors.left: bookStackLeft.left
        title: qsTr("Find your next great read")
        subtitle: qsTr("Shop Books")
        maxWidth: bookStackLeft.width
    }

    InfoCard {
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: bookStackRight.bottom
        anchors.left: bookStackRight.left
        title: qsTr("Create a Wishlist of books you're interested in")
        subtitle: qsTr("Wishlist")
        maxWidth: bookStackRight.width
    }

}
