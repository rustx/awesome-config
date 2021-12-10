--
-- helpers.lua
-- helper functions
--

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local beautiful = require("beautiful")

local https = require("ssl.https")
local http  = require("socket.http")
local ltn12 = require("ltn12")
local mime  = require("mime")

local helpers = {}

-- ========================================
-- Package
-- ========================================

-- Check package exists
helpers.is_module_available = function (name)
  if package.loaded[name] then return true end

  for _, searcher in ipairs(package.searchers or package.loaders) do
    local loader = searcher(name)
    if type(loader) == "function" then
      package.preload[name] = loader
      return true
    end
  end

  return false
end

-- ========================================
-- WM
-- ========================================

-- When layout is max remove gaps
--helpers.set_gaps = function (screen, tag)
--  local layout = tag.layout
--  local topbar = screen.topbar
--
--  if (layout == awful.layout.suit.max) then
--    tag.gap = 0
--    topbar.x = screen.geometry.x
--    topbar.y = screen.geometry.y
--    topbar.width = screen.geometry.width
--    topbar:struts { top = beautiful.topbar_height }
--  else
--    tag.gap = beautiful.useless_gap
--    topbar.x = screen.geometry.x + beautiful.topbar_margin * 2
--    topbar.y = screen.geometry.y + beautiful.topbar_margin * 2
--    topbar.width = screen.geometry.width - beautiful.topbar_margin * 4
--    topbar:struts { top = beautiful.topbar_height + beautiful.topbar_margin * 2 }
--  end
--end

-- generate rounded rect shape
helpers.rrect = function (cr, w, h)
  gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
end

-- Right arrow separator
helpers.separators_arrow_right = function(col1, col2)
  local separators = { height = 0, width = 9 }
  local widget = wibox.widget.base.make_widget()
  widget.col1 = col1
  widget.col2 = col2

  widget.fit = function(_,  _, _)
    return separators.width, separators.height
  end

  widget.update = function(_, _)
    widget.col1 = col1
    widget.col2 = col2
    widget:emit_signal("widget::redraw_needed")
  end

  widget.draw = function(_, _, cr, width, height)
    if widget.col2 ~= "alpha" then
      cr:set_source_rgba(gears.color.parse_color(widget.col2))
      cr:new_path()
      cr:move_to(0, 0)
      cr:line_to(width, height/2)
      cr:line_to(width, 0)
      cr:close_path()
      cr:fill()

      cr:new_path()
      cr:move_to(0, height)
      cr:line_to(width, height/2)
      cr:line_to(width, height)
      cr:close_path()
      cr:fill()
    end

    if widget.col1 ~= "alpha" then
      cr:set_source_rgba(gears.color.parse_color(widget.col1))
      cr:new_path()
      cr:move_to(0, 0)
      cr:line_to(width, height/2)
      cr:line_to(0, height)
      cr:close_path()
      cr:fill()
    end
 end

 return widget
end

-- Left arrow separator
helpers.separators_arrow_left = function(col1, col2)
  local separators = { height = 0, width = 9 }
  local widget = wibox.widget.base.make_widget()
  widget.col1 = col1
  widget.col2 = col2

  widget.fit = function(_,  _, _)
    return separators.width, separators.height
  end

  widget.update = function(c1, c2)
    widget.col1 = c1
    widget.col2 = c2
    widget:emit_signal("widget::redraw_needed")
  end

  widget.draw = function(_, _, cr, width, height)
    if widget.col1 ~= "alpha" then
      cr:set_source_rgba(gears.color.parse_color(widget.col1))
      cr:new_path()
      cr:move_to(width, 0)
      cr:line_to(0, height/2)
      cr:line_to(0, 0)
      cr:close_path()
      cr:fill()

      cr:new_path()
      cr:move_to(width, height)
      cr:line_to(0, height/2)
      cr:line_to(0, height)
      cr:close_path()
      cr:fill()
    end

  if widget.col2 ~= "alpha" then
    cr:new_path()
    cr:move_to(width, 0)
    cr:line_to(0, height/2)
    cr:line_to(width, height)
    cr:close_path()

    cr:set_source_rgba(gears.color.parse_color(widget.col2))
    cr:fill()
  end
 end

 return widget
end

-- ========================================
-- Scripts
-- ========================================

-- make https request
helpers.https_request = function(host, url, user, pass)
  local resp = {}

  local status, code, head = https.request {
    method = "GET",
    url = host .. url,
    headers = {
      ["Authorization"] = "Basic " .. (mime.b64(user .. ":" .. pass)),
      ["Content-Type"] = "application/json"
    },
    sink = ltn12.sink.table(resp)
  }
  if code == 200 then
    return resp, nil
  else
    return nil, code
  end
end

-- make http request
helpers.http_request = function(host, url, user, pass)
  local resp = {}

  local status, code, head = http.request {
    method = "GET",
    url = host .. url,
    headers = {
      ["Authorization"] = "Basic " .. (mime.b64(user .. ":" .. pass)),
      ["Content-Type"] = "application/json"
    },
    sink = ltn12.sink.table(resp)
  }
  if code == 200 then
    return resp, nil
  else
    return nil, code
  end
end

-- get main process name
helpers.get_main_process_name = function (cmd)
  -- remove whitespace
  cmd = cmd:gsub("%s+$", "")

  local first_space_idx = cmd:find(" ")

  return first_space_idx ~= nil
    and cmd:sub(0, first_space_idx - 1)
    or  cmd
