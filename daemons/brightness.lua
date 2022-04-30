--
-- brightness.lua
-- brightness daemon
-- Dependencies:
--   light
--   inotify-tools
--
-- Signals:
-- daemon::brightness::percentage
--   percentage (integer)
--

local awful = require("awful")
local helpers = require("helpers")


-- ========================================
-- Config
-- ========================================

local backlight_path = "/sys/class/backlight"

-- script to monitor volume events
-- Subscribe to backlight changes
local monitor_script = "[ ! -z \"$(ls -A " .. backlight_path .. ")\" ] && inotifywait -mq -e modify ".. backlight_path .. "/*/brightness || echo \"N/A\""

local brightness_script = "light -G"


-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_brightness_percentage = function ()
  awful.spawn.easy_async_with_shell(brightness_script, function (stdout)
    local percentage = math.floor(tonumber(stdout))

    awesome.emit_signal("daemon::brightness::percentage", percentage)
  end)
end


-- ========================================
-- Initialization
-- ========================================

-- Run once to initialize widgets
emit_brightness_percentage()


-- Start monitoring process
helpers.start_monitor(monitor_script, { stdout = emit_brightness_percentage })
