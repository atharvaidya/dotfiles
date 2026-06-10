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
    property bool wifiEnabled: false
    property string connectedSsid: ""
    property int signalStrength: 0
    property string connectingSsid: ""

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

    ListModel { id: wifiModel }

    function getWifiIcon(enabled, ssid, signal) {
        if (!enabled) return "󰤮"
        if (!ssid) return "󰤯"
        if (signal >= 80) return "󰤨"
        if (signal >= 60) return "󰤥"
        if (signal >= 40) return "󰤢"
        if (signal >= 20) return "󰤟"
        return "󰤯"
    }

    function getWifiColor(enabled, ssid) {
        if (!enabled) return Colors.textMuted
        return ssid ? Colors.primary : Colors.text
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
            text: root.getWifiIcon(root.wifiEnabled, root.connectedSsid, root.signalStrength)
            color: root.getWifiColor(root.wifiEnabled, root.connectedSsid)
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
                            text: "Wi-Fi"
                            color: Colors.text
                            font.pixelSize: 14
                            font.bold: true
                            font.family: "Inter"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            id: toggleSwitch
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 34; height: 18; radius: 9
                            color: root.wifiEnabled ? Colors.primary : Colors.tertiary
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Rectangle {
                                width: 14; height: 14; radius: 7
                                color: Colors.background
                                x: root.wifiEnabled ? 18 : 2; y: 2
                                Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuart } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (root.wifiEnabled)
                                        toggleProcess.command = ["nmcli", "radio", "wifi", "off"];
                                    else
                                        toggleProcess.command = ["nmcli", "radio", "wifi", "on"];
                                    toggleProcess.running = true;
                                    root.wifiEnabled = !root.wifiEnabled;
                                    refreshTimer.restart();
                                }
                            }
                        }
                    }

                    // Divider
                    Rectangle {
                        width: parent.width; height: 1
                        color: Colors.borderGlassMuted
                    }

                    // Network list
                    Item {
                        width: parent.width
                        height: parent.height - y - 10

                        Text {
                            visible: !root.wifiEnabled
                            text: "Wi-Fi is disabled"
                            color: Colors.textMuted
                            font.pixelSize: 11; font.italic: true
                            anchors.centerIn: parent
                        }

                        Flickable {
                            visible: root.wifiEnabled
                            anchors.fill: parent
                            contentHeight: networkCol.implicitHeight
                            clip: true

                            Column {
                                id: networkCol
                                width: parent.width
                                spacing: 6

                                Text {
                                    visible: root.connectingSsid !== ""
                                    text: `Connecting to ${root.connectingSsid}...`
                                    color: Colors.primary
                                    font.pixelSize: 11; font.bold: true; font.italic: true
                                    width: parent.width
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Text {
                                    text: "Connected"
                                    color: Colors.primary
                                    font.pixelSize: 10; font.bold: true; font.family: "Inter"
                                    visible: root.connectedSsid !== "" && root.connectingSsid === ""
                                }

                                Repeater {
                                    model: wifiModel
                                    delegate: WifiItem { visible: active }
                                }

                                Text {
                                    text: "Available"
                                    color: Colors.textMuted
                                    font.pixelSize: 10; font.bold: true; font.family: "Inter"
                                    visible: root.wifiEnabled && wifiModel.count > (root.connectedSsid !== "" ? 1 : 0) && root.connectingSsid === ""
                                }

                                Repeater {
                                    model: wifiModel
                                    delegate: WifiItem { visible: !active }
                                }

                                Text {
                                    visible: root.wifiEnabled && wifiModel.count === 0 && root.connectingSsid === ""
                                    text: "Scanning networks..."
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

    // ── WifiItem component ───────────────────────────────────────────────────
    component WifiItem: Rectangle {
        id: netItem
        width: 202
        height: visible ? 38 : 0
        radius: 8
        color: active ? Colors.hoverBgActive : (netMouse.containsMouse ? Colors.hoverBg : "transparent")
        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            width: 3; height: 14; radius: 2
            color: active ? Colors.primary : "transparent"
            anchors.left: parent.left; anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.left: parent.left; anchors.leftMargin: 14
            anchors.right: parent.right; anchors.rightMargin: 38
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1

            Text {
                text: ssid
                color: active ? Colors.text : Colors.textMuted
                font.pixelSize: 11; font.bold: active
                elide: Text.ElideRight; width: parent.width
            }
            Text {
                text: active ? "Connected" : `${signal}% signal`
                color: active ? Colors.primary : Colors.textMuted
                font.pixelSize: 9
            }
        }

        Text {
            anchors.right: parent.right; anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: root.getWifiIcon(true, ssid, signal)
            color: active ? Colors.primary : Colors.textMuted
            font.pixelSize: 13
            opacity: netMouse.containsMouse ? 1.0 : 0.55
        }

        MouseArea {
            id: netMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (!active && root.connectingSsid === "") {
                    root.connectingSsid = ssid;
                    connectProcess.command = ["nmcli", "device", "wifi", "connect", ssid];
                    connectProcess.running = true;
                }
            }
        }
    }

    // ── Timers & Processes ───────────────────────────────────────────────────
    Timer {
        id: refreshTimer
        interval: 8000; repeat: true
        running: root.wifiEnabled || wifiModel.count === 0
        triggeredOnStart: true
        onTriggered: refreshProcess.running = true
    }

    onOpenChanged: {
        if (open) refreshProcess.running = true;
    }

    Process {
        id: refreshProcess
        command: ["sh", "-c", "nmcli radio wifi && echo '---' && nmcli -t -f active,ssid,signal device wifi"]
        stdout: StdioCollector {
            onStreamFinished: root.parseWifiOutput(this.text)
        }
    }

    Process {
        id: connectProcess
        stdout: StdioCollector {
            onStreamFinished: {
                root.connectingSsid = "";
                refreshProcess.running = true;
            }
        }
    }

    Process {
        id: toggleProcess
        stdout: StdioCollector {
            onStreamFinished: refreshProcess.running = true
        }
    }

    function parseWifiOutput(output) {
        if (!output) return;
        let lines = output.trim().split("\n");
        if (lines.length === 0) return;

        let isWifiOn = (lines[0].trim() === "enabled");
        let activeSsidName = "";
        let activeSsidSignal = 0;
        let list = [];
        let startList = false;

        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (line === "---") { startList = true; continue; }
            if (!startList) continue;

            let parts = line.split(":");
            if (parts.length < 3) continue;
            let active = (parts[0] === "yes");
            let ssid = parts[1];
            let signal = parseInt(parts[2]) || 0;
            if (!ssid) continue;

            let duplicate = false;
            for (let j = 0; j < list.length; j++) {
                if (list[j].ssid === ssid) {
                    duplicate = true;
                    if (signal > list[j].signal) {
                        list[j].signal = signal;
                        list[j].active = list[j].active || active;
                    }
                    break;
                }
            }
            if (!duplicate) list.push({ ssid, signal, active });
            if (active) { activeSsidName = ssid; activeSsidSignal = signal; }
        }

        list.sort((a, b) => {
            if (a.active) return -1;
            if (b.active) return 1;
            return b.signal - a.signal;
        });

        root.wifiEnabled = isWifiOn;
        root.connectedSsid = activeSsidName;
        root.signalStrength = activeSsidSignal;

        wifiModel.clear();
        for (let k = 0; k < list.length; k++) wifiModel.append(list[k]);
    }
}
