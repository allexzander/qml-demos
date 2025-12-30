import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    minimumWidth: 900
    minimumHeight: 1200
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight
    visible: true
    title: qsTr("E-books reader")

    Column {
        anchors.fill: parent
        anchors.topMargin: controlCenter.collapsedHeight

        Item {
            width: parent.width
            height: parent.height - tabs.height

            MouseArea {
                anchors.fill: parent
                onClicked: controlCenter.collapse()
            }

        StackLayout {
            anchors.fill: parent
            currentIndex: tabs.currentIndex

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Text {
                    anchors.centerIn: parent
                    text: "Home"
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Text {
                    anchors.centerIn: parent
                    text: "My Books"
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Text {
                    anchors.centerIn: parent
                    text: "Discover"
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Text {
                    anchors.centerIn: parent
                    text: "More"
                }
            }
        }
        }

        TabBar {
            id: tabs
            width: parent.width

            background: Item {
                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: "#777777"
                }
            }

            Repeater {
                model: [
                    { label: "Home",     iconSource: "assets/icon-home.svg" },
                    { label: "My Books", iconSource: "assets/icon-books.svg" },
                    { label: "Discover", iconSource: "assets/icon-discover.svg" },
                    { label: "More",     iconSource: "assets/icon-more.svg" }
                ]

                IconTabButton {
                    text: modelData.label
                    iconSource: modelData.iconSource
                    onPressed: controlCenter.collapse()
                }
            }
        }
    }

    ControlCenter {
        id: controlCenter
        x: 0
        y: 0
        width:root.width
        collapsedHeight: 80
        expandedHeight: Math.round(root.height * 0.75)
        z: 1000
    }
}
