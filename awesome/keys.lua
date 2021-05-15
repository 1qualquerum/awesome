local gears = require('gears')
local awful = require('awful')
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

---------------------------- MOUSE BINDINGS ----------------------------

root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

---------------------------- KEY BINDINGS ----------------------------

    -- 
globalkeys = gears.table.join(

    -- PROGRAMS
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "programs"}),
    awful.key({ modkey },           "space",     function () awful.spawn("dmenu_run") end,
           {description = "run dmenu", group = "programs"}),
    awful.key({ modkey },           "b",     function () awful.spawn("brave") end,
            {description = "open brave", group = "programs"}),
    awful.key({ modkey, "Shift" },  "s",     function () awful.spawn("spectacle -r -c -b") end,
            {description = "copy a print of a region to the clipboard", group = "programs"}),
    awful.key({ modkey },           "z",     function () awful.spawn("pamac-manager") end,
            {description = "open pamac", group = "programs"}),
    awful.key({ "Control", "Shift" },  "Escape",     function () awful.spawn("alacritty -e htop") end,
            {description = "spawn htop", group = "programs"}),
    --awful.key({ modkey },  "space",     function () awful.spawn('rofi -modi drun -show drun -display-drun "Apps : " -line-padding 4 -columns 2 -lines 5 -padding 50 -hide-scrollbar -show-icons -drun-icon-theme "Arc-X-D" -font "Noto Sans Regular 11"') end,
    --        {description = "spawn rofi apps", group = "programs"}),
    awful.key({ alt },  "Tab",     function () awful.spawn('rofi -show window -display-window "Window : " -line-padding 4 -lines 5 -padding 50 -hide-scrollbar -show-icons -drun-icon-theme "Arc-X-D" -font "Noto Sans Regular 11"') end,
            {description = "spawn rofi widow switcher", group = "programs"}),


    -- AWESOME RALATED KEY BINDINGS
    awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- CHANGE SCREEN
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- CHANGE FOCUS
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- LAYOUT MANIPULATION
    awful.key({ modkey, "Control"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Control"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,    alt    }, "l",     function () awful.client.incwfact(-0.05)          end,
              {description = "decrease client height factor", group = "layout"}),
    awful.key({ modkey,    alt    }, "h",     function () awful.client.incwfact( 0.05)          end,
              {description = "increase client height factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"})
)
    -- FULLSCREEN | FLOATING | CLOSE | MOVE TO MASTE | MOVE TO SCREEN
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    ----
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
        {description = "toggle floating", group = "client"}),
    ----
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"})
)

    -- WORKSPACES KEYBINDIGS

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- VIEW TAG ONLY.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- MOVE CLIENT TO TAG.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
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

return globalkeys
