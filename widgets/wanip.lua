--
-- wanip.lua
-- wanip widget
--

local wibox = require("wibox")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "wanip/"

-- ========================================
-- Definition
-- ========================================

-- update wanip widget
local update_widget = function (widget, address)

  local icon_name
  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  if string.match(address, "%d+.%d+.%d+.%d+") then
    icon_name = "wanip_normal"
    text_widget:set_markup(' ' .. address)
  else
    icon_name = "wanip_off"
    text_widget:set_markup(' Unknown')
  end

  image_widget.image = icons_path .. icon_name .. ".svg"
end

local create_widget = function(screen)
  local widget = wibox.widget{
    {
      id = "image",
      image = icons_path .. "wanip_off.svg",
      widget = wibox.widget.imagebox
    },
    {
      id = "text",
      widget = wibox.widget.textbox
    },
    id = "container",
    layout = wibox.layout.fixed.horizontal,
  }

  awesome.connect_signal("daemon::wanip::address", function (...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)

  return container
end

return create_widget
