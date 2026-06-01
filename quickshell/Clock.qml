import Quickshell
import QtQuick
import Quickshell.Wayland

PanelWindow{
  color: "transparent"
  focusable:false
  anchors{
    top:true
    bottom:true
    left:true
    right:true
  }
  WlrLayershell.layer: WlrLayer.Bottom
  Item{
    id:clock
    anchors.fill:parent

    property string time: Qt.formatDateTime(sysClock.date, "HH:mm")
    property string day: Qt.formatDateTime(sysClock.date, " dddd,")
    property string date: Qt.formatDateTime(sysClock.date, " dd MMM yyyy")

    SystemClock{
      id:sysClock
      precision: SystemClock.Minutes
    }
    
    Column {
      anchors.centerIn: parent
      Text { text: clock.time; color: "white"; font.pixelSize: 100 }
      Text { text: clock.day; color: "white"; font.pixelSize: 40 }
      Text { text: clock.date; color: "white"; font.pixelSize: 30 }
    }
  }
}
