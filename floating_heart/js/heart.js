const gui = require('gui')

const win = gui.Window.create({frame: false, transparent: true})
win.setAlwaysOnTop(true)
win.setContentSize({width: 150, height: 130})
win.onClose = () => gui.lifetime.quit()

const contentview = gui.Container.create()
contentview.setMouseDownCanMoveWindow(true)
win.setContentView(contentview)

function drawHeart(painter) {
  painter.beginPath()
  painter.moveTo({x: 75, y: 40})
  painter.bezierCurveTo({x: 75, y: 37}, {x: 70, y: 25}, {x: 50, y: 25})
  painter.bezierCurveTo({x: 20, y: 25}, {x: 20, y: 62.5}, {x: 20, y: 62.5})
  painter.bezierCurveTo({x: 20, y: 80}, {x: 40, y: 102}, {x: 75, y: 120})
  painter.bezierCurveTo({x: 110, y: 102}, {x: 130, y: 80}, {x: 130, y: 62.5})
  painter.bezierCurveTo({x: 130, y: 62.5}, {x: 130, y: 25}, {x: 100, y: 25})
  painter.bezierCurveTo({x: 85, y: 25}, {x: 75, y: 37}, {x: 75, y: 40})
  painter.fill()
}

contentview.onDraw = (self, painter) => {
  painter.setFillColor('#3000')
  drawHeart(painter)
  painter.translate({x: -5, y: -5})
  painter.setFillColor('#D46A6A')
  drawHeart(painter)
}

win.center()
win.activate()
