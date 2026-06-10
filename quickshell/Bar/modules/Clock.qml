import Quickshell
import QtQuick    

Item{
    SystemClock {
        id: clock
        precision: SystemClock.minutes
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDateTime(clock.date, "hh:\nmm")
    }
}