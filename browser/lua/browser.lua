local gui = require('yue.gui')

-- Create window.
win = gui.Window.create{}
win.onclose = function() gui.MessageLoop.quit() end
win:setcontentsize{width=500, height=500}

-- Create controls and set layout.
local contentview = gui.Container.create()
win:setcontentview(contentview)
local toolbar = gui.Container.create()
toolbar:setstyle{flexdirection='row', padding=5}
contentview:addchildview(toolbar)
local back = gui.Button.create('<')
toolbar:addchildview(back)
local forward = gui.Button.create('>')
forward:setstyle{marginright=5}
toolbar:addchildview(forward)
local addressbar = gui.Entry.create()
addressbar:setstyle{flex=1}
toolbar:addchildview(addressbar)
local go = gui.Button.create('GO')
go:setstyle{marginleft=5}
toolbar:addchildview(go)
local browser = gui.Browser.create()
browser:setstyle{flex=1}
contentview:addchildview(browser)

-- Bind browser events to toolbar.
browser.oncommitnavigation = function(self, url)
  addressbar:settext(url)
  browser:focus()
end

-- Bind toolbar events to browser.
addressbar.onactivate = function(self)
  browser:loadurl(self:gettext())
end

back.onclick = function(self)
  browser:goback()
end

forward.onclick = function(self)
  browser:goforward()
end

go.onclick = function(self)
  browser:loadurl(addressbar:gettext())
end

-- Load URL.
browser:loadurl('https://github.com/yue/yue')

-- Show window.
win:center()
win:activate()

gui.MessageLoop.run()
