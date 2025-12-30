import QtQuick
import QtQuick.Layouts
import Config
import Messenger

Rectangle {
    id: root

    function checkReadState() {
        if (chatRoomMessages.atYEnd ||
            chatRoomMessages.contentHeight <= chatRoomMessages.height) {
            ConversationsModel.markCurrentConversationRead()
        }
    }

    Connections {
        target: ConversationsModel

        function onMessagesModelChanged() {
            Qt.callLater(checkReadState)
        }
    }

    Connections {
        target: ConversationsModel.messagesModel

        function onRowsInserted(parent, first, last) {
            Qt.callLater(() => chatRoomMessages.positionViewAtEnd())
        }
    }

    ColumnLayout {
        anchors.fill: parent
        ConversationDetails {
            id: conversationDtails
            name: ConversationsModel.currentConversation.name || qsTr("Select conversation")
            lastActive:
                ConversationsModel.messagesModel &&
                ConversationsModel.messagesModel.rowCount() > 0
                    ? "Last active " + Config.timeAgo(
                          ConversationsModel.messagesModel.data(
                                                  ConversationsModel.messagesModel.index(
                                                      ConversationsModel.messagesModel.rowCount() - 1,
                                                      0
                                                  ),
                                                  MessagesModel.TimestampRole
                                              ),
                          true
                      )
                    : ""
            iconUrl: ConversationsModel.currentConversationAvatarUrls[0] || ""

            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: root.height * 0.1
        }
        ListView {
            id: chatRoomMessages
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ConversationsModel.messagesModel
            spacing: 0
            clip: true

            onAtYEndChanged: {
                checkReadState()
            }

            delegate: ConversationMessageListItem {
                listView: chatRoomMessages
                width: chatRoomMessages.width
            }
        }

        MessageComposer {
            Layout.fillWidth: true
            Layout.preferredHeight: root.height * 0.1
        }
    }
}
