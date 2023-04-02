--
-- crypto_rates.lua
-- crypto_rates widget
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local keys = require("keys")
local dpi = require("beautiful").xresources.apply_dpi

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "crypto/"

-- ========================================
-- Definition
-- ========================================

-- watch crypto rates details on goingecko
local buttons = function(screen, coin)
  return gears.table.join(
    awful.button(
      {}, keys.rightclick,
      function()
        awful.spawn("xdg-open https://www.coingecko.com/coins/" .. coin)
      end
    )
  )
end

-- format trend text box with colors and arrow
local fmt_trend = function(trend)
  local fmt = trend < 0 and { color = 'red', arrow = '⮯' } or { color = 'green', arrow = '⮭' }
  return fmt
end

-- update crypto_rates popup
local update_popup = function(widget, rates, coin)
  local title_popup = widget:get_children_by_id(coin .. '_title')[1]
  local trend_popup = widget:get_children_by_id(coin .. '_trend')[1]
  local date_popup = widget:get_children_by_id(coin .. '_date')[1]

  if rates ~= nil then
    local rate = rates[coin][Coins.currency.name]
    local trend = rates[coin][Coins.currency.name .. '_24h_change']
    local last_updated = rates[coin]['last_updated_at']
    local fmt = fmt_trend(trend)

    title_popup:set_markup(
      '<b><span size="large">' .. coin .. ' </span></b>' ..
      '<b><span size="large" color="' .. fmt.color .. '">' .. fmt.arrow .. '</span></b>'
    )
    trend_popup:set_markup(
      '<b><span size="medium">' .. Coins.currency.symbol .. rate .. ' </span></b>' ..
      '<b><span size="medium" color="' .. fmt.color .. '">' .. string.format('%.2f', trend) .. '% </span></b>'
    )
    date_popup:set_markup(
      '<b><span size="small">' .. os.date('%Y-%m-%d %H:%M:%S', last_updated) .. '</span></b>'
    )
  else
    title_popup:set_markup(' N/A ')
    trend_popup:set_markup(' N/A ')
    date_popup:set_markup(' N/A ')
  end
end

-- update crypto_rates widget
local update_widget = function(widget, rates, coin)
  local text_widget = widget:get_children_by_id("text")[1]
  if rates ~= nil then
    local currency_name = rates[coin][Coins.currency.name]
    local currency_symbol = Coins.currency.symbol

    text_widget:set_markup(
      ' ' .. currency_symbol .. currency_name .. ' '
    )
  else
    text_widget:set_markup(' N/A ')
  end
end

local create_widget = function(screen, coin)
  local crypto_icon = wibox.widget {
    image = icons_path .. coin .. ".svg",
    resize = true,
    widget = wibox.widget.imagebox
  }

  local popup = awful.popup {
    ontop = true,
    visible = false,
    opacity = 0.8,
    shape = gears.shape.rounded_rect,
    maximum_width = dpi(250),
    maximum_height = dpi(100),
    hide_on_right_click = true,
    preferred_anchors = 'middle',
    offset = { y = 1 },
    widget = wibox.widget {
      {
        {
          {
            {
              id = coin .. '_image',
              crypto_icon,
              margins = dpi(8),
              layout = wibox.container.margin
            },
            valign = 'center',
            spacing = dpi(8),
            forced_width = dpi(80),
            layout = wibox.container.place
          },
          {
            {
              {
                id = coin .. '_title',
                markup = '<b>' .. coin .. '</b>',
                align = 'center',
                widget = wibox.widget.textbox
              },
              {
                id = coin .. '_trend',
                markup = "N/A ",
                align = 'center',
                widget = wibox.widget.textbox
              },
              {
                id = coin .. '_date',
                markup = "N/A ",
                align = 'center',
                widget = wibox.widget.textbox
              },
              spacing = dpi(8),
              forced_width = dpi(150),
              margins = dpi(8),
              layout = wibox.layout.flex.vertical
            },
            valign = 'center',
            layout = wibox.container.place
          },
          spacing = 8,
          layout = wibox.layout.align.horizontal
        },
        margins = 8,
        layout = wibox.container.margin
      },
      bg = beautiful.notification_bg,
      widget = wibox.container.background
    },
  }

  local widget = wibox.widget {
    {
      id = "image",
      image = icons_path .. coin .. ".svg",
      widget = wibox.widget.imagebox
    },
    {
      id = "text",
      widget = wibox.widget.textbox
    },
    id = "container",
    layout = wibox.layout.fixed.horizontal,
  }

  popup:bind_to_widget(widget)

  awesome.connect_signal("daemon::crypto::rates", function(...)
    update_widget(widget, ..., coin)
    update_popup(popup.widget, ..., coin)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen, coin))

  return container
end

return create_widget
