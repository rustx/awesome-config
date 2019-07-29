--[[

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")
local math     = math
local string   = string
local dpi      = require("beautiful.xresources").apply_dpi
local gears    = require("gears")
local beautiful = require("beautiful")
local tostring = tostring

-- CPU usage
-- lain.widget.cpu

local function factory(args)
    local cpubar   = { core = {}, widget = wibox.widget.progressbar {} }
    local args     = args or {}
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    function cpubar.update()
        -- Read the amount of time the CPUs have spent performing
        -- different kinds of work. Read the first line of /proc/stat
        -- which is the sum of all CPUs.
        for index,time in pairs(helpers.lines_match("cpu","/proc/stat")) do
            local coreid = index - 1
            local core   = cpubar.core[coreid] or
                           { last_active = 0 , last_total = 0, usage = 0 }
            local at     = 1
            local idle   = 0
            local total  = 0

            for field in string.gmatch(time, "[%s]+([^%s]+)") do
                -- 4 = idle, 5 = ioWait. Essentially, the CPUs have done
                -- nothing during these times.
                if at == 4 or at == 5 then
                    idle = idle + field
                end
                total = total + field
                at = at + 1
            end

            local active = total - idle

            if core.last_active ~= active or core.last_total ~= total then
                -- Read current data and calculate relative values.
                local dactive = active - core.last_active
                local dtotal  = total - core.last_total
                local usage   = math.ceil((dactive / dtotal) * 100)

                core.last_active = active
                core.last_total  = total
                core.usage       = usage

                -- Save current data for the next run.
                cpubar.core[coreid] = core
            end
        end

        cpubar_now = cpubar.core
        cpubar_now.usage = cpubar_now[0].usage
        widget = cpubar.widget

        settings()
    end

    helpers.newtimer("cpubar", timeout, cpubar.update)

    return cpubar
end

return factory
