hl.curve("premium", {
    type = "bezier",
    points = {
        {0.25, 0.8},
        {0.1, 1.0}
    }
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed =10,
    bezier = "premium",
    style = "popin 92%"
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 8,
    bezier = "premium"
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 10,
    bezier = "premium",
    style ="slidefade 12%"
})

hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 7,
    bezier = "premium",
    style = "fade"
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 7,
    bezier = "premium"
})

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",

        col = {
            active_border = {
                colors = {
                    "rgba(33ccffee)",
                },
            },
            inactive_border = "rgba(595959aa)"
        }
    },

    decoration = {
        rounding = 14,
        rounding_power = 3,

        active_opacity = 1.0,
        inactive_opacity = 0.97,

        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            vibrancy = 0.15
        }
    },
})
