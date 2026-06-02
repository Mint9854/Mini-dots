local hl = require("hyprland")

-- Monitors
hl.monitor({ name = "", resolution = "preferred", position = "auto", scale = 1 })

-- Autostart
hl.on("hyprland.start", function()
    hl.exec("waybar")
    hl.exec("hyprpaper")
    hl.exec("hypridle")
    hl.exec("dunst")
    hl.exec("blueman-applet")
    hl.exec("nm-applet --indicator")
    hl.exec("wl-paste --type text --watch cliphist store")
    hl.exec("wl-paste --type image --watch cliphist store")
end)

-- Config
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 12,
        border_size = 1,
        ["col.active_border"] = "rgba(a8b5c8ff) rgba(7e9ab5ff) 45deg",
        ["col.inactive_border"] = "rgba(2a2d3688)",
        layout = "dwindle",
        resize_on_border = true,
    },
    decoration = {
        rounding = 8,
        active_opacity = 1.0,
        inactive_opacity = 0.92,
        blur = {
            enabled = true,
            size = 5,
            passes = 3,
            new_optimizations = true,
            noise = 0.02,
            contrast = 0.9,
            brightness = 0.8,
        },
        shadow = {
            enabled = true,
            range = 20,
            render_power = 3,
            color = "rgba(00000055)",
        },
    },
    animations = {
        enabled = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true,
        },
    },
    dwindle = {
        preserve_split = true,
        smart_resizing = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },
})

-- Animations
hl.bezier("easeOut", 0.16, 1, 0.3, 1)
hl.bezier("easeIn", 0.7, 0, 0.84, 0)
hl.bezier("spring", 0.34, 1.56, 0.64, 1)
hl.bezier("linear", 0, 0, 1, 1)
hl.animation("windows",     true, 4,  "spring",  "slide")
hl.animation("windowsOut",  true, 3,  "easeIn",  "slide")
hl.animation("border",      true, 6,  "easeOut")
hl.animation("borderangle", true, 60, "linear",  "loop")
hl.animation("fade",        true, 4,  "easeOut")
hl.animation("workspaces",  true, 4,  "easeOut",  "slidevert")

-- Layer rules (blur)
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "wofi" },   blur = true })

-- Window rules
hl.window_rule({ match = { class = "pavucontrol" },        float = true })
hl.window_rule({ match = { class = "blueman-manager" },    float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true, pin = true })
hl.window_rule({ match = { class = "kitty" },              opacity = "0.92 override 0.85 override" })

-- Keybinds
local SUPER = "SUPER"

hl.bind(SUPER, "Return",  hl.dsp.exec("kitty"))
hl.bind(SUPER, "Space",   hl.dsp.exec("wofi --show drun"))
hl.bind(SUPER, "Q",       hl.dsp.killactive())
hl.bind(SUPER .. " SHIFT", "E", hl.dsp.exit())
hl.bind(SUPER, "F",       hl.dsp.togglefloating())
hl.bind(SUPER .. " SHIFT", "F", hl.dsp.fullscreen())
hl.bind(SUPER, "J",       hl.dsp.togglesplit())

-- Utilities
hl.bind(SUPER, "S",              hl.dsp.exec("~/.dotfiles/scripts/settings-menu"))
hl.bind(SUPER .. " SHIFT", "W",  hl.dsp.exec("~/.dotfiles/scripts/wallpaper-picker"))
hl.bind(SUPER, "V",              hl.dsp.exec("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind(SUPER .. " SHIFT", "S",  hl.dsp.exec("grimblast copy area"))
hl.bind("", "Print",             hl.dsp.exec("grimblast copy output"))
hl.bind(SUPER, "W",              hl.dsp.exec("pkill waybar || waybar"))
hl.bind(SUPER, "B",              hl.dsp.exec("blueman-manager"))
hl.bind(SUPER, "N",              hl.dsp.exec("nm-connection-editor"))

-- Focus
hl.bind(SUPER, "left",  hl.dsp.movefocus("l"))
hl.bind(SUPER, "right", hl.dsp.movefocus("r"))
hl.bind(SUPER, "up",    hl.dsp.movefocus("u"))
hl.bind(SUPER, "down",  hl.dsp.movefocus("d"))
hl.bind(SUPER, "h",     hl.dsp.movefocus("l"))
hl.bind(SUPER, "l",     hl.dsp.movefocus("r"))
hl.bind(SUPER, "k",     hl.dsp.movefocus("u"))
hl.bind(SUPER, "j",     hl.dsp.movefocus("d"))

-- Move windows
hl.bind(SUPER .. " SHIFT", "left",  hl.dsp.movewindow("l"))
hl.bind(SUPER .. " SHIFT", "right", hl.dsp.movewindow("r"))
hl.bind(SUPER .. " SHIFT", "up",    hl.dsp.movewindow("u"))
hl.bind(SUPER .. " SHIFT", "down",  hl.dsp.movewindow("d"))

-- Workspaces
for i = 1, 6 do
    hl.bind(SUPER, tostring(i), hl.dsp.workspace(i))
    hl.bind(SUPER .. " SHIFT", tostring(i), hl.dsp.movetoworkspace(i))
end

hl.bind(SUPER, "mouse_down", hl.dsp.workspace("e+1"))
hl.bind(SUPER, "mouse_up",   hl.dsp.workspace("e-1"))
hl.bindm(SUPER, "mouse:272", hl.dsp.movewindow())
hl.bindm(SUPER, "mouse:273", hl.dsp.resizewindow())

-- Volume / brightness
hl.binde("", "XF86AudioRaiseVolume",  hl.dsp.exec("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.binde("", "XF86AudioLowerVolume",  hl.dsp.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bindl("", "XF86AudioMute",         hl.dsp.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.binde("", "XF86MonBrightnessUp",   hl.dsp.exec("brightnessctl s +5%"))
hl.binde("", "XF86MonBrightnessDown", hl.dsp.exec("brightnessctl s 5%-"))
