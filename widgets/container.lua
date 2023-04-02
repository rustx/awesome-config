--
-- container.lua
-- container with padding
--

local wibox = require('wibox')
local beautiful = require("beautiful")

-- create widget instance
local create_widget = function(widget, bg)
  local container = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.margin,
      top = beautiful.clickable_container_padding_y,
      bottom = beautiful.clickable_container_padding_y,
      left = beautiful.clickable_container_padding_x,
      right = beautiful.clickable_container_padding_x,
      widget,
    },
    bg = bg
  }

  return container
end

return create_widget
