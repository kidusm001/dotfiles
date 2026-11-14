local host = require("host") -- machine-specific overrides, {} on unknown machines
require("monitor")
require("lua/plugins/hyprvim").setup({
	which_key = {
		enabled = true,
		delay_ms = 0,
		vim_delay_ms = 300,
		position = "bottom-right",
		auto_show = {
			disabled = { "NORMAL", "VISUAL", "V-LINE", "INSERT" },
			enabled = nil,
		},
	},
})

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "vicinae toggle"
local superMenu = "rofi -show combi"
local calcMenu = "rofi -show calc"
local browser = "zen-browser"
local picker = "hyprpicker -a"

hl.on("hyprland.start", function()
	hl.exec_cmd(host.hyprpaper_cmd or "hyprpaper")
	hl.exec_cmd(host.hypridle_cmd or "hypridle")
	hl.exec_cmd("waybar")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("vicinae server")

	-- Startup apps (a host file can replace this list)
	local startup_apps = host.startup_apps or {
		{ terminal, "1" },
		{ browser, "2" },
		{ "Telegram", "2" },
	}
	for _, app in ipairs(startup_apps) do
		hl.exec_cmd(app[1], { workspace = app[2] })
	end

	-- Electron app
	hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

	-- QT theme
	hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
	hl.env("QT_QPA_PLATFORM", "wayland")
	hl.env("QT_STYLE_OVERRIDE", "kvantum")

	-- GTK theme
	hl.env("GTK_THEME", "Catppuccin-Mauve-Dark")
	hl.env("GTK_COLOR_SCHEME", "prefer-dark")
end)

-- Bind workspaces 1-10 to laptop monitor
for i = 1, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

-- Bind workspaces 11-20 to the DP monitors
for _, output in ipairs({ "DP-2", "DP-3" }) do
	for i = 11, 20 do
		hl.workspace_rule({ workspace = tostring(i), monitor = output })
	end
end

-- HDMI monitors get their own 1-10: ID = base + n, shown as "n"
local hdmi_bases = { ["HDMI-A-1"] = 30, ["HDMI-A-2"] = 40 }
for output, base in pairs(hdmi_bases) do
	for i = 1, 10 do
		hl.workspace_rule({ workspace = tostring(base + i), monitor = output, default_name = tostring(i) })
	end
end

local function local_workspace(i)
	return (hdmi_bases[hl.get_active_monitor().name] or 0) + i
end

hl.config({

	general = {
		gaps_in = 3,
		gaps_out = 5,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(c7a96dee)", "rgba(f0dfbfee)" }, angle = 45 },
			inactive_border = "rgba(9b8a66aa)",
		},
		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 3,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows,
		active_opacity = 0.93,
		inactive_opacity = 0.89,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 3,
			ignore_opacity = true,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

-- GESTUTES

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up", action = "fullscreen" })

-- KEYBINDINGS
--
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(superMenu))
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.exec_cmd(calcMenu))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(picker))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/rofi/powermenu.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(
	"Print",
	hl.dsp.exec_cmd('bash "$HOME/.config/hypr/screenshot.sh" region')
)
hl.bind(
	mainMod .. " + Print",
	hl.dsp.exec_cmd('bash "$HOME/.config/hypr/screenshot.sh" all')
)

-- Move focus with mainMod + hjkl or arrows
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, function()
		hl.dispatch(hl.dsp.focus({ workspace = local_workspace(i) }))
	end)
	hl.bind(mainMod .. " + SHIFT + " .. key, function()
		hl.dispatch(hl.dsp.window.move({ workspace = local_workspace(i) }))
	end)
end

