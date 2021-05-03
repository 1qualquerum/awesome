pcall(require, "luarocks.loader") -- leav this alone

-------- LIBRARIES --------
require("awful.autofocus")
local powermenu = require("widgets.powermenu")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 32

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-------- ERROR HANDLING --------
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-------- AUTOSTART --------

run_once({ "picom", "nm-applet", "volumeicon", "xfce4-clipman", "lxsession" }) -- entries must be separated by commas
awful.spawn.once("nitrogen --restore")

awful.spawn.single_instance("whatsapp-nativefier-dark", awful.rules.rules)

-------- VARIABLES --------
beautiful.init("~/.config/awesome/theme.lua")

terminal = "alacritty"
modkey = "Mod4"
alt = "Mod1"

-------- LAYOUTS --------

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

-------- TAG + WIDGETS --------

---- Clock Widget
clock = awful.widget.watch("date +'%a %d %b %R'", 60)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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

awful.screen.connect_for_each_screen(function(s)

---- TAGS
    awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

---- Layout Box Widget
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
---- Tag List Widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    
---- Memory - Cpu - Temperature Widgets ----
    mem_widget = require('widgets.mem')
    cpu_widget = require('widgets.cpu')
    temp_widget = require('widgets.temp')

 -------- CREATING THE PANEL --------

    s.mywibox = awful.wibar({ position = "top",
    screen = s,
    height = 26,
    bg = "transparent",

 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {   layout = wibox.layout.fixed.horizontal,
            {
                {
                    {   s.mytaglist,
                        top = 3,
                        bottom = 3,
                        left = 4,
                        right = 4,
                        widget = wibox.container.margin
                    },
                    shape = beautiful.rrect(10),
                    bg = beautiful.bg_normal,
                    widget = wibox.container.background
                },
                left = 15,
                top = 3,
                widget = wibox.container.margin,
            },
            {
                {
                    {
                        s.mylayoutbox,
                        top = 5,
                        bottom = 4,
                        left = 7,
                        right = 7,
                        widget = wibox.container.margin
                    },
                shape = beautiful.rrect(10),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
                },
            left = 4,
            top = 3,
            widget = wibox.container.margin,
            },
        },
            {
                {
                    {
                        clock,
                        left = 15,
                        right =15,
                        widget = wibox.container.margin
                    },
                    shape = beautiful.rrect(10),
                    bg = beautiful.bg_normal,
                    widget = wibox.container.background
                },
                top = 3,
                widget = wibox.container.margin,
            },
        {
    layout = wibox.layout.fixed.horizontal,
        {   
            {   
                {
                    mem_widget,
                    top = 3,
                    bottom = 3,
                    left = 7,
                    right =7,
                    widget = wibox.container.margin
                },
                shape = beautiful.rrect(10),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            top = 3,
            right = 5,
            widget = wibox.container.margin,
        },
        {   
            {   
                {
                    cpu_widget,
                    top = 3,
                    bottom = 3,
                    left = 7,
                    right =7,
                    widget = wibox.container.margin
                },
                shape = beautiful.rrect(10),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            top = 3,
            right = 5,
            widget = wibox.container.margin,
        },
        {   
            {   
                {
                    temp_widget,
                    top = 3,
                    bottom = 3,
                    left = 7,
                    right =7,
                    widget = wibox.container.margin
                },
                shape = beautiful.rrect(10),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            top = 3,
            right = 5,
            widget = wibox.container.margin,
        },  
        {   
            {   
                {
                    wibox.widget.systray(),
                    top = 3,
                    bottom = 3,
                    left = 10,
                    right = 10,
                    widget = wibox.container.margin
                },
                shape = beautiful.rrect(10),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            top = 3,
            right = 5,
            widget = wibox.container.margin,
        },
        {
            {
                {
                    powermenu,
                    top = 3,
                    left = 7,
                    right = 7,
                    bottom = 3,
                    widget = wibox.container.margin
                },
                shape = beautiful.rrect(10),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            right = 15,
            top = 3,
            widget = wibox.container.margin,
            }
        },
    }
end)

-------- SET THE KEYBINDINGS --------

_G.root.keys(require("keys"))

--------- RULES ---------

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- client to tag

    { rule = { class = "Brave-browser" },
  properties = { tag = "", switchtotag = true } },
    { rule = { class = "whatsapp-nativefier-d52542" },
  properties = { tag = ""} },
    { rule = { name = "Steam" },
  properties = { tag = ""} },
    { rule = { class = "vlc" },
  properties = { tag = ""} },
    { rule = { class = "discord" },
  properties = { tag = ""} },


    -- Floating clients.
    {rule_any = {
        class = {
            "Arandr",
            "Galculator",
            "Gpick",
            "Imagewriter",
            "Font-manager",
            "Sxiv",
            "Wpa_gui",
            "Pavucontrol",
            "Ulauncher"},

    name = {
          "Event Tester",  -- xev.
        },
        role = {
          "pop-up",
          "Preferences",
          "setup",
        }
      }, properties = { floating = true }},
}

---- Signals ----

-- Signal function to execute when a new client appears.
client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)