pcall(require, "luarocks.loader") -- leav this alone

---- LIBRARIES ----
require("awful.autofocus")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 32
local wibar = require("wibar")
-- run once function
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

---- ERROR HANDLING ----
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
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

---- AUTOSTART ----

run_once({ "picom", "nm-applet", "volumeicon", --[[ "udiskie -t", ]] "xfce4-clipman", "lxsession" }) -- entries must be separated by commas
awful.spawn.once("nitrogen --restore")

---- VARIABLES ----
local theme_path = string.format("%s/.config/awesome/themes/theme.lua", os.getenv("HOME"))
beautiful.init(theme_path)

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
alt = "Mod1"

---- LAYOUTS ----

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

---- TAG ----

awful.screen.connect_for_each_screen(function(s)
    for i = 1, 9, 1
    do
       awful.tag.add(i, {
          icon = gears.filesystem.get_configuration_dir() .. "/icons/" .. i .. ".svg",
          icon_only = true,
          layout = awful.layout.suit.tile,
          screen = s,
          selected = i == 1
       })
    end
end)


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- SET KEYS
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
    -- Floating clients.
    { 
        rule_any = {
            class = {"Arandr", "Sxiv", "Wpa_gui"},
            name = {"Event Tester"},
            role = {"pop-up"}
        }, 
        properties = { floating = true }
    }, {
        rule_any = {type = { "dialog" }},
        properties = { titlebars_enabled = true }
    }, {
        rule = {
            class = "Firefox", "Brave-browser"
        },
        properties = { screen = 1, tag = "1" }
    }, {
        rule = {
            name = "WhatsApp"
        },
        properties = { screen = 1, tag = "2" }
    },
}
--
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