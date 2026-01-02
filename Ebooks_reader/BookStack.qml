import QtQuick
import QtQuick.Effects
import Config

Item {
    id: root

    property alias model: repeater.model
    property string title: ""
    property string subtitle: ""

    property int maxBooks: 3
    property real bookWidth: 120
    property real aspectRatio: 1.55

    property real xOffsetStep: 100
    property real yOffsetStep: bookHeight * 0.1

    readonly property real bookHeight: bookWidth * aspectRatio

    width: bookWidth + xOffsetStep * (maxBooks - 1)
    implicitHeight: stack.height + labels.implicitHeight

    Item {
        id: stack
        width: parent.width
        height: bookHeight

        Repeater {
            id: repeater

            delegate: Item {
                required property string bookCoverSource
                required property int index

                visible: index < root.maxBooks

                width: root.bookWidth
                height: root.bookHeight - index * root.yOffsetStep

                x: index * root.xOffsetStep
                y: index * root.yOffsetStep
                z: root.maxBooks - index   // leftmost on top

                Image {
                    id: cover
                    anchors.fill: parent
                    source: bookCoverSource
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    visible: false
                }

                MultiEffect {
                    anchors.fill: cover
                    source: cover
                    saturation: -1.0
                }
            }
        }
    }

    Column {
        id: labels
        anchors {
            top: stack.bottom
            topMargin: 8
            left: stack.left
        }
        spacing: 2

        Text {
            text: root.title
            font.pixelSize: Config.titleFontPixelSize
            font.weight: Font.Medium
            color: "#000000"
        }

        Text {
            text: root.subtitle
            font.pixelSize: Config.descriptionFontPixelSize
            color: "#777777"
            font.capitalization: Font.AllUppercase
        }
    }
}