for i = 11, 20 do
	local key = i % 10
	if key == 0 then
		key = 10
	end
	hl.bind(mainMod .. " + F" .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + F" .. key, hl.dsp.window.move({ workspace = i }))
end

for i = 21, 30 do
	local key = i % 10
	if key == 0 then
		key = 10
	end
	hl.bind(mainMod .. " + CTRL + F" .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + CTRL + SHIFT + F" .. key, hl.dsp.window.move({ workspace = i }))
end

-- scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:276", hl.dsp.window.resize(), { mouse = true })

-- Move/resize windows with mainMod + h,j,k,l
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -10, y = 0 }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 10 }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 10, y = 0 }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 0, y = -10 }))

-- Laptop + a single HDMI screen: wrap around so the HDMI screen is reachable both ways
local function single_hdmi_setup()
	local monitors = hl.get_monitors()
	if #monitors ~= 2 then
		return nil
	end
	for _, m in ipairs(monitors) do
		if m.name:find("^HDMI") then
			return monitors
		end
	end
	return nil
end

-- Mouse: pushing past the outer left/right edge jumps to the opposite edge
hl.timer(function()
	local monitors = single_hdmi_setup()
	if not monitors then
		return
	end
	local min_x, max_x = math.huge, -math.huge
	local leftmost, rightmost
	for _, m in ipairs(monitors) do
		local right = m.x + m.width / m.scale
		if m.x < min_x then
			min_x, leftmost = m.x, m
		end
		if right > max_x then
			max_x, rightmost = right, m
		end
	end
	local c = hl.get_cursor_pos()
	local function target_y(from, to)
		local rel = (c.y - from.y) / (from.height / from.scale)
		return to.y + rel * (to.height / to.scale)
	end
	if c.x <= min_x then
		hl.dispatch(hl.dsp.cursor.move({ x = math.floor(max_x - 2), y = math.floor(target_y(leftmost, rightmost)) }))
	elseif c.x >= max_x - 1 then
		hl.dispatch(hl.dsp.cursor.move({ x = math.floor(min_x + 1), y = math.floor(target_y(rightmost, leftmost)) }))
	end
end, { timeout = 30, type = "repeat" })

-- Keyboard: focus / move windows to the other screen, either direction
hl.bind(mainMod .. " + ALT + H", hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + ALT + SHIFT + H", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + ALT + SHIFT + L", hl.dsp.window.move({ monitor = "+1" }))

hl.bind(mainMod .. " + SHIFT + N", hl.dsp.layout("swapnext"))

-- Laptop multimedia keys for volume and LCD brightness

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pamixer -i 5 && ~/.config/eww/volume/volume-popup.sh"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pamixer -d 5 && ~/.config/eww/volume/volume-popup.sh"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("pamixer -t && ~/.config/eww/volume/volume-popup.sh"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+ && ~/.config/eww/brightness/brightness-popup.sh"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%- && ~/.config/eww/brightness/brightness-popup.sh"),
	{ locked = true, repeating = true }
)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/hypr/nighlight.sh enable 3000"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("~/.config/hypr/nighlight.sh disable"))

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})
hl.window_rule({ opacity = "0.8 0.8", match = { class = "zeditor" } })
hl.window_rule({ opacity = "0.85 override 0.8 override", match = { class = "kitty" } })
hl.window_rule({ opacity = "1 override 0.8", match = { class = "mpv" } })

hl.layer_rule({
	name = "vicinae-rules",
	match = { namespace = "vicinae" },
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "rofi-rules",
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0,
})

hl.window_rule({
	name = "PiP-rules",
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	opacity = "1 override",
	size = { "monitor_w*0.25", "monitor_h*0.25" },
	move = { "monitor_w*0.74", "monitor_h*0.74" },
	match = { title = "^(Picture-in-Picture)$" },
})

hl.window_rule({
	name = "spotify-player",
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	render_unfocused = true,
	opacity = "1 override",
	no_blur = true,
	no_shadow = false,

	size = { "monitor_w*0.25", "monitor_h*0.25" },
	move = { "monitor_w*0.74", "monitor_h*0.74" },
	match = { class = "chromium-browser", title = ".*[•|].*" },
})

if host.apply then
	host.apply()
end

require("hyprcaffeine-keybinds")
