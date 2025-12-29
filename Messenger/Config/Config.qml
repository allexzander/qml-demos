pragma Singleton
import QtQuick

QtObject {
    readonly property string assetsBase:
        "qrc:/qt/qml/Messenger/assets"
    function timeAgo(timestampMs, isDetailed = false) {
        if (!timestampMs || timestampMs === 0)
            return ""

        const seconds = Math.floor((Date.now() - timestampMs) / 1000)

        // --- NOW / RECENT ---
        if (seconds < 30)
            return isDetailed ? qsTr("just now") : qsTr("now")

        if (seconds < 60)
            return isDetailed ? qsTr("less than a minute ago") : qsTr("now")

        const minutes = Math.floor(seconds / 60)
        if (minutes < 60) {
            return isDetailed
                ? qsTr("%1 minute(s) ago").arg(minutes)
                : minutes + qsTr("m")
        }

        const hours = Math.floor(minutes / 60)
        if (hours < 24) {
            return isDetailed
                ? qsTr("%1 hour(s) ago").arg(hours)
                : hours + qsTr("h")
        }

        const days = Math.floor(hours / 24)
        if (days < 7) {
            return isDetailed
                ? qsTr("%1 day(s) ago").arg(days)
                : days + qsTr("d")
        }

        const weeks = Math.floor(days / 7)
        if (weeks < 4) {
            return isDetailed
                ? qsTr("%1 week(s) ago").arg(weeks)
                : weeks + qsTr("w")
        }

        const months = Math.floor(days / 30)
        if (months < 12) {
            return isDetailed
                ? qsTr("%1 month(s) ago").arg(months)
                : months + qsTr("mo")
        }

        const years = Math.floor(days / 365)
        return isDetailed
            ? qsTr("%1 year(s) ago").arg(years)
            : years + qsTr("y")
    }
}
