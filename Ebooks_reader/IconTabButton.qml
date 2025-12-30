import QtQuick
import QtQuick.Controls

TabButton {
    id: root

    property alias iconSource: icon.source
    property color activeColor: "#000000"
    property color inactiveColor: "#777777"

    implicitWidth: 108
    implicitHeight: 64

    contentItem: Item {
        anchors.centerIn: parent

        Image {
            id: icon
            width: 24
            height: 24
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
            font.pixelSize: 12
            color: root.checked ? root.activeColor : root.inactiveColor
            anchors.top: icon.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: icon.horizontalCenter
        }
    }

    background: Rectangle {
        color: "transparent"
    }
}
