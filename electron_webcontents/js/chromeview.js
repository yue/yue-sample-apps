if (!process.versions.electron) {
  console.error('This example requires Electron >= 1.8.x')
  process.exit(1)
}

if (process.platform != 'darwin') {
  console.error('This example only runs on macOS')
  process.exit(2)
}

const electron = require('electron')
const gui = require('gui')

const menu = gui.MenuBar.create([
  {
    label: 'File',
    submenu: [
      {
        label: 'Quit',
        accelerator: 'CmdOrCtrl+Q',
        onClick: () => electron.app.quit()
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
gui.app.setApplicationMenu(menu)

const win = gui.Window.create({})
win.setContentSize({width: 600, height: 400})
win.onClose = () => electron.app.quit()

let back, forward, entry

const toolbar = gui.Toolbar.create('com.yue.toolbar')
toolbar.setDefaultItemIdentifiers(['back', 'forward', 'FlexibleSpaceItem', 'entry', 'FlexibleSpaceItem'])
toolbar.setAllowedItemIdentifiers(['back', 'forward', 'FlexibleSpaceItem', 'entry', 'FlexibleSpaceItem'])
toolbar.setDisplayMode('icon')
toolbar.setAllowCustomization(true)
toolbar.getItem = (toolbar, identifier) => {
  if (identifier == 'back') {
    back = gui.Button.create('')
    back.setImage(gui.Image.createFromPath(__dirname + '/left@2x.png'))
    return { label: 'Back', minSize: {width: 30, height: 35}, view: back }
  } else if (identifier == 'forward') {
    forward = gui.Button.create('')
    forward.setImage(gui.Image.createFromPath(__dirname + '/right@2x.png'))
    return { label: 'Forward', minSize: {width: 30, height: 35}, view: forward }
  } else if (identifier == 'entry') {
    entry = gui.Entry.create()
    const minSize = entry.getMinimumSize()
    minSize.width = 200
    const maxSize = { width: 2 << 30 - 1, height: minSize.height }
    return { label: 'Address', view: entry, minSize, maxSize }
  }
}

win.setTitleVisible(false)
win.setToolbar(toolbar)

let page

electron.app.once('ready', () => {
  page = electron.webContents.create({isBrowserView: true})
  page.on('did-navigate', () => entry.setText(page.getURL()))
  back.onClick = () => page.goBack()
  forward.onClick = () => page.goForward()
  entry.onActivate = () => page.loadURL(entry.getText())

  page.loadURL('http://github.com')

  const chrome = gui.ChromeView.create(page.getNativeView())
  win.setContentView(chrome)

  win.center()
  win.activate()
})
