--
-- bluetooth.lua
-- bluetooth daemon
--
-- Dependencies:
--   bluez
--   bluez-utils
--
-- Signals:
-- daemon::bluetooth::info
--   active (boolean)
--

local awful = require("awful")
local gears = require("gears")

-- ========================================
-- Config
-- ========================================

-- update_interval
local update_interval = 5

-- script to check bluetooth status
local check_script = "hciconfig -a"

-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_bluetooth_info = function ()
  awful.spawn.easy_async_with_shell(check_script, function (stdout)
    local info = {
      device = string.match(stdout, "^hci[%d]"),
      mac = string.match(stdout, "BD Address: ([%x+:?]+)"),
      status = string.match(stdout, "(DOWN)") or string.match(stdout,"(UP)"),
      name = string.match(stdout, "Name: '(%a+-%d)'")
    }
    awesome.emit_signal("daemon::bluetooth::info", info)
    awesome.emit_signal("daemon::bluetooth::status", info.status)
  end)
end

-- ========================================
-- Initialization
-- ========================================

gears.timer {
  timeout = update_interval,
  autostart = true,
  call_now = true,
  callback = emit_bluetooth_info,
}