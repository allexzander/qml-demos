import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property alias text: messageInput.text
    signal textEdited(string text)

    implicitHeight: 30

    Image {
        id: iconAttachment
        source: "assets/icons/icon-plus.svg"
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
            onTextChanged: root.textEdited(text)
            anchors.left: parent.left
            anchors.right: iconSticker.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            id: iconSticker
            source: "assets/icons/icon-sticker.svg"
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
            source: "assets/icons/icon-smile.svg"
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
        source: "assets/icons/icon-like.svg"
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
