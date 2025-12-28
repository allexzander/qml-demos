import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 960
    height: 720
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("Hello World")

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

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: leftSidebar
            color: "#090513"
            Layout.preferredWidth: 4
            Layout.horizontalStretchFactor: 3
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                LeftSidebarTopBar {
                    id: leftSideBarTopBar
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.preferredHeight: leftSidebar.height * 0.1
                }

                SearchBar {
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.preferredHeight: leftSideBarTopBar.height / 2
                }

                ListView {
                    id: contacts
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: ConversationsModel
                    currentIndex: -1
                    delegate: ContactsListItem {
                        listView: contacts
                        height: leftSideBarTopBar.height * 1.2
                    }
                }
            }
        }
        Rectangle {
            id: rightSidebar
            color: "#000000"
            Layout.preferredWidth: 10
            Layout.horizontalStretchFactor: 7
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                RightSidebarTopBar {
                    id: rightSideBarTopBar
                    name: ConversationsModel.currentConversation.name || "Select conversation"
                    iconUrl: ConversationsModel.currentConversationAvatarUrls[0] || ""

                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.preferredHeight: rightSidebar.height * 0.1
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

                    delegate: Item {
                        width: chatRoomMessages.width
                        implicitHeight: Math.max(
                            bubble.implicitHeight,
                            avatar.visible ? avatar.height : 0
                        ) + 6

                        Loader {
                            id: avatarLoader
                            active: model.isLastInSeries && !isMine

                            anchors {
                                left: parent.left
                                leftMargin: 12
                                bottom: bubble.bottom
                            }

                            sourceComponent: UserAvatar {
                                source: model.avatar
                                width: bubble.implicitHeight * 0.8
                                height: width
                            }
                        }

                        Rectangle {
                            id: bubble
                            radius: 18
                            color: isMine ? "#19a3ff" : "#1a1424"

                            implicitWidth: Math.min(
                                messageText.implicitWidth + 24,
                                chatRoomMessages.width * 0.7
                            )
                            implicitHeight: messageText.implicitHeight + 16

                            anchors {
                                right: isMine ? parent.right : undefined
                                left: isMine ? undefined : parent.left
                                leftMargin: isMine
                                    ? 12
                                    : bubble.implicitHeight * 0.8 + 20
                                rightMargin: 12
                            }

                            Text {
                                id: messageText
                                text: model.text
                                color: "#ffffff"
                                wrapMode: Text.Wrap
                                verticalAlignment: Text.AlignVCenter
                                width: bubble.implicitWidth - 24

                                anchors {
                                    fill: parent
                                    margins: 12
                                }
                            }
                        }
                    }
                }

                ChatRoomInput {
                    Layout.fillWidth: true
                    Layout.preferredHeight: rightSidebar.height * 0.1
                }
            }
        }
    }
}
