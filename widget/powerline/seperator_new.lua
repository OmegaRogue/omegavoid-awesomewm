---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by omegarogue.
--- DateTime: 15.02.22 10:14
---

local fixed = require("wibox.layout.fixed")
local gears = require("gears")
local wibox = require("wibox")
local lain = require('lain')
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

local function factory(args)
    args = args or {}
    local seperator = {
        layout = args.layout or fixed.horizontal(),
        is_left = args.is_left or false,
        fg = args.fg or beautiful.fg_normal,
        curr_bg = args.curr_bg or beautiful.bg_normal,
        next_bg = args.next_bg or beautiful.bg_normal
    }

    local arrow = {}
    local thin = {}
    if seperator.is_left then
        arrow = lain.util.separators.arrow_right(seperator.curr_bg,seperator.next_bg)
        thin = wibox.widget {
            widget = wibox.widget.separator,
            shape = gears.shape.powerline,
            forced_width = dpi(18),
            color = seperator.fg,
        }
    else
        arrow = lain.util.separators.arrow_left(seperator.next_bg, seperator.curr_bg)
        thin = wibox.widget {
            widget = wibox.widget.separator,
            forced_width = dpi(18),
            shape = function(cr, width, height)
                gears.shape.transform(gears.shape.powerline):translate(width, beautiful.wibar_height):rotate(math.pi)(cr, width, height)
            end,
            color = seperator.fg,
        }
    end

    if seperator.curr_bg == seperator.next_bg then
        seperator[1] = wibox.container.background(thin, seperator.curr_bg)
    else
        seperator[1] = wibox.container.background(arrow, seperator.curr_bg)
    end

    return seperator

end

return factory
