--[[

     Teknicity Awesome WM theme, inspired from Powerarrow Dark Awesome WM theme
     from github.com/lcpz

--]]

local gears = require("gears")
local lain = require("lain")
local extra = require("extra")
local awful = require("awful")
local wibox = require("wibox")

local dpi = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local utils = require("extra.utils")

local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/teknicity"
theme.wallpaper = theme.dir .. "/wall.png"
theme.font = "Source Code Pro Medium 8"
theme.icon_theme = "Paper-Vimix"
theme.awesome_icon = theme.dir .. "/icons/awesome.png"

theme.fg_normal = "#8D9F9F"
theme.fg_focus = "#FFFFFF"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#212121"
theme.bg_focus = "#313131"
theme.bg_urgent = "#1A1A1A"

theme.border_width = dpi(1)
theme.border_normal = "#3F3F3F"
theme.border_focus = "#7F7F7F"
theme.border_marked = "#CC9393"

theme.tasklist_bg_focus = "#1A1A1A"
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus = theme.fg_focus

theme.menu_height = dpi(16)
theme.menu_width = dpi(140)
theme.wibar_height = dpi(22)

theme.menu_submenu_icon = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"

theme.layout_tile = theme.dir .. "/icons/tile.png"
theme.layout_tileleft = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv = theme.dir .. "/icons/fairv.png"
theme.layout_fairh = theme.dir .. "/icons/fairh.png"
theme.layout_spiral = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle = theme.dir .. "/icons/dwindle.png"
theme.layout_max = theme.dir .. "/icons/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier = theme.dir .. "/icons/magnifier.png"
theme.layout_floating = theme.dir .. "/icons/floating.png"
theme.layout_centerfair = theme.dir .. "/icons/centerfair.png"
theme.layout_termfair = theme.dir .. "/icons/termfair.png"
theme.layout_termfairw = theme.dir .. "/icons/termfairw.png"
theme.layout_centerwork = theme.dir .. "/icons/centerworkw.png"
theme.layout_centerworkh = theme.dir .. "/icons/centerworkh.png"
theme.layout_cascade = theme.dir .. "/icons/cascadew.png"
theme.layout_cascadetile = theme.dir .. "/icons/cascadetilew.png"

theme.widget_ac = theme.dir .. "/icons/ac.png"
theme.widget_battery = theme.dir .. "/icons/battery.png"
theme.widget_battery_low = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem = theme.dir .. "/icons/mem.png"
theme.widget_brightness = theme.dir .. "/icons/brightness.svg"
theme.widget_cpu = theme.dir .. "/icons/cpu.png"
theme.widget_temp = theme.dir .. "/icons/temp.png"
theme.widget_net = theme.dir .. "/icons/net.png"
theme.widget_hdd = theme.dir .. "/icons/hdd.png"
theme.widget_keyboard = theme.dir .. "/icons/desktop-locale.svg"
theme.widget_music = theme.dir .. "/icons/note.png"
theme.widget_music_on = theme.dir .. "/icons/note_on.png"
theme.widget_vol = theme.dir .. "/icons/vol.png"
theme.widget_vol_low = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail = theme.dir .. "/icons/mail.png"
theme.widget_mail_on = theme.dir .. "/icons/mail_on.png"
theme.widget_scissors = theme.dir .. "/icons/scissors.png"
theme.widget_task = theme.dir .. "/icons/task.png"
theme.widget_task_icon = theme.dir .. "/icons/taskwarrior.png"
theme.widget_weather = theme.dir .. "/icons/dish.png"
theme.tasklist_plain_task_name = false
theme.tasklist_disable_icon = false
theme.useless_gap = dpi(4)
theme.titlebar_close_button_focus = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

theme.debian_icon = theme.dir .. "/icons/debian.png"

theme.sidebar_width = dpi(300)
theme.sidebar_y = 0
theme.sidebar_border_radius = dpi(0)
theme.sidebar_hide_on_mouse_leave = true
theme.sidebar_show_on_mouse_edge = true

theme.sidebar_poweroff_icon = theme.dir .. "/icons/poweroff.png"
theme.sidebar_search_icon = theme.dir .. "/icons/search.png"
theme.sidebar_icon_size = 60
theme.screenshot_icon = theme.dir .. "/icons/screenshot.png"

theme.playerctl_button_size = 40
theme.playerctl_toggle_icon = theme.dir .. "/icons/playerctl_toggle.png"
theme.playerctl_prev_icon = theme.dir .. "/icons/playerctl_prev.png"
theme.playerctl_next_icon = theme.dir .. "/icons/playerctl_next.png"

local markup = lain.util.markup
local separators = lain.util.separators

-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
        "date +'%a %d %b %R'", 60,
        function(widget, stdout)
            widget:set_markup(" " .. markup.font(theme.font, stdout))
        end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = theme.font,
        fg = theme.fg_normal,
        bg = theme.bg_normal
    }
})

