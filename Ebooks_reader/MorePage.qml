import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Config

Item {
    id: root

    property bool loading: true
    visible: loading

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        opacity: 0.85
    }

    Column {
        anchors.centerIn: parent
        spacing: Config.mediumMargin

        AnimatedImage {
            source: "assets/loading.gif"
            width: Config.loadingIndicatorSize
            height: Config.loadingIndicatorSize
            playing: true
            smooth: true
            cache: true
        }

        Text {
            text: qsTr("Please wait…")
            font.pixelSize: Config.titleFontPixelSize
            color: Config.titleFontColor
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
