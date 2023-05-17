-- to have good looking tables in terminal https://github.com/jagt/pprint.lua

pcall(require, "luarocks.loader")
local pprint = require("pprint")
local glome = require("glome")

local awful = require("awful")
local wibox = require("wibox")

local function menutest(xid)
	local k = glome.appmenu.get_menu(xid, 0, -1)
	pprint(k)
	--local id = 12 -- what to call, makes a split in Konsole
	--glome.appmenu.call_event(xid, id)
end

local function findWhere(array, key, value)
	local t = 1
	while (t < #array and array[t][key] ~= value) do
		t = t + 1
	end
	if t < #array then
		return array[t]
	else
		return false
	end
end
local function arrangeIntoTree(paths)
	local tree = {}
	for i = 1, #paths do
		local path = paths[i]
		local currentLevel = tree
		for j = 1, #path do
			local part = path[j]
			local existingPath = findWhere(currentLevel, 'name', part)
			if existingPath then
				currentLevel = existingPath.children
			else
				local newPart = { name = part, children = {} }
				table.insert(currentLevel, newPart)
				currentLevel = newPart.children
			end
		end
	end
	return tree
end

local function findInList(k, path_end)
	for i, o in ipairs(k) do
		if o.path[#o.path] == path_end then
			return i, o
		end
	end
end
local function findInListStart(k, path, diff)
	local b = type(path) == "string" and path or table.concat(path, "/")
	local r = {}
	for i, o in ipairs(k) do
		if diff then
			local baz = { table.unpack(o.path) }
			for i = 1, diff, 1 do
				table.remove(baz, #baz)
			end
			local a = table.concat(baz, "/")
			if a == b then
				table.insert(r, table.concat(o.path, "/"))
				--return o, i
			end
		else
			local a = type(o.path) == "string" and o.path or table.concat(o.path, "/")
			if a:find(b, 1, true) == 1 then
				table.insert(r, table.concat(o.path, "/"))
				--return i, o
			end
		end
	end
	return r
	--return nil, -1
end

local function findInListFull(k, path)
	local b = type(path) == "string" and path or table.concat(path, "/")
	for i, o in ipairs(k) do
		local a = type(o.path) == "string" and o.path or table.concat(o.path, "/")
		if a == b then
			return o, i
		end
	end
	return nil, -1
end


local function convertTree(k, tree)
	--local tr = {}
	for _, foo in ipairs(tree) do
		if #foo.children > 0 then
			convertTree(k, foo.children)
			foo.action = foo.children
		else
			foo.action = function() print(foo.id) end
		end
		local _, c = findInList(k, foo.name)
		foo.id = c.id
		--foo.label = c.label
		--foo.accel = c.accel
		foo[1] = c.label
		--foo[2] = foo.action
		foo.name = nil
		foo.children = nil
		foo.id = nil
		foo.action = nil
	end
	local function recurse(currentLevel, state)
		if currentLevel == nil then
			return nil
		end
		if state == nil then
			state = {}
		end
		for _, foo in ipairs(currentLevel) do
			state[1] = foo.label
			state[2] = recurse(foo.children, {}) or foo.action
		end
		return state
	end
	-- pprint(recurse(tree))
end

local function gtktest(gtk_bus_name, gtk_obj_path)
	local k = glome.gtk.get_menu(gtk_bus_name, gtk_obj_path)
	local tr = {}
	--pprint(k)
	--local n = 0
	--while (n < #k) do
	local paths = {}
	-- for j = 1, 2 do
	-- 	for i, o in ipairs(k) do
	-- 		-- pprint(o)
	-- 		local foo = { table.unpack(o.path) }
	-- 		local bar = table.concat(foo, ".")
	-- 		print(type(bar))
	-- 		if j == 1 then
	-- 			tr[bar] = { i, id = o.id, children = {} }
	-- 		end
	-- 		if #o.path > 1 then
	-- 			local baz = { table.unpack(foo) }
	-- 			table.remove(baz, #baz)
	-- 			local qux = table.concat(baz, ".")
	-- 			--print(qux)
	-- 			if tr[qux] ~= nil then
	-- 				table.insert(tr[qux].children, i)
	-- 				print("test")
	-- 			end
	-- 		end
	-- 		--table.remove(foo, #foo)
	-- 	end
	-- end
	-- end
	for _, o in ipairs(k) do
		table.insert(paths, o.path)
	end

	--tr = arrangeIntoTree(paths)
	-- pprint(tr)
	--convertTree(k, tr)
	--pprint(tr)
	--return tr
	--pprint(k)
	local mt = {}
	mt.__index = function(table, key)
		local result = type(key) ~= "number" and findInListFull(k, key) or rawget(table, key)
		local mt2 = {}
	end
	setmetatable(k, mt)
	k.root = function(self)
		local root = {}
		for _, v in ipairs(self) do
			if #v.path == 1 then
				--pprint(v)
				table.insert(root, table.concat(v.path, "/"))
			end
		end
		return root
	end
	k.list = function(self, path, diff)
		return findInListStart(self, path, diff)
	end




	return k

	--pprint(paths)
	-- return tr
	--local id = "unity.file-open-location" -- a GIMP specific action
	--glome.gtk.call_event(id, gtk_bus_name, gtk_obj_path)
end

local function menu_test()
	local menu = {}
	for _, k in ipairs(gtktest(":1.512", "/org/appmenu/gtk/window/0"):root()) do
		menu[#menu + 1] = { string.gsub(k, "_", "&"), function()
			--naughty.notify{text="test"}
			awful.menu({{"f",function()end},{"r",function()end}}):show()
		end }
	end
	return menu
end
local function bar_test()
	awful.popup { widget = {
		layout = wibox.layout.fixed.horizontal,
		table.unpack(awful.menu(menu_test()).layout.children)
	}, placement = awful.placement.centered, ontop = true}
end

--local m = {} for _, o in ipairs(k:root()) do table.insert(m,{text=string.gsub(k[o].label,"_","&"),cmd=function(a,b)naughty.notify{title=tostring(a),text=gears.debug.dump_return(b)}end}) end awful.menu(m):show()
-- local m = {}
-- local k = {}
-- for _, o in ipairs(k:root()) do
-- 	local act = nil
-- 	findInListStart(k, k[o].path, 1)
-- 	table.insert(m,
-- 		{
-- 			text = string.gsub(k[o].label, "_", "&"),
-- 			cmd = function(p)
-- 				naughty.notify { text = k[o].id, title = gears.debug.dump_return(gears.table.keys(p)) }
-- 				-- glome.gtk.call_event("unity.file-menu", ":1.220", "/org/appmenu/gtk/window/0")
-- 			end
-- 		})
-- end
-- awful.menu(m):show()
--g = require('luagraphs.data.graph').create(#example(":1.16378", "/org/appmenu/gtk/window/0"), true)

-- you can get the info that needs to be passed here with the get.sh script
-- ('', objectpath '/')
-- _GTK_UNIQUE_BUS_NAME = ":1.15234"
-- _GTK_MENUBAR_OBJECT_PATH = "/org/appmenu/gtk/window/0"
-- ID: 20972318
--menutest(20972318) -- takes window id
--gtktest(":1.15234", "/org/appmenu/gtk/window/0") -- takes gtk bus and object

return { gtktest = gtktest, findInListStart = findInListStart, findInListFull = findInListFull, findInList = findInList, menu_test=menu_test,bar_test=bar_test }
