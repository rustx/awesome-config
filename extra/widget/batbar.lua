--[[

	 Licensed under GNU General Public License v2
	  * (c) 2013,      Luca CPZ
	  * (c) 2010-2012, Peter Hofmann

--]]

local helpers  = require("lain.helpers")
local fs       = require("gears.filesystem")
local naughty  = require("naughty")
local wibox    = require("wibox")
local math     = math
local string   = string
local ipairs   = ipairs
local tonumber = tonumber

-- Battery infos
-- extra.widget.batbar

local function factory(args)
    local pspath = args.pspath or "/sys/class/power_supply/"

    if not fs.is_dir(pspath) then
        naughty.notify { text = "lain.widget.bat: invalid power supply path", timeout = 0 }
        return
    end

    local batbar      = { widget = wibox.widget.progressbar() }
    local args        = args or {}
    local timeout     = args.timeout or 30
    local notify      = args.notify or "on"
    local full_notify = args.full_notify or notify
    local n_perc      = args.n_perc or { 5, 15 }
    local batteries   = args.batteries or (args.battery and {args.battery}) or {}
    local ac          = args.ac or "AC0"
    local settings    = args.settings or function() end

    function batbar.get_batteries()
        helpers.line_callback("ls -1 " .. pspath, function(line)
            local bstr =  string.match(line, "BAT%w+")
            if bstr then
                batteries[#batteries + 1] = bstr
            else
                ac = string.match(line, "A%w+") or "AC0"
            end
        end)
    end

    if #batteries == 0 then batbar.get_batteries() end

    batbar_notification_critical_preset = {
        title   = "Battery exhausted",
        text    = "Shutdown imminent",
        timeout = 15,
        fg      = "#000000",
        bg      = "#FFFFFF"
    }

    batbar_notification_low_preset = {
        title   = "Battery low",
        text    = "Plug the cable!",
        timeout = 15,
        fg      = "#202020",
        bg      = "#CDCDCD"
    }

    batbar_notification_charged_preset = {
        title   = "Battery full",
        text    = "You can unplug the cable",
        timeout = 15,
        fg      = "#202020",
        bg      = "#CDCDCD"
    }

    batbar_now = {
        status    = "N/A",
        ac_status = "N/A",
        perc      = "N/A",
        time      = "N/A",
        watt      = "N/A"
    }

    batbar_now.n_status = {}
    batbar_now.n_perc   = {}
    for i = 1, #batteries do
        batbar_now.n_status[i] = "N/A"
        batbar_now.n_perc[i] = 0
    end

    -- used to notify full charge only once before discharging
    local fullnotification = false

    function batbar.update()
        local sum_rate_current = 0
        local sum_rate_voltage = 0
        local sum_rate_power   = 0
        local sum_rate_energy  = 0
        local sum_energy_now   = 0
        local sum_energy_full  = 0

        for i, battery in ipairs(batteries) do
            local bstr    = pspath .. battery
            local present = helpers.first_line(bstr .. "/present")

            if tonumber(present) == 1 then
                -- current_now(I)[uA], voltage_now(U)[uV], power_now(P)[uW]
                local rate_current = tonumber(helpers.first_line(bstr .. "/current_now"))
                local rate_voltage = tonumber(helpers.first_line(bstr .. "/voltage_now"))
                local rate_power   = tonumber(helpers.first_line(bstr .. "/power_now"))

                -- energy_now(P)[uWh], charge_now(I)[uAh]
                local energy_now = tonumber(helpers.first_line(bstr .. "/energy_now") or
                                   helpers.first_line(bstr .. "/charge_now"))

                -- energy_full(P)[uWh], charge_full(I)[uAh]
                local energy_full = tonumber(helpers.first_line(bstr .. "/energy_full") or
                                    helpers.first_line(bstr .. "/charge_full"))

                local energy_percentage = tonumber(helpers.first_line(bstr .. "/capacity")) or
                                          math.floor((energy_now / energy_full) * 100)

                batbar_now.n_status[i] = helpers.first_line(bstr .. "/status") or "N/A"
                batbar_now.n_perc[i]   = energy_percentage or batbar_now.n_perc[i]

                sum_rate_current = sum_rate_current + (rate_current or 0)
                sum_rate_voltage = sum_rate_voltage + (rate_voltage or 0)
                sum_rate_power   = sum_rate_power + (rate_power or 0)
                sum_rate_energy  = sum_rate_energy + (rate_power or (((rate_voltage or 0) * (rate_current or 0)) / 1e6))
                sum_energy_now   = sum_energy_now + (energy_now or 0)
                sum_energy_full  = sum_energy_full + (energy_full or 0)
            end
        end

        -- When one of the battery is charging, others' status are either
        -- "Full", "Unknown" or "Charging". When the laptop is not plugged in,
        -- one or more of the batteries may be full, but only one battery
        -- discharging suffices to set global status to "Discharging".
        batbar_now.status = batbar_now.n_status[1]
        for _,status in ipairs(batbar_now.n_status) do
            if status == "Discharging" or status == "Charging" then
                batbar_now.status = status
            end
        end
        batbar_now.ac_status = tonumber(helpers.first_line(string.format("%s%s/online", pspath, ac))) or "N/A"

        if batbar_now.status ~= "N/A" then
            if batbar_now.status ~= "Full" and sum_rate_power == 0 and batbar_now.ac_status == 1 then
                batbar_now.perc  = math.floor(math.min(100, (sum_energy_now / sum_energy_full) * 100))
                batbar_now.time  = "00:00"
                batbar_now.watt  = 0

            -- update {perc,time,watt} iff battery not full and rate > 0
            elseif batbar_now.status ~= "Full" then
                local rate_time = 0
                -- Calculate time and watt if rates are greater then 0
                if (sum_rate_power > 0 or sum_rate_current > 0) then
                    local div = (sum_rate_power > 0 and sum_rate_power) or sum_rate_current

                    if batbar_now.status == "Charging" then
                        rate_time = (sum_energy_full - sum_energy_now) / div
                    else -- Discharging
                        rate_time = sum_energy_now / div
                    end

                    if 0 < rate_time and rate_time < 0.01 then -- check for magnitude discrepancies (#199)
                        rate_time_magnitude = math.abs(math.floor(math.log10(rate_time)))
                        rate_time = rate_time * 10^(rate_time_magnitude - 2)
                    end
                 end

                local hours   = math.floor(rate_time)
                local minutes = math.floor((rate_time - hours) * 60)
                batbar_now.perc  = math.floor(math.min(100, (sum_energy_now / sum_energy_full) * 100))
                batbar_now.time  = string.format("%02d:%02d", hours, minutes)
                batbar_now.watt  = tonumber(string.format("%.2f", sum_rate_energy / 1e6))
            elseif bat_now.status == "Full" then
                batbar_now.perc  = 100
                batbar_now.time  = "00:00"
                batbar_now.watt  = 0
            end
        end

        widget = batbar.widget
        settings()

        -- notifications for critical, low, and full levels
        if notify == "on" then
            if batbar_now.status == "Discharging" then
                if tonumber(batbar_now.perc) <= n_perc[1] then
                    batbar.id = naughty.notify({
                        preset = batbar_notification_critical_preset,
                        replaces_id = batbar.id
                    }).id
                elseif tonumber(batbar_now.perc) <= n_perc[2] then
                    batbar.id = naughty.notify({
                        preset = batbar_notification_low_preset,
                        replaces_id = batbar.id
                    }).id
                end
                fullnotification = false
            elseif batbar_now.status == "Full" and full_notify == "on" and not fullnotification then
                batbar.id = naughty.notify({
                    preset = batbar_notification_charged_preset,
                    replaces_id = batbar.id
                }).id
                fullnotification = true
            end
        end
    end

    helpers.newtimer("batteriesbar", timeout, batbar.update)

    return batbar
end

return factory
