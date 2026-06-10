import QtQuick
import Quickshell.Services.UPower
import "../../Theme"

Item {
    id: root
    width: col.implicitWidth
    height: col.implicitHeight

    readonly property bool ready: UPower.displayDevice.ready
    readonly property real p: ready ? UPower.displayDevice.percentage : 0
    readonly property int percent: Math.round(p <= 1 ? p * 100 : p)
    readonly property bool charging: !UPower.onBattery

    function getBatteryIcon(pct, isCharging) {
        if (!ready) return "󰂑"
        if (isCharging) return "󰂄"
        if (pct >= 95) return "󰁹"
        if (pct >= 85) return "󰂂"
        if (pct >= 75) return "󰂁"
        if (pct >= 65) return "󰂀"
        if (pct >= 55) return "󰁿"
        if (pct >= 45) return "󰁾"
        if (pct >= 35) return "󰁽"
        if (pct >= 25) return "󰁼"
        if (pct >= 15) return "󰁻"
        return "󰁺"
    }

    function getBatteryColor(pct, isCharging) {
        if (!ready) return Colors.textMuted
        if (isCharging) return Colors.success
        if (pct <= 20) return Colors.danger
        if (pct <= 30) return Colors.warning
        return Colors.textMuted
    }

    Column {
        id: col
        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.getBatteryIcon(root.percent, root.charging)
            color: root.getBatteryColor(root.percent, root.charging)
            font.pixelSize: 18

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.ready ? `${root.percent}%` : "--"
            color: Colors.textMuted
            font.pixelSize: 10
            font.bold: true
            font.family: "Inter"
        }
    }
}