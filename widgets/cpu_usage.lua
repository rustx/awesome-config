--
-- cpu_usage.lua
-- cpu usage widget
--

local vicious = require("vicious")
local wibox = require("wibox")

local create_widget = function (screen)
  local widget = wibox.widget.textbox()
  vicious.cache(vicious.widgets.mem)
  vicious.register(widget, vicious.widgets.cpu, "$1 %", 3)

  local container = require("widgets.clickable_container")(widget)

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Cpu Usage"

  return container
end

return create_widget
