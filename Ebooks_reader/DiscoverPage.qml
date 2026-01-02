import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Config

Column {
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
        id: listBooksOneDrive
        ListElement { progress: 2;  remaining: 18000; bookCoverSource: "assets/books/book1.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book2.jpg" }
        ListElement { progress: 2;  remaining: 7200;  bookCoverSource: "assets/books/book3.jpg" }
        ListElement { progress: 3;  remaining: 14400; bookCoverSource: "assets/books/book4.jpg" }
    }
    ListModel {
        id: listBooksEbook
        ListElement { progress: 2;  remaining: 18000; bookCoverSource: "assets/books/book5.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book6.jpg" }
        ListElement { progress: 2;  remaining: 7200;  bookCoverSource: "assets/books/book8.jpg" }
        ListElement { progress: 3;  remaining: 14400; bookCoverSource: "assets/books/book9.jpg" }
    }
    ListModel {
        id: listBooksAudio
        ListElement { progress: 2;  remaining: 18000; bookCoverSource: "assets/books/book10.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book2.jpg" }
        ListElement { progress: 2;  remaining: 7200;  bookCoverSource: "assets/books/book1.jpg" }
        ListElement { progress: 3;  remaining: 14400; bookCoverSource: "assets/books/book7.jpg" }
    }

    TabBar {
        id: tabs
        width: parent.width
        height: Config.textTabsHeight

        property var tabTitles: ["eBooks", "AudioBooks", "OneDrive"]
        property real maxTabTextWidth: 0

        TextMetrics {
            id: metrics
            font.pixelSize: Config.tabsFontPixelSize
        }

        function recomputeMaxWidth() {
            let max = 0
            for (let i = 0; i < tabTitles.length; ++i) {
                metrics.text = tabTitles[i]
                max = Math.max(max, metrics.width)
            }
            maxTabTextWidth = max
        }

        Component.onCompleted: recomputeMaxWidth()

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
                width: tabs.maxTabTextWidth + 20   // 10px left + right
            }
        }
    }

    Item {
        width: parent.width
        height: 20
    }

    StackLayout {
        currentIndex: tabs.currentIndex

        Row {
            id: ebooks
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: booksSpacing

            readonly property bool showProgress: false

            Repeater {
                model: listBooksEbook

                Column {
                    width: bookWidth
                    spacing: 4

                    Item {
                        width: parent.width
                        height: bookHeight

                        Image {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            width: parent.width
                            height: parent.height
                            source: bookCoverSource
                            fillMode: Image.PreserveAspectFit
                            smooth: true

                            layer.enabled: true
                            layer.effect: MultiEffect {
                                saturation: -1.0
                            }

                        }
                    }

                    Item {
                        width: parent.width
                        height: 10
                        visible: ebooks.showProgress
                    }

                    Text {
                        visible: ebooks.showProgress
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("%1% Read").arg(progress)
                        font.pixelSize: Config.titleFontPixelSize
                        color: "#000000"
                    }

                    Text {
                        visible: ebooks.showProgress
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("%1 HOURS TO GO")
                            .arg(Math.max(1, Math.ceil(remaining / 3600)))
                        font.pixelSize: Config.descriptionFontPixelSize
                        font.capitalization: Font.AllUppercase
                        color: "#777777"
                    }
                }
            }
        }
        Row {
            id: audiobooks
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: booksSpacing

            readonly property bool showProgress: false

            Repeater {
                model: listBooksAudio

                Column {
                    width: bookWidth
                    spacing: 4

                    Item {
                        width: parent.width
                        height: bookHeight

                        Image {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            width: parent.width
                            height: parent.height
                            source: bookCoverSource
                            fillMode: Image.PreserveAspectFit
                            smooth: true

                            layer.enabled: true
                            layer.effect: MultiEffect {
                                saturation: -1.0
                            }

                        }
                    }

                    Item {
                        visible: audiobooks.showProgress
                        width: parent.width
                        height: 10
                    }

                    Text {
                        visible: audiobooks.showProgress
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("%1% Read").arg(progress)
                        font.pixelSize: Config.titleFontPixelSize
                        color: "#000000"
                    }

                    Text {
                        visible: audiobooks.showProgress
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("%1 HOURS TO GO")
                            .arg(Math.max(1, Math.ceil(remaining / 3600)))
                        font.pixelSize: Config.descriptionFontPixelSize
                        font.capitalization: Font.AllUppercase
                        color: "#777777"
                    }
                }
            }
        }
        Row {
            id: booksOneDrive
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: booksSpacing

            readonly property bool showProgress: false

            Repeater {
                model: listBooksOneDrive

                Column {
                    width: bookWidth
                    spacing: 4

                    Item {
                        width: parent.width
                        height: bookHeight

                        Image {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            width: parent.width
                            height: parent.height
                            source: bookCoverSource
                            fillMode: Image.PreserveAspectFit
                            smooth: true

                            layer.enabled: true
                            layer.effect: MultiEffect {
                                saturation: -1.0
                            }

                        }
                    }

                    Item {
                        visible: booksOneDrive.showProgress
                        width: parent.width
                        height: 10
                    }

                    Text {
                        visible: booksOneDrive.showProgress
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("%1% Read").arg(progress)
                        font.pixelSize: Config.titleFontPixelSize
                        color: "#000000"
                    }

                    Text {
                        visible: booksOneDrive.showProgress
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("%1 HOURS TO GO")
                            .arg(Math.max(1, Math.ceil(remaining / 3600)))
                        font.pixelSize: Config.descriptionFontPixelSize
                        font.capitalization: Font.AllUppercase
                        color: "#777777"
                    }
                }
            }
        }
    }
}
