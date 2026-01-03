import QtQuick
import QtQuick.Effects
import Config

Item {
    id: root

    property alias model: repeater.model
    property alias title: title.text
    property alias subtitle: subtitle.text
    property alias count: repeater.count
    property int maxBooks: 3
    property real bookWidth: 120
    property real bookHeight: bookWidth * aspectRatio
    property real aspectRatio: Config.bookCoverAspect
    property real xOffsetStep: Config.bookStackHorizontalOffsetStep
    property real yOffsetStep: bookHeight * 0.1

    width: bookWidth + xOffsetStep * (maxBooks - 1)
    implicitHeight: bookHeight + labels.implicitHeight


    Item {
        id: stack
        width: parent.width
        height: bookHeight

        Repeater {
            id: repeater

            delegate: Item {
                width: root.bookWidth
                height: root.bookHeight - index * root.yOffsetStep

                x: index * root.xOffsetStep
                y: index * root.yOffsetStep
                z: root.maxBooks - index

                Image {
                    id: cover
                    anchors.fill: parent
                    source: bookCoverSource
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        saturation: -1.0
                    }
                }
            }
        }
    }

    Column {
        id: labels
        anchors {
            top: stack.bottom
            topMargin: Config.smallMargin
            left: stack.left
        }
        spacing: Config.tinySpacing

        Text {
            id: title
            text: root.title
            font.pixelSize: Config.titleFontPixelSize
            font.weight: Font.Medium
            color: Config.titleFontColor
        }

        Text {
            id: subtitle
            text: root.subtitle
            font.pixelSize: Config.descriptionFontPixelSize
            color: Config.descriptionFontColor
            font.capitalization: Font.AllUppercase
        }
    }
}
