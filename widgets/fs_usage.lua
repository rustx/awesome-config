--
-- fs_usage.lua
-- fs usage widget
--

local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "fs/"

-- ========================================
-- Definition
-- ========================================

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

local create_widget = function (screen)
  local widget = wibox.widget{
    {
      id = "image",
      image = icons_path .. "fs.svg",
      widget = wibox.widget.imagebox
    },
    {
      id = "text",
      widget = wibox.widget.textbox
    },
    id = "container",
    layout = wibox.layout.fixed.horizontal,
  }

  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  local mp = mount_points()

  local base = " [%s] ${%s used_p}%%"
  local display = ''

  for _, fs in pairs(mp) do
    display = display .. string.format(base, fs, fs, fs, fs)
  end

  vicious.cache(vicious.widgets.fs)
  vicious.register(text_widget, vicious.widgets.fs, display, 59)

  local container = require("widgets.clickable_container")(widget)

  image_widget.tooltip = require("widgets.tooltip")({ container })
  image_widget.tooltip.text = "Fs usage"

  return container
end

return create_widget