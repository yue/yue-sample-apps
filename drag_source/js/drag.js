const gui = require('gui')
const path = require('path')

// Create window and controls.
const win = gui.Window.create({})
win.setContentSize({width: 240, height: 120})
win.onClose = () => gui.MessageLoop.quit()

const contentView = gui.Container.create()
contentView.setStyle({flexDirection: 'row'})
contentView.setBackgroundColor('#FFF')
win.setContentView(contentView)

const drag = gui.Container.create()
drag.setStyle({width: 100, margin: 10})
drag.setMouseDownCanMoveWindow(false)
contentView.addChildView(drag)

const drop = gui.Container.create()
drop.setStyle({flex: 1, margin: 10})
contentView.addChildView(drop)

// The image that will be used as drag data.
const pngPath = path.resolve('..', 'drag.png')
const image = gui.Image.createFromPath(pngPath)

// Handle dragging.
drag.onDraw = (self, painter) => {
  const rect = self.getBounds()
  rect.x = 0
  rect.y = 0
  painter.drawImage(image, rect)
}
drag.onMouseDown = (self) => {
  self.doDragWithOptions([{type: 'file-paths', value: [pngPath]},
                          {type: 'image', value: image}],
                         gui.DraggingInfo.dragOperationCopy,
                         {image})
  return true
}

// Drawing the dragged data.
let data = {type: 'none', value: null}
drop.onDraw = (self, painter) => {
  painter.setColor('#F23')
  const rect = self.getBounds()
  rect.x = 0
  rect.y = 0
  painter.strokeRect(rect)

  rect.x = rect.y = 1
  rect.width -= 2
  rect.height -= 2
  if (data.type == 'image')
    painter.drawImage(data.value, rect)
  else
    painter.drawText('Drag image here', rect,
                     {color: '#999', align: 'center', valign: 'center'})
}

// Handle dropping.
drop.registerDraggedTypes(['image'])
drop.handleDragEnter = (self, info, point) => {
  return gui.DraggingInfo.dragOperationCopy
}
drop.handleDrop = (self, info, point) => {
  data = info.getData('image')
  self.schedulePaint()
  return true
}

win.center()
win.activate()
