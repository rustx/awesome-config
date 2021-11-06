--
-- wanip.lua
-- wanip daemon
-- Dependencies:
--   curl
--
-- Signals:
-- daemon::wanip::address
--   address (string)
--

local awful = require("awful")
local gears = require("gears")

-- ========================================
-- Config
-- ========================================

local update_interval = 30

-- script to retrieve wan ip info
-- Subscribe to wanip changes
local monitor_script = "curl -s http://ipinfo.io/ip"

-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_wanip_address = function ()
  awful.spawn.easy_async_with_shell(monitor_script, function (stdout)
    local address = stdout

    awesome.emit_signal("daemon::wanip::address", address)
  end)
end

-- ========================================
-- Initialization
-- ========================================

gears.timer {
  timeout = update_interval,
  autostart = true,
  call_now = true,
  callback = emit_wanip_address,
}
