import * as path from "std/path";

import { $ } from "dax";

import { Config, Download, Text } from "../config.ts";
import { CONFIG_DIR, HOME_DIR } from "../path.ts";

const wallpaper = path.join(HOME_DIR!, "Pictures", "underwater_shipwareck.jpg");

const mod = "SUPER";
const config = `
# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,1.33

# Execute your favorite apps at launch
exec-once = swaybg -i ${wallpaper} -m fill & dunst & eww open bar

input {
    kb_layout =
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = true

    touchpad {
        natural_scroll = true
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    gaps_in = 3
    gaps_out = 6
    border_size = 3
    col.active_border = rgba(3040595a)
    col.inactive_border = rgba(3040595a)

    layout = dwindle
}

decoration {
    rounding = 12

    blur {
        enabled = true
        size = 5
        passes = 2
    }

    active_opacity = 1
    inactive_opacity = 0.8
    fullscreen_opacity = 1

    drop_shadow = true
    shadow_range = 80
    shadow_offset = 0 0
    shadow_render_power = 3
    shadow_scale = 0.95
    col.shadow = rgba(000000d4)
}

animations {
    enabled = true

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = windows, 0, 0.5, 0, 1.3
    bezier = border, 0, 1, 0.7, 1
    bezier = workspaces, 0.3, 0, 0.2, 0.95

    animation = windows, 1, 5, windows
    animation = border, 1, 10, border
    animation = fade, 1, 7, windows
    animation = workspaces, 1, 4, workspaces
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # you probably want this
}

gestures {
    workspace_swipe = false
}

misc {
    disable_hyprland_logo = true
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = ${mod},       C,      killactive, 
bind = ${mod} SHIFT, Q,      exit, 
bind = ${mod},       F,      togglefloating, 
bind = ${mod},       B,      fullscreen
bind = ${mod},       P,      pseudo, # dwindle
bind = ${mod},       V,      togglesplit, # dwindle
bind = ${mod},       RETURN, exec, alacritty
bind = ${mod},       S,      exec, vivaldi-stable
bind = ${mod} SHIFT, S,      exec, grim $HOME/Pictures/$(date "+%y-%m-%d_%H:%M:%S").png -g $(slurp),
bind = ${mod},       R,      exec, wofi --show drun

# Move focus with mainMod + arrow keys
bind = ${mod}, H, movefocus, l
bind = ${mod}, L, movefocus, r
bind = ${mod}, K, movefocus, u
bind = ${mod}, J, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = ${mod}, 1, workspace, 1
bind = ${mod}, 2, workspace, 2
bind = ${mod}, 3, workspace, 3
bind = ${mod}, 4, workspace, 4
bind = ${mod}, 5, workspace, 5
bind = ${mod}, 6, workspace, 6
bind = ${mod}, 7, workspace, 7
bind = ${mod}, 8, workspace, 8
bind = ${mod}, 9, workspace, 9
bind = ${mod}, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = ${mod} SHIFT, 1, movetoworkspace, 1
bind = ${mod} SHIFT, 2, movetoworkspace, 2
bind = ${mod} SHIFT, 3, movetoworkspace, 3
bind = ${mod} SHIFT, 4, movetoworkspace, 4
bind = ${mod} SHIFT, 5, movetoworkspace, 5
bind = ${mod} SHIFT, 6, movetoworkspace, 6
bind = ${mod} SHIFT, 7, movetoworkspace, 7
bind = ${mod} SHIFT, 8, movetoworkspace, 8
bind = ${mod} SHIFT, 9, movetoworkspace, 9
bind = ${mod} SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = ${mod}, mouse_down, workspace, e+1
bind = ${mod}, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = ${mod}, mouse:272, movewindow
bindm = ${mod}, mouse:273, resizewindow
`;

const hyprland: Config = {
  enabled: () => !!HOME_DIR && $.commandExists("Hyprland"),

  files: () => [
    new Text([CONFIG_DIR, "hypr", "hyprland.conf"], config),
    new Download(wallpaper, "https://i.imgur.com/rpwtZgN.jpg"),
  ],
};

export default hyprland;
