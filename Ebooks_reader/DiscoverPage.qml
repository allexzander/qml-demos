import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Config
import Ebooks_reader

Item {
    id: root

    readonly property int booksSpacing: Config.mediumMargin
    readonly property int lastReadBooksDisplayCount: Config.lastReadBooksDisplayCount
    readonly property real bookAspectRatio: Config.bookCoverAspect
    readonly property int scrollBarPadding: Config.mediumMargin
    readonly property int scrollBarWidth: 12

    readonly property real totalSpacing:
        booksSpacing * (lastReadBooksDisplayCount - 1)

    readonly property real totalBooksWidth:
        width - totalSpacing - scrollBarPadding

    readonly property real bookWidth:
        totalBooksWidth / lastReadBooksDisplayCount

    readonly property real bookHeight:
        bookWidth * bookAspectRatio

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

            background: Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Config.deviderColor
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

                ScrollBar.vertical: ScrollBarCustom {
                    id: vScrollBar
                    policy: ScrollBar.AsNeeded
                    width: root.scrollBarWidth
                }

                Column {
                    id: ebooksColumn
                    width: parent.width - scrollBarPadding
                    spacing: Config.largeMargin

                    readonly property var sections: [
                        { name: "Best of Non-Fiction",    offset: 0  },
                        { name: "Newest Arrivals",       offset: 4  },
                        { name: "Bestsellers 2025",      offset: 12  },
                        { name: "Recommended for You",  offset: 8 }
                    ]

                    Repeater {
                        model: ebooksColumn.sections

                        DiscoverPageSection {
                            width: ebooksColumn.width
                            spacing: Config.mediumMargin
                            booksSpacing: root.booksSpacing

                            name: modelData.name
                            actionLabel: "View all"

                            model: BooksProxyModel {
                                sourceModel: BooksModel
                                limit: 4
                                offset: modelData.offset
                            }
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

                ScrollBar.vertical: ScrollBarCustom {
                    policy: ScrollBar.AsNeeded
                    width: root.scrollBarWidth
                }

                Column {
                    id: audioColumn
                    width: parent.width - scrollBarPadding
                    spacing: Config.largeMargin

                    readonly property var sections: [
                        { name: "Favorite Voice",  offset: 4 },
                        { name: "Top Narrators",   offset: 8 },
                        { name: "Selected Books", offset: 12 }
                    ]

                    Repeater {
                        model: audioColumn.sections

                        DiscoverPageSection {
                            width: audioColumn.width
                            spacing: Config.mediumMargin
                            booksSpacing: root.booksSpacing

                            name: modelData.name
                            actionLabel: "View all"

                            model: BooksProxyModel {
                                sourceModel: BooksModel
                                limit: 4
                                offset: modelData.offset
                            }
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

                ScrollBar.vertical: ScrollBarCustom {
                    policy: ScrollBar.AsNeeded
                    width: root.scrollBarWidth
                }

                Column {
                    id: onedriveColumn
                    width: parent.width - scrollBarPadding
                    spacing: Config.largeMargin

                    readonly property var sections: [
                        { name: "Award Winners",   offset: 3  },
                        { name: "Recently Synced", offset: 10  },
                        { name: "Actively Read",   offset: 14  },
                        { name: "Rarely Read",     offset: 0 }
                    ]

                    Repeater {
                        model: onedriveColumn.sections

                        DiscoverPageSection {
                            width: onedriveColumn.width
                            spacing: Config.mediumMargin
                            booksSpacing: root.booksSpacing

                            name: modelData.name
                            actionLabel: "View all"

                            model: BooksProxyModel {
                                sourceModel: BooksModel
                                limit: 4
                                offset: modelData.offset
                            }
                        }
                    }
                }
            }
        }
    }
}
