import QtQuick
import Config
import QtQuick.Layouts

Column {
    spacing: Config.mediumMargin

    property alias name: sectionName.text
    property alias actionLabel: action.text
    property alias model: listBooks.model
    property alias booksSpacing: listBooks.booksSpacing

    RowLayout {
        width: parent.width
        Text {
            id: sectionName
            font.pixelSize: Config.titleFontPixelSize
            color: Config.titleFontColor
        }
        Item { Layout.fillWidth: true }
        Text {
            id: action
            font.pixelSize: Config.titleFontPixelSize
            color: Config.descriptionFontColor
        }
    }

    ListBooks {
        id: listBooks
        width: parent.width
        spacing: booksSpacing
    }
}
