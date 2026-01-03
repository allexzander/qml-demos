import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Config
import Ebooks_reader

Item {
    id: root

    required property ListView listView
    required property real bookWidth
    required property real bookHeight
    required property var model
    required property int index

    readonly property bool selected: ListView.isCurrentItem

    height: bookHeight + Config.largeMargin + devider.height

    Rectangle {
        anchors.fill: parent
        color: root.selected
               ? Config.listElementSelectedColor
               : Config.listElementColor
    }

    MouseArea {
        anchors.fill: parent
        onClicked: listView.currentIndex = index
    }

    RowLayout {
        id: contentRow
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        spacing: Config.smallMargin
        anchors.leftMargin: Config.smallMargin
        anchors.rightMargin: Config.smallMargin

        Image {
            id: bookCoverIcon

            Layout.preferredWidth: root.bookWidth
            Layout.preferredHeight: root.bookHeight
            Layout.alignment: Qt.AlignVCenter

            source: root.model.bookCoverSource
            fillMode: Image.PreserveAspectFit
            smooth: true

            layer.enabled: true
            layer.effect: MultiEffect {
                saturation: -1.0
            }
        }

        ColumnLayout {
            id: bookInfo
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false

            Text {
                text: root.model.title
                font.pixelSize: Config.titleFontPixelSize
                color: root.selected
                       ? Config.titleFontNegativeColor
                       : Config.titleFontColor
            }

            Text {
                visible: root.model.subtitle !== ""
                text: root.model.subtitle
                font.pixelSize: Config.descriptionFontPixelSize
                color: root.selected
                       ? Config.descriptionFontNegativeColor
                       : Config.descriptionFontColor
                Layout.maximumWidth: 80
                elide: Text.ElideRight
            }

            Text {
                visible: root.model.author !== ""
                text: root.model.author
                font.pixelSize: Config.descriptionFontPixelSize
                color: root.selected
                       ? Config.descriptionFontNegativeColor
                       : Config.descriptionFontColor
                Layout.maximumWidth: 80
                elide: Text.ElideRight
            }
        }

        ColumnLayout {
            id: bookMetadata
            spacing: 2

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
                maximumLineCount: 1

                text: qsTr("%1% Read")
                        .arg(Math.round(root.model.progress * 100))

                font.pixelSize: Config.descriptionFontPixelSize
                color: root.selected
                       ? Config.descriptionFontNegativeColor
                       : Config.descriptionFontColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.smallMargin

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    visible: root.model.locationString !== ""
                    text: root.model.locationString
                    font.pixelSize: Config.descriptionFontPixelSize
                    font.capitalization: Font.AllUppercase
                    color: root.selected
                           ? Config.descriptionFontNegativeColor
                           : Config.descriptionFontColor
                    elide: Text.ElideRight
                }

                Text {
                    text: "·"
                    font.pixelSize: Config.descriptionFontPixelSize
                    color: root.selected
                           ? Config.descriptionFontNegativeColor
                           : Config.descriptionFontColor
                }

                Text {
                    text: Config.formatSize(root.model.size)
                    font.pixelSize: Config.descriptionFontPixelSize
                    color: root.selected
                           ? Config.descriptionFontNegativeColor
                           : Config.descriptionFontColor
                    elide: Text.ElideRight
                }
            }

            Text {
                Layout.alignment: Qt.AlignRight

                text: "..."
                font.pixelSize: Config.titleFontPixelSize * 1.5
                font.bold: true
                color: root.selected
                       ? Config.descriptionFontNegativeColor
                       : Config.descriptionFontColor
            }
        }
    }

    Devider {
        id: devider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
