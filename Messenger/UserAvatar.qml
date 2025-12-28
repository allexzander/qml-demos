import QtQuick
import QtQuick.Effects

Item {
    id: root

    property alias source: userAvatar.source
    implicitWidth: 40
    implicitHeight: 40

    Image {
        id: userAvatar
        anchors.fill: parent
        source: "assets/current_user_photo.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
        layer.enabled: true
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: width / 2
        antialiasing: true
        visible: false
        layer.enabled: true
        layer.smooth: true
    }

    MultiEffect {
        anchors.fill: parent
        source: userAvatar

        maskEnabled: true
        maskSource: mask

        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }
}
