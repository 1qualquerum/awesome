-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

--- TEXTCLOCK WIDGET
mytextclock = wibox.widget.textclock()

--- CREATE THE TAGLIST CLICKABLE WORKSPACES FOR ALL SCREENS
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

--- LAYOUT WIDGET
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
--- CREATE A TAGLIST WIDGET
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style = {shape = gears.shape.rectangle},
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {id = 'icon_role', widget = wibox.widget.imagebox},
                    layout = wibox.layout.fixed.horizontal
                },
                left = 5,
                right = 5,
                top = 3,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        },
    }

------ BAR CREATION ------
    s.mywibox = awful.wibar({ 
        position = "bottom",
        screen = s,
        height = dpi(30),
        width = 1897,
        bg = "transparent",
        x = 4,
        y = dpi(4),
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { --- LEFT WIDGETS
            layout = wibox.layout.fixed.horizontal,
            {
                {
                    s.mytaglist,
                    bg = beautiful.bg_normal,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background
                },
                bottom = 3,
                left = 15,
                widget = wibox.container.margin,
            },
        },
        { --- RIGHT WIDGETS
            {
                {
                    mytextclock,
                    top = dpi(3),
                    bottom = dpi(3),
                    left = dpi(7),
                    right = dpi(7),
                    widget = wibox.container.margin
                },
                bg = "#30333d",
                shape = gears.shape.rounded_rect,
                widget = wibox.container.background
            },
            bottom = 3,
            right = 5,
            left = 5,
            widget = wibox.container.margin
        },
        { --- RIGHT WIDGETS
            {
                {
                    {
                        wibox.widget.systray(),
                        top = dpi(3),
                        bottom = dpi(3),
                        left = dpi(7),
                        right = dpi(7),
                        widget = wibox.container.margin
                    },
                    bg = "#30333d",
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background
                },
                bottom = 3,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
            {
                {
                    {
                        s.mylayoutbox,
                        top = dpi(3),
                        bottom = dpi(3),
                        left = dpi(7),
                        right = dpi(7),
                        widget = wibox.container.margin
                    },
                    bg = "#30333d",
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background
                },
                bottom = 3,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal,
        },
    }

end)
-- EOF ------------------------------------------------------------------------
