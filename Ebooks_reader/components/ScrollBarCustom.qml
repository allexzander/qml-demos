import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Config

ScrollBar {
    id: root

    policy: ScrollBar.AsNeeded
    implicitWidth: 12

    topPadding: upArrow.height + Config.mediumMargin
    bottomPadding: downArrow.height + Config.mediumMargin

    readonly property bool atTop: root.position <= 0
    readonly property bool atBottom: root.position + root.size >= 1

    background: Item {
        anchors.fill: parent

        Text {
            id: upArrow
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: "▲"
            font.pixelSize: Config.descriptionFontPixelSize
            color: Config.descriptionFontColor

            opacity: root.atTop ? 0.5 : 1.0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        Text {
            id: downArrow
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            text: "▼"
            font.pixelSize: Config.descriptionFontPixelSize
            color: Config.descriptionFontColor

            opacity: root.atBottom ? 0.5 : 1.0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            id: trackLine
            width: 2
            radius: 1
            color: Config.descriptionFontColor

            anchors {
                top: upArrow.bottom
                bottom: downArrow.top
                topMargin: Config.mediumMargin
                bottomMargin: Config.mediumMargin
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    contentItem: Rectangle {
        radius: 2

        color: Config.scrollBarHandleColor
        border.color: Config.titleFontColor
        border.width: 1

        implicitWidth: 6
        implicitHeight: Math.max(trackLine.height * 0.35, 24)
    }
}
