import QtQuick
import Quickshell.Services.UPower

Item {
    width: 30
    height: 30


    Text {
        anchors.centerIn: parent
        text: Math.round(UPower.displayDevice.percentage) + "%"
    }
}