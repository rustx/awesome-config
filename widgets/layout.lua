--
-- layout.lua
-- display currently active layout
--

local awful = require("awful")
local gears = require("gears")
local keys = require("keys")

-- define buttons
local buttons = function()
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
local create_widget = function(s)
  local widget = awful.widget.layoutbox(s)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons())

  return container
end

return create_widget
