import QtQuick
import QtQuick.Controls
import Config

Rectangle {
    id: root

    property int collapsedHeight: 100
    property int expandedHeight: Math.round(root.height * 0.75)

    property bool expanded: false
    property real startHeight: collapsedHeight
    property real pressY: 0

    width: parent ? parent.width : implicitWidth
    height: collapsedHeight

    color: "transparent"
    border.color: expanded ? Config.titleFontColor : "transparent"
    border.width: expanded ? 1 : 0

    function expand() {
        expanded = true
        height = expandedHeight
    }

    function collapse() {
        expanded = false
        height = collapsedHeight
    }

    Behavior on height {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        anchors.fill: parent
        drag.target: null

        onPressed: {
            pressY = mouseY
            startHeight = root.height
        }

        onPositionChanged: {
            if (!pressed)
                return

            const delta = mouseY - pressY
            root.height = Math.max(
                root.collapsedHeight,
                Math.min(root.expandedHeight, startHeight + delta)
            )
        }

        onReleased: {
            const midpoint =
                (root.collapsedHeight + root.expandedHeight) / 2

            root.height >= midpoint ? root.expand() : root.collapse()
        }
    }

    Column {
        anchors.fill: parent
        spacing: 0

        Item {
            height: root.collapsedHeight * 0.6
            width: parent.width

            Text {
                id: timeText
                anchors {
                    left: parent.left
                    leftMargin: Config.mediumMargin
                    verticalCenter: parent.verticalCenter
                }
                text: Qt.formatTime(new Date(), "hh:mm AP")
                font.pixelSize: Config.infoFontPixelSize
                color: Config.titleFontColor
            }

            Timer {
                interval: 60 * 1000
                running: true
                repeat: true
                onTriggered:
                    timeText.text = Qt.formatTime(new Date(), "hh:mm AP")
            }

            // Icons
            Row {
                anchors {
                    right: parent.right
                    rightMargin: Config.mediumMargin
                    verticalCenter: parent.verticalCenter
                }
                spacing: Config.smallSpacing

                Repeater {
                    model: [
                        "assets/icon-brightness.svg",
                        "assets/icon-wifi.svg",
                        "assets/icon-battery.svg",
                        "assets/icon-refresh.svg",
                        "assets/icon-search.svg"
                    ]

                    Image {
                        source: modelData
                        sourceSize.width: width
                        sourceSize.height: height
                        width: root.collapsedHeight * 0.3
                        height: root.collapsedHeight * 0.3
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }
            }
        }
    }
}
