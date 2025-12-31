import QtQuick
import QtQuick.Effects

Item {
    id: root

    // ===== CONSTANTS =====
    readonly property int horizontalMargin: 24
    readonly property int columnSpacing: 16
    readonly property int booksCount: 4

    readonly property real coverAspectRatio: 1.55   // portrait
    readonly property int textBlockHeight: 36        // progress + remaining

    // Width per book
    readonly property real bookWidth:
        (width - horizontalMargin * 2
               - columnSpacing * (booksCount - 1))
        / booksCount

    readonly property real coverHeight:
        Math.min(
            bookWidth * coverAspectRatio,
            height - textBlockHeight
        )

    ListModel {
        id: lastReadBooks
        ListElement { progress: 2;  remaining: 18000; bookCoverSource: "assets/books/book1.jpg" }
        ListElement { progress: 21; remaining: 14400; bookCoverSource: "assets/books/book2.jpg" }
        ListElement { progress: 2;  remaining: 7200;  bookCoverSource: "assets/books/book3.jpg" }
        ListElement { progress: 3;  remaining: 14400; bookCoverSource: "assets/books/book4.jpg" }
    }

    Row {
        anchors {
            fill: parent
            leftMargin: horizontalMargin
            rightMargin: horizontalMargin
            topMargin: 12
        }
        spacing: columnSpacing

        Repeater {
            model: lastReadBooks

            Column {
                width: bookWidth
                spacing: 4

                Item {
                    width: parent.width
                    height: coverHeight

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

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("%1% Read").arg(progress)
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: "#000000"
                }

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("%1 HOURS TO GO")
                        .arg(Math.max(1, Math.ceil(remaining / 3600)))
                    font.pixelSize: 14
                    font.capitalization: Font.AllUppercase
                    color: "#777777"
                }
            }
        }
    }
}
