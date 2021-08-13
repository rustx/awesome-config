--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local dpi           = require("beautiful.xresources").apply_dpi
local freedesktop   = require("freedesktop")
local extra         = require("extra")
local utils         = require("extra.utils")

local markup        = lain.util.markup
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "compton", "urxvtd", "unclutter -root", "nm-applet", "volti", "pulseaudio", "blueman-applet", "xscreensaver", "thunar --daemon" }) -- entries must be separated by commas


freedesktop.desktop.add_icons({
    baseicons = {
        [1] = {
            label = "Computer",
            icon = "/usr/share/icons/Vimix/scalable/devices/computer.svg",
            onclick = "computer://",
        },
        [2] = {
            label = "Home",
            icon = "/usr/share/icons/Vimix/scalable/places/user-home.svg",
            onclick = os.getenv("HOME"),
        },
        [3] = {
            label = "Desktop",
            icon = "/usr/share/icons/Vimix/scalable/places/user-desktop.svg",
            onclick = os.getenv("HOME") .. "/Desktop",
        },
        [4] = {
            label = "Development",
            icon = "/usr//share/icons/Vimix/scalable/places/folder-root.svg",
            onclick = os.getenv("HOME") .. "/Development",
        },
        [5] = {
            label = "Documents",
            icon = "/usr/share/icons/Vimix/scalable/places/folder-documents.svg",
            onclick = os.getenv("HOME") .. "/Documents",
        },
        [6] = {
            label = "Downloads",
            icon = "/usr/share/icons/Vimix/scalable/places/folder-download.svg",
            onclick = os.getenv("HOME") .. "/Downloads"
        },
        [7] = {
            label = "Trash",
            icon = "/usr/share/icons/Vimix/scalable/places/user-trash.svg",
            onclick = "trash://",
        },
    },
    -- dir = os.getenv("HOME") .. "/Development",
    labelsize  = { width = 140, height = 20 },
    margin     = { x = 40, y = 40 },
    open_with = 'xdg-open'
})

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

--local chosen_theme = themes[10]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "urxvtc"
local editor       = os.getenv("EDITOR") or "vim"
local browser      = "brave-browser"
local guieditor    = "gedit"
local scrlocker    = "xscreensaver-command --lock"

local touchpad_ids = extra.utils.get_touchpad_ids()

awful.util.terminal = terminal
awful.util.tagnames = {
    { ["[www]"] = { 1, 2, 2, 1 } },
    { ["[mail]"] = { 1, 2, 2, 1 } },
    { ["[desk]"] = { 1, 1, 1, 1 } },
    { ["[dev]"] = { 1, 1, 1, 1 } },
    { ["[shell]"] = { 1, 1, 3, 6 } },
    { ["[talk]"] = { 1, 1, 1, 1 } },
    { ["[media]"] = { 1, 2, 3, 1 } },
    { ["[sys]"] = { 1, 1, 1, 1 } },
    { ["[zik]"] = { 1, 2, 3, 1 } },
}

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    lain.layout.cascade,
    lain.layout.cascade.tile,
    lain.layout.centerwork,
    lain.layout.centerwork.horizontal,
    lain.layout.termfair,
    lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(extra.utils.get_theme_path() .. "theme.lua" )
-- }}}

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Debian", debian.menu.Debian_menu.Debian },
        { "open terminal", terminal }
    }
})
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or dpi(16),
    before = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "open terminal", terminal },
        -- other triads can be put here
    }
})
---- hide menu when mouse leaves it
--awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function() awful.util.mymainmenu:hide() end)

menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({ altkey }, "p", function()
                naughty.notify({title = "Say cheese!", text = "Taking shot in 5 seconds", timeout = 4, icon = beautiful.screenshot_icon, icon_size=48})
                awful.spawn.with_shell("scrot") end,
              {description = "take a screenshot", group = "hotkeys"}),

    -- X screen locker
    awful.key({ modkey, altkey }, "l", function () os.execute(scrlocker) end,
              {description = "lock screen", group = "hotkeys"}),

    -- Typematrix layout
    awful.key({ modkey, altkey }, "k", function() awful.spawn("feh -Nx " .. extra.utils.get_theme_path() .. "typematrix_layout.png") end,
              { description = "show Typematrix layout", group = "applications" }),

    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Xrandr management
		awful.key({altkey}, "q", function() extra.xrandr.xrandr() end ),

    -- Awesome switcher
    awful.key({ "Mod1",           }, "Tab",
        function ()
            extra.switcher.switch( 1, "Mod1", "Alt_L", "Shift", "Tab")
        end),

    awful.key({ "Mod1", "Shift"   }, "Tab",
        function ()
            extra.switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
        end),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),

    -- Applications
    awful.key({ modkey, "Mod1" }, 'c', function() awful.spawn("google-chrome-stable") end,
        { description = "open google chrome stable browser", group = "applications" }),
    awful.key({ modkey, "Mod1" }, 'b', function() awful.spawn("brave-browser") end,
        { description = "open brave browser", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "f", function() awful.spawn("firefox") end,
        { description = "open firefox browser", group = "applications" }),
    awful.key({ modkey, "Mod1" }, 'p', function() awful.spawn("pycharm") end,
        { description = "open pycharm ide", group = "applications" }),
    awful.key({ modkey, "Mod1" }, 'x', function() awful.spawn(terminal .. " -title mutt -e sh -c 'mutt'") end,
        { description = "open mutt session", group = "applications" }),
    awful.key({ modkey, "Mod1" }, 'u', function() awful.spawn(terminal .. " -title urxvt_shell") end,
        { description = "open shell session", group = "applications" }),
    awful.key({ modkey, "Mod1" }, 'v', function() awful.spawn(terminal .. " -title vim_ide -e sh -c 'vim'") end,
        { description = "open vim ide", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "t", function() awful.spawn("thunderbird") end,
        { description = "open thunderbird mail client", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "g", function() awful.spawn("goland") end,
        { description = "open goland ide", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "j", function() awful.spawn("idea") end,
        { description = "open intellij idea", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "i", function() awful.spawn(terminal .. " -title weechat -e sh -c '" .. os.getenv("AWESOME_WEECHAT") .. "'") end,
        { description = "open remote weechat irc client", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "m", function() awful.spawn(terminal .. " -title mocp_widget -e sh -c 'mocp'") end,
        { description = "open music on console client", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "z", function() awful.spawn("zoom") end,
        { description = "open zoom video conference", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "s", function() awful.spawn("slack") end,
        { description = "open slack discussion", group = "applications" }),
    awful.key({ modkey, "Mod1" }, "r", function() awful.spawn(terminal .. " -title ranger -e sh -c 'ranger'") end,
        { description = "open ranger file browser", group = "applications" }),

    -- Touchpad on/off shorcuts
    awful.key({ modkey, "Mod1" }, "d", function() awful.spawn('xinput --disable ' .. touchpad_ids[1]) end,
        { description = "deactivate touchpad", group = "system" }),
    awful.key({ modkey, "Mod1" }, "a", function() awful.spawn('xinput --enable ' .. touchpad_ids[1]) end,
        { description = "activate touchpad", group = "system" }),

    -- Keyboard keys
    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("gobacklight -d 5") end,
        { description = "decrease brightness by 5", group = "system" }),
    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("gobacklight -i 5") end,
        { description = "increase brightness by 5", group = "system" }),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("amixer -D pulse sset Master 5%-") end,
        { description = "decrease volume by 5%", group = "system" }),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("amixer -D pulse sset Master 5%+") end,
        { description = "increase volume by 5%", group = "system" }),
    awful.key({}, "XF86AudioPrev", function() utils.moc_control("previous") end,
        { description = "play previous song with mocp", group = "system" }),
    awful.key({}, "XF86AudioPlay", function() utils.moc_control("play") end,
        { description = "play music with mocp", group = "system" }),
    awful.key({ "Shift" }, "XF86AudioPlay", function() utils.moc_control("stop") end,
        { description = "stop music with mocp", group = "system" }),
    awful.key({}, "XF86AudioNext", function() utils.moc_control("next") end,
        { description = "play next song with mocp", group = "system" }),

    -- ALSA volume control
    awful.key({ altkey }, "Up",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ altkey }, "Down",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ altkey }, "m",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "hotkeys"}),
    awful.key({ altkey, "Control" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume 100%", group = "hotkeys"}),
    awful.key({ altkey, "Control" }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume 0%", group = "hotkeys"}),


    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey, "Shift" }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey, "Shift" }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "hotkeys"}),

    -- User programs
    awful.key({ modkey }, "q", function () awful.spawn(browser) end,
              {description = "run browser", group = "launcher"}),
    awful.key({ modkey }, "a", function () awful.spawn(guieditor) end,
              {description = "run gui editor", group = "launcher"}),

    -- Default
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
    --]]
)

