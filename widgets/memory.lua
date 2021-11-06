--
-- memory.lua
-- memory usage widget
--

local vicious = require("vicious")
local wibox = require("wibox")

local create_widget = function (screen)
  local widget = wibox.widget.textbox()
  vicious.cache(vicious.widgets.mem)
  vicious.register(widget, vicious.widgets.mem, "$2/$3 MiB ($1%)", 13)

  local container = require("widgets.clickable_container")(widget)

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Memory Usage"

  return container
end

return create_widget