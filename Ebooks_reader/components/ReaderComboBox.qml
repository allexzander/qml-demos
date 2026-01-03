pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import Config

ComboBox {
    id: control

    model: ["First", "Second", "Third"]

    spacing: Config.smallMargin

    /* =========================
       DELEGATE (UNCHANGED)
       ========================= */

    delegate: ItemDelegate {
        id: delegate

        required property var model
        required property int index

        width: control.width

        contentItem: Text {
            text: delegate.model[control.textRole]
            color: Config.descriptionFontColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        highlighted: control.highlightedIndex === index
    }

    /* =========================
       DROPDOWN INDICATOR
       (ONLY X POSITION CHANGED)
       ========================= */

    indicator: Canvas {
        id: canvas

        width: 12
        height: 8
        contextType: "2d"

        y: control.topPadding
           + (control.availableHeight - height) / 2

        // 🔑 ONLY CHANGE: adaptive x based on text width
        x: {
            const textWidth = Math.min(
                contentText.paintedWidth,
                control.availableWidth - width - control.spacing
            )

            return Math.min(
                contentText.x + textWidth + control.spacing,
                control.width - width - control.rightPadding
            )
        }

        Connections {
            target: control
            function onPressedChanged() { canvas.requestPaint() }
            function onDisplayTextChanged() { canvas.requestPaint() }
        }

        onPaint: {
            context.reset()
            context.moveTo(0, 0)
            context.lineTo(width, 0)
            context.lineTo(width / 2, height)
            context.closePath()
            context.fillStyle = Config.descriptionFontColor
            context.fill()
        }
    }

    /* =========================
       CONTENT ITEM
       (UNCHANGED EXCEPT id)
       ========================= */

    contentItem: Text {
        id: contentText   // ✅ ONLY ADDITION

        leftPadding: 0
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: Config.descriptionFontColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    /* =========================
       BACKGROUND (UNCHANGED)
       ========================= */

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        border.color: "transparent"
        radius: 2
    }

    /* =========================
       POPUP (UNCHANGED)
       ========================= */

    popup: Popup {
        y: control.height - 1
        width: control.width
        height: Math.min(
            contentItem.implicitHeight,
            control.Window.height - topMargin - bottomMargin
        )
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: Config.descriptionFontColor
            radius: 2
        }
    }
}
