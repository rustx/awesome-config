--
-- net_usage.lua
-- net usage widget
--

local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local icons_path = beautiful.icons_path .. "network/"

local create_widget = function (screen)
  local widget = wibox.widget{
    {
      id = "up",
      image = icons_path .. "netdown.svg",
      widget = wibox.widget.imagebox
    },
    {
      id = "text",
      widget = wibox.widget.textbox
    },
    {
      id = "down",
      image = icons_path .. "netup.svg",
      widget = wibox.widget.imagebox
    },
    id = "container",
    layout = wibox.layout.fixed.horizontal,
  }
  local text_widget = widget:get_children_by_id("text")[1]
  local iface = Network_Interfaces["wlan"]

  vicious.cache(vicious.widgets.net)
  vicious.register(
    text_widget,
    vicious.widgets.net,
    " ${" .. iface .. " up_mb} MB - ${" .. iface .. " down_mb} MB ",
    2,
    "wlp58s0"
  )

  local container = require("widgets.clickable_container")(widget)

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Net usage"

  return container
end

return create_widget
