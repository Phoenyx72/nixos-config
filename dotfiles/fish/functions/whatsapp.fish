function whatsapp
    systemctl is-active --quiet waydroid-container
    or sudo systemctl start waydroid-container

    waydroid session start 2>/dev/null || true

    waydroid app launch com.whatsapp
end
