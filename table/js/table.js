const gui = require('gui')

global.win = gui.Window.create({})
win.setContentSize({width: 400, height: 400})
win.onClose = () => gui.MessageLoop.quit()

const model = gui.AbstractTableModel.create(3)
model.getRowCount = (self) => {
  return 10000
}

const editedText = {}
model.getValue = (self, column, row) => {
  if (column == 0) {
    return String(row)
  } else if (column == 1) {
    if (editedText[row])
      return editedText[row]
    else
      return `Edit Me ${row}`
  } else if (column == 2) {
    const r = (row % 5) * 40 + (row % 55) * 1
    const g = (row % 4) * 40 + (row % 20) * 4
    const b = (row % 3) * 40 + (row % 10) * 13
    return {name: `rgb(${r}, ${g}, ${b})`, value: gui.Color.rgb(r, g, b)}
  }
}
model.setValue = (self, column, row, value) => {
  if (column == 1)
    editedText[row] = value
}

const onDraw = (painter, rect, value) => {
  painter.setFillColor(value.value)
  painter.fillRect(rect)
  painter.drawText(value.name, rect, {color: '#FFF'})
}

const table = gui.Table.create()
table.addColumnWithOptions('ID', {width: 40})
table.addColumnWithOptions('Editable Text', {type: 'edit', width: 100})
table.addColumnWithOptions('Custom Color', {type: 'custom', onDraw})
table.setModel(model)

win.setContentView(table)

win.center()
win.activate()

if (!process.versions.yode) {
  gui.MessageLoop.run()
  process.exit(0)
}
