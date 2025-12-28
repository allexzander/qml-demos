import QtQuick

Item {
    id: root

    required property ListView listView
    required property var model
    required property int index


    function timeAgo(timestampMs) {
        if (!timestampMs || timestampMs === 0)
            return ""

        const seconds = Math.floor((Date.now() - timestampMs) / 1000)

        if (seconds < 60)
            return "now"

        const minutes = Math.floor(seconds / 60)
        if (minutes < 60)
            return minutes + "m"

        const hours = Math.floor(minutes / 60)
        if (hours < 24)
            return hours + "h"

        const days = Math.floor(hours / 24)
        if (days < 7)
            return days + "d"

        const weeks = Math.floor(days / 7)
        if (weeks < 4)
            return weeks + "w"

        const months = Math.floor(days / 30)
        if (months < 12)
            return months + "mo"

        const years = Math.floor(days / 365)
        return years + "y"
    }


    width: listView.width
    implicitHeight: contactAvatar.implicitHeight

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        opacity: listView.currentIndex === index ? 0.08 : 0
        z: -1
    }

    TapHandler {
        onTapped: {
            listView.currentIndex = index
            ConversationsModel.currentConversationId = model.id
        }
    }

    UserAvatar {
        id: contactAvatar
        width: root.height * 0.6
        height: root.height * 0.6
        source: root.model.avatarUrls[root.model.avatarUrls.length - 1]
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    Column {
        id: contactChatInfo
        anchors.left: contactAvatar.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.model.title
            color: "#ffffff"
            font.pixelSize: root.height * 0.25
        }

        Item {
            id: contactInfoTexts
            width: parent.width
            implicitHeight: Math.max(messageText.implicitHeight, timeText.implicitHeight)
            property int maxMessageWidth: root.width * 0.6

            Text {
                id: messageText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(implicitWidth, contactInfoTexts.maxMessageWidth)

                text: root.model.lastMessage.text
                color: root.model.isRead ? "#525252" : "#ffffff"
                font.pixelSize: root.height * 0.2
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }

            Text {
                id: timeText
                anchors.left: messageText.right
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter

                text: "· " + root.timeAgo(root.model.lastMessage.timestampMs)
                color: "#525252"
                font.pixelSize: root.height * 0.2
            }
        }
    }

    Item {
        anchors.left: contactChatInfo.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 4
            source: "assets/icons/new-message-icon.svg"
            width: root.model.isRead ? 0 : root.height * 0.2
            height: root.model.isRead ? 0 : root.height * 0.2
            sourceSize.width: root.model.isRead ? 0 : root.height * 0.2
            sourceSize.height: root.model.isRead ? 0 : root.height * 0.2
            visible: width > 0
            smooth: true
        }
    }
}
