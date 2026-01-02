import QtQuick
import QtQuick.Effects
import Config

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

    ListModel {
        id: lastReadBooks
        ListElement { progress: 2;  remaining: 18000; bookCoverSource: "assets/books/book1.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book2.jpg" }
        ListElement { progress: 2;  remaining: 7200;  bookCoverSource: "assets/books/book3.jpg" }
        ListElement { progress: 3;  remaining: 14400; bookCoverSource: "assets/books/book4.jpg" }
    }


    ListModel {
        id: availableBooks
        ListElement { bookCoverSource: "assets/books/book5.jpg" }
        ListElement { bookCoverSource: "assets/books/book6.jpg" }
        ListElement { bookCoverSource: "assets/books/book7.jpg" }
        ListElement { bookCoverSource: "assets/books/book8.jpg" }
        ListElement { bookCoverSource: "assets/books/book9.jpg" }
        ListElement { bookCoverSource: "assets/books/book10.jpg" }
    }

    ListModel {
        id: availableBooksCollection
        ListElement { bookCoverSource: "assets/books/book8.jpg" }
        ListElement { bookCoverSource: "assets/books/book9.jpg" }
        ListElement { bookCoverSource: "assets/books/book10.jpg" }
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

        model: lastReadBooks
    }

    BookStack {
        id: bookStackLeft
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: library.bottom
        anchors.left: library.left
        width: root.bookWidth * 2 + root.booksSpacing
        model: availableBooks
        xOffsetStep: (width - bookWidth + root.booksSpacing) / (maxBooks - 1)
        bookWidth: root.bookWidth
        bookHeight: root.bookHeight
        maxBooks: Math.min(Config.maxBooksInCollectionsPreview, availableBooks.count)
        title: qsTr("My Books")
        subtitle: qsTr("%1 Books").arg(availableBooks.count)
    }

    BookStack {
        id: bookStackRight
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: library.bottom
        anchors.right: library.right
        width: root.bookWidth * 2 + root.booksSpacing
        model: availableBooksCollection
        xOffsetStep: (width - bookWidth + root.booksSpacing) / (maxBooks - 1)
        bookWidth: root.bookWidth
        bookHeight: root.bookHeight
        maxBooks: Math.min(Config.maxBooksInCollectionsPreview, availableBooksCollection.count)
        title: qsTr("Manga")
        subtitle: qsTr("Collection")
    }

    InfoCard {
        anchors.topMargin: Config.sectionsVerticalSpacing
        anchors.top: bookStackLeft.bottom
        anchors.left: bookStackLeft.left
        title: qsTr("Find your next great read")
        subtitle: qsTr("Shop Kobo")
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
