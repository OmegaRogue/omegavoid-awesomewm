package = "omegavoid-awesomewm"
version = "dev-1"
source = {
   url = "https://github.com/OmegaRogue/omegavoid-awesome",
}
description = {
   summary = "Various utilities and modules for Awesome WM",
   homepage = "https://github.com/OmegaRogue/omegavoid-awesome",
   license = "GNU GPL v3"
}
dependencies = {
   "lua >= 5.1",
   "awesome >= 4.0",
}
build = {
   type = "builtin",
   modules = {
      ["omegavoid.helpers"] = "helpers.lua",
      omegavoid = "init.lua",
      ["omegavoid.widget.clock"] = "widget/clock.lua",
      ["omegavoid.widget.init"] = "widget/init.lua",
      ["omegavoid.widget.powerline.init"] = "widget/powerline/init.lua",
      ["omegavoid.widget.powerline.segment"] = "widget/powerline/segment.lua",
      ["omegavoid.widget.powerline.seperator"] = "widget/powerline/seperator.lua"
   }
}
