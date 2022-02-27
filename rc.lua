--    ___      _____ ___  ___  __  __ _____      ____  __
--   /_\ \    / / __/ __|/ _ \|  \/  | __\ \    / /  \/  |
--  / _ \ \/\/ /| _|\__ \ (_) | |\/| | _| \ \/\/ /| |\/| |
-- /_/ \_\_/\_/ |___|___/\___/|_|  |_|___| \_/\_/ |_|  |_|
--

local gears   = require("gears")
local awful   = require("awful")
local helpers = require("helpers")

local config_dir = gears.filesystem.get_configuration_dir()

-- ========================================
-- User Config
-- ========================================

-- define default apps
Apps = {
  terminal          = "urxvtc",
  browser           = "brave-browser",
  scrlocker         = "xscreensaver-command --lock",
  editor            = os.getenv("EDITOR") or "vim",
  bluetooth_manager = "blueman-manager",
  volume_manager    = "pavucontrol",
  network_manager   = "nm-connection-editor",
  screenshot        = "maim",
  filebrowser       = "thunar",
  launcher          = "rofi -show drun",
}

-- network interfaces
local ifaces = helpers.get_active_ifaces()
Network_Interfaces = {
  wlan = string.match(table.concat(ifaces, " "), "wl[%l%d+]+" ),
  lan  = string.match(table.concat(ifaces, " "), "en[%l%d+]+" ),
}

-- language mappings
Languages = {
  { lang = "en", engine = "xkb:us::eng" },
  { lang = "fr", engine = "xkb:fr::fra" },
}

-- Crypto coins
Coins = {
  rates = {
    "bitcoin",
    "ethereum",
    "monero",
    "cosmos",
    "polkadot",
    "tezos",
    "matic-network"
  },
  currency = {
    name = "eur",
    symbol = "€"
  }
}

-- layouts
awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.magnifier,
}

-- tags
Tags = {
  { name = "web",   layout = awful.layout.layouts[1], screen = {1, 2, 2} },
  { name = "mail",  layout = awful.layout.layouts[1], screen = {1, 2, 2} },
  { name = "desk",  layout = awful.layout.layouts[1], screen = {1, 2, 1} },
  { name = "dev",   layout = awful.layout.layouts[1], screen = {1, 1, 1} },
  { name = "shell", layout = awful.layout.layouts[6], screen = {1, 2, 3} },
  { name = "talk",  layout = awful.layout.layouts[1], screen = {1, 1, 1} },
  { name = "media", layout = awful.layout.layouts[1], screen = {1, 2, 3} },
  { name = "sys",   layout = awful.layout.layouts[1], screen = {1, 1, 1} },
  { name = "games", layout = awful.layout.layouts[1], screen = {1, 2, 3} },
}

-- run these commands at startup
local startup_scripts = {
  -- Compose key remappings
  "xmodmap $HOME/.Xmodmap",
  -- Faster key repeat response
  --"xset r rate 200 30",
  -- Compositor
  "compton",
  -- Night mode
  "redshift-gtk",
  -- Set wallpaper
  "feh --bg-scale " .. config_dir .. "/wallpapers/forest_background.png",
  -- Start ibus
  "ibus-daemon -drx",
  -- Start urxvt daemon
  "urxvtd",
  -- Start unclutter
  "unclutter -root",
  -- Start network-manager applet
  "nm-applet",
  -- Start pulseaudio
  "pulseaudio",
  -- Start blueman-manager applet
  "blueman-applet",
  -- Start thunar daemon
  "thunar --daemon",
  -- Start xscreensaver
  "xscreensaver"
}

-- ========================================
-- Visualizations
-- ========================================

-- Load theme vars
local beautiful = require("beautiful")
beautiful.init(config_dir .. "theme.lua")

-- ========================================
-- Initialization
-- ========================================

-- Run all apps listed on start up
for _, app in ipairs(startup_scripts) do
  -- Don't spawn startup command if already exists
  awful.spawn.with_shell(string.format(
    [[ pgrep -u $USER -x %s > /dev/null || (%s) ]],
    helpers.get_main_process_name(app),
    app
  ))
end

-- Start daemons
require("daemons")

-- Load notifications
require("notifications")

-- Load components
require("components")

-- ========================================
-- Tags
-- ========================================

-- Each screen has its own specific tag table.
awful.screen.connect_for_each_screen(function(s)
  helpers.dynamic_tags(s)
end)

awful.screen.disconnect_for_each_screen(function(s)
  helpers.dynamic_tags(s)
end)

---- Remove gaps if layout is set to max
--tag.connect_signal("property::layout", function(t)
--  helpers.set_gaps(t.screen, t)
--end)
---- Layout might change in different tag
---- so update again when switched to another tag
--tag.connect_signal("property::selected", function(t)
--  helpers.set_gaps(t.screen, t)
--end)

-- ========================================
-- Keybindings
-- ========================================

local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- ========================================
-- Rules
-- ========================================

local rules = require("rules")
awful.rules.rules = rules

-- ========================================
-- Clients
-- ========================================

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- Set rounded corners for windows
  c.shape = helpers.rrect
end)

-- Set border color of focused client
client.connect_signal("focus", function (c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function (c)
  c.border_color = beautiful.border_normal
end)

-- Focus clients under mouse
require("awful.autofocus")
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- ========================================
-- Misc.
-- ========================================

-- Reload config when screen geometry change
screen.connect_signal("property::geometry", awesome.restart)

-- Garbage collection for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
