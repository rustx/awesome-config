--
-- btmbar.lua
-- btmbar config
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

awful.screen.connect_for_each_screen(function (s)
  s.btmbar = awful.wibar({
    screen = s,
    visible = true,
    height = beautiful.btmbar_height,
    position = beautiful.btmbar_position
  })
  s.btmbar:struts {
    top = beautiful.btmbar_height
  }
  s.btmbar:setup {
    widget = wibox.container.margin,
    left = beautiful.btmbar_padding_x,
    right = beautiful.btmbar_padding_x,
    {
      layout = wibox.layout.align.horizontal,
      expand = "none",

      -- Left widgets
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.container.background(require("widgets.fs_usage")(s),beautiful.color.darkgrey),
        beautiful.arrr_dl,
        require("widgets.crypto_rates")(s, "bitcoin"),
        beautiful.arrr_ld,
        wibox.container.background(require("widgets.crypto_rates")(s, "ethereum"), beautiful.color.darkgrey),
        beautiful.arrr_dl,
      },

      -- Middle widgets
      {
        layout = wibox.layout.fixed.horizontal,
      },

      -- Right widgets
      {
        layout = wibox.layout.fixed.horizontal,
        --beautiful.arrl_ld,
        --wibox.container.background(require("widgets.mpd")(s), beautiful.color.darkgrey),
        --beautiful.arrl_dl,
        require("widgets.net_usage")(s),
        beautiful.arrl_ld,
        wibox.container.background(require("widgets.wanip")(s), beautiful.color.darkgrey),
        beautiful.arrl_dl,
        require("widgets.volume")(s),
        beautiful.arrl_ld,
        wibox.container.background(require("widgets.language")(s), beautiful.color.darkgrey),
      },
    },
  }
end)
