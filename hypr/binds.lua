mainMod = "SUPER"
terminal = "kitty"
fileManager = "dolphin"
menu = "rofi -show combi -combi-modes \"drun,run\""


hl.config({input = {touchpad = {natural_scroll = true}}})
hl.config({cursor = {no_warps = true}})
hl.config({input = {follow_mouse = 0}})


hl.config({general={layout="dwindle"}})


hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
    hl.dispatch(hl.dsp.window.resize({ x = 600, y = 400 }))
end)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))



hl.bind(mainMod .. " + left", hl.dsp.focus({direction = "left"}))
hl.bind(mainMod .. " + right", hl.dsp.focus({direction = "right"}))
hl.bind(mainMod .. " + up", hl.dsp.focus({direction = "up"}))
hl.bind(mainMod .. " + down", hl.dsp.focus({direction = "down"}))
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({workspace = i}))
end
hl.bind("ALT + TAB", hl.dsp.window.cycle_next({next}))


hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({workspace = "e+1"}))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({workspace = "e-1"}))


hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
