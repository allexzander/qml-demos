import QtQuick
import "../"

Item {
    id: root

    required property ListView listView
    required property var model
    required property int index

    width: listView.width
    implicitHeight: Math.max(
        bubble.implicitHeight,
        root.model.avatar.visible ? root.model.avatar.height : 0
    ) + 6

    Loader {
        id: avatarLoader
        active: root.model.isLastInSeries && !root.model.isMine

        anchors {
            left: parent.left
            leftMargin: 12
            bottom: bubble.bottom
        }

        sourceComponent: UserAvatar {
            source: root.model.avatar
            width: bubble.implicitHeight * 0.8
            height: width
        }
    }

    Rectangle {
        id: bubble
        radius: 18
        color: root.model.isMine ? "#19a3ff" : "#1a1424"

        implicitWidth: Math.min(
            messageText.implicitWidth + 24,
            listView.width * 0.7
        )
        implicitHeight: messageText.implicitHeight + 16

        anchors {
            right: root.model.isMine ? parent.right : undefined
            left: root.model.isMine ? undefined : parent.left
            leftMargin: root.model.isMine
                ? 12
                : bubble.implicitHeight * 0.8 + 20
            rightMargin: 12
        }

        Text {
            id: messageText
            text: root.model.text
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
