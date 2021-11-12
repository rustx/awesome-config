--
-- crypto_rates.lua
-- crypto_rates widget
--

local wibox = require("wibox")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "crypto/"

-- ========================================
-- Definition
-- ========================================

-- update wanip widget
local update_widget = function (widget, rates, coin)

  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  text_widget:set_markup(' ' .. rates[coin]["usd"] .. ' $')

  image_widget.image = icons_path .. coin .. ".svg"
  image_widget.tooltip.text = string.format(coin .. " : %s $", rates[coin]["usd"])
end

local create_widget = function(screen, coin)
  local widget = wibox.widget{
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
  local image_widget = widget:get_children_by_id("image")[1]

  awesome.connect_signal("daemon::crypto::rates", function (...)
    update_widget(widget, ..., coin)
  end)

  local container = require("widgets.clickable_container")(widget)

  image_widget.tooltip = require("widgets.tooltip")({ container })
  image_widget.tooltip.text = "Crypto rates unknown"

  return container
end

return create_widget
