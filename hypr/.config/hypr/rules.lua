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


-- Float steam sub-apps
hl.window_rule({
    name = "steam-popups",
    match = { class = "steam", title = ".+" },
    float = true,
    center = true,
    max_size = { 50%, 50% }
})

hl.window_rule({
    name = "steam-main",
    match = { class = "steam", title = "^(Steam)$" },
    float = false
})

-- Float browser steam sub-apps
hl.window_rule({
    name = "zen-popups",
    match = { initial_class = "zen", initial_title = ".+" },
    float = true,
    center = true,
    max_size = { 50%, 50% }
})

hl.window_rule({
    name = "zen-main",
    match = { initial_class = zen, initial_title = "^(Zen Browser)$" },
    float = false
})
