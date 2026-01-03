import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Messenger
import "conversations"

ApplicationWindow {
    id: root
    width: 960
    height: 720
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("Messenger")

    RowLayout {
        id: mainContainer
        anchors.fill: parent
        spacing: 0

        Conversations {
            id: conversations
            color: "#090513"
            Layout.preferredWidth: 4
            Layout.horizontalStretchFactor: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        ConversationWorkspace {
            id: conversationWorkspace
            color: "#000000"
            Layout.preferredWidth: 10
            Layout.horizontalStretchFactor: 7
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
