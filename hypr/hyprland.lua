require("windows")
require("binds")
require("animations")


hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("AQ_DRM_DEVICES", "/dev/dri/igpu:/dev/dri/dgpu")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")


hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
