import Quickshell
import QtQuick
import Quickshell.Hyprland
import "../../Theme"

Column {
    spacing: 11
    
    anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
    }


    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {

            required property var modelData
            property HyprlandWorkspace ws: modelData

            visible: ws && (ws.focused || occupied)

            readonly property bool occupied:
                ws
                && ws.lastIpcObject
                && ws.lastIpcObject.windows > 0

            width: ws && ws.focused ? 10 : 6
            height: width
            radius: width / 2

            color: ws && ws.focused
                ? Colors.primary
                : Colors.secondary

            MouseArea {
                anchors.fill: parent
                onClicked: ws.activate()
            }
        }
    }
}