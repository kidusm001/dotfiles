-- Static monitor configuration
-- Use hl.monitor() for each known monitor

local monitor_settings = {
	["eDP-1"] = { mode = "1920x1080@60", position = "0x0", scale = 1.2 },
	["DP-2"] = { mode = "preferred", position = "auto-left", scale = 0.83, bitdepth = 10, cm = "srgb" },
	["DP-3"] = { mode = "preferred", position = "auto-left", scale = 0.83, bitdepth = 10, cm = "srgb" },
	["HDMI-A-1"] = { mode = "preferred", position = "auto", scale = 1 },
	["HDMI-A-2"] = { mode = "preferred", position = "auto", scale = 1 },
}

for output, settings in pairs(monitor_settings) do
	local args = { output = output }
	for key, value in pairs(settings) do
		args[key] = value
	end
	hl.monitor(args)
end
