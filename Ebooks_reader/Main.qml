import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "maintabs"
import Config

Window {
    id: root
    minimumWidth: Config.appWindowWidth
    minimumHeight: Config.appWindowHeight
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight
    visible: true
    title: qsTr("E-books reader")

    Column {
        opacity: controlCenter.brightness
        anchors.fill: parent
        anchors.topMargin: controlCenter.collapsedHeight + Config.contentTopMargin

        Item {
            id: mainContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Config.mainContentHorizontalMargin
            anchors.rightMargin: Config.mainContentHorizontalMargin
            height: parent.height - tabs.height

            MouseArea {
                anchors.fill: parent
                onClicked: controlCenter.collapse()
            }

            StackLayout {
                anchors.fill: parent
                currentIndex: tabs.currentIndex

                HomePage {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                BooksPage {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                DiscoverPage {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                MorePage {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        TabBar {
            id: tabs
            width: parent.width
            height: Config.tabsHeight

            background: Item {
                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: Config.tabsHeight
                    color: "#ffffff"
                }
            }

            spacing: 0

            Repeater {
                model: [
                    { label: "Home",     iconSource: "../assets/icon-home.svg" },
                    { label: "My Books", iconSource: "../assets/icon-books.svg" },
                    { label: "Discover", iconSource: "../assets/icon-discover.svg" },
                    { label: "More",     iconSource: "../assets/icon-more.svg" }
                ]

                MainTabsButton {
                    text: modelData.label
                    width:  tabs.width / tabs.count
                    iconSource: modelData.iconSource
                    onPressed: controlCenter.collapse()
                }
            }
        }
    }

    Rectangle {
        id: overlay
        x: 0
        y: 0
        z: 999
        width: parent.width
        height: parent.height
        opacity: visible ? 0.5 : 0.0
        color: Config.descriptionFontColor
        visible: controlCenter.expanded

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                controlCenter.collapse()
            }
        }
    }

    ControlCenter {
        id: controlCenter
        x: 0
        y: 0
        width:root.width
        z: 1000
    }
}
