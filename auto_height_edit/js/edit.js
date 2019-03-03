const gui = require('./out/Component/gui')

const win = gui.Window.create({})
win.onClose = () => gui.MessageLoop.quit()

const edit = gui.TextEdit.create()
edit.setStyle({flex: 1})
win.setContentView(edit)

// Calculate height for 1 and 20 lines.
edit.setText('1')
const minHeight = edit.getTextBounds().height
edit.setText('1' + '\n1'.repeat(19))
const maxHeight = edit.getTextBounds().height
edit.setText('')

// Automatically change window size for the text edit view.
edit.onTextChange = () => {
  let height = edit.getTextBounds().height
  if (height < minHeight)
    height = minHeight
  else if (height > maxHeight)
    height = maxHeight
  const size = win.getContentSize()
  if (height != size.height) {
    size.height = height
    win.setContentSize(size)
  }
}

win.setContentSize({width: 200, height: minHeight})
win.center()
win.activate()
edit.focus()

if (!process.versions.yode) {
  gui.MessageLoop.run()
  process.exit(0)
}
