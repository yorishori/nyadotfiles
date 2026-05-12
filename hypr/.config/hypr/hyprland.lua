hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)

require("extra/keybinds")
require("extra/lookNfeel")
require("extra/rules")

hl.monitor({ 
	output = "DP-3", 
	mode = "2560x1440@120", 
	position = "0x0", 
	scale = 1 
})

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd GTK_USE_PORTAL=1")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("plymouth quit --retain-splash")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("pidof hyprlock || hyprlock")
end)

hl.config({
    dwindle = {
        preserve_split = true,
        force_split   = 2
    },

    master = {
        new_status = "master"
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true
    },

    input = {
        kb_layout    = "us",
        kb_options   = "compose:caps",
        follow_mouse = 1,
        sensitivity  = 0
    }
})
