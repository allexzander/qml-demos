import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Config
import Messenger

Item {
    id: root

    property alias text: messageInput.text
    signal messageSent()

    implicitHeight: 30

    Connections {
        target: ConversationsModel

        function onCurrentConversationIdChanged() {
            if (!messageInput.readOnly && !messageInput.activeFocus) {
                messageInput.focus = true
            }
        }
    }

    Image {
        id: iconAttachment
        source: Config.assetsBase + "/icons/icon-plus.svg"
        sourceSize.width: messageInput.height * 0.8
        sourceSize.height: messageInput.height * 0.8
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: inputContainer.verticalCenter
        fillMode: Image.PreserveAspectFit
        opacity: 0.7
        smooth: true
    }

    Rectangle {
        id: inputContainer
        radius: 10
        color: "#1a1424"
        border.color: "#2c2440"
        border.width: 1

        anchors.left: iconAttachment.right
        anchors.leftMargin: 10
        anchors.right: iconLike.left
        anchors.rightMargin: 10
        height: messageInput.implicitHeight

        TextField {
            id: messageInput
            Layout.fillWidth: true
            placeholderText: "Aa"
            background: null
            color: "#ffffff"
            placeholderTextColor: "#525252"
            font.pixelSize: root.height * 0.4
            anchors.left: parent.left
            anchors.right: iconSticker.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            readOnly: ConversationsModel.currentConversationId === ""
            enabled: ConversationsModel.currentConversationId !== ""
            onAccepted: {
                if (ConversationsModel.currentConversation) {
                    ConversationsModel.sendMessage(messageInput.text)
                    messageInput.text = ""
                    root.messageSent()
                }
            }
            onReadOnlyChanged: {
                messageInput.focus = !readOnly
            }
        }

        Image {
            id: iconSticker
            source: Config.assetsBase + "/icons/icon-sticker.svg"
            sourceSize.width: messageInput.height * 0.8
            sourceSize.height: messageInput.height * 0.8
            anchors.right: iconEmoji.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            opacity: 0.7
            smooth: true
        }

        Image {
            id: iconEmoji
            source: Config.assetsBase + "/icons/icon-smile.svg"
            sourceSize.width: messageInput.height * 0.8
            sourceSize.height: messageInput.height * 0.8
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            opacity: 0.7
            smooth: true
        }
    }

    Image {
        id: iconLike
        source: Config.assetsBase + "/icons/icon-like.svg"
        sourceSize.width: messageInput.height * 0.8
        sourceSize.height: messageInput.height * 0.8
        anchors.right: parent.right
        anchors.verticalCenter: inputContainer.verticalCenter
        anchors.rightMargin: 10
        fillMode: Image.PreserveAspectFit
        opacity: 0.7
        smooth: true
    }
}
