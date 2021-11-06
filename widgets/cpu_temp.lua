--
-- cpu_temp.lua
-- cpu temperature widget
--

local vicious = require("vicious")
local wibox = require("wibox")

local create_widget = function (screen)
  local widget = wibox.widget.textbox()
  vicious.cache(vicious.widgets.mem)
  vicious.register(widget, vicious.widgets.thermal, "$1 °C", 13, "thermal_zone0")

  local container = require("widgets.clickable_container")(widget)

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Cpu Temperature"

  return container
end

return create_widget
