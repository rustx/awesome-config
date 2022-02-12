--
-- crypo_rates.lua
-- crypto rates daemon
-- Dependencies:
--   curl
--
-- Signals:
-- daemon::crypto::rates
--   address (string)
--

local awful = require("awful")
local gears = require("gears")
local json = require("json")

-- ========================================
-- Config
-- ========================================

local update_interval = 33

local coins_list = Coins.rates
local coins_currency = Coins.currency.name
local currency_host = 'https://api.coingecko.com'

local build_price_url = function(coins_list)
  local price_url = '/api/v3/simple/price?ids='
  for _, coin in pairs(coins_list) do
    price_url = price_url .. coin ..  ','
  end
  return price_url:sub(1,-2) .. '&vs_currencies=' .. coins_currency
end

-- script to retrieve crypto rates
-- Subscribe to crypto rates changes
local monitor_script = "curl -s \""  .. currency_host .. build_price_url(coins_list) .. "\""

-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_currency_rates = function ()
  awful.spawn.easy_async_with_shell(monitor_script, function (stdout)
    local rates = json.decode(stdout)
      awesome.emit_signal("daemon::crypto::rates", rates)
  end)
end

-- ========================================
-- Initialization
-- ========================================

---- Run once to initialize widgets
--awful.spawn.easy_async_with_shell(check_script, function (stdout)
--  print("Stdout" .. stdout)
--  check_bluetooth(stdout)
--end)

emit_currency_rates()

gears.timer {
  timeout = update_interval,
  autostart = true,
  call_now = true,
  callback = emit_currency_rates,
}
