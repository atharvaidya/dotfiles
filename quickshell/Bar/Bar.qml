import Quickshell
import QtQuick
import"./modules"

PanelWindow {
    anchors {
        left: true
        top: true
        bottom: true
    }
    
    focusable: false
    width: 45
    Clock{
        anchors.horizontalCenter: parent.horizontalCenter
            anchors {
        top: parent.top
        topMargin: 800
    }
    }
    Workspaces{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }
    Battery{
        anchors.horizontalCenter: parent.horizontalCenter
    }
}