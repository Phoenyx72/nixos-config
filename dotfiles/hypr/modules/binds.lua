local terminal    = "kitty"

local mainMod = "SUPER"

-- Ambxst Binds
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("ambxst run launcher"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("ambxst run clipboard"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("ambxst run wallpapers"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("ambxst run overview"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("ambxst run powermenu"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("ambxst run lock-session"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("ambxst run screenshot"))
hl.bind(mainMod .. " + SHIFT + a", hl.dsp.exec_cmd("ambxst run lens"))

--My essentials
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Window Management
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))