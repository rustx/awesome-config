--- Utils functions needed by widget modules

--- Gears filesystem
local gfs = require("gears.filesystem")
local awful = require("awful")

local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_dir("config")


function get_tuntap_ifaces()
	local iface = {}
    for line in io.lines("/proc/net/dev") do
        local dev = string.match(line, '%s+([tun|tap]-[%d]-):%s+')
        if dev ~= nil then
            table.insert(iface, dev)
        end
    end
    return iface
end

function get_active_ifaces()
    local iface = {}
    for line in io.lines("/proc/net/dev") do
        local dev = string.match(line, '^%s-([en|sl|wl|ww|pp|et][%l%d+]+):%s+')
        if dev ~= nil then
            iface[dev] = { ip = 'test' }
            -- table.insert(iface, dev)
        end
    end
    return iface
end

function readfile(path, mode)
	local f, ret

	f = assert(io.open(path, "r"))
	ret = f:read(mode)
	f:close()

	return ret
end

function get_theme()
	local theme = os.getenv('AWESOME_THEME')
	if theme == nil then
		theme = 'teknicity'
		print('Theme set to default (' .. theme .. ')')
	else
		print('Theme set to custom (' .. theme .. ')')
	end
	return theme
end

function get_theme_path()
	local theme = get_theme()
	return config_path .. "themes/" .. theme .. "/"
end

function get_touchpad_ids()
    local f
	local ids = {}
    awful.spawn.with_line_callback("xinput list", {
        stdout = function(line)
            if string.find(line, "TouchPad") or string.find(line, "GlidePoint") then
                table.insert(ids, string.match(line, '.*id=(%d+).'))
                print("Touchpad id found :" .. string.match(line, '.*id=(%d+).') )
            elseif string.find(line, 'Touchpad') then
                table.insert(ids, string.match(line, '.*id=(%d+).'))
                print("Touchpad id found :" .. string.match(line, '.*id=(%d+).'))
            elseif string.find(line, "Xephyr virtual mouse") then
                table.insert(ids, string.match(line, '.*id=(%d+).'))
                print("Touchpad id found :" .. string.match(line, '.*id=(%d+).'))
            end
        end
    })

    return ids
end

function get_stick_id()
    local id

    awful.spawn.with_line_callback("xinput list", {
        stdout = function(line)
            if string.find(line,"Stick") then
                id = string.match(line, 'id=(%d+).')
			    print("Stick id is " .. id)
            end
        end
    })

    return id
end

function get_screen(tag)
	local screen_count = screen.count()

	if tag == 'www' or tag == 'mail'  then
		if screen_count == 1 then
			return 1
		else
			return 2
		end
	end
	if tag == 'dev' or tag == 'desk' or tag == 'sys' then
		return 1
	end
	if tag == 'shell' or tag == 'irc' or tag == 'media' then
		if screen_count == 3 then
			return 3
		else
			return 1
		end
	end
	if tag == 'zik' then
		return screen_count
	end

end

function getnbcore()
	local ret, line, tmp

	for line in io.lines("/proc/cpuinfo") do
		tmp= string.match(line, "processor%s:%s+(%d+)")
		if tmp then
			ret = tmp
		end
	end

	return ret + 1
end

function moc_control(action)
    local info, state

    if action == "next" then
        awful.spawn("mocp --next")
    elseif action == "previous" then
        awful.spawn("mocp --previous")
    elseif action == "stop" then
        awful.spawn("mocp --stop")
    elseif action == "play" then
        awful.spawn.easy_async_with_shell("mocp -i", function(stdout, stderr, reason, exit_code)
            for line in string.gmatch(stdout, "[^\r\n]+") do
                if string.find(line, 'State:') then
                    state = string.match(line, "State: (%a+)")
                end
                if state == "PLAY" then
                    awful.spawn("mocp --pause")
                elseif state == "PAUSE" then
                    awful.spawn("mocp --unpause")
                elseif state == "STOP" then
                    awful.spawn("mocp --play")
                end
            end
        end)
    end
end

