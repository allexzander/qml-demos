import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import Config

ColumnLayout {
    id: root

    Item {
        Layout.fillWidth: true
        height: Config.tabsHeight
        Text {
            text: qsTr("More")
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Config.titleFontPixelSize
            color: Config.titleFontColor
        }
    }

    Devider { Layout.fillWidth: true }

    ColumnLayout {
        id: menuColumn
        Layout.fillWidth: true

        Repeater {
            model: [
                { label: "My Wishlist", iconSource: "../assets/icon-heart.svg" },
                { label: "My Dropbox", iconSource: "../assets/icon-dropbox.svg" },
                { label: "My Articles", iconSource: "../assets/icon-shield.svg" },
                { label: "Activity", iconSource: "../assets/icon-chart.svg" },
                { label: "Beta Features", iconSource: "../assets/icon-beta.svg" },
                { label: "Settings", iconSource: "../assets/icon-settings.svg" },
                { label: "Help", iconSource: "../assets/icon-help.svg" }
            ]

            delegate: Item {
                Layout.fillWidth: true
                height: Config.textTabsHeight + Config.smallMargin + 1

                Item {
                    height: Config.textTabsHeight
                    width: parent.width

                    Image {
                        id: icon
                        width: parent.height * 0.6
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        source: modelData.iconSource
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Text {
                        anchors.left: icon.right
                        anchors.leftMargin: Config.mediumMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Config.descriptionFontPixelSize
                        color: Config.descriptionFontColor
                        text: modelData.label
                    }
                }

                Devider {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    Item { Layout.fillHeight: true } // optional spacer
}

