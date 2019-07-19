--[[

     Licensed under GNU General Public License v2
      * (c) 2015, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local naughty  = require("naughty")
local wibox    = require("wibox")
local string   = string

-- Wanip
-- current wan ip
-- extra.widget.wanip

local function factory(args)
    local wanip               = { widget = wibox.widget.textbox() }
    local args                  = args or {}
    local timeout               = args.timeout or 10 -- 1 min
    local current_call          = args.current_call  or "curl -s 'http://ipinfo.io/ip'"
    local wanip_na_markup       = args.wanip_na_markup or " N/A "
    local settings              = args.settings or function() end

    wanip.widget:set_markup(wanip_na_markup)

    function wanip.hide()
        if wanip.notification then
            naughty.destroy(wanip.notification)
            wanip.notification = nil
        end
    end

    function wanip.update()
        local cmd = string.format(current_call)
        helpers.async(cmd, function(f)
            wanip_now = f

            if  wanip_now ~= '' then
                widget = wanip.widget
                settings()
            else
                wanip.widget:set_markup(wanip_na_markup)
            end

        end)
    end

    wanip.timer = helpers.newtimer("wanip" , timeout, wanip.update, false, true)

    return wanip
end

return factory
