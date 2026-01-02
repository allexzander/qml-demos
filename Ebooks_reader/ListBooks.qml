import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Config

Row {
    id: root

    property int booksSpacing: Config.mediumMargin
    property int lastReadBooksDisplayCount: Config.lastReadBooksDisplayCount

    property real bookAspectRatio: Config.bookCoverAspect

    property real totalSpacing: booksSpacing * (lastReadBooksDisplayCount - 1)
    property real totalBooksWidth: width - totalSpacing

    // calc single book dimensions
    property real bookWidth: totalBooksWidth / lastReadBooksDisplayCount
    property real bookHeight: bookWidth * bookAspectRatio


    property bool showProgress: false

    property alias model: list.model

    spacing: booksSpacing

    Repeater {
        id: list

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
                visible: root.showProgress
            }

            Text {
                visible: root.showProgress
                width: parent.width
                horizontalAlignment: Text.AlignLeft
                text: qsTr("%1% Read").arg(progress)
                font.pixelSize: Config.titleFontPixelSize
                color: "#000000"
            }

            Text {
                visible: root.showProgress
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
