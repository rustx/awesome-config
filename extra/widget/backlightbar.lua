--[[

     Licensed under GNU General Public License v2
      * (c) 2015, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local naughty  = require("naughty")
local wibox    = require("wibox")
local string   = string

-- Brightness Bar Widget
-- current brightness
-- extra.widget.brightnessbar

local function factory(args)
    local backlight             = { widget = wibox.widget.progressbar()  }
    local args                  = args or {}
    local timeout               = args.timeout or 10 -- 1 min
    local current_call          = args.current_call  or "gobacklight -g"
    local backlight_na_markup   = args.backlight_na_markup or 0
    local settings              = args.settings or function() end

    backlight.widget:set_value(backlight_na_markup)

    function backlight.hide()
        if backlight.notification then
            naughty.destroy(backlight.notification)
            backlight.notification = nil
        end
    end

    function backlight.update()
        local cmd = string.format(current_call)
        helpers.async(cmd, function(f)
            backlight_now = f

            if  backlight_now ~= '' then
                widget = backlight.widget
                widget:set_value(backlight_now)
                settings()
            else
                backlight.widget:set_value(backlight_na_markup)
            end

        end)
    end

    backlight.timer = helpers.newtimer("backlight" , timeout, backlight.update, false, true)

    return backlight
end

return factory
