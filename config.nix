{ pkgs, assets, inputs, ... }: let 
  rofi = "${inputs.rofi.packages.x86_64-linux.rofi}/bin/rofi";
  volume = "${inputs.volume.packages.x86_64-linux.volume}/bin/volume";
  brightness = "${inputs.brightness.packages.x86_64-linux.brightness}/bin/brightness";
  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  gsound-play = "${pkgs.gsound}/bin/gsound-play";
  dbus-update-activation-environment = "${pkgs.dbus}/bin/dbus-update-activation-environment";
  waybar = "${inputs.waybar.packages.x86_64-linux.waybar}/bin/waybar";
  swaynag = "${pkgs.sway}/bin/swaynag";
in ''
    font pango:monospace 8.000000
    floating_modifier Mod4
    default_border pixel 2
    default_floating_border pixel 2
    hide_edge_borders none
    focus_wrapping no
    focus_follows_mouse yes
    focus_on_window_activation smart
    mouse_warping output
    workspace_layout default
    workspace_auto_back_and_forth no

    client.focused #ff0000 #ff0000 #000000 #ff0000 #ff441e
    client.focused_inactive #ffffff #ffffff #000000 #0000ff #ffffff00
    client.unfocused #ffffff #ffffff #000000 #00ff00 #dddddd
    client.urgent #2f343a #900000 #ffffff #900000 #900000
    client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
    client.background #ffffff

    input "*" {
      natural_scroll enabled
      repeat_delay 300
      tap enabled
      xkb_layout gb
    }

    output "*" {
      background ${assets}/wallpapers/inkwater.jpg fill
    }

    bindsym --release Super_L exec ${rofi} -show drun -show-icons -display-drun -i Apps
    bindsym Mod1+Control+Shift+Escape mode default
    bindsym Mod4+Escape kill
    bindsym Mod4+Left focus left
    bindsym Mod4+Right focus right
    bindsym Mod4+Shift+Escape exec ${swaynag} -t warning -m "Shutdown?" -b "Shutdown" "systemctl poweroff"
    bindsym Mod4+Shift+Left move left
    bindsym Mod4+Shift+Right move right

    bindsym XF86AudioLowerVolume exec ${volume} down
    bindsym XF86AudioMute exec ${volume} toggle-mute
    bindsym XF86AudioRaiseVolume exec ${volume} up
    bindsym XF86MonBrightnessDown exec ${brightness} down
    bindsym XF86MonBrightnessUp exec ${brightness} up

    bindsym Print exec "${grimshot} save output & ${gsound-play} -f ${assets}/sounds/screenshot.wav"

    gaps top 20
    gaps outer 10
    gaps inner 10
    smart_gaps off
    smart_borders off

    bar {
      swaybar_command ${waybar}
    }

    exec "${dbus-update-activation-environment} --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE; systemctl --user start sway-session.target"
''
