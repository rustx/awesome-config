--
-- layout.lua
-- display currently active layout
--

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local keys = require("keys")
local beautiful = require("beautiful")

-- define buttons
local buttons = function (s)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.layout.inc(1) end
    ),
    awful.button(
      {}, keys.rightclick,
      function() awful.layout.inc(-1) end
    ),
    awful.button(
      {}, keys.scrolldown,
      function() awful.layout.inc(1) end
    ),
    awful.button(
      {}, keys.scrollup,
      function() awful.layout.inc(-1) end
    )
  )
end

-- create widget instance
local create_widget = function (s)
  local widget = awful.widget.layoutbox(s)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  return container
end

return create_widget
