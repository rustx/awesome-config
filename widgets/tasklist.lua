--
-- tasklist.lua
-- tasklist component
--

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- update currently focused client name
local update_widget = function(widget)
  local c = client.focus
  if c ~= nil then
    widget.text = c.name or c.class or ""
  else
    widget.text = ""
  end
end

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        { raise = true }
      )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function()
    awful.client.focus.byidx(-1)
  end))

-- create client_name widget instance
local create_widget = function(screen, cr)
  local widget = awful.widget.tasklist {
    screen = screen,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      spacing = 10,
      spacing_widget = {
        {
          forced_width = 12,
          shape = gears.shape.powerline,
          color = '#777aaa',
          widget = wibox.widget.separator
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      layout = wibox.layout.flex.horizontal
    },

    widget_template = {
      {
        wibox.widget.base.make_widget(),
        id = 'background_role',
        widget = wibox.container.background,
      },
      {
        {
          id = 'clienticon_role',
          widget = awful.widget.clienticon,
        },
        margins = 3,
        widget = wibox.container.margin
      },
      nil,
      create_callback = function(self, c, index, objects) --luacheck: no unused args
        self:get_children_by_id('clienticon_role')[1].client = c
      end,
      layout = wibox.layout.align.vertical,
      {
        id = 'text_role',
        widget = wibox.widget.textbox,
      },
      margin = 5,
      layout = wibox.layout.fixed.horizontal,
    },
  }

  client.connect_signal("focus", function(c)
    update_widget(widget)
  end)
  client.connect_signal("unfocus", function(c)
    update_widget(widget)
  end)
  client.connect_signal("property::name", function(c)
    update_widget(widget)
  end)

  return widget
end

return create_widget
