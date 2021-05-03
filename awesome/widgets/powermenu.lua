-------------------------------------------------
-- Power menu Widget for Awesome Window Manager
-- Changed the bookmark widget from Pavel Makhov
-- link for his bookmark widget: 
--http://pavelmakhov.com/awesome-wm-widgets/#tabLists
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local HOME = os.getenv('HOME')

--- Widget to add to the wibar
local powermenu = wibox.widget {
    {
        text = "",
        resize = true,
        widget = wibox.widget.textbox,
    },
    margins = 4,
    layout = wibox.container.margin
}

local menu_items = {
    { name = ' Desligar', command = "systemctl poweroff"},
    { name = ' Reiniciar', command = "systemctl reboot" },
    { name = ' Suspender', command = "systemctl suspend" },
    { name = ' Lock', command = "betterlockscreen -l" },
    { name = ' Logout', command = "echo 'awesome.quit()' | awesome-client" },
    { name = ' Cancel', command = "" },
}


local popup = awful.popup {
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    border_width = 0,
    border_color = beautiful.bg_focus,
    maximum_width = 400,
    offset = { y = 5 },
    widget = {}
}
local rows = { layout = wibox.layout.fixed.vertical }

for _, item in ipairs(menu_items) do

    local row = wibox.widget {
        {
            {
                {
                    text = item.name,
                    widget = wibox.widget.textbox
                },
                spacing = 12,
                layout = wibox.layout.fixed.horizontal
            },
            margins = 8,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    -- Change item background on mouse hover
    row:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_normal) end)
    row:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)

    -- Change cursor on mouse hover
    local old_cursor, old_wibox
    row:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)
    row:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    -- Mouse click handler
    row:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                popup.visible = not popup.visible
                awful.spawn.with_shell(item.command)
            end)
        )
    )

    -- Insert created row in the list of rows
    table.insert(rows, row)
end

-- Add rows to the popup
popup:setup(rows)

-- Mouse click handler
powermenu:buttons(
    awful.util.table.join(
        awful.button({}, 1, function()
            if popup.visible then
                popup.visible = not popup.visible
            else
                 popup:move_next_to(mouse.current_widget_geometry)
            end
    end))
)

return powermenu