-- MOC
local mocicon = wibox.widget.imagebox(theme.widget_music)
local mymoc = lain.widget.contrib.moc({
    settings = function()
        local moc_markup = ''
        local moc_state = moc_now.state
        if moc_state == "PAUSE" then
            moc_markup = moc_markup .. markup(theme.fg_normal, '|| ')
        elseif moc_state == "STOP" then
            moc_markup = moc_markup .. markup('orange', '[] ')
        elseif moc_state == "PLAY" then
            moc_markup = moc_markup .. markup('green', '> ') .. string.lower(moc_now.title) .. ' '
        end
        widget:set_markup(markup.font(theme.font, " " .. moc_markup))
    end
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        local color = 'green'

        local pctuse = mem_now.perc

        if pctuse > 51 and pctuse < 71 then
            color = 'yellow'
        elseif pctuse > 71 and pctuse < 81 then
            color = 'orange'
        elseif pctuse > 81 then
            color = 'red'
        end
        widget:set_markup(markup.font(theme.font, " " ..
                markup("#46A8C3", mem_now.used) .. " / " .. markup('#7AC82E', mem_now.total) .. " MB " ..
                markup(color, "(" .. mem_now.perc .. " %)")))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})

-- FS
local fsusage = lain.widget.fs({
    --notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = theme.font, position = "bottom_left" },
    timeout = 10,
    showpopup = "off",
    settings = function()

        local fs_markup = ''

        for path in pairs(fs_now) do
            local color = 'green'

            local pctuse = fs_now[path].percentage

            if pctuse > 51 and pctuse < 71 then
                color = 'yellow'
            elseif pctuse > 71 and pctuse < 81 then
                color = 'orange'
            elseif pctuse > 81 then
                color = 'red'
            end
            if fs_now[path].percentage ~= 0 then
                fs_markup = fs_markup .. markup.font(theme.font, markup(theme.fg_normal, " [" .. path .. "] ") ..
                        markup(color, pctuse .. "% "))
            end
        end

        widget:set_markup(fs_markup)
    end
})
--

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})
-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(theme.widget_vol_low)
        else
            volicon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
})

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(theme.font,
                markup("#7AC82E", " " .. net_now.received)
                        .. " " ..
                        markup("#46A8C3", " " .. net_now.sent .. " ")))
    end
})

-- Scissors (xsel copy and paste)
local scissors = wibox.widget.imagebox(theme.widget_scissors)
scissors:buttons(my_table.join(awful.button({}, 1, function()
    awful.spawn.with_shell("xsel | xsel -i -b")
end)))

local wanip_icon = wibox.widget.imagebox(theme.widget_battery)
local wanip = extra.widget.wanip({
    settings = function()
        widget:set_markup(markup.font(theme.font, 'wan : ' .. wanip_now))
    end
})

--- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Separators
local spr = wibox.widget.textbox(' ')
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)
local arrr_dl = separators.arrow_right(theme.bg_focus, "alpha")
local arrr_ld = separators.arrow_right("alpha", theme.bg_focus)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal, followtag = true, name = 'Quake' })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags with placement
    for _, j in ipairs(awful.util.tagnames) do
        for k, v in pairs(j) do
            if v[screen.count()] == s.index then
                if k == "[desk]" then
                    awful.tag.add(k, { layout = awful.layout.layouts[v[4]], screen = s, selected = true })
                else
                    awful.tag.add(k, { layout = awful.layout.layouts[v[4]], screen = s })
                end
            end
        end
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
            awful.button({}, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({}, 2, function()
                awful.layout.set(awful.layout.layouts[1])
            end),
            awful.button({}, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({}, 4, function()
                awful.layout.inc(1)
            end),
            awful.button({}, 5, function()
                awful.layout.inc(-1)
            end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the top, bottom, and sidebar wibox
    s.mytopwibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })
    s.btmwibox = awful.wibar({ position = "bottom", screen = s, height = dpi(16), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the bottom wibox
    s.btmwibox:setup {
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.container.background(scissors),
            spr,
            arrr_ld,
        },
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.container.background(wibox.widget.imagebox(theme.widget_hdd), theme.bg_focus),
            wibox.container.background(fsusage.widget, theme.bg_focus),
            arrr_dl
        },
        {
            layout = wibox.layout.fixed.horizontal,
            separator,
            wibox.container.background(wibox.widget.imagebox(theme.widget_network_info)),
            arrl_ld,
            wibox.container.background(mocicon, theme.bg_focus),
            wibox.container.background(mymoc.widget, theme.bg_focus),
            arrl_dl,
            wanip_icon,
            wanip.widget,
            arrl_ld,
            wibox.container.background(volicon, theme.bg_focus),
            wibox.container.background(theme.volume.widget, theme.bg_focus),
            arrl_dl,
            spr, spr,
            wibox.widget.imagebox(theme.widget_keyboard),
            mykeyboardlayout,
        },
        layout = wibox.layout.align.horizontal,
    }
    -- Add widgets to the top wibox
    s.mytopwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            awful.widget.launcher({ image = theme.awesome_icon, menu = awful.util.mymainmenu }),
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            arrl_ld,
            wibox.container.background(memicon, theme.bg_focus),
            wibox.container.background(mem.widget, theme.bg_focus),
            arrl_dl,
            cpuicon,
            cpu.widget,
            arrl_ld,
            wibox.container.background(tempicon, theme.bg_focus),
            wibox.container.background(temp.widget, theme.bg_focus),
            wibox.container.background(spr, theme.bg_focus),
            arrl_dl,
            baticon,
            bat.widget,
            arrl_ld,
            wibox.container.background(neticon, theme.bg_focus),
            wibox.container.background(net.widget, theme.bg_focus),
            arrl_dl,
            wibox.container.background(wibox.widget.systray(), theme.bg_focus),
            spr,
            arrl_ld,
            wibox.container.background(clock, theme.bg_focus),
            wibox.container.background(spr, theme.bg_focus),
            arrl_dl,
            spr,
            s.mylayoutbox,
        },
    }
end

return theme
