import Quickshell
import QtQuick    
import "../../Theme"

Item {
    id: root
    width: col.implicitWidth
    height: col.implicitHeight
    
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: col
        anchors.centerIn: parent
        spacing: 6

        Text {
            id: timeText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh\nmm")
            color: Colors.text
            font.pixelSize: 18
            font.bold: true
            font.family: "JetBrains Mono"
            lineHeight: 0.85
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            width: 16
            height: 1
            color: Colors.borderGlass
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "dd\nMMM")
            color: Colors.textMuted
            font.pixelSize: 10
            font.bold: true
            font.family: "Inter"
            lineHeight: 0.95
            horizontalAlignment: Text.AlignHCenter
        }
    }
}