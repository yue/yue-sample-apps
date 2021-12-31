const gui = require('gui')

// Create window and controls.
global.win = gui.Window.create({})
win.setContentSize({width: 400, height: 400})
win.onClose = () => gui.MessageLoop.quit()

const contentView = gui.Container.create()
contentView.setBackgroundColor('#FFF')
win.setContentView(contentView)

const drop = gui.Container.create()
drop.setStyle({flex: 1, margin: 10})
contentView.addChildView(drop)

// Drawing the dragged data.
let isDragging = false
let data = {type: 'none', value: null}
drop.onDraw = (self, painter) => {
  painter.setColor(isDragging ? '#F23' : '#A89')
  const rect = self.getBounds()
  rect.x = 0
  rect.y = 0
  painter.strokeRect(rect)

  rect.x = rect.y = 1
  rect.width -= 2
  rect.height -= 2
  switch (data.type) {
    case 'file-paths':
      painter.drawText(data.value.join('\n'), rect, {})
      break
    case 'html':
    case 'text':
      painter.drawText(data.value, rect, {})
      break
    case 'image':
      painter.drawImage(data.value, rect)
      break
    default:
      painter.drawText('Please drag things here', rect,
                       {color: '#999', align: 'center', valign: 'center'})
      break
  }
}

// Handle dropping.
drop.registerDraggedTypes(['file-paths', 'html', 'text', 'image'])
drop.handleDragEnter = (self, info, point) => {
  isDragging = true
  drop.schedulePaint()
  return gui.DraggingInfo.dragOperationCopy
}
drop.onDragLeave = () => {
  isDragging = false
  drop.schedulePaint()
}
drop.handleDrop = (self, info, point) => {
  data = info.getData('file-paths')
  // If dragging a single image, draw the image directly.
  if (data.value && data.value.length == 1) {
    const image = gui.Image.createFromPath(data.value[0])
    if (image.getSize().width > 1)
      data = {type: 'image', value: image}
  }

  // Try other types.
  if (!data.value)
    data = info.getData('html')
  if (!data.value)
    data = info.getData('text')
  if (!data.value)
    data = info.getData('image')
  drop.schedulePaint()
  return true
}

win.center()
win.activate()
