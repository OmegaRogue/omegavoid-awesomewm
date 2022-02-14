---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by omegarogue.
--- DateTime: 15.02.22 10:14
---

local setmetatable = setmetatable
local os = os
local textbox = require("wibox.widget.textbox")
local gears = require("gears")
local wibox = require("wibox")
local gtable = require("gears.table")
local lain = require('lain')
local markup = lain.util.markup
local beautiful = require("beautiful")
local seperator = { mt = {} }



local function new(left,current_color,next_color,fg)
    local w = wibox.layout.fixed.horizontal()
    gtable.crush(w, seperator, true)
    local arrow = {}
    local thin = {}
    local character_soft = "\u{E0B1}"
    local character_hard = "\u{E0B0}"
    local curr_bg = current_color or beautiful.bg_normal
    local next_bg = next_color or beautiful.bg_normal
    --local divider_fg = fg or beautiful.fg_powerline or beautiful.fg_normal
    local base_fg = fg or beautiful.fg_normal
    if left then
        arrow = lain.util.separators.arrow_right(current_color,next_color)
        thin = wibox.widget{
            widget = wibox.widget.separator,
            shape = gears.shape.powerline,
            forced_width=18,
            color = fg,
        }
    else
        arrow = lain.util.separators.arrow_left(next_color,current_color)
        thin = wibox.widget{
            widget = wibox.widget.separator,
            forced_width=18,
            shape = function(cr,width,height)
                gears.shape.transform(gears.shape.powerline):translate(width,beautiful.wibar_height):rotate(math.pi)(cr,width,height)
            end,
            color = fg,
        }

        --thin.shape = gears.shape.transform(gears.shape.powerline):translate(10,beautiful.wibar_height):rotate(math.pi)
        --curr_bg = next_color or beautiful.bg_normal
        --next_bg = current_color or beautiful.bg_normal
    end

    if curr_bg == next_bg then
        w:add(wibox.widget.background(thin,curr_bg))
    else
        w:add(wibox.widget.background(arrow,curr_bg))
    end

    return w
end
function seperator.mt:__call(...)
    return new(...)
end


return setmetatable(seperator, seperator.mt)

