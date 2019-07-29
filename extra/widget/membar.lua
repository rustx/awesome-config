--[[

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local helpers              = require("lain.helpers")
local wibox                = require("wibox")
local gmatch, lines, floor = string.gmatch, io.lines, math.floor

-- Memory usage (ignoring caches)
-- extra.widget.membar

local function factory(args)
    local membar   = { widget = wibox.widget.progressbar() }
    local args     = args or {}
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    function membar.update()
        membar_now = {}
        for line in lines("/proc/meminfo") do
            for k, v in gmatch(line, "([%a]+):[%s]+([%d]+).+") do
                if     k == "MemTotal"     then membar_now.total = floor(v / 1024 + 0.5)
                elseif k == "MemFree"      then membar_now.free  = floor(v / 1024 + 0.5)
                elseif k == "Buffers"      then membar_now.buf   = floor(v / 1024 + 0.5)
                elseif k == "Cached"       then membar_now.cache = floor(v / 1024 + 0.5)
                elseif k == "SwapTotal"    then membar_now.swap  = floor(v / 1024 + 0.5)
                elseif k == "SwapFree"     then membar_now.swapf = floor(v / 1024 + 0.5)
                elseif k == "SReclaimable" then membar_now.srec  = floor(v / 1024 + 0.5)
                end
            end
        end

        membar_now.used = membar_now.total - membar_now.free - membar_now.buf - membar_now.cache - membar_now.srec
        membar_now.swapused = membar_now.swap - membar_now.swapf
        membar_now.perc = math.floor(membar_now.used / membar_now.total * 100)

        widget = membar.widget
        settings()
    end

    helpers.newtimer("membar", timeout, membar.update)

    return membar
end

return factory
