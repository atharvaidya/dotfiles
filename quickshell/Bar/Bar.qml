import Quickshell
import QtQuick
import "./modules"
import "../Theme"

PanelWindow {
    id: rootWindow

    anchors {
        left: true
        top: true
        bottom: true
    }

    focusable: false
    implicitWidth: 60

    margins {
        top: 0
        bottom: 0
        left: 0
    }

    color: "transparent"

    // Reserve space for our bar so active windows don't overlap with it
    exclusiveZone: width

    // Unshifted container that matches rootWindow bounds exactly
    Item {
        anchors.fill: parent

        // Background rectangle (shifted left to clip corners)
        Rectangle {
            id: bg
            anchors {
                fill: parent
                leftMargin: -20 // overflow to clip left corners and border
            }
            color: Colors.bgGlass
            radius: 16
            border.color: Colors.borderGlass
            border.width: 1
        }

        // Top Section: Brand Icon & Workspace dots
        Column {
            id: topSection
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 24

            // Brand Launcher Icon
            Rectangle {
                width: 38
                height: 38
                radius: 19
                color: launcherMouse.containsMouse ? Colors.hoverBg : "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    anchors.centerIn: parent
                    text: ""
                    color: launcherMouse.containsMouse ? Colors.primary : Colors.text
                    font.pixelSize: 20

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    id: launcherMouse
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Workspaces {
                id: workspacesModule
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Center Section: Vertical Clock & Date
        Clock {
            id: clockModule
            anchors.centerIn: parent
        }

        // Bottom Section: System Icons & Power Menu
        Column {
            id: bottomSection
            anchors {
                bottom: parent.bottom
                bottomMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 18

            PowerProfile {
                id: powerProfileModule
                panelWindow: rootWindow
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Wifi {
                id: wifiModule
                panelWindow: rootWindow
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Bluetooth {
                id: bluetoothModule
                panelWindow: rootWindow
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Battery {
                id: batteryModule
                anchors.horizontalCenter: parent.horizontalCenter
            }

            PowerMenu {
                id: powerMenuModule
                panelWindow: rootWindow
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}