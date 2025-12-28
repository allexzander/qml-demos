import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property alias text: searchField.text
    signal textEdited(string text)

    implicitHeight: 30
    radius: 10
    color: "#1a1424"
    border.color: "#2c2440"
    border.width: 1

    property string shortcutLabel: {
        switch (Qt.platform.os) {
        case "osx":
            return "⌘K"
        case "windows":
        case "linux":
            return "Ctrl+K"
        default:
            return "Ctrl+K"
        }
    }


    RowLayout {
        anchors.fill: parent
        spacing: 0

        Image {
            source: "assets/icons/icon-search.svg"
            sourceSize.width: searchField.height * 0.8
            sourceSize.height: searchField.height * 0.8
            Layout.leftMargin: 5
            Layout.preferredWidth: searchField.height * 0.8
            Layout.preferredHeight: searchField.height * 0.8
            fillMode: Image.PreserveAspectFit
            opacity: 0.7
            smooth: true
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: qsTr("Search (%1)").arg(shortcutLabel)
            background: null
            color: "#ffffff"
            placeholderTextColor: "#525252"
            font.pixelSize: root.height * 0.4
            onTextChanged: root.textEdited(text)
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
