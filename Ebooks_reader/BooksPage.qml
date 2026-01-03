import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Config
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

    function formatSize(bytes) {
        if (bytes === undefined || bytes <= 0)
            return ""

        const kb = 1024
        const mb = kb * 1024
        const gb = mb * 1024

        if (bytes >= gb)
            return (bytes / gb).toFixed(1) + " GB"
        if (bytes >= mb)
            return (bytes / mb).toFixed(1) + " MB"
        if (bytes >= kb)
            return Math.round(bytes / kb) + " KB"

        return bytes + " B"
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

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.mediumMargin
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

            readonly property int arrowArea: 14
            readonly property int trackPadding: 6

            ScrollBar.vertical: ScrollBarCustom {
                id: vScrollBar
                policy: ScrollBar.AsNeeded
                width: 12
            }

            delegate: Item {
                property ListView listView: booksFiltered
                id: row
                width: listView.width - root.scrollBarPadding
                height: bookHeight + Config.largeMargin + devider.height

                readonly property bool selected: ListView.isCurrentItem

                Rectangle {
                    anchors.fill: parent
                    color: row.selected ? Config.listElementSelectedColor : Config.listElementColor
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: listView.currentIndex = index
                }


                Image {
                    id: bookCoverIcon
                    anchors.left: parent.left
                    anchors.leftMargin: Config.smallMargin
                    anchors.verticalCenter: parent.verticalCenter

                    width: root.bookWidth
                    height: root.bookHeight
                    source: bookCoverSource
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        saturation: -1.0
                    }
                }
                Column {
                    id: bookInfo
                    anchors.left: bookCoverIcon.right
                    anchors.leftMargin: Config.smallMargin
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: model.title
                        font.pixelSize: Config.titleFontPixelSize
                        color: row.selected ? Config.titleFontNegativeColor : Config.titleFontColor
                    }
                    Text {
                        visible: model.subtitle !== ""
                        text: model.subtitle
                        width: 80
                        font.pixelSize: Config.descriptionFontPixelSize
                        color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor
                    }
                    Text {
                        visible: model.author !== ""
                        text: model.author
                        width: 80
                        font.pixelSize: Config.descriptionFontPixelSize
                        color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor
                    }
                }
                Column {
                    id: bookMetadata
                    spacing: 2

                    anchors.right: parent.right
                    anchors.left: bookInfo.right
                    anchors.rightMargin: Config.smallMargin
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideRight
                        maximumLineCount: 1

                        text: qsTr("%1% Read").arg(Math.round(model.progress * 100))
                        font.pixelSize: Config.descriptionFontPixelSize
                        color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor
                    }

                    Item {
                        id: metaLine
                        width: parent.width
                        height: Math.max(locationText.implicitHeight, sizeText.implicitHeight)

                        Text {
                            id: locationText
                            anchors.right: dotText.left
                            anchors.rightMargin: Config.smallMargin
                            anchors.verticalCenter: parent.verticalCenter

                            visible: model.locationString !== ""
                            text: model.locationString
                            font.pixelSize: Config.descriptionFontPixelSize
                            font.capitalization: Font.AllUppercase
                            color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor

                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        Text {
                            id: dotText
                            anchors.right: sizeText.left
                            anchors.rightMargin: Config.smallMargin
                            anchors.verticalCenter: parent.verticalCenter

                            text: "·"
                            font.pixelSize: Config.descriptionFontPixelSize
                            color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor
                        }

                        Text {
                            id: sizeText
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            text: root.formatSize(model.size)
                            font.pixelSize: Config.descriptionFontPixelSize
                            color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor

                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }
                    }

                    Text {
                        id: dotMenu
                        anchors.right: parent.right

                        text: "..."
                        font.pixelSize: Config.titleFontPixelSize * 1.5
                        font.bold: true
                        color: row.selected ? Config.descriptionFontNegativeColor : Config.descriptionFontColor
                    }
                }
                Rectangle {
                    id: devider
                    visible: true
                    width: parent.width
                    height: 1
                    color: Config.deviderColor
                }
            }
        }
    }
}
