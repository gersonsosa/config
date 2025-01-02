local wezterm = require("wezterm")

local config = wezterm.config_builder()
local actions = wezterm.action

-- TODO: can I use the colors defined in the theme rather than hardcoding them?
-- local tokyo_night = wezterm.color.get_builtin_schemes()["Tokyo Night Storm"]

local storm = {
  bg = "#24283b",
  bg_dark = "#1f2335",
  bg_highlight = "#292e42",
  blue = "#7aa2f7",
  blue0 = "#3d59a1",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#b4f9f8",
  blue7 = "#394b70",
  comment = "#565f89",
  cyan = "#7dcfff",
  dark3 = "#545c7e",
  dark5 = "#737aa2",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_gutter = "#3b4261",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  orange = "#ff9e64",
  purple = "#9d7cd8",
  red = "#f7768e",
  red1 = "#db4b4b",
  teal = "#1abc9c",
  terminal_black = "#414868",
  yellow = "#e0af68",
  git = {
    add = "#449dab",
    change = "#6183bb",
    delete = "#914c54",
  },
}

config.window_decorations = "RESIZE"
config.default_prog = { "/opt/homebrew/bin/bash", "-l" }
config.window_frame = {
  font = wezterm.font({ family = "Andale Mono", weight = "Regular" }),
  font_size = 15.0,
  active_titlebar_bg = storm.bg_dark,
}

config.initial_cols = 150
config.initial_rows = 45

config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true

config.window_background_opacity = 0.92
config.macos_window_background_blur = 20

config.font = wezterm.font("Maple Mono NF")
config.font_size = 16.5

config.scrollback_lines = 10000

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.visual_bell = {
  fade_in_duration_ms = 120,
  fade_out_duration_ms = 120,
  target = "CursorColor",
}

config.colors = {
  visual_bell = storm.red,
  tab_bar = {
    background = storm.bg_dark,
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = storm.bg_dark,
    active_tab = {
      -- The color of the background area for the tab
      bg_color = storm.bg_highlight,
      fg_color = storm.fg,
    },
    inactive_tab = {
      -- The color of the background area for the tab
      bg_color = storm.bg_dark,
      fg_color = storm.fg_gutter,
    },
    inactive_tab_hover = {
      -- The color of the background area for the tab
      bg_color = storm.fg_gutter,
      fg_color = storm.bg_dark,
    },
    new_tab = {
      bg_color = storm.bg_highlight,
      fg_color = storm.magenta,
    },
    new_tab_hover = {
      bg_color = storm.magenta,
      fg_color = storm.bg_highlight,
    },
  },
}

local SOLID_LEFT_CIRCLE = wezterm.nerdfonts.ple_left_half_circle_thick

wezterm.on("update-right-status", function(window, _)
  local color_scheme = window:effective_config().resolved_palette
  local fg = color_scheme.foreground
  local bg_search = storm.fg_dark
  local bg_visual = storm.bg_highlight
  local blue = storm.blue0
  local magenta = storm.magenta

  window:set_right_status(wezterm.format({
    -- First, we draw the arrow...
    { Background = { Color = color_scheme.background } },
    { Foreground = { Color = blue } },
    { Text = SOLID_LEFT_CIRCLE },
    -- Then we draw our text
    { Background = { Color = blue } },
    { Foreground = { Color = fg } },
    { Text = " " .. wezterm.hostname() .. " " },
    -- workspace
    { Background = { Color = blue } },
    { Foreground = { Color = bg_search } },
    { Text = SOLID_LEFT_CIRCLE },
    { Background = { Color = bg_search } },
    { Foreground = { Color = blue } },
    { Text = " " .. window:active_workspace() .. " " },
    -- date
    { Background = { Color = bg_search } },
    { Foreground = { Color = bg_visual } },
    { Text = SOLID_LEFT_CIRCLE },
    { Background = { Color = bg_visual } },
    { Foreground = { Color = magenta } },
    { Text = " " .. wezterm.strftime("%a %b %-d %H:%M") .. " " },
  }))
end)

config.keys = {
  { key = " ", mods = "CTRL|CMD", action = "QuickSelect" },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    description = wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { AnsiColor = "Purple" } },
      { Background = { AnsiColor = "Grey" } },
      { Text = "Fuzzy workspaces" },
    }),
    action = actions.ShowLauncherArgs({
      flags = "FUZZY|WORKSPACES",
    }),
  },
  {
    key = "s",
    mods = "CTRL|SHIFT",
    action = actions.PromptInputLine({
      prompt = "New workspace name > ",
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Purple" } },
        { Background = { AnsiColor = "Grey" } },
        { Text = "Creating a new workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            actions.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  { key = "l", mods = "LEADER", action = actions.ActivatePaneDirection("Right") },
  { key = "h", mods = "LEADER", action = actions.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = actions.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = actions.ActivatePaneDirection("Up") },
  { key = "n", mods = "LEADER", action = actions.ActivatePaneDirection("Next") },
  { key = "p", mods = "LEADER", action = actions.ActivatePaneDirection("Prev") },
  { key = "-", mods = "LEADER", action = actions.SplitVertical({ domain = "CurrentPaneDomain" }) },
  {
    key = "|",
    mods = "LEADER",
    action = actions.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { key = "x", mods = "CMD", action = actions.CloseCurrentPane({ confirm = true }) },
  { key = "x", mods = "LEADER", action = actions.CloseCurrentPane({ confirm = false }) },
  { key = "s", mods = "LEADER", action = actions.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
  { key = " ", mods = "LEADER", action = actions.PaneSelect },
}

local appearance = require("appearance")

if appearance.is_dark() then
  config.color_scheme = "Tokyo Night Storm"
else
  config.color_scheme = "Tokyo Night Moon"
end

return config
