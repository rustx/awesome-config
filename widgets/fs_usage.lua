--
-- fs_usage.lua
-- fs usage widget
--

local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mount_points = function()
  local mp = {}
  for line in io.lines("/proc/mounts") do
    local dev = string.match(line, "^/dev/([nvm|sd|hd][%a%d]-[%a%d]+)%s")
    if dev ~= nil then
      table.insert(mp,  string.match(line, dev .. " ([/%a]+)"))
    end
  end
  return mp
end

local get_color = function(pctuse)
  local color = beautiful.color.green
  if pctuse > 51 and pctuse < 71 then color = beautiful.color.yellow
  elseif pctuse > 71 and pctuse < 81 then color = beautiful.color.orange
  elseif pctuse > 81 then color = beautiful.color.red
  end
  return color
end

local create_widget = function (screen)
  local widget = wibox.widget.textbox()
  local mp = mount_points()

  local base = "[%s] ${%s used_p} %% "
  local display = ''

  for _, fs in pairs(mp) do
    display = display .. string.format(base, fs, fs, fs, fs)
  end

  vicious.cache(vicious.widgets.fs)
  vicious.register(widget, vicious.widgets.fs, display, 59)

  local container = require("widgets.clickable_container")(widget)

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Fs usage"

  return container
end

return create_widget