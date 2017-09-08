const fs = require('fs')
const path = require('path')
const gui = require('gui')

const menu = gui.MenuBar.create([
  {
    label: 'File',
    submenu: [
      {
        label: 'Quit',
        accelerator: 'CmdOrCtrl+Q',
        onClick: () => gui.lifetime.quit()
      },
    ],
  },
  {
    label: 'Edit',
    submenu: [
      { role: 'copy' },
      { role: 'cut' },
      { role: 'paste' },
      { role: 'select-all' },
      { type: 'separator' },
      { role: 'undo' },
      { role: 'redo' },
    ],
  },
])

const win = gui.Window.create({})
win.setContentSize({width: 400, height: 400})
win.onClose = () => gui.lifetime.quit()

const contentView = gui.Container.create()
contentView.setStyle({flexDirection: 'row'})
win.setContentView(contentView)

let sidebar
if (process.platform == 'darwin') {
  sidebar = gui.Vibrant.create()
  sidebar.setBlendingMode('behind-window')
  sidebar.setMaterial('dark')
} else {
  sidebar = gui.Container.create()
}
sidebar.setStyle({padding: 5})
contentView.addChildView(sidebar)

const edit = gui.TextEdit.create()
edit.setStyle({flex: 1})
contentView.addChildView(edit)

let filename
let folder

const open = gui.Button.create('')
open.setImage(gui.Image.createFromPath(__dirname + '/eopen@2x.png'))
open.setStyle({marginBottom: 5})
open.onClick = () => {
  const dialog = gui.FileOpenDialog.create()
  dialog.setOptions(gui.FileDialog.optionShowHidden)
  dialog.setFilters([
    { description: 'All Files', extensions: ['*'] },
    { description: 'JavaScript Files', extensions: ['js'] },
  ])
  if (dialog.runForWindow(win)) {
    const p = dialog.getResult()
    folder = path.dirname(p)
    filename = path.basename(p)
    edit.setText(String(fs.readFileSync(p)))
    edit.focus()
    win.setTitle(filename)
  }
}
sidebar.addChildView(open)

const save = gui.Button.create('')
save.setImage(gui.Image.createFromPath(__dirname + '/esave@2x.png'))
save.onClick = () => {
  if (!folder)
    return
  const dialog = gui.FileSaveDialog.create()
  dialog.setFolder(folder)
  dialog.setFilename(filename)
  if (dialog.runForWindow(win)) {
    fs.writeFileSync(String(dialog.getResult()), edit.getText())
  }
}
sidebar.addChildView(save)

sidebar.setStyle({width: sidebar.getPreferredSize().width})

if (process.platform == 'darwin')
  gui.app.setApplicationMenu(menu)
else
  win.setMenuBar(menu)

win.center()
win.activate()

if (!process.versions.yode) {
  gui.lifetime.run()
  process.exit(0)
}
