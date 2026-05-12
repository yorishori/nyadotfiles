hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)

hl.env("XDG_CONFIG_HOME", "/home/yori/.config")
hl.env("XDG_DATA_HOME", "/home/yori/.local/share")

hl.env("WAYLAND_DISPLAY","wayland-1")

hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("PROTON_ENABLE_NGX_UPDATER", "0")

-- Nvidia stuff
hl.env("NVD_BACKEND", "direct")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("GDK_BACKEND", "wayland")

hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")

hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
