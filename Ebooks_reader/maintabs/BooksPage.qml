import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Config
import "../components"
import Ebooks_reader

Item {
    id: root

    readonly property int scrollBarPadding: Config.mediumMargin

    BooksProxyModel {
        id: booksFilteredModel
        sourceModel: BooksModel
    }

    ListModel {
        id: categoryChoices
        ListElement { text: "All";               value: -1 }
        ListElement { text: "Fantasy";           value: Book.Fantasy }
        ListElement { text: "Horror";            value: Book.Horror }
        ListElement { text: "Thriller";          value: Book.Thriller }
        ListElement { text: "Dystopian";         value: Book.Dystopian }
        ListElement { text: "Manga";             value: Book.Manga }
        ListElement { text: "Kids";              value: Book.Kids }
        ListElement { text: "Mystery";           value: Book.Mystery }
        ListElement { text: "Historical Fiction";value: Book.HistoricalFiction }
        ListElement { text: "Adventure";         value: Book.Adventure }
    }

    ListModel {
        id: sortChoices
        ListElement { text: "Recent"; value: BooksModel.Date }
        ListElement { text: "Older";  value: BooksModel.Date }   // same key, different order
        ListElement { text: "Title";  value: BooksModel.Title }
        ListElement { text: "Author"; value: BooksModel.Author }
    }

    readonly property real bookWidth: 60
    readonly property real bookHeight: bookWidth * Config.bookCoverAspect

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabs
            Layout.fillWidth: true
            Layout.preferredHeight: Config.textTabsHeight

            property var tabTitles: ["Books", "Authors", "Series", "Collections"]
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

            background: Devider {
                anchors.bottom: parent.bottom
                width: parent.width
            }

            Repeater {
                model: tabs.tabTitles
                TabsButton {
                    text: modelData
                    width: tabs.maxTabTextWidth + 20
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.smallMargin

            Text {
                text: qsTr("Sort:")
                font.pixelSize: Config.descriptionFontPixelSize
                color: Config.descriptionFontColor
                elide: Text.ElideRight
            }
            ReaderComboBox {
                id: filterCombo
                model: categoryChoices
                textRole: "text"
                valueRole: "value"
                currentIndex: 0
                Layout.preferredWidth: 140

                onActivated: {
                    booksFiltered.currentIndex = -1
                    if (currentValue === -1) {
                        booksFilteredModel.clearCategoryFilter()
                    } else {
                        booksFilteredModel.categoryFilter = currentValue
                    }
                }
            }

            Text {
                text: qsTr("Filter:")
                font.pixelSize: Config.descriptionFontPixelSize
                color: Config.descriptionFontColor
                elide: Text.ElideRight
            }
            ReaderComboBox {
                id: sortCombo
                model: sortChoices
                textRole: "text"
                valueRole: "value"
                currentIndex: 0

                Layout.preferredWidth: 140

                onActivated: {
                    booksFiltered.currentIndex = -1
                    if (currentText === "Older") {
                        booksFilteredModel.sortKey = currentValue
                        booksFilteredModel.sortOrder = Qt.AscendingOrder
                    } else if (currentText === "Recent") {
                        booksFilteredModel.sortKey = currentValue
                        booksFilteredModel.sortOrder = Qt.DescendingOrder
                    } else {
                        booksFilteredModel.sortKey = currentValue
                        booksFilteredModel.sortOrder = Qt.AscendingOrder
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "⋯"
                font.pixelSize: Config.titleFontPixelSize
                font.bold: true
                color: Config.titleFontColor
                Layout.alignment: Qt.AlignVCenter
            }
        }

        ListView {
            id: booksFiltered
            model: booksFilteredModel
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: -1

            readonly property int arrowArea: 14
            readonly property int trackPadding: 6

            ScrollBar.vertical: ScrollBarCustom {
                id: vScrollBar
                policy: ScrollBar.AsNeeded
                width: 12
            }

            delegate: BooksListElement {
                listView: booksFiltered
                width: booksFiltered.width - root.scrollBarPadding
                bookWidth: root.bookWidth
                bookHeight: root.bookHeight
            }
        }
    }
}
