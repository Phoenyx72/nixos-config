hl.on("hyprland.start", function () 
    hl.exec_cmd("/nix/store/m155fm3k16h7db5x89nab5s8qgpnsrwd-polkit-gnome-0.105/libexec/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("ambxst")
    hl.exec_cmd("sunshine")
end)

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl output create headless")

    -- wait for the output to exist
    hl.exec_cmd("sleep 1")

    hl.monitor({
        output = "HEADLESS-1",
        mode = "1680x1050@60",
        position = "0x1080",
        scale = 1.5,
    })

    hl.workspace_rule({
        workspace = "name:remote",
        monitor = "HEADLESS-1",
    })
end)