clientkeys = my_table.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, }, "c",      function (c) c:kill()                                   end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

local function get_screen(tag)
	local screen_count = screen.count()

	if tag == 'www' or tag == 'mail'  then
		if screen_count == 1 then
			return 1
		else
			return 2
		end
	end
	if tag == 'dev' or tag == 'desk' or tag == 'sys' then
		return 1
	end
	if tag == 'shell' or tag == 'talk' or tag == 'media' then
		if screen_count == 3 then
			return 3
		else
			return 1
		end
	end
	if tag == 'zik' then
		return screen_count
	end

end
-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            maximized_vertical = false,
            maximized_horizontal = false,
            buttons = clientbuttons,
            size_hints_honor = false,
            screen = awful.screen.preferred,
            placement = awful.placement.no_offscreen + awful.placement.centered
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = { "DTA", "copyq" },
            class = { "Arandr", "Gpick", "MessageWin", "Sxiv", "Wpa_gui", "pinentry", "veromix", "xtightvncviewer" },
            name = { "Event Tester" },
            role = { "AlarmWindow", "pop-up" }
        },
        properties = { floating = true }
    },

    -- Remove titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = false }
    },

    -- Set rules to creates app in proper tags with special properties

    -- Tag #1 [www]
    {
        rule_any = {
            class = { "Firefox", "Chromium-browser", "Google-chrome", "Tor Browser", "Brave-browser", "Links" }
        },
        properties = { screen = get_screen("www"), tag = "[www]" }
    },
    -- Tag #2 [mail]
    {
        rule_any = {
            class = { "Thunderbird" },
            name = { "mutt" }
        },
        properties = { screen = get_screen("mail"), tag = "[mail]", switchtotag = true }
    },
    -- Tag #3 [dev]
    {
        rule_any = {
            class = { "jetbrains-pycharm", "jetbrains-pycharm-ce", "jetbrains-goland", "jetbrains-idea-ce" },
            name = { "PyCharm", "vim_ide", "GoLand" }
        },
        properties = { screen = get_screen("dev"), tag = "[dev]", switchtotag = true }
    },
    -- Tag #4 [shell]
    {
        rule_any = {
            class = { "Terminator" },
            name = { "urxvt_shell" }
        },
        properties = { screen = get_screen("shell"), tag = "[shell]", switchtotag = true }
    },
    -- Tag #5 [talk]
    {
        rule_any = {
            name = { "Slack" },
            class = { "slack", "discord" }
        },
        properties = { screen = get_screen("talk"), tag = "[talk]", switchtotag = true }
    },
    -- Tag #6 [desk]
    {
        rule_any = {
            name = { "Thunar", "ranger" }
        },
        properties = { screen = get_screen("desk"), tag = "[desk]", switchtotag = true }
    },
    -- Tag #7 [media]
    {
        rule_any = {
            class = { "Gimp", "Openshot", "Steam", "vlc", "zoom", "Eog"},
            name = { "Zoom", "EasyTAG" }
        },
        properties = { screen = get_screen("media"), tag = "[media]", switchtotag = true }
    },
    -- Tag #8 [sys]
    {
        rule_any = {
            name = { "Bluetooth Devices", "Remmina", "System Settings" },
            class = { "QEMU", "Virt-manager", "VirtualBox", "Arandr", "Seahorse", "Pavucontrol", "Nm-applet", "Nm-connection-editor", "Ibus-setup", "cloud-backup-ui" }
        },
        properties = { screen = get_screen("sys"), tag = "[sys]", switchtotag = true }
    },
    -- Tag #9 [zik]
    {
        rule_any = {
            name = { "vlc", "MOC", "mocp_widget" },
            class = { "mocp" }
        },
        properties = { screen = get_screen("zik"), tag = "[zik]", switchtotag = true }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = dpi(16)}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- possible workaround for tag preservation when switching back to default screen:
-- https://github.com/lcpz/awesome-copycats/issues/251
-- }}}
