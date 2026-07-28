hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@120",
    position = "0x0",
    scale    = "1",
})
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080",
    position = "1920x0",
    scale    = "1",
})
hl.monitor({
    output   = "HEADLESS-1",
    mode     = "2560x1600@60", -- Match your MacBook's 16:10 ratio
    position = "0x1080",         -- Place it cleanly out of the way
    scale    = "1.6",
})