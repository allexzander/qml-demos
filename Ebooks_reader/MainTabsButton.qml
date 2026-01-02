import QtQuick
import QtQuick.Controls
import Config

TabButton {
    id: root

    property alias iconSource: icon.source
    property color activeColor: Config.titleFontColor
    property color inactiveColor: Config.descriptionFontColor

    implicitWidth: 100
    implicitHeight: Config.tabsHeight

    contentItem: Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        Image {
            id: icon
            width: parent.height * 0.4
            height: width
            sourceSize.width: width
            sourceSize.height: height

            fillMode: Image.PreserveAspectFit
            smooth: true
            opacity: root.checked ? 1.0 : 0.6
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: label
            text: root.text
            font.pixelSize: Config.tabsFontPixelSize
            color: root.checked ? root.activeColor : root.inactiveColor
            anchors.top: icon.bottom
            anchors.topMargin: Config.smallMargin
            anchors.horizontalCenter: icon.horizontalCenter
        }
    }

    background: Rectangle {
        color: "transparent"
    }
}
