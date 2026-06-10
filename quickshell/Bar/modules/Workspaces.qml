import Quickshell
import QtQuick
import Quickshell.Hyprland
import "../../Theme"

Rectangle {
    id: root

    radius: 14
    color: Colors.borderGlassMuted
    border.color: Colors.borderGlassMuted
    border.width: 1

    implicitWidth: col.implicitWidth + 12
    implicitHeight: col.implicitHeight + 16

    Column {
        id: col
        spacing: 8
        anchors.centerIn: parent

        Repeater {
            model: Hyprland.workspaces

            delegate: Item {
                id: wsItem
                required property var modelData
                property HyprlandWorkspace ws: modelData

                readonly property bool occupied:
                    ws && ws.lastIpcObject && ws.lastIpcObject.windows > 0

                readonly property bool focused:
                    ws && ws.focused

                width: 12
                height: 20

                Rectangle {
                    id: dot
                    anchors.centerIn: parent

                    width: focused ? 6 : (occupied ? 6 : 4)
                    height: focused ? 14 : (occupied ? 6 : 4)
                    radius: 3

                    color: focused
                        ? Colors.primary
                        : (occupied ? Colors.text : Colors.secondary)

                    scale: itemMouse.containsMouse ? 1.3 : 1.0

                    Behavior on width {
                        NumberAnimation { duration: 250; easing.type: Easing.OutQuart }
                    }
                    Behavior on height {
                        NumberAnimation { duration: 250; easing.type: Easing.OutQuart }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutQuart }
                    }
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: ws.activate()
                }
            }
        }
    }
}