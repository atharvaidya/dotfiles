import QtQuick
import Quickshell
import Quickshell.Io
import "../../Theme"

Item {
    id: root

    width: 38
    height: 38

    required property var panelWindow

    property bool open: false
    readonly property bool hoveringTrigger: triggerHover.hovered
    readonly property bool hoveringPopup: popupHover.hovered

    onHoveringTriggerChanged: updateState()
    onHoveringPopupChanged: updateState()

    function updateState() {
        if (hoveringTrigger || hoveringPopup) {
            debounceTimer.stop();
            if (!open) root.open = true;
        } else {
            debounceTimer.restart();
        }
    }

    Timer {
        id: debounceTimer
        interval: 350
        repeat: false
        onTriggered: {
            if (!hoveringTrigger && !hoveringPopup) {
                root.open = false;
                animKeepAliveTimer.start();
            }
        }
    }

    Timer {
        id: animKeepAliveTimer
        interval: 250
        repeat: false
    }

    function runCommand(cmd) {
        process.command = ["sh", "-c", cmd];
        process.running = true;
    }

    // ── Trigger button ──────────────────────────────────────────────────────
    Rectangle {
        id: trigger
        anchors.fill: parent
        radius: width / 2
        color: triggerHover.hovered ? Colors.hoverBg : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        HoverHandler { id: triggerHover }

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 3 // nudge down by 3px for perfect visual centering
            text: "⏻"
            color: Colors.danger
            font.pixelSize: 20
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.open = !root.open
        }
    }

    // ── Popup Window ────────────────────────────────────────────────────────
    PopupWindow {
        id: popup
        visible: root.open || animKeepAliveTimer.running
        color: "transparent"

        anchor {
            item: trigger
            edges: Edges.Right
            gravity: Edges.Right
            // Use Slide adjustment to automatically push the popup upward if it goes off the bottom of the screen
            adjustment: PopupAdjustment.Flip | PopupAdjustment.Slide
        }

        // 16px bridge + 72px card + 60px tooltip space
        implicitWidth: 148
        implicitHeight: 176

        Item {
            anchors.fill: parent

            // Invisible hover bridge to catch mouse movement between bar and popup card
            Item {
                id: hoverBridge
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 16
            }

            // Visible popup card
            Rectangle {
                id: popupCard
                width: 72
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                
                // Position card at x: 16 (after hover bridge) when open, sliding left slightly when closed
                x: 16 + (root.open ? 0 : -16)
                opacity: root.open ? 1.0 : 0.0

                Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                color: Colors.bgGlass
                radius: 14
                border.color: Colors.borderGlass
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    PowerAction {
                        icon: "🌙"
                        label: "Sleep"
                        command: "systemctl suspend"
                    }

                    PowerAction {
                        icon: "🔄"
                        label: "Reboot"
                        command: "systemctl reboot"
                    }

                    PowerAction {
                        icon: "⏻"
                        label: "Power off"
                        command: "systemctl poweroff"
                    }
                }
            }

            HoverHandler { id: popupHover }
        }
    }

    // ── PowerAction component ────────────────────────────────────────────────
    component PowerAction: Rectangle {
        required property string icon
        required property string label
        required property string command

        width: 44; height: 44
        radius: 10
        color: mouse.containsMouse ? Colors.hoverBg : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text: icon
            font.pixelSize: 20
            color: mouse.containsMouse ? Colors.danger : Colors.text
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.runCommand(command);
                root.open = false;
            }
        }

        // Tooltip label on hover
        Rectangle {
            visible: mouse.containsMouse
            anchors.left: parent.right
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            width: labelText.implicitWidth + 12
            height: 22
            radius: 6
            color: Colors.bgGlass
            border.color: Colors.borderGlass
            border.width: 1

            Text {
                id: labelText
                anchors.centerIn: parent
                text: label
                color: Colors.text
                font.pixelSize: 10
                font.family: "Inter"
            }
        }
    }

    Process {
        id: process
    }
}