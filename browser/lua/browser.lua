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
back:setenabled(false)
toolbar:addchildview(back)
local forward = gui.Button.create('>')
forward:setenabled(false)
forward:setstyle{marginright=5}
toolbar:addchildview(forward)
local refresh = gui.Button.create('S')
refresh:setstyle{width=20, marginright=5}
toolbar:addchildview(refresh)
local addressbar = gui.Entry.create()
addressbar:setstyle{flex=1}
toolbar:addchildview(addressbar)
local go = gui.Button.create('GO')
go:setstyle{marginleft=5}
toolbar:addchildview(go)
local browser = gui.Browser.create{contextmenu=true}
browser:setstyle{flex=1}
contentview:addchildview(browser)

-- Bind browser events to toolbar.
browser.onchangeloading = function(self)
  if browser:isloading() then
    refresh:settitle('S')
  else
    refresh:settitle('R')
  end
end

browser.onupdatecommand = function(self)
  back:setenabled(browser:cangoback())
  forward:setenabled(browser:cangoforward())
  addressbar:settext(browser:geturl())
end

browser.onupdatetitle = function(self, title)
  win:settitle(title)
end

browser.oncommitnavigation = function(self, url)
  addressbar:settext(url)
end

browser.onfinishnavigation = function(self, url)
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

refresh.onclick = function(self)
  if browser:isloading() then
    browser:stop()
  else
    browser:reload()
  end
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
