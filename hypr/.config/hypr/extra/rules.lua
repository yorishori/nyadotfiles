-- HYPERLAND DEFUALT CONFIG
hl.window_rule({
    name = "",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = { 20, "monitor_h-120" },
    float = true
})

-- CUSTOM RULES
hl.layer_rule({
    name = "rofi_blur",
    match = { namespace = "rofi" },
    blur =  true,
    dim_around = true
})

hl.window_rule({
    name = "nyapps",
    match = { class = "^(nya-.*)$" },
    center = true,
    float = true,
    dim_around = true
})

hl.window_rule({ 
    match = { workspace = "special:special" }, 
    float = true,
    center = false,
    pseudo = true
})
