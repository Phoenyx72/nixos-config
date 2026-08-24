{ self, inputs, ... }: {

  perSystem = { pkgs, ... }: {
    
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {

      settings = {

        prefer-no-csd

        hotkey-overlay {
            skip-at-startup
        }

        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"


        input {
            keyboard {
                xkb {
                    layout "us"
                }
                repeat-delay 250
                repeat-rate 50
            }
            touchpad {
                tap
                tap-button-map "left-right-middle"
            }
            mouse {
                accel-profile "flat"
            }

            mod-key "Super"
            mod-key-nested "Alt"
        }


        layout {
            gaps 25
            background-color "transparent"
            center-focused-column "never"
            
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }
            
            default-column-width { 
                proportion 0.5
            }
            
            border {
                off
                width 4
                active-color   "#707070"
                inactive-color "#d0d0d0"
                urgent-color   "#cc4444"
            }
            
            focus-ring {
                off
                width 1
                active-color   "#808080"
                inactive-color "#505050"
            }
            
            shadow {
              // off
                softness 30
                spread 5
                offset x=0 y=5
                color "#0007"
            }
            
            struts { }
        }

        gestures {
            hot-corners {
                // off
            }
        }

        cursor {
            xcursor-theme "Bibata-Modern-Ice"
            xcursor-size 24
            hide-when-typing
        }

        overview {
            zoom 0.75

            // Uncomment to give the overview a solid backdrop between workspaces.
            //backdrop-color "#777777"

            // Uncomment to disable the workspace shadow in the overview.
            //workspace-shadow {
            //    off
            //}
        }


        window-rule {
            geometry-corner-radius 16
            clip-to-geometry true
        }

        window-rule { 
            match is-active=false
            opacity 0.9
        }


        animations {
            off
            

            workspace-switch {
                spring damping-ratio=0.78 stiffness=600 epsilon=0.0001
            }
            

            window-open {
                spring damping-ratio=0.82 stiffness=500 epsilon=0.0001
            }
            

            window-close {
                spring damping-ratio=0.88 stiffness=900 epsilon=0.0001
            }
            

            horizontal-view-movement {
                spring damping-ratio=0.80 stiffness=550 epsilon=0.0001
            }
            

            window-movement {
                spring damping-ratio=0.85 stiffness=650 epsilon=0.0001
            }
            

            window-resize {
                spring damping-ratio=0.88 stiffness=700 epsilon=0.0001
            }
            

            config-notification-open-close {
                spring damping-ratio=0.90 stiffness=800 epsilon=0.0001
            }
            

            screenshot-ui-open {
                spring damping-ratio=0.85 stiffness=750 epsilon=0.0001
            }
        }


        environment {
            XDG_CURRENT_DESKTOP "niri"
            XDG_MENU_PREFIX "plasma-"  // Required for Dolphin/KDE app file associations
            QT_QPA_PLATFORM "wayland"
            ELECTRON_OZONE_PLATFORM_HINT "auto"
            QT_LOGGING_RULES "quickshell.dbus.properties=false"
            
            QT_QPA_PLATFORMTHEME "kde"
            QT_STYLE_OVERRIDE "Darkly"
            
            // Quickshell Python virtual environment
            INIR_VENV "$HOME/.local/state/quickshell/.venv"
            ILLOGICAL_IMPULSE_VIRTUAL_ENV "$HOME/.local/state/quickshell/.venv"
        }



        spawn-at-startup "bash" "-c" "systemctl --user import-environment XDG_MENU_PREFIX && kbuildsycoca6"

        spawn-at-startup "bash" "-c" "wl-paste --watch cliphist store &"
        spawn-at-startup "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"


        binds {
            // System
            Mod+Tab repeat=false { toggle-overview; }
            Mod+Shift+E { quit; }
            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
            
            // ii Window Switcher (Alt+Tab)
            Alt+Tab { spawn "qs" "-c" "inir" "ipc" "call" "altSwitcher" "next"; }
            Alt+Shift+Tab { spawn "qs" "-c" "inir" "ipc" "call" "altSwitcher" "previous"; }
            
            // ii Overlay
            Super+G { spawn "qs" "-c" "inir" "ipc" "call" "overlay" "toggle"; }

            // ii Overview (daemon)
            Mod+Space repeat=false {
                spawn "inir" "overview" "toggle";
            }
            
            Mod+Return { spawn "kitty"; }

            Mod+Q { close-window; }

            // ii Clipboard
            Mod+V { spawn "qs" "-c" "inir" "ipc" "call" "clipboard" "toggle"; }
            
            // ii Lock screen
            Mod+Alt+L allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "lock" "activate"; }
            
            // ii Region tools
            Mod+Shift+S { spawn "qs" "-c" "inir" "ipc" "call" "region" "screenshot"; }
            Mod+Shift+X { spawn "qs" "-c" "inir" "ipc" "call" "region" "ocr"; }
            Mod+Shift+A { spawn "qs" "-c" "inir" "ipc" "call" "region" "search"; }
            
            // ii Wallpaper selector
            Ctrl+Alt+T { spawn "qs" "-c" "inir" "ipc" "call" "wallpaperSelector" "toggle"; }
            
            // ii Settings
            Mod+Comma { spawn "qs" "-c" "inir" "ipc" "call" "settings" "open"; }
            
            // ii Cheatsheet
            Mod+Slash { spawn "qs" "-c" "inir" "ipc" "call" "cheatsheet" "toggle"; }
            
            // ii Panel family (cycle between Material ii and Waffle styles)
            Mod+Shift+W { spawn "qs" "-c" "inir" "ipc" "call" "panelFamily" "cycle"; }
            
            // Applications (uses configured terminal from Settings)
            // Mod+T { spawn "bash" "-c" "$HOME/.config/quickshell/inir/scripts/launch-terminal.sh"; }
            // Mod+Return { spawn "bash" "-c" "$HOME/.config/quickshell/inir/scripts/launch-terminal.sh"; }
            Super+E { spawn "nautilus"; }
            Super+W { spawn "bash" "-c" "xdg-open https://"; }
            
            // Window management
            // Mod+Q repeat=false { spawn "bash" "-c" "$HOME/.config/quickshell/inir/scripts/close-window.sh"; }
            Mod+B { maximize-column; }
            Mod+G { fullscreen-window; }
            Mod+T { toggle-window-floating; }

            // Focus
            Mod+Left { focus-column-left; }
            Mod+Right { focus-column-right; }
            Mod+Up { focus-window-up; }
            Mod+Down { focus-window-down; }
            Mod+H { focus-column-left; }
            Mod+J { focus-window-down; }
            Mod+K { focus-window-up; }
            Mod+L { focus-column-right; }
            
            // Move windows
            Mod+Shift+Left { move-column-left; }
            Mod+Shift+Right { move-column-right; }
            Mod+Shift+Up { move-window-up; }
            Mod+Shift+Down { move-window-down; }
            Mod+Shift+H { move-column-left; }
            Mod+Shift+J { move-window-down; }
            Mod+Shift+K { move-window-up; }
            Mod+Shift+L { move-column-right; }
            
            // Workspaces
            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }


            Mod+Shift+Page_Down { move-workspace-down; }
            Mod+Shift+Page_Up   { move-workspace-up; }
            Mod+Shift+U         { move-workspace-down; }
            Mod+Shift+I         { move-workspace-up; }

            // You can bind mouse wheel scroll ticks using the following syntax.
            // These binds will change direction based on the natural-scroll setting.
            //
            // To avoid scrolling through workspaces really fast, you can use
            // the cooldown-ms property. The bind will be rate-limited to this value.
            // You can set a cooldown on any bind, but it's most useful for the wheel.
            Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
            Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
            Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

            Mod+WheelScrollRight      { focus-column-right; }
            Mod+WheelScrollLeft       { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft  { move-column-left; }

            // Usually scrolling up and down with Shift in applications results in
            // horizontal scrolling; these binds replicate that.
            Mod+Shift+WheelScrollDown      { focus-column-right; }
            Mod+Shift+WheelScrollUp        { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
            
            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            
            // Screenshots (native)
            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }
            
            // ========================================================================
            // HARDWARE KEYS - Audio, Brightness, Media
            // ========================================================================
            // These use ii IPC so the OSD (On Screen Display) shows feedback
            
            // Volume (hardware keys)
            XF86AudioRaiseVolume allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "audio" "volumeUp"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "audio" "volumeDown"; }
            XF86AudioMute allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "audio" "mute"; }
            XF86AudioMicMute allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "audio" "micMute"; }
            
            // Brightness (hardware keys)
            XF86MonBrightnessUp allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "brightness" "increment"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "qs" "-c" "inir" "ipc" "call" "brightness" "decrement"; }
            
            // Media playback (hardware keys)
            XF86AudioPlay { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "playPause"; }
            XF86AudioPause { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "playPause"; }
            XF86AudioNext { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "next"; }
            XF86AudioPrev { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "previous"; }
            
            // Music control (keyboard alternatives for keyboards without media keys)
            Ctrl+Mod+Space { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "playPause"; }
            Mod+Alt+N { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "next"; }
            Mod+Alt+P { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "previous"; }
            Mod+Shift+M { spawn "qs" "-c" "inir" "ipc" "call" "audio" "mute"; }
            Mod+Shift+P { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "playPause"; }
            Mod+Shift+N { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "next"; }
            Mod+Shift+B { spawn "qs" "-c" "inir" "ipc" "call" "mpris" "previous"; }
            
            // Power / Session
            Mod+Shift+Q { spawn "qs" "-c" "inir" "ipc" "call" "session" "toggle"; }
            Ctrl+Shift+T { spawn "qs" "-c" "inir" "ipc" "call" "wallpaperSelector" "toggle"; }

        }

        // Layer rules for ii backdrop visibility during Niri overview
        layer-rule {
            match namespace="quickshell:iiBackdrop"
            place-within-backdrop true
            opacity 1.0
        }

        layer-rule {
            match namespace="quickshell:wBackdrop"
            place-within-backdrop true
            opacity 1.0
        }

        output "DP-1" {
            mode "1920x1080@143.855"
        }

      }
    };

  };

}