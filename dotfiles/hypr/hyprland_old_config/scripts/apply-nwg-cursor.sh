#!/usr/bin/env sh
set -eu

fallback_theme="${1:-default}"
fallback_size="${2:-24}"

default_index="${HOME}/.icons/default/index.theme"
gtk_settings="${HOME}/.config/gtk-3.0/settings.ini"

cursor_theme="$fallback_theme"
cursor_size="$fallback_size"

if [ -r "$default_index" ]; then
    cursor_theme="$(awk -F= '/^Inherits=/ {print $2; exit}' "$default_index")"
fi

if [ -r "$gtk_settings" ]; then
    cursor_size="$(awk -F= '/^gtk-cursor-theme-size=/ {print $2; exit}' "$gtk_settings")"
fi

cursor_theme="${cursor_theme:-$fallback_theme}"
cursor_size="${cursor_size:-$fallback_size}"

hyprctl setcursor "$cursor_theme" "$cursor_size"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
gsettings set org.gnome.desktop.interface cursor-size "$cursor_size"
