pragma Singleton
import QtQuick

QtObject {
    readonly property int sectionsVerticalSpacing: 60
    readonly property int appWindowWidth: 720
    readonly property int appWindowHeight: 960
    readonly property int contentTopMargin: 5
    readonly property int tabsHeight: 64
    readonly property int tabsFontPixelSize: 12
    readonly property int textTabsHeight: 32
    readonly property int smallMargin: 8
    readonly property int titleFontPixelSize: 18
    readonly property int descriptionFontPixelSize: 14
    readonly property int infoFontPixelSize: 16
    readonly property color titleFontColor: "#000000"
    readonly property color titleFontNegativeColor: "#ffffff"
    readonly property color descriptionFontColor: "#777777"
    readonly property color descriptionFontNegativeColor: "#ffffff"
    readonly property color deviderColor: "#D0D0D0"
    readonly property int maxBooksInCollectionsPreview: 3
    readonly property int mediumMargin: 16
    readonly property int largeMargin: 24
    readonly property int lastReadBooksDisplayCount: 4
    readonly property int mainContentHorizontalMargin: 24
    readonly property int bookStackHorizontalOffsetStep: 100
    readonly property real bookCoverAspect: 1.55 // portrait
    readonly property int tinySpacing: 2
    readonly property int smallSpacing: 16
    readonly property color listElementSelectedColor: "#000000"
    readonly property color listElementColor: "transparent"
    readonly property color scrollBarHandleColor: "#ffffff"
    readonly property color popupBackgroundColor: "#ffffff"
    readonly property int loadingIndicatorSize: 64

    function formatSize(bytes) {
        if (bytes === undefined || bytes <= 0)
            return ""

        const kb = 1024
        const mb = kb * 1024
        const gb = mb * 1024

        if (bytes >= gb)
            return (bytes / gb).toFixed(1) + " GB"
        if (bytes >= mb)
            return (bytes / mb).toFixed(1) + " MB"
        if (bytes >= kb)
            return Math.round(bytes / kb) + " KB"

        return bytes + " B"
    }
}
