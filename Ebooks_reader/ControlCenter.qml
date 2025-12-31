import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property int collapsedHeight: 100
    property int expandedHeight: Math.round((parent?.height || 1200) * 0.75)
    property int headerHeight: 56

    property bool expanded: false
    property real startHeight: collapsedHeight
    property real pressY: 0

    width: parent ? parent.width : implicitWidth
    height: collapsedHeight

    color: "transparent"
    border.color: expanded ? "#777777" : "transparent"
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
            height: root.headerHeight
            width: parent.width

            Text {
                id: timeText
                anchors {
                    left: parent.left
                    leftMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                text: Qt.formatTime(new Date(), "hh:mm AP")
                font.pixelSize: 16
                color: "#000000"
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
                    rightMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                spacing: 14

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
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: parent.height - root.headerHeight
        }
    }
}
