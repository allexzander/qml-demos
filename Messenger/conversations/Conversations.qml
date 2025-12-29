import QtQuick
import QtQuick.Layouts
import Messenger

Rectangle {
    id: root

    ColumnLayout {
        anchors.fill: parent
        AppHeader {
            id: appHeader
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: root.height * 0.1
        }

        SearchBar {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.preferredHeight: appHeader.height / 2
        }

        ListView {
            id: contacts
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ConversationsModel
            currentIndex: -1
            delegate: ConversationListItem {
                listView: contacts
                height: appHeader.height * 1.2
            }
        }
    }
}
