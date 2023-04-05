--
-- topbar.lua
-- topbar config
--

local awful = require("awful")
local wibox = require("wibox")
local quake = require("components.quake")
local beautiful = require("beautiful")
local helpers = require("helpers")

local left_widgets = {
  "taglist",
  "promptbox",
  "tasklist"
}

local right_widgets = {
  "cpu_usage",
  "cpu_temp",
  "memory",
  "bluetooth",
  "network",
  "brightness",
  "battery",
  "systray",
  "calendar",
  "layout"
}

local build_right_widgets = function(s, widgets)
  local bar = s.topbar:get_children_by_id('right')[1]
  bar:add(beautiful.arrl_ld)
  for i, wdg in pairs(widgets) do
    if (i % 2 ~= 0) then
      bar:add(
        wibox.container.background(
          require("widgets." .. wdg)(s),
          beautiful.color.darkgrey
        )
      )
      if i ~= #widgets then
        bar:add(beautiful.arrl_dl)
      end
    else
      bar:add(require("widgets." .. wdg)(s))
      if i ~= #widgets then
        bar:add(beautiful.arrl_ld)
      end
    end
  end
end

local build_left_widgets = function(s, widgets)
  local bar = s.topbar:get_children_by_id('left')[1]
  for i, wdg in pairs(widgets) do
    if (i % 2 ~= 0) then
      if wdg == 'promptbox' then
        bar:add(s.promptbox)
      else
        bar:add(require("widgets." .. wdg)(s))
      end
      if i ~= #widgets then
        bar:add(beautiful.arrr_ld)
      end
    else
      if wdg == 'promptbox' then
        bar:add(
          wibox.container.background(
            s.promptbox,
            beautiful.color.darkgrey
          )
        )
      else
        bar:add(
          wibox.container.background(
            require("widgets." .. wdg)(s),
            beautiful.color.darkgrey
          )
        )
      end
      bar:add(beautiful.arrr_dl)
    end
  end
end

awful.screen.connect_for_each_screen(function(s)
  s.promptbox = awful.widget.prompt({ bg_cursor = beautiful.color.white })
  s.quake = quake({
    app = Apps.terminal,
    followtag = true,
    name = 'Quake',
    argname = helpers.quake_argname(Apps.terminal)
  })
  s.topbar = awful.wibar({
    screen = s,
    visible = true,
    height = beautiful.topbar_height,
    position = beautiful.topbar_position
  })
  s.topbar:struts {
    top = beautiful.topbar_height
  }
  s.topbar:setup {
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
      }
    }
  }
  build_left_widgets(s, left_widgets)
  build_right_widgets(s, right_widgets)
end)