end

-- set dynamic tags
helpers.dynamic_tags =  function(s)
  local tag_names = {}
  local tag_layouts = {}
  local count = screen:count()

  for _, tag in pairs(Tags) do
    if tag.screen[count] == s.index then
      table.insert(tag_names, tag.name)
      table.insert(tag_layouts, tag.layout)
    end
  end
  awful.tag(tag_names, s, tag_layouts)
end

-- set tags in appropriate screen
helpers.get_screen = function(t)
  for _, tag in pairs(Tags) do
    if tag.name == t then
      return tag.screen[screen:count()]
    end
  end
end

-- get percentage colors
helpers.get_pct_color = function(pct, dir)
  local colors = {
    [25]  = { up = beautiful.fg_normal,    down = beautiful.color.red    },
    [50]  = { up = beautiful.color.yellow, down = beautiful.color.orange },
    [75]  = { up = beautiful.color.orange, down = beautiful.color.yellow },
    [100] = { up = beautiful.color.red,    down = beautiful.fg_normal    },
  }
  if pct <= 25 then
    return colors[25][dir]
  elseif pct > 25  and pct <= 50 then
    return colors[50][dir]
  elseif pct > 50 and pct <= 75 then
    return colors[75][dir]
  elseif pct > 75 then
    return colors[100][dir]
  end
end

-- get vpn interfaces
helpers.get_tuntap_ifaces = function()
	local iface = {}
    for line in io.lines("/proc/net/dev") do
      local dev = string.match(line, '%s+([tun|tap]-[%d]-):%s+')
      if dev ~= nil then
        table.insert(iface, dev)
      end
    end
	return iface
end

-- get active interfaces
helpers.get_active_ifaces = function()
    local iface = {}
    for line in io.lines("/proc/net/dev") do
      local dev = string.match(line, '^%s-([en|sl|wl|ww|pp|et][%l%d+]+):%s+')
      if dev ~= nil and dev ~= "lo" then
         table.insert(iface, dev)
      end
    end
	return iface
end

-- get touchpad ids
helpers.get_touchpad_ids = function()
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

-- get stick ids
helpers.get_stick_id = function()
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

-- start a monitoring script and monitor its output
helpers.start_monitor = function (script, callbacks)
  -- remove whitespace and escape quotes
  script = script:gsub("^%s+", ""):gsub("%s+$", ""):gsub('"', '\\"')

  local monitor_script = string.format(
    [[ bash -c "%s" ]],
    script
  )
  local kill_monitor_script = string.format(
    [[ pkill %s ]],
    helpers.get_main_process_name(script)
  )

  -- First, kill any existing monitor processes
  awful.spawn.easy_async_with_shell(kill_monitor_script, function ()
    -- Start monitor process
    awful.spawn.with_line_callback(monitor_script, callbacks)
  end)
end

-- ========================================
-- Brightness
-- ========================================

-- change brightness
helpers.change_brightness = function (change_by)
  local cmd = change_by < 0
    and "light -U " .. -change_by
    or  "light -A " .. change_by

  awful.spawn.with_shell(cmd)
end

-- ========================================
-- Media Controls
-- ========================================

-- Play/Pause
helpers.media_play_pause = function ()
  local cmd = "playerctl play-pause"
  awful.spawn.with_shell(cmd)
end


-- Previous track
helpers.media_prev = function ()
  local cmd = "playerctl previous"
  awful.spawn.with_shell(cmd)
end


-- Next track
helpers.media_next = function ()
  local cmd = "playerctl next"
  awful.spawn.with_shell(cmd)
end


-- ========================================
-- Volume
-- ========================================

-- change volume
helpers.change_volume = function (change_by)
  local percentage = change_by < 0
    and string.format("-%s%%", -change_by)
    or  string.format("+%s%%", change_by)

  local cmd = "pactl set-sink-volume @DEFAULT_SINK@ " .. percentage

  awful.spawn.with_shell(cmd)
end


-- toggle volume mute
helpers.toggle_volume_mute = function ()
  local cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
  awful.spawn.with_shell(cmd)
end


-- ========================================
-- Language
-- ========================================

-- get language map index
helpers.get_language_map_index = function (key, val)
  for i, pair in ipairs(Languages) do
    if pair[key] == val then return i end
  end

  return nil
end


-- get language from engine name
helpers.get_language = function (engine)
  local index = helpers.get_language_map_index("engine", engine)

  return index == nil and "unknown" or Languages[index].lang
end


-- get engine name from Language
helpers.get_engine = function (language)
  local index = helpers.get_language_map_index("lang", language)

  return index == nil and "unknown" or Languages[index].engine
end


-- set language
helpers.set_language = function (language)
  local engine = helpers.get_engine(language)
  local set_engine_script = "ibus engine " .. engine

  awful.spawn.easy_async_with_shell(set_engine_script, function ()
    awesome.emit_signal("daemon::language", language)
  end)
end


-- switch language
helpers.switch_language = function ()
  awful.spawn.easy_async_with_shell("ibus engine", function (stdout)
    local curr_index = helpers.get_language_map_index("engine", stdout:gsub("%s+", ""))

    local next_index = curr_index == #Languages and 1 or curr_index + 1
    local next_language = Languages[next_index].lang
    helpers.set_language(next_language)
  end)
end

return helpers
