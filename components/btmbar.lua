--
-- btmbar.lua
-- btmbar config
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local left_widgets = {
  "fs_usage",
  "crypto_rates"
}

local right_widgets = {
  "net_usage",
  "wanip",
  "volume",
  "language"
}

local build_right_widgets = function(s, widgets)
  local bar = s.btmbar:get_children_by_id('right')[1]
  for i, wdg in pairs(widgets) do
    if (i % 2 ~= 0) then
      bar:add(require("widgets." .. wdg)(s))
      if i ~= #widgets then bar:add(beautiful.arrl_ld) end
    else
      bar:add(
        wibox.container.background(
          require("widgets." .. wdg)(s),
          beautiful.color.darkgrey
        )
      )
      if i ~= #widgets then bar:add(beautiful.arrl_dl) end
    end
  end
end

local build_left_widgets = function(s, widgets)
  local bar = s.btmbar:get_children_by_id('left')[1]
  for i, wdg in pairs(widgets) do
    if (i % 2 ~= 0) then
      if wdg ~= "crypto_rates" then
        bar:add(
          wibox.container.background(
            require("widgets." .. wdg)(s),
            beautiful.color.darkgrey
          )
        )
        bar:add(beautiful.arrr_dl)
      else
        for idx, coin in pairs(Coins.rates) do
          if (idx % 2 ~= 0) then
            bar:add(
              wibox.container.background(
                require("widgets." .. wdg)(s, coin),
                beautiful.color.darkgrey
              )
            )
            bar:add(beautiful.arrr_dl)
          else
            bar:add(require("widgets." .. wdg)(s, coin))
            bar:add(beautiful.arrr_ld)
          end
        end
      end
    else
      if wdg ~= "crypto_rates" then
        bar:add(require("widgets." .. wdg)(s))
        bar:add(beautiful.arrr_dl)
      else
        for idx, coin in pairs(Coins.rates) do
          if (idx % 2 ~= 0) then
            bar:add(require("widgets." .. wdg)(s, coin))
            bar:add(beautiful.arrr_ld)
          else
            bar:add(
              wibox.container.background(
                require("widgets." .. wdg)(s, coin),
                beautiful.color.darkgrey
              )
            )
            bar:add(beautiful.arrr_dl)
          end
        end
      end
    end
  end
end

awful.screen.connect_for_each_screen(function(s)
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
    {
      layout = wibox.layout.align.horizontal,
      expand = "none",
      -- Left widgets
      {
        id = 'left',
        layout = wibox.layout.fixed.horizontal,
      },
      -- Middle widgets
      {
        id = 'middle',
        layout = wibox.layout.fixed.horizontal,
      },
      -- Right widgets
      {
        id = 'right',
        layout = wibox.layout.fixed.horizontal,
      },
    },
  }
  build_left_widgets(s, left_widgets)
  build_right_widgets(s, right_widgets)
end)
