import QtQuick 2.0

import QtQuick 2.15
import QtQuick.Controls 2.15

AbstractButton {
    id: root
    leftPadding: 10
    rightPadding: 10
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: 30

    font.pixelSize: 10

    property color color: "#ffffff"

    contentItem: Item {
        anchors.fill: parent
        implicitWidth: icon.implicitWidth + label.implicitWidth + root.leftPadding + root.rightPadding
        implicitHeight: contentItemContainer.implicitHeight
        Item {
            id: contentItemContainer
            readonly property int spacing: 5
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            implicitWidth: icon.implicitWidth + label.implicitWidth + spacing
            implicitHeight: Math.max(icon.implicitHeight, label.implicitHeight)
            Image {
                id: icon
                source: root.icon.source
                sourceSize.width: 24
                sourceSize.height: 24
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: label
                font.pixelSize: root.font.pixelSize
                color: root.color
                text: root.text
                anchors.left: icon.right
                anchors.leftMargin: parent.spacing
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            border.color: "red"
            border.width: 1
            color: "transparent"
        }
    }
    background: Rectangle {
        color: "#5ca946"
        radius: 5
        anchors.fill: parent
        opacity: hovered ? 1.0 : 0.5
    }
}
