-- Alienware m17 R5 (home PC): NVIDIA hybrid GPU, 480Hz panel at scale 1.
-- Restored from the old hyprland.conf / monitor.conf on this machine.

-- NVIDIA / renderer env (set at load time, like the old `env =` lines)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_RENDERER", "vulkan")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("WLR_DRM_NO_ATOMIC", "1")

-- Screenshots + cursor
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")
hl.env("HYPRCURSOR_THEME", "GoogleDot-Black")
hl.env("HYPRCURSOR_SIZE", "25")

return {
	-- merged over the shared table in monitor.lua
	monitors = {
		["eDP-1"] = { mode = "1920x1080@480", position = "0x0", scale = 1 },
		["DP-2"] = { mode = "1280x1025@60", position = "1920x0", scale = 1 },
	},

	-- own wallpaper (lock screen: hosts/alienware-hyprlock.conf via Scripts/lock.sh)
	hyprpaper_cmd = "hyprpaper -c " .. os.getenv("HOME") .. "/.config/hypr/hosts/alienware-hyprpaper.conf",

	-- lock after 10 min idle instead of 5
	hypridle_cmd = "hypridle -c " .. os.getenv("HOME") .. "/.config/hypr/hosts/alienware-hypridle.conf",

	-- replaces the shared startup apps list in hyprland.lua
	startup_apps = {
		{ "kitty", "1" },
		{ "zen-browser", "2" },
		{ "Telegram", "3" },
		{ "vesktop", "3" },
		{ "spotify", "4" },
	},

	-- runs after the shared config
	apply = function()
		hl.config({ misc = { disable_hyprland_logo = true } })

		-- Catppuccin Mocha borders: Mauve/Pink active, Surface1 inactive
		hl.config({
			general = {
				col = {
					active_border = { colors = { "rgba(cba6f7ee)", "rgba(f5c2e7ee)" }, angle = 45 },
					inactive_border = "rgba(45475aaa)",
				},
			},
		})

		hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd("rofi -show combi"))
		hl.bind("F1", hl.dsp.exec_cmd("~/.config/hypr/Scripts/toggle_power.sh"))
	end,
}
