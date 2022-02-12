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

-- update crypto_rates widget
local update_widget = function (widget, rates, coin)

  local image_widget = widget:get_children_by_id("image")[1]
  local text_widget = widget:get_children_by_id("text")[1]

  if rates ~= nil then
    text_widget:set_markup(' ' .. Coins.currency.symbol .. rates[coin][Coins.currency.name] .. ' ')
  else
    text_widget:set_markup(' N/A ')
  end

  image_widget.image = icons_path .. coin .. ".svg"
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

  awesome.connect_signal("daemon::crypto::rates", function (...)
    update_widget(widget, ..., coin)
  end)

  local container = require("widgets.clickable_container")(widget)

  return container
end

return create_widget
