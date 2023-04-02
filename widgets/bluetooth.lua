--
-- bluetooth.lua
-- bluetooth widget
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "bluetooth/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function(screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(Apps.bluetooth_manager) end
    )
  )
end

-- update widget
local update_widget = function(widget, info)
  local icon_name
  local status

  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  if info.status == "UP" then
    icon_name = "bluetooth.svg"
    status = "on"
    text_widget:set_markup('<span> ' .. info.device .. '</span>')
    image_widget.tooltip.text = string.format(
      "Bluetooth is %s\nDevice: %s\nName: %s\nMac: %s",
      status, info.device, info.name, info.mac
    )
  else
    icon_name = "bluetooth-off.svg"
    status = "off"
    text_widget:set_markup('<span color="' .. beautiful.color.red .. '"> ' .. info.device and info.device or
    "N/A" .. '</span>')
    image_widget.tooltip.text = string.format(
      "Bluetooth is %s\nDevice: %s\nMac: %s",
      status, info.device, info.mac
    )
  end

  image_widget.image = icons_path .. icon_name
end


-- create widget instance
local create_widget = function(screen)
  local widget = wibox.widget {
    {
      id = "image",
      image = icons_path .. "bluetooth.svg",
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

  awesome.connect_signal("daemon::bluetooth::info", function(...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  image_widget.tooltip = require("widgets.tooltip")({ container })
  image_widget.tooltip.text = "Bluetooth status unknown"

  return container
end

return create_widget
