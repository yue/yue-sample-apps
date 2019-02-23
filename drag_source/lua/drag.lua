local gui = require('yue.gui')

-- Create window and controls.
local win = gui.Window.create{}
win:setcontentsize{width=240, height=120}

function win.onclose()
  gui.MessageLoop.quit()
end

local contentView = gui.Container.create()
contentView:setstyle{flexDirection='row'}
contentView:setbackgroundcolor('#FFF')
win:setcontentview(contentView)

local drag = gui.Container.create()
drag:setstyle{width=100, margin=10}
drag:setmousedowncanmovewindow(false)
contentView:addchildview(drag)

local drop = gui.Container.create()
drop:setstyle{flex=1, margin=10}
contentView:addchildview(drop)

-- The image that will be used as drag data.
local pngPath = '../drag.png'
local image = gui.Image.createfrompath(pngPath)

-- Handle dragging.
function drag.ondraw(self, painter)
  local rect = self:getbounds()
  rect.x = 0
  rect.y = 0
  painter:drawimage(image, rect)
end

function drag.onmousedown(self)
  self:dodragwithoptions({{type='file-paths', value={pngPath}},
                          {type='image', value=image}},
                         gui.DraggingInfo.dragoperationcopy,
                         {image=image})
  return true
end

-- Drawing the dragged data.
local data = {type='none', value=null}
function drop.ondraw(self, painter)
  painter:setcolor('#F23')
  local rect = self:getbounds()
  rect.x = 0
  rect.y = 0
  painter:strokerect(rect)

  rect.x = 1
  rect.y = 1
  rect.width = rect.width - 2
  rect.height = rect.height - 2
  if data.type == 'image' then
    painter:drawimage(data.value, rect)
  else
    painter:drawtext('Drag image here', rect,
                     {color='#999', align='center', valign='center'})
  end
end

-- Handle dropping.
drop:registerdraggedtypes({'image'})
function drop.handledragenter(self, info, point)
  return gui.DraggingInfo.dragoperationcopy
end

function drop.handledrop(self, info, point)
  data = info:getdata('image')
  self:schedulepaint()
  return true
end

win:center()
win:activate()

-- Enter message loop.
gui.MessageLoop.run()
