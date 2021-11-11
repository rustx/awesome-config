--
-- topbar.lua
-- topbar config
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

awful.screen.connect_for_each_screen(function(s)
  --s.quake = quake({ app = awful.util.terminal, followtag = true, name = 'Quake' })
  s.promptbox = awful.widget.prompt()
  s.topbar = awful.wibar({
    screen = s,
    visible = true,
    --width = s.geometry.width - beautiful.topbar_margin * 4,
    height = beautiful.topbar_height,
    position = beautiful.topbar_position
  })
  s.topbar:struts {
    top = beautiful.topbar_height + beautiful.topbar_margin * 2,
  }
  s.topbar:setup {
    widget = wibox.container.margin,
    left = beautiful.topbar_padding_x,
    right = beautiful.topbar_padding_x,
    {
      layout = wibox.layout.align.horizontal,
      expand = "none",

      -- Left widgets
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.container.background(require("widgets.taglist")(s),beautiful.color.darkgrey),
        beautiful.arrr_dl,
        s.promptbox,
        require("widgets.client_name")(s),
      },

      -- Middle widgets
      {
        layout = wibox.layout.fixed.horizontal,
      },

      -- Right widgets
      {
        layout = wibox.layout.fixed.horizontal,
        beautiful.arrl_ld,
        require("widgets.container")(wibox.widget.imagebox(beautiful.cpu_usage_icon), beautiful.color.darkgrey),
        wibox.container.background(require("widgets.cpu_usage")(s), beautiful.color.darkgrey),
        beautiful.arrl_dl,
        require("widgets.cpu_temp")(s),
        beautiful.arrl_ld,
        require("widgets.container")(wibox.widget.imagebox(beautiful.memory_icon), beautiful.color.darkgrey),
        wibox.container.background(require("widgets.memory")(s), beautiful.color.darkgrey),
        beautiful.arrl_dl,
        require("widgets.bluetooth")(s),
        beautiful.arrl_ld,
        wibox.container.background(require("widgets.network")(s),beautiful.color.darkgrey),
        beautiful.arrl_dl,
        require("widgets.brightness")(s),
        beautiful.arrl_ld,
        wibox.container.background(require("widgets.battery")(s),beautiful.color.darkgrey),
        beautiful.arrl_dl,
        require("widgets.systray")(s),
        beautiful.arrl_ld,
        wibox.container.background(require("widgets.calendar")(s), beautiful.color.darkgrey),
        beautiful.arrl_dl,
        require("widgets.layout")(s),
      },
    },
  }
end)