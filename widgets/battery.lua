--
-- battery.lua
-- battery status widget
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local beautiful = require("beautiful")
local helpers = require("helpers")
local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "battery/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(Apps.power_manager) end
    )
  )
end


-- get battery icon
local get_battery_icon = function (percentage, status)
  if percentage == nil then return icons_path .. "charger-plugged.svg" end

  local icon_name = "battery"

  local rounded_charge = math.ceil(percentage / 10) * 10

  if status == "Charging" or status == "Full" then
    icon_name = icon_name .. "-charging"
  end

  if rounded_charge == 0 then
    icon_name = icon_name .. "-outline"
  elseif rounded_charge ~= 100 then
    icon_name = icon_name .. "-" .. rounded_charge
  end

  return icons_path .. icon_name .. ".svg"
end

-- update widget
local update_widget = function (widget, _, stat, summary)

  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  image_widget.image = get_battery_icon(stat.percentage, stat.status)
  image_widget.tooltip.text = string.gsub(summary, "\n$", "")

  text_widget:set_markup(
    '<span color="' .. helpers.get_pct_color(stat.percentage, "down") .. '"> ' .. stat.percentage .. '%</span>'
  )
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget{
    {
      id = "image",
      image = get_battery_icon(),
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

  awesome.connect_signal("daemon::battery::status", function(...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  image_widget.tooltip = require("widgets.tooltip")({ container })
  image_widget.tooltip.text = "AC adapter plugged in"

  return container
end

return create_widget
