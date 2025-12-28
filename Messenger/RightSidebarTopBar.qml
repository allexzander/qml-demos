import QtQuick

Item {
    id: root
    implicitWidth: channelIcon.implicitWidth + contactChatInfo.implicitWidth + channelControls.implicitWidth
    implicitHeight: 80
    property alias name: channelName.text
    property alias iconUrl: channelIcon.source
    UserAvatar {
        id: channelIcon
        width: root.height * 0.6
        height: root.height * 0.6

        source: "assets/user_photos/user_photo_3.jpg"
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    Column {
        id: contactChatInfo
        anchors.left: channelIcon.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: channelName
            text: "Crew"
            color: "#ffffff"
            font.pixelSize: root.height * 0.2
        }

        Text {
            id: lastActiveText
            text: "Last active 2 hours ago"
            color: "#525252"
            font.pixelSize: root.height * 0.2
        }
    }

    Row {
        id: channelControls
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        Image {
            id: call
            width: root.height * 0.4
            height: root.height * 0.4
            source: "assets/icons/icon-call.svg"
            sourceSize.width: root.height * 0.4
            sourceSize.height: root.height * 0.4
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
        }

        Image {
            id: videocall
            width: root.height * 0.4
            height: root.height * 0.4
            source: "assets/icons/icon-videocall.svg"
            sourceSize.width: root.height * 0.4
            sourceSize.height: root.height * 0.4
            smooth: true
        }

        Image {
            id: menu
            width: root.height * 0.4
            height: root.height * 0.4
            source: "assets/icons/icon-menu.svg"
            sourceSize.width: root.height * 0.4
            sourceSize.height: root.height * 0.4
            smooth: true
        }
    }
}
