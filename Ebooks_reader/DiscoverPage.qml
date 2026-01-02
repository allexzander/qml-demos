import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Config

Item {
    id: root

    readonly property int booksSpacing: Config.mediumMargin
    readonly property int lastReadBooksDisplayCount: Config.lastReadBooksDisplayCount
    readonly property real bookAspectRatio: Config.bookCoverAspect

    readonly property int scrollBarPadding: Config.mediumMargin

    readonly property real totalSpacing:
        booksSpacing * (lastReadBooksDisplayCount - 1)

    readonly property real totalBooksWidth:
        width - totalSpacing - scrollBarPadding

    readonly property real bookWidth:
        totalBooksWidth / lastReadBooksDisplayCount

    readonly property real bookHeight:
        bookWidth * bookAspectRatio


    ListModel {
        id: listBooksEbook
        ListElement { progress: 2; remaining: 18000; bookCoverSource: "assets/books/book5.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book6.jpg" }
        ListElement { progress: 2; remaining: 7200;  bookCoverSource: "assets/books/book8.jpg" }
        ListElement { progress: 3; remaining: 14400; bookCoverSource: "assets/books/book9.jpg" }
    }

    ListModel {
        id: listBooksAudio
        ListElement { progress: 2; remaining: 18000; bookCoverSource: "assets/books/book10.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book2.jpg" }
        ListElement { progress: 2; remaining: 7200;  bookCoverSource: "assets/books/book1.jpg" }
        ListElement { progress: 3; remaining: 14400; bookCoverSource: "assets/books/book7.jpg" }
    }

    ListModel {
        id: listBooksOneDrive
        ListElement { progress: 2; remaining: 18000; bookCoverSource: "assets/books/book1.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book2.jpg" }
        ListElement { progress: 2; remaining: 7200;  bookCoverSource: "assets/books/book3.jpg" }
        ListElement { progress: 3; remaining: 14400; bookCoverSource: "assets/books/book4.jpg" }
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabs
            Layout.fillWidth: true
            Layout.preferredHeight: Config.textTabsHeight

            property var tabTitles: ["eBooks", "AudioBooks", "OneDrive"]
            property real maxTabTextWidth: 0

            TextMetrics {
                id: metrics
                font.pixelSize: Config.tabsFontPixelSize
            }

            Component.onCompleted: {
                let max = 0
                for (let i = 0; i < tabTitles.length; ++i) {
                    metrics.text = tabTitles[i]
                    max = Math.max(max, metrics.width)
                }
                maxTabTextWidth = max
            }

            background: Item {
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Config.deviderColor
                }
            }

            Repeater {
                model: tabs.tabTitles
                TabsButton {
                    text: modelData
                    width: tabs.maxTabTextWidth + 20
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Config.largeMargin
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabs.currentIndex


            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true
                flickableDirection: Flickable.VerticalFlick

                contentWidth: width
                contentHeight: ebooksColumn.implicitHeight

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar
                    policy: ScrollBar.AsNeeded
                }

                Column {
                    id: ebooksColumn
                    width: parent.width - scrollBar.width - scrollBarPadding
                    spacing: Config.largeMargin

                    readonly property var sections: [
                        {
                            name: "Best of Non-Fiction",
                            actionLabel: "View all",
                            model: listBooksEbook
                        },
                        {
                            name: "Newest Arrivals",
                            actionLabel: "View all",
                            model: listBooksEbook
                        },
                        {
                            name: "Bestsellers 2025",
                            actionLabel: "View all",
                            model: listBooksEbook
                        },
                        {
                            name: "Recommended for You",
                            actionLabel: "View all",
                            model: listBooksEbook
                        }
                    ]

                    Repeater {
                        model: ebooksColumn.sections

                        DiscoverPageSection {
                            width: ebooksColumn.width
                            spacing: Config.mediumMargin

                            name: modelData.name
                            actionLabel: modelData.actionLabel
                            model: modelData.model
                            booksSpacing: root.booksSpacing
                        }
                    }
                }

            }


            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                flickableDirection: Flickable.VerticalFlick

                contentWidth: width
                contentHeight: audioColumn.implicitHeight

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                Column {
                    id: audioColumn
                    width: parent.width - scrollBarPadding
                    spacing: Config.largeMargin

                    readonly property var sections: [
                        {
                            name: "Favorite Voice",
                            actionLabel: "View all",
                            model: listBooksAudio
                        },
                        {
                            name: "Top Narrators",
                            actionLabel: "View all",
                            model: listBooksAudio
                        },                        {
                            name: "Selected Books",
                            actionLabel: "View all",
                            model: listBooksAudio
                        }
                    ]

                    Repeater {
                        model: audioColumn.sections

                        DiscoverPageSection {
                            width: audioColumn.width
                            spacing: Config.mediumMargin

                            name: modelData.name
                            actionLabel: modelData.actionLabel
                            model: modelData.model
                            booksSpacing: root.booksSpacing
                        }
                    }
                }
            }


            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                flickableDirection: Flickable.VerticalFlick

                contentWidth: width
                contentHeight: onedriveColumn.implicitHeight

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                Column {
                    id: onedriveColumn
                    width: parent.width - scrollBarPadding
                    spacing: Config.largeMargin

                    readonly property var sections: [
                        {
                            name: "Award Winners",
                            actionLabel: "View all",
                            model: listBooksOneDrive
                        },
                        {
                            name: "Recently Synced",
                            actionLabel: "View all",
                            model: listBooksOneDrive
                        },
                        {
                            name: "Actively Read",
                            actionLabel: "View all",
                            model: listBooksOneDrive
                        },
                        {
                            name: "Rarely Read",
                            actionLabel: "View all",
                            model: listBooksOneDrive
                        }
                    ]

                    Repeater {
                        model: onedriveColumn.sections

                        DiscoverPageSection {
                            width: onedriveColumn.width
                            spacing: Config.mediumMargin

                            name: modelData.name
                            actionLabel: modelData.actionLabel
                            model: modelData.model
                            booksSpacing: root.booksSpacing
                        }
                    }
                }
            }

        }
    }
}
