import QtQuick

Item {
    id: root
    implicitWidth: userAvatar.implicitWidth + appName.implicitWidth + newMessage.implicitWidth
    implicitHeight: 80
    UserAvatar {
        id: userAvatar
        width: root.height * 0.6
        height: root.height * 0.6

        source: "assets/current_user_photo.jpg"
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: appName
        text: "Messenger"
        font.bold: true
        font.pixelSize: root.height * 0.3
        color: "#ffffff"
        anchors.centerIn: parent
    }

    Image {
        id: newMessage
        width: root.height * 0.3
        height: root.height * 0.3
        source: "assets/icons/icon-write.svg"
        sourceSize.width: root.height * 0.3
        sourceSize.height: root.height * 0.3
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        smooth: true
    }
}
