--
-- brightness.lua
-- brightness status notification
--

local naughty = require("naughty")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

local icons_path = beautiful.icons_path .. "bluetooth/"

-- ========================================
-- Logic
-- ========================================

-- notify bluetooth down
local notify_bluetooth_down = function()
  naughty.notify {
    preset = naughty.config.presets.critical,
    icon = icons_path .. "bluetooth-off.svg",
    timeout = 5,
    title = "Bluetooth down",
    text = "Bluetooth is down "
  }
end

-- notify bluetooth up
local notify_bluetooth_up = function()
  naughty.notify {
    icon = icons_path .. "bluetooth.svg",
    timeout = 5,
    title = "Bluetooth up",
    text = "Bluetooth is up"
  }
end

-- Notify bluetooth change
local notify_bluetooth_change = function(status)
  if status == "DOWN" then
    notify_bluetooth_down()
  else
    notify_bluetooth_up()
  end
end

-- ========================================
-- Initialization
-- ========================================

local notification
local old_status

awesome.connect_signal("daemon::bluetooth::status", function(status)
  -- Remove existing notification
  if notification then
    naughty.destroy(notification)
  end

  if old_status ~= status then
    notification = notify_bluetooth_change(status)
  end
  old_status = status
end)
