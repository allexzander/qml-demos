import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "components"
import Config

Rectangle {
    id: root

    readonly property int chevronHeight: 30
    property int collapsedHeight: 60
    property int expandedHeight: Math.round(parent.height * 0.38)

    property bool expanded: false
    property real startHeight: collapsedHeight
    property real pressY: 0

    property alias brightness: slider.value

    readonly property real expandProgress: {
        const t = Math.max(
            0,
            Math.min(
                1,
                (height - collapsedHeight) / (expandedHeight - collapsedHeight)
            )
        )
        return Math.pow(t, 0.4)
    }


    width: parent ? parent.width : implicitWidth
    height: collapsedHeight

    color: expanded ? Config.popupBackgroundColor : "transparent"
    border.width: 0
    radius: 0

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

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.mediumMargin

        Item {
            id: header
            Layout.fillWidth: true
            height: root.collapsedHeight

            MouseArea {
                anchors.fill: parent

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

                onClicked: {
                    root.expanded ? root.collapse() : root.expand()
                }
            }

            Text {
                id: timeText
                anchors.left: parent.left
                anchors.leftMargin: Config.mediumMargin
                anchors.verticalCenter: parent.verticalCenter

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

            Row {
                visible: !root.expanded
                anchors.right: parent.right
                anchors.rightMargin: Config.mediumMargin
                anchors.verticalCenter: parent.verticalCenter
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
                        width: root.collapsedHeight * 0.4
                        height: width
                        source: modelData
                        sourceSize.width: width
                        sourceSize.height: height
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Config.mediumMargin
            spacing: Config.mediumMargin

            opacity: root.expandProgress
            visible: opacity > 0.0


            RowLayout {
                Layout.fillWidth: true
                spacing: Config.mediumMargin

                Image {
                    source: "assets/icon-wifi.svg"
                    width: 28
                    height: 28
                    sourceSize.width: width
                    sourceSize.height: height
                    smooth: true
                }

                Text {
                    text: "Wi-Fi"
                    font.pixelSize: Config.titleFontPixelSize
                    Layout.fillWidth: true
                }

                Switch { checked: true }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Config.smallSpacing

                Text {
                    text: "Brightness"
                    font.pixelSize: Config.titleFontPixelSize
                }

                Slider {
                    id: slider
                    from: 0.3
                    to: 1.0
                    value: 1.0
                    Layout.fillWidth: true

                    background: Rectangle {
                        id: background
                        height: 4
                        radius: 2
                        color: Config.deviderColor
                    }

                    handle: Rectangle {
                        width: 18
                        height: 18
                        radius: 9
                        color: Config.popupBackgroundColor
                        border.color: Config.titleFontColor
                        border.width: 1

                        y: background.y + background.height / 2 - height / 2
                        x: slider.leftPadding
                           + slider.visualPosition
                             * (slider.availableWidth - width)
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.mediumMargin

                Image {
                    source: "assets/icon-battery.svg"
                    width: 36
                    height: 36
                    sourceSize.width: width
                    sourceSize.height: height
                    smooth: true
                }

                Text {
                    text: "Battery"
                    font.pixelSize: Config.titleFontPixelSize
                    Layout.fillWidth: true
                }

                Text {
                    text: "100%"
                    font.pixelSize: Config.titleFontPixelSize
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: Config.popupBackgroundColor
                border.width: 1
                border.color: Config.titleFontColor

                RowLayout {
                    anchors.fill: parent
                    Layout.leftMargin: Config.mediumMargin
                    Layout.rightMargin: Config.mediumMargin
                    spacing: Config.smallMargin

                    Image {
                        Layout.leftMargin: Config.smallMargin
                        source: "assets/icon-search.svg"
                        width: 18
                        height: 18
                        sourceSize.width: width
                        sourceSize.height: height
                        smooth: true
                    }

                    TextField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("Search books…")
                        background: null
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Item {
        id: chevronOverlay
        width: parent.width
        height: chevronHeight

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            anchors.fill: parent

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

            onClicked: root.expanded ? root.collapse() : root.expand()
        }

        Image {
            id: chevronIcon
            anchors.centerIn: parent
            source: root.expanded
                    ? "assets/icon-chevronup.svg"
                    : "assets/icon-chevrondown.svg"
            width: parent.height * 0.7
            height: width
            sourceSize.width: width
            sourceSize.height: height
            smooth: true
        }
    }
}
