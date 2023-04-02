--
-- memory.lua
-- memory usage widget
--

local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "memory/"

-- ========================================
-- Definition
-- ========================================

local create_widget = function()
  local widget = wibox.widget {
    {
      id = "image",
      image = icons_path .. "memory.svg",
      widget = wibox.widget.imagebox
    },
    {
      id = "text",
      widget = wibox.widget.textbox
    },
    id = "container",
    layout = wibox.layout.fixed.horizontal,
  }

  local text_widget = widget:get_children_by_id("text")[1]

  vicious.cache(vicious.widgets.mem)
  vicious.register(
    text_widget,
    vicious.widgets.mem,
    function(_, args)
      return (
          '<span> %.2f/%2.f GiB</span><span color="%s"> (%s%%)</span>'
          ):format(tonumber(args[2] / 1024), tonumber(args[3] / 1024), helpers.get_pct_color(args[1], "up"), args[1])
    end,
    --" $2/$3 MiB ($1%)",
    13
  )

  local container = require("widgets.clickable_container")(widget)

  return container
end

return create_widget
