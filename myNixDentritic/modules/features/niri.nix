{ self, inputs, ... }:

{
  perSystem = { pkgs, lib, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      v2-settings = true;

      settings = {
        prefer-no-csd = _: { };

        hotkey-overlay = {
          skip-at-startup = _: { };
        };

        screenshot-path =
          "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        input = {
          keyboard = {
            xkb = {
              layout = "us";
            };

            repeat-delay = 250;
            repeat-rate = 50;
          };

          touchpad = {
            tap = _: { };
            tap-button-map = "left-right-middle";
          };

          mouse = {
            accel-profile = "flat";
          };

          mod-key = "Super";
          mod-key-nested = "Alt";
        };

        layout = {
          gaps = 25;
          background-color = "transparent";
          center-focused-column = "never";

          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          default-column-width = {
            proportion = 0.5;
          };

          border = {
            off = _: { };
            width = 4;
            active-color = "#707070";
            inactive-color = "#d0d0d0";
            urgent-color = "#cc4444";
          };

          focus-ring = {
            off = _: { };
            width = 1;
            active-color = "#808080";
            inactive-color = "#505050";
          };

          shadow = {
            softness = 30;
            spread = 5;

            offset = {
              x = 0;
              y = 5;
            };

            color = "#0007";
          };

          struts = _: { };
        };

        gestures = {
          hot-corners = {
            # `off` was commented out in the original config.
          };
        };

        cursor = {
          xcursor-theme = "Bibata-Modern-Ice";
          xcursor-size = 24;
          hide-when-typing = _: { };
        };

        overview = {
          zoom = 0.75;

          # backdrop-color = "#777777";

          # workspace-shadow = {
          #   off = _: { };
          # };
        };

        window-rule = [
          {
            geometry-corner-radius = 16;
            clip-to-geometry = true;
          }

          {
            match = {
              is-active = false;
            };

            opacity = 0.9;
          }
        ];

        animations = {
          off = _: { };

          workspace-switch = {
            spring = {
              damping-ratio = 0.78;
              stiffness = 600;
              epsilon = 0.0001;
            };
          };

          window-open = {
            spring = {
              damping-ratio = 0.82;
              stiffness = 500;
              epsilon = 0.0001;
            };
          };

          window-close = {
            spring = {
              damping-ratio = 0.88;
              stiffness = 900;
              epsilon = 0.0001;
            };
          };

          horizontal-view-movement = {
            spring = {
              damping-ratio = 0.80;
              stiffness = 550;
              epsilon = 0.0001;
            };
          };

          window-movement = {
            spring = {
              damping-ratio = 0.85;
              stiffness = 650;
              epsilon = 0.0001;
            };
          };

          window-resize = {
            spring = {
              damping-ratio = 0.88;
              stiffness = 700;
              epsilon = 0.0001;
            };
          };

          config-notification-open-close = {
            spring = {
              damping-ratio = 0.90;
              stiffness = 800;
              epsilon = 0.0001;
            };
          };

          screenshot-ui-open = {
            spring = {
              damping-ratio = 0.85;
              stiffness = 750;
              epsilon = 0.0001;
            };
          };
        };

        environment = {
          XDG_CURRENT_DESKTOP = "niri";
          XDG_MENU_PREFIX = "plasma-";
          QT_QPA_PLATFORM = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          QT_LOGGING_RULES = "quickshell.dbus.properties=false";
          QT_QPA_PLATFORMTHEME = "kde";
          QT_STYLE_OVERRIDE = "Darkly";

          INIR_VENV = "$HOME/.local/state/quickshell/.venv";
          ILLOGICAL_IMPULSE_VIRTUAL_ENV =
            "$HOME/.local/state/quickshell/.venv";
        };

        spawn-at-startup = [
          {
            command = [
              "bash"
              "-c"
              "systemctl --user import-environment XDG_MENU_PREFIX && kbuildsycoca6"
            ];
          }

          {
            command = [
              "bash"
              "-c"
              "wl-paste --watch cliphist store &"
            ];
          }

          {
            command = [
              "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
            ];
          }
        ];

        binds = {
          "Mod+Tab" = {
            repeat = false;
            toggle-overview = _: { };
          };

          "Mod+Shift+E".quit = _: { };

          "Mod+Escape" = {
            allow-inhibiting = false;
            toggle-keyboard-shortcuts-inhibit = _: { };
          };

          "Alt+Tab".spawn = [
            "qs"
            "-c"
            "inir"
            "ipc"
            "call"
            "altSwitcher"
            "next"
          ];

          "Alt+Shift+Tab".spawn = [
            "qs"
            "-c"
            "inir"
            "ipc"
            "call"
            "altSwitcher"
            "previous"
          ];

          "Super+G".spawn = [
            "qs" "-c" "inir" "ipc" "call" "overlay" "toggle"
          ];

          "Mod+Space" = {
            repeat = false;
            spawn = [
              "inir"
              "overview"
              "toggle"
            ];
          };

          "Mod+Return".spawn = [ "kitty" ];

          "Mod+Q".close-window = _: { };

          "Mod+V".spawn = [
            "qs" "-c" "inir" "ipc" "call" "clipboard" "toggle"
          ];

          "Mod+Alt+L" = {
            allow-when-locked = true;
            spawn = [
              "qs" "-c" "inir" "ipc" "call" "lock" "activate"
            ];
          };

          "Mod+Shift+S".spawn = [
            "qs" "-c" "inir" "ipc" "call" "region" "screenshot"
          ];

          "Mod+Shift+X".spawn = [
            "qs" "-c" "inir" "ipc" "call" "region" "ocr"
          ];

          "Mod+Shift+A".spawn = [
            "qs" "-c" "inir" "ipc" "call" "region" "search"
          ];

          "Ctrl+Alt+T".spawn = [
            "qs" "-c" "inir" "ipc" "call" "wallpaperSelector" "toggle"
          ];

          "Mod+Comma".spawn = [
            "qs" "-c" "inir" "ipc" "call" "settings" "open"
          ];

          "Mod+Slash".spawn = [
            "qs" "-c" "inir" "ipc" "call" "cheatsheet" "toggle"
          ];

          "Mod+Shift+W".spawn = [
            "qs" "-c" "inir" "ipc" "call" "panelFamily" "cycle"
          ];

          "Super+E".spawn = [ "nautilus" ];

          "Super+W".spawn = [
            "bash" "-c" "xdg-open https://"
          ];

          "Mod+B".maximize-column = _: { };
          "Mod+G".fullscreen-window = _: { };
          "Mod+T".toggle-window-floating = _: { };

          "Mod+Left".focus-column-left = _: { };
          "Mod+Right".focus-column-right = _: { };
          "Mod+Up".focus-window-up = _: { };
          "Mod+Down".focus-window-down = _: { };

          "Mod+H".focus-column-left = _: { };
          "Mod+J".focus-window-down = _: { };
          "Mod+K".focus-window-up = _: { };
          "Mod+L".focus-column-right = _: { };

          "Mod+Shift+Left".move-column-left = _: { };
          "Mod+Shift+Right".move-column-right = _: { };
          "Mod+Shift+Up".move-window-up = _: { };
          "Mod+Shift+Down".move-window-down = _: { };

          "Mod+Shift+H".move-column-left = _: { };
          "Mod+Shift+J".move-window-down = _: { };
          "Mod+Shift+K".move-window-up = _: { };
          "Mod+Shift+L".move-column-right = _: { };

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Shift+Page_Down".move-workspace-down = _: { };
          "Mod+Shift+Page_Up".move-workspace-up = _: { };
          "Mod+Shift+U".move-workspace-down = _: { };
          "Mod+Shift+I".move-workspace-up = _: { };

          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            focus-workspace-down = _: { };
          };

          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            focus-workspace-up = _: { };
          };

          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            move-column-to-workspace-down = _: { };
          };

          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            move-column-to-workspace-up = _: { };
          };

          "Mod+WheelScrollRight".focus-column-right = _: { };
          "Mod+WheelScrollLeft".focus-column-left = _: { };

          "Mod+Ctrl+WheelScrollRight".move-column-right = _: { };
          "Mod+Ctrl+WheelScrollLeft".move-column-left = _: { };

          "Mod+Shift+WheelScrollDown".focus-column-right = _: { };
          "Mod+Shift+WheelScrollUp".focus-column-left = _: { };

          "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = _: { };
          "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = _: { };

          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;

          "Print".screenshot = _: { };
          "Ctrl+Print".screenshot-screen = _: { };
          "Alt+Print".screenshot-window = _: { };

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            spawn = [ "qs" "-c" "inir" "ipc" "call" "audio" "volumeUp" ];
          };

          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            spawn = [ "qs" "-c" "inir" "ipc" "call" "audio" "volumeDown" ];
          };

          "XF86AudioMute" = {
            allow-when-locked = true;
            spawn = [ "qs" "-c" "inir" "ipc" "call" "audio" "mute" ];
          };

          "XF86AudioMicMute" = {
            allow-when-locked = true;
            spawn = [ "qs" "-c" "inir" "ipc" "call" "audio" "micMute" ];
          };

          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            spawn = [ "qs" "-c" "inir" "ipc" "call" "brightness" "increment" ];
          };

          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            spawn = [ "qs" "-c" "inir" "ipc" "call" "brightness" "decrement" ];
          };

          "XF86AudioPlay".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "playPause" ];
          "XF86AudioPause".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "playPause" ];
          "XF86AudioNext".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "next" ];
          "XF86AudioPrev".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "previous" ];

          "Ctrl+Mod+Space".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "playPause" ];
          "Mod+Alt+N".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "next" ];
          "Mod+Alt+P".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "previous" ];

          "Mod+Shift+M".spawn = [ "qs" "-c" "inir" "ipc" "call" "audio" "mute" ];
          "Mod+Shift+P".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "playPause" ];
          "Mod+Shift+N".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "next" ];
          "Mod+Shift+B".spawn = [ "qs" "-c" "inir" "ipc" "call" "mpris" "previous" ];

          "Mod+Shift+Q".spawn = [
            "qs" "-c" "inir" "ipc" "call" "session" "toggle"
          ];

          "Ctrl+Shift+T".spawn = [
            "qs" "-c" "inir" "ipc" "call" "wallpaperSelector" "toggle"
          ];
        };

        layer-rule = {
          "quickshell:iiBackdrop" = {
            match = {
              namespace = "quickshell:iiBackdrop";
            };

            place-within-backdrop = _: { };
            opacity = 1.0;
          };

          "quickshell:wBackdrop" = {
            match = {
              namespace = "quickshell:wBackdrop";
            };

            place-within-backdrop = _: { };
            opacity = 1.0;
          };
        };

        outputs = {
          "DP-1" = {
            mode = "1920x1080@143.855";
          };
        };
      };
    };
}