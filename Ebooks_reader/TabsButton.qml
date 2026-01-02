import QtQuick
import QtQuick.Controls
import Config

TabButton {
    id: root

    property color activeColor: Config.titleFontColor
    property color inactiveColor: Config.descriptionFontColor

    implicitHeight: Config.textTabsHeight

    contentItem: Item {
        anchors.fill: parent

        Text {
            id: label
            text: root.text
            font.pixelSize: Config.tabsFontPixelSize
            color: root.checked ? root.activeColor : root.inactiveColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Config.smallMargin
        }

        Rectangle {
            visible: root.checked
            height: 2
            color: Config.titleFontColor

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    background: Item {}
}

