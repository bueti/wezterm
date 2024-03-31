-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set the color scheme depending on the system setting
function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end
function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Frappe"
	end
end

-- This is where you actually apply your config choices
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.front_end = "WebGpu"
config.keys = {
	{ key = "LeftArrow", mods = "OPT", action = act({ SendString = "\x1bb" }) },
	{ key = "RightArrow", mods = "OPT", action = act({ SendString = "\x1bf" }) },
	{ key = "h", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{
		key = "k",
		mods = "CMD",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},

	{
		key = "e",
		mods = "CMD",
		action = act({
			QuickSelectArgs = {
				patterns = {
					"http?://\\S+",
					"https?://\\S+",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					wezterm.open_with(url)
				end),
			},
		}),
	},
}
config.color_scheme = scheme_for_appearance(get_appearance())
-- remove padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.font = wezterm.font("JetBrains Mono")
-- and finally, return the configuration to wezterm
return config
