--
-- volume.lua
-- volume widget
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
local icons_path = beautiful.icons_path .. "volume/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(Apps.volume_manager) end
    ),
    awful.button(
      {}, keys.rightclick,
      function() helpers.toggle_volume_mute() end
    ),
    awful.button(
      {}, keys.scrolldown,
      function() helpers.change_volume(1) end
    ),
    awful.button(
      {}, keys.scrollup,
      function() helpers.change_volume(-1) end
    )
  )
end


-- update widget percentage
local update_widget_percentage = function (widget, percentage)
  local icon_name

  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  if percentage <= 30 then
    icon_name = "volume_low"
  elseif percentage > 30 and percentage <= 60 then
    icon_name = "volume_medium"
  elseif percentage > 60 then
    icon_name = "volume_high"
  end

  image_widget.image = icons_path .. icon_name .. ".svg"
  image_widget.tooltip.text = string.format("Volume is at %s%%", percentage)

  text_widget:set_markup(
    '<span color="' .. helpers.get_pct_color(percentage, "down") .. '"> ' .. percentage .. '%</span>'
  )
end


-- update widget mute
local update_widget_mute = function (widget)
  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  image_widget.image = icons_path .. "volume_muted.svg"
  image_widget.tooltip.text = "Volume is muted"

  text_widget:set_markup(' -/-')
end


-- create widget instance
local create_widget = function (screen)

  local widget = wibox.widget{
    {
      id = "image",
      image = icons_path .. "volume_medium.svg",
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

  awesome.connect_signal("daemon::volume::percentage", function (...)
    update_widget_percentage(widget, ...)
  end)
  awesome.connect_signal("daemon::volume::muted", function ()
    update_widget_mute(widget)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  image_widget.tooltip = require("widgets.tooltip")({ container })
  image_widget.tooltip.text = "Volume status unknown"

  return container
end

return create_widget
