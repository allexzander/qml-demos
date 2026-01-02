import QtQuick
import Config

Item {
    id: root

    property string title: ""
    property string subtitle: ""

    // layout tuning
    property int maxWidth: 260

    readonly property int maxWidthText: maxWidth * 0.8

    width: maxWidth
    implicitHeight: content.implicitHeight

    Column {
        id: content
        width: parent.width
        spacing: 6

        Rectangle {
            visible: true
            width: parent.width
            height: 1
            color: Config.deviderColor
        }

        Text {
            text: root.title
            width: root.maxWidthText

            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideNone

            font.pixelSize: Config.titleFontPixelSize
            color: Config.titleFontColor
        }

        Text {
            text: root.subtitle
            width: root.maxWidthText
            font.pixelSize: Config.descriptionFontPixelSize
            font.capitalization: Font.AllUppercase
            color: Config.descriptionFontColor
        }
    }
}
