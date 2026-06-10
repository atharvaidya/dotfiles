import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../../Theme"

Item {
    id: root

    width: 38
    height: 38

    required property var panelWindow

    readonly property bool isCurrent: panelWindow.activePopup === "powerprofile"
    readonly property bool anotherPopupActive: panelWindow.activePopup !== "" && panelWindow.activePopup !== "powerprofile"
    readonly property bool open: isCurrent

    readonly property bool hoveringTrigger: triggerHover.hovered
    readonly property bool hoveringPopup: popupHover.hovered

    onHoveringTriggerChanged: updateState()
    onHoveringPopupChanged: updateState()

    function updateState() {
        if (hoveringTrigger || hoveringPopup) {
            debounceTimer.stop();
            if (panelWindow.activePopup !== "powerprofile") {
                panelWindow.activePopup = "powerprofile";
            }
        } else {
            debounceTimer.restart();
        }
    }

    Timer {
        id: debounceTimer
        interval: 350
        repeat: false
        onTriggered: {
            if (!hoveringTrigger && !hoveringPopup && panelWindow.activePopup === "powerprofile") {
                panelWindow.activePopup = "";
                animKeepAliveTimer.start();
            }
        }
    }

    Timer {
        id: animKeepAliveTimer
        interval: 250
        repeat: false
    }

    function profileEmoji(profile) {
        switch (profile) {
        case PowerProfile.PowerSaver:   return "🌱"
        case PowerProfile.Balanced:     return "⚖️"
        case PowerProfile.Performance:  return "🚀"
        default:                        return "⚖️"
        }
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
            text: root.profileEmoji(PowerProfiles.profile)
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (panelWindow.activePopup === "powerprofile") {
                    panelWindow.activePopup = "";
                } else {
                    panelWindow.activePopup = "powerprofile";
                }
            }
        }
    }

    // ── Popup Window ────────────────────────────────────────────────────────
    PopupWindow {
        id: popup
        visible: isCurrent || (animKeepAliveTimer.running && !anotherPopupActive)
        color: "transparent"

        anchor {
            item: trigger
            edges: Edges.Right
            gravity: Edges.Right
            adjustment: PopupAdjustment.Flip | PopupAdjustment.Slide
        }

        implicitWidth: 88
        implicitHeight: 158

        Item {
            anchors.fill: parent

            // Invisible hover bridge
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
                x: 16 + (isCurrent ? 0 : -24)
                opacity: isCurrent ? 1.0 : 0.0

                Behavior on x {
                    NumberAnimation {
                        duration: 350
                        easing.bezierCurve: [0.16, 1.0, 0.3, 1.0, 1.0, 1.0]
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.bezierCurve: [0.16, 1.0, 0.3, 1.0, 1.0, 1.0]
                    }
                }

                color: Colors.bgGlass
                radius: 14
                border.color: Colors.borderGlass
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    ProfileItem {
                        icon: "🌱"
                        profile: PowerProfile.PowerSaver
                    }

                    ProfileItem {
                        icon: "⚖️"
                        profile: PowerProfile.Balanced
                    }

                    ProfileItem {
                        icon: "🚀"
                        profile: PowerProfile.Performance
                    }
                }
            }

            HoverHandler { id: popupHover }
        }
    }

    // ── ProfileItem component ────────────────────────────────────────────────
    component ProfileItem: Rectangle {
        required property string icon
        required property int profile

        readonly property bool isActive: PowerProfiles.profile === profile

        width: 44; height: 38
        radius: 10
        color: isActive ? Colors.hoverBgActive : (itemMouse.containsMouse ? Colors.hoverBg : "transparent")
        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text: icon
            font.pixelSize: 18
        }

        MouseArea {
            id: itemMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                PowerProfiles.profile = profile;
                panelWindow.activePopup = "";
            }
        }
    }
}