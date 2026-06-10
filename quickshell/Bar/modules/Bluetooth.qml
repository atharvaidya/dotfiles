import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "../../Theme"

Item {
    id: root

    width: 38
    height: 38

    required property var panelWindow

    property bool open: false
    readonly property bool hasAdapter: Bluetooth.defaultAdapter !== null
    readonly property bool isEnabled: hasAdapter && Bluetooth.defaultAdapter.enabled
    readonly property bool anyConnected: isEnabled && Bluetooth.devices && Bluetooth.devices.count > 0

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

    onOpenChanged: {
        if (hasAdapter) {
            Bluetooth.defaultAdapter.discovering = open;
        }
    }

    function getBluetoothIcon() {
        if (!isEnabled) return "󰂲"
        return anyConnected ? "󰂱" : "󰂯"
    }

    function getBluetoothColor() {
        if (!isEnabled) return Colors.textMuted
        return anyConnected ? Colors.primary : Colors.text
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
            text: root.getBluetoothIcon()
            color: root.getBluetoothColor()
            font.pixelSize: 18
            Behavior on color { ColorAnimation { duration: 150 } }
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
            adjustment: PopupAdjustment.Flip | PopupAdjustment.Slide
        }

        implicitWidth: 246
        implicitHeight: 290

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
                width: 230
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                x: 16 + (root.open ? 0 : -16)
                opacity: root.open ? 1.0 : 0.0

                Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                color: Colors.bgGlass
                radius: 14
                border.color: Colors.borderGlass
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    // Header
                    Item {
                        width: parent.width
                        height: 26

                        Text {
                            text: "Bluetooth"
                            color: Colors.text
                            font.pixelSize: 14
                            font.bold: true
                            font.family: "Inter"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 34; height: 18; radius: 9
                            color: root.isEnabled ? Colors.primary : Colors.tertiary
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Rectangle {
                                width: 14; height: 14; radius: 7
                                color: Colors.background
                                x: root.isEnabled ? 18 : 2; y: 2
                                Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuart } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (root.hasAdapter) {
                                        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                                    }
                                }
                            }
                        }
                    }

                    // Divider
                    Rectangle {
                        width: parent.width; height: 1
                        color: Colors.borderGlassMuted
                    }

                    // Device list
                    Item {
                        width: parent.width
                        height: parent.height - y - 10

                        Text {
                            visible: !root.hasAdapter
                            text: "No Bluetooth adapter found"
                            color: Colors.textMuted
                            font.pixelSize: 11; font.italic: true
                            anchors.centerIn: parent
                        }

                        Text {
                            visible: root.hasAdapter && !root.isEnabled
                            text: "Bluetooth is disabled"
                            color: Colors.textMuted
                            font.pixelSize: 11; font.italic: true
                            anchors.centerIn: parent
                        }

                        Flickable {
                            visible: root.isEnabled
                            anchors.fill: parent
                            contentHeight: deviceCol.implicitHeight
                            clip: true

                            Column {
                                id: deviceCol
                                width: parent.width
                                spacing: 6

                                Text {
                                    text: "Connected"
                                    color: Colors.primary
                                    font.pixelSize: 10; font.bold: true; font.family: "Inter"
                                    visible: root.anyConnected
                                }

                                Repeater {
                                    model: Bluetooth.devices
                                    delegate: DeviceItem {}
                                }

                                Text {
                                    text: "Available"
                                    color: Colors.textMuted
                                    font.pixelSize: 10; font.bold: true; font.family: "Inter"
                                    visible: root.isEnabled && Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.devices.count > 0
                                }

                                Repeater {
                                    model: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.devices : null
                                    delegate: DeviceItem { visible: !device.connected }
                                }

                                Text {
                                    visible: root.isEnabled &&
                                             (!Bluetooth.devices || Bluetooth.devices.count === 0) &&
                                             (!Bluetooth.defaultAdapter || Bluetooth.defaultAdapter.devices.count === 0)
                                    text: "Searching for devices..."
                                    color: Colors.textMuted
                                    font.pixelSize: 11; font.italic: true
                                    width: parent.width
                                    horizontalAlignment: Text.AlignHCenter
                                    topPadding: 20
                                }
                            }
                        }
                    }
                }
            }

            HoverHandler { id: popupHover }
        }
    }

    // ── DeviceItem component ─────────────────────────────────────────────────
    component DeviceItem: Rectangle {
        id: devItem
        width: 202
        height: visible ? 38 : 0
        radius: 8
        color: devMouse.containsMouse ? Colors.hoverBg : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        property var device: modelData

        Rectangle {
            width: 3; height: 14; radius: 2
            color: device && device.connected ? Colors.primary : "transparent"
            anchors.left: parent.left; anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.left: parent.left; anchors.leftMargin: 14
            anchors.right: parent.right; anchors.rightMargin: 38
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1

            Text {
                text: device ? (device.name || device.deviceName || "Unknown Device") : "Unknown"
                color: device && device.connected ? Colors.text : Colors.textMuted
                font.pixelSize: 11; font.bold: device && device.connected
                elide: Text.ElideRight; width: parent.width
            }
            Text {
                text: device && device.connected
                    ? (device.batteryAvailable ? `Connected • 󰁹 ${Math.round(device.battery * 100)}%` : "Connected")
                    : "Available"
                color: device && device.connected ? Colors.primary : Colors.textMuted
                font.pixelSize: 9
            }
        }

        Text {
            anchors.right: parent.right; anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: device && device.connected ? "󰂲" : "󰂯"
            color: Colors.textMuted
            font.pixelSize: 13
            opacity: devMouse.containsMouse ? 1.0 : 0.55
        }

        MouseArea {
            id: devMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (device) {
                    if (device.connected) device.disconnect();
                    else device.connect();
                }
            }
        }
    }
}
