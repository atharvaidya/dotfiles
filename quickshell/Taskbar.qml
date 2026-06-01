import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Services.UPower

PanelWindow {
    anchors {
	top: true
	left: true
	right: true
    }
    implicitHeight: 22
    color: "#50000000"
    SystemClock {
      id: clock
      precision: SystemClock.Minutes
    }

    Text {
      text: Qt.formatDateTime(clock.date, " hh:mm")
    }
}

