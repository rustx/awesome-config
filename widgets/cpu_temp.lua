--
-- cpu_temp.lua
-- cpu temperature widget
--

local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "cpu/"

-- ========================================
-- Definition
-- ========================================

local create_widget = function (screen)
  local widget = wibox.widget{
    {
      id = "image",
      image = icons_path .. "cpu_temp.svg",
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

  vicious.cache(vicious.widgets.thermal)
  vicious.register(text_widget, vicious.widgets.thermal, " $1°C", 13, "thermal_zone0")

  local container = require("widgets.clickable_container")(widget)

  image_widget.tooltip = require("widgets.tooltip")({ container })
  image_widget.tooltip.text = "Cpu Temperature"

  return container
end

return create_widget
