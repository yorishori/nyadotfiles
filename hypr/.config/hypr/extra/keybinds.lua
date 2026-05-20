-- Apps
hl.bind("SUPER + ESCAPE",         hl.dsp.exec_cmd("nyhud.sh rofi session"))
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.exec_cmd("nylaunch.sh btop"))
hl.bind("SUPER + SPACE",          hl.dsp.exec_cmd("nyhud.sh rofi launcher"))
hl.bind("SUPER + V",              hl.dsp.exec_cmd("nyhud.sh rofi clipboard"))
hl.bind("SUPER + PERIOD",         hl.dsp.exec_cmd("nyhud.sh rofi emoji"))
hl.bind("SUPER + B",              hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + Y",              hl.dsp.exec_cmd("kitty -e yazi ~/Downloads/"))
hl.bind("SUPER + Return",          hl.dsp.exec_cmd("kitty"))

-- Windows
hl.bind("SUPER + F", hl.dsp.window.fullscreen_state({internal = 2, client = 0, action = "toggle"}))
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {mouse = true})
hl.bind("SUPER + Q", hl.dsp.window.kill())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.move({direction = "u"}))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.move({direction = "d"}))
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.move({direction = "l"}))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({direction = "r"}))
for i = 1, 9 do
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({workspace = i, follow = true}))
end
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:special" }))

-- Navigation
hl.bind("SUPER + UP", hl.dsp.focus({direction = "u"}))
hl.bind("SUPER + DOWN", hl.dsp.focus({direction = "d"}))
hl.bind("SUPER + LEFT", hl.dsp.focus({direction = "l"}))
hl.bind("SUPER + RIGHT", hl.dsp.focus({direction = "r"}))
for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i, on_current_monitor = true}))
end
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("special"))
