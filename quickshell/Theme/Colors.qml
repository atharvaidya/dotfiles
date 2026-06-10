pragma Singleton
import Quickshell
import QtQuick

QtObject {

    readonly property color primary: "#cba6f7"
    readonly property color secondary: "#7c7f93"
    readonly property color tertiary: "#45475a"

    readonly property color background: "#11111b"
    readonly property color surface: "#1e1e2e"
    readonly property color overlay: "#313244"

    readonly property color text: "#cdd6f4"
    readonly property color textMuted: "#a6adc8"

    readonly property color success: "#a6e3a1"
    readonly property color warning: "#f9e2af"
    readonly property color danger: "#f38ba8"

    // Glassmorphism / translucency helper colors
    readonly property color bgGlass: "#cc11111b"
    readonly property color surfaceGlass: "#ee1e1e2e"
    readonly property color borderGlass: "#1cffffff"
    readonly property color borderGlassMuted: "#0dffffff"
    readonly property color hoverBg: "#22ffffff"
    readonly property color hoverBgActive: "#3cffffff"
}