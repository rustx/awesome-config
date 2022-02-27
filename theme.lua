--
-- theme.lua
-- Theme config
--

local gears = require("gears")
local helpers = require("helpers")
local dpi = require("beautiful").xresources.apply_dpi

local theme = {}

-- ========================================
-- Variables
-- ========================================

-- Theme color
local color = {
  lightblue = "#8fbcbb",
  darkblue  = "#2e3440",
  red       = "#bf616a",
  orange    = "#d08770",
  yellow    = "#ebcb8b",
  green     = "#a3be8c",
  white     = "#eceff4",
  black     = "#000000",
  darkgrey  = "#313131",
  lightgrey = "#918A8A",
}

-- Theme font
local font = "HackGen Console"

-- ========================================
-- Colors
-- ========================================
theme.color = color

-- ========================================
-- Icons
-- ========================================

-- Icons path
theme.icons_path = gears.filesystem.get_configuration_dir() .. "icons/"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Vimix"

-- ========================================
-- Common
-- ========================================

-- Font
theme.font = font .. " 10"

-- Background
theme.bg_normal   = color.black
theme.bg_dark     = color.black
theme.bg_focus    = color.black
theme.bg_urgent   = color.black
theme.bg_minimize = color.black
theme.bg_systray  = color.black

-- Foreground
theme.fg_normal   = color.white
theme.fg_focus    = color.lightblue
theme.fg_urgent   = color.red
theme.fg_minimize = color.lightgrey

-- Borders/Gaps
theme.useless_gap   = dpi(2)
theme.screen_margin = theme.useless_gap
theme.border_width  = dpi(1)
theme.border_radius = dpi(5)
theme.border_focus  = color.lightblue
theme.border_marked = color.red
theme.border_normal = color.black

-- Tooltips
theme.tooltip_font      = theme.font
theme.tooltip_padding_x = dpi(10)
theme.tooltip_padding_y = dpi(10)

-- Notification
theme.notification_width        = dpi(350)
theme.notification_margin       = dpi(15)
theme.notification_border_width = dpi(0)
theme.notification_icon_size    = dpi(48)
theme.notification_fg           = color.white
theme.notification_bg           = color.darkblue .. "aa"
theme.notification_bg_critical  = color.red .. "aa"
theme.notification_font         = theme.font


-- ========================================
-- Components
-- ========================================

-- Topbar
theme.topbar_position  = "top"
theme.topbar_height    = dpi(22)
theme.topbar_margin    = theme.useless_gap
theme.topbar_padding_x = dpi(2)

-- Btmbar
theme.btmbar_position   = "bottom"
theme.btmbar_height     = dpi(22)
theme.btmbar_margin     = theme.useless_gap
theme.btmmbar_padding_x = dpi(2)

-- Promptbox
theme.prompt_bg = color.darkgrey

-- Exit screen
theme.exit_screen_bg              = theme.bg_normal .. "aa"
theme.exit_screen_button_spacing  = dpi(48)
theme.exit_screen_caption_spacing = dpi(8)
theme.exit_screen_icon_size       = dpi(48)

-- Lock screen
theme.lock_screen_icons_path = theme.icons_path .. "lock_screen/"

theme.lock_screen_bg        = theme.bg_normal .. "aa"
theme.lock_screen_width     = dpi(800)
theme.lock_screen_spacing_x = dpi(10)
theme.lock_screen_spacing_y = dpi(30)

theme.lock_screen_title_icon      = theme.lock_screen_icons_path .. "lock_screen_padlock.svg"
theme.lock_screen_title_icon_size = dpi(40)
theme.lock_screen_title_font      = font .. " 24"

theme.lock_screen_dot_icon    = theme.lock_screen_icons_path .. "lock_screen_dot.svg"
theme.lock_screen_dot_spacing = dpi(5)
theme.lock_screen_dot_color   = theme.fg_normal
theme.lock_screen_dot_size    = dpi(20)

theme.lock_screen_warning_icon = theme.lock_screen_icons_path .. "lock_screen_warning.svg"

-- Screen switcher
theme.screen_switcher_bg = theme.bg_normal .. "aa"

theme.arrl_dl = helpers.separators_arrow_left(color.darkgrey, "alpha")
theme.arrl_ld = helpers.separators_arrow_left("alpha", color.darkgrey)
theme.arrr_dl = helpers.separators_arrow_right(color.darkgrey, "alpha")
theme.arrr_ld = helpers.separators_arrow_right("alpha", color.darkgrey)

-- ========================================
-- Widgets
-- ========================================

-- Clickable container
theme.clickable_container_padding_x = dpi(3)
theme.clickable_container_padding_y = dpi(3)

-- Systray
theme.systray_icon_spacing = dpi(10)

-- Taglist
theme.taglist_spacing = dpi(5)

theme.taglist_bg_empty    = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_urgent   = theme.bg_normal
theme.taglist_bg_focus    = theme.bg_normal

theme.taglist_fg_empty    = theme.fg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_fg_urgent   = theme.fg_urgent
theme.taglist_fg_focus    = theme.fg_focus

theme.taglist_padding_x   = dpi(1)
theme.taglist_padding_y   = dpi(2)

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_icon_visible = " "
theme.tasklist_icon_hidden  = " "

theme.tasklist_bg_normal   = theme.bg_normal
theme.tasklist_bg_focus    = theme.bg_focus
theme.tasklist_bg_urgent   = theme.bg_urgent
theme.tasklist_bg_minimize = theme.bg_minimize
theme.tasklist_fg_normal   = theme.fg_normal
theme.tasklist_fg_focus    = theme.fg_focus
theme.tasklist_fg_urgent   = theme.fg_urgent
theme.tasklist_fg_minimize = theme.fg_minimize

-- Calendar
theme.calendar_padding = dpi(10)
theme.calendar_spacing = dpi(5)

-- System tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Battery
theme.battery_fg_normal = theme.fg_normal
theme.battery_fg_urgent = theme.fg_urgent

-- Layout
theme.layout_floating     = theme.icons_path .. "layouts/floating.png"
theme.layout_tile         = theme.icons_path .. "layouts/tile.png"
theme.layout_tileleft     = theme.icons_path .. "layouts/tileleft.png"
theme.layout_tilebottom   = theme.icons_path .. "layouts/tilebottom.png"
theme.layout_tiletop      = theme.icons_path .. "layouts/tiletop.png"
theme.layout_fairv        = theme.icons_path .. "layouts/fairv.png"
theme.layout_fairh        = theme.icons_path .. "layouts/fairh.png"
theme.layout_spiral       = theme.icons_path .. "layouts/spiral.png"
theme.layout_dwindle      = theme.icons_path .. "layouts/dwindle.png"
theme.layout_max          = theme.icons_path .. "layouts/maximized.png"
theme.layout_magnifier    = theme.icons_path .. "layouts/magnifier.png"

-- Memory
theme.memory_icon  = theme.icons_path .. "memory/memory.svg"

-- Fs usage
theme.fs_icon = theme.icons_path .. "fs/fs.svg"

-- Cpu
theme.cpu_temp_icon  = theme.icons_path .. "cpu/cpu_temp.svg"
theme.cpu_usage_icon = theme.icons_path .. "cpu/cpu_usage.svg"

-- Hotkeys
theme.hotkeys_font             = font .. " Bold 10"
theme.hotkeys_description_font = font .. " 10"
theme.hotkeys_bg               = color.darkgrey .. "aa"
theme.hotkeys_border_width     = dpi(1)
theme.hotkeys_shape            = helpers.rrect
theme.hotkeys_modifiers_fg     = color.yellow
theme.hotkeys_label_fg         = color.white
theme.hotkeys_label_bg         = color.darkblue
theme.hotkeys_group_margin     = dpi(40)


return theme