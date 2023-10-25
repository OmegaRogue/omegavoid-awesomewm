---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by omegarogue.
--- DateTime: 15.02.22 10:07
---

local setmetatable = setmetatable
local os = os
local fixed = require("wibox.layout.fixed")
local seperator = require("omegavoid.widget.powerline.seperator_new")
local segment = require("omegavoid.widget.powerline.segment")
local gtable = require("gears.table")
local lain = require('lain')
local markup = lain.util.markup
local beautiful = require("beautiful")
local wibox = require('wibox')
local awestore = require("awestore")



-- powerline.segment(beautiful.bg_focus, nil, widgets.memicon, widgets.mem),
-- powerline.segment(nil, nil, widgets.cpuicon, widgets.cpu),
-- powerline.segment(beautiful.bg_focus, nil, widgets.baticon, widgets.bat),
-- powerline.segment(nil, nil, awful.widget.keyboardlayout),
-- powerline.segment(beautiful.bg_focus, nil, s.systray),
-- powerline.segment(nil, nil, s.layoutbox),
-- powerline.segment("#303030", "#626262", widgets.date),
-- powerline.segment("#303030", "#626262", widgets.time),
-- powerline.segment("#121212", nil, s.powerbutton),

-- [{bg,fg,content={}}]


local powerline_line = {}




local function factory(args)
    args = args or {}
    local line = {
        layout = args.layout or fixed.horizontal(),
        is_left = args.is_left or false,
        line_layout = {},
		bg_default = args.bg or beautiful.bg_normal,
    }
    for i, v in ipairs(args.line_layout) do
        line.line_layout[i] = {
            bg = awestore.writable(v.bg or beautiful.bg_normal),
            fg = awestore.writable(v.fg or beautiful.fg_normal),
            content = awestore.writable(v.content)
        }
        local container = wibox.widget{
            widget = wibox.container.background,
            bg = v.bg,
            {
                layout = wibox.layout.fixed.horizontal,
                --wibox.widget.textbox("a"),
            }
        }
        line.line_layout[i].bg:subscribe(function(bg)
            container.bg = bg
        end)
        line.line_layout[i].fg:subscribe(function(fg)
            container.fg = fg
        end)
        for _, c in ipairs(v.content) do
            container.children[1]:add(c)
        end
        line.line_layout[i].content:subscribe(function(content)
            container.children[1]:reset()
            for _, c in ipairs(content) do
                container.children[1]:add(c)
            end
        end)
        if line.is_left then
            line[i*2-1] = container
        else
            line[i*2] = container
        end

    end
    for i, v in ipairs(line.line_layout) do
        if line.is_left then
            if i == #line.line_layout then
                line[i*2] = seperator{is_left=true,curr_bg=v.bg:get(),next_bg=line.bg_default,fg=v.fg:get()}
                v.bg:subscribe(function(bg)
                    line[i*2] = seperator{is_left=true,curr_bg=bg,next_bg=line.bg_default,fg=v.fg:get()}
                end)
                v.fg:subscribe(function(fg)
                    line[i*2] = seperator{is_left=true,curr_bg=v.bg:get(),next_bg=line.bg_default,fg=fg}
                end)
            else
                line[i*2] = seperator{is_left=true,curr_bg=v.bg:get(),next_bg=line.line_layout[i+1].bg:get(),fg=v.fg:get()}
                v.bg:subscribe(function(bg)
                    line[i*2] = seperator{is_left=true,curr_bg=bg,next_bg=line.line_layout[i+1].bg:get(),fg=v.fg:get()}
                end)
                line.line_layout[i+1].bg:subscribe(function(bg)
                    line[i*2] = seperator{is_left=true,curr_bg=v.bg:get(),next_bg=bg,fg=v.fg:get()}
                end)
                v.fg:subscribe(function(fg)
                    line[i*2] = seperator{is_left=true,curr_bg=v.bg:get(),next_bg=line.line_layout[i+1].bg:get(),fg=fg}
                end)
            end
        else
            if i == 1 then
                line[1] = seperator{curr_bg=v.bg:get(),next_bg=line.bg_default,fg=v.fg:get()}
                v.bg:subscribe(function(bg)
                    line[1] = seperator{curr_bg=bg,next_bg=line.bg_default,fg=v.fg:get()}
                end)
                v.fg:subscribe(function(fg)
                    line[1] = seperator{curr_bg=v.bg:get(),next_bg=line.bg_default,fg=fg}
                end)
            else
                line[i*2-1] = seperator{curr_bg=v.bg:get(),next_bg=line.line_layout[i-1].bg:get(),fg=v.fg:get()}
                v.bg:subscribe(function(bg)
                    line[i*2-1] = seperator{curr_bg=bg,next_bg=line.line_layout[i-1].bg:get(),fg=v.fg:get()}
                end)
                line.line_layout[i-1].bg:subscribe(function(bg)
                    line[i*2-1] = seperator{curr_bg=v.bg:get(),next_bg=bg,fg=v.fg:get()}
                end)
                v.fg:subscribe(function(fg)
                    line[i*2-1] = seperator{curr_bg=v.bg:get(),next_bg=line.line_layout[i-1].bg:get(),fg=fg}
                end)

            end
        end

    end

    return line

end




return factory
