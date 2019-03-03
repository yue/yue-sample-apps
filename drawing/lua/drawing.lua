local gui = require('yue.gui')

function draw_example1(painter)
  for i=0, 5, 1 do
    for j=0, 5, 1 do
      painter:setfillcolor(gui.Color.argb(255,
                                          math.floor(255 - 42.5 * i),
                                          math.floor(255 - 42.5 * j),
                                          0))
      painter:fillrect(j * 25, i * 25, 25, 25)
    end
  end
end

function draw_example2(painter)
  painter:setstrokecolor('#550000')
  painter:setfillcolor('#D46A6A')
  painter:beginpath()
  painter:moveto(25, 25)
  painter:lineto(105, 25)
  painter:lineto(25, 105)
  painter:closepath()
  painter:fill()
  painter:beginpath()
  painter:moveto(125, 125)
  painter:lineto(125, 45)
  painter:lineto(45, 125)
  painter:closepath()
  painter:stroke()
end

function draw_example3(painter)
  painter:beginpath()
  painter:moveto(75, 40)
  painter:beziercurveto({x=75, y=37}, {x=70, y=25}, {x=50, y=25})
  painter:beziercurveto({x=20, y=25}, {x=20, y=62.5}, {x=20, y=62.5})
  painter:beziercurveto({x=20, y=80}, {x=40, y=102}, {x=75, y=120})
  painter:beziercurveto({x=110, y=102}, {x=130, y=80}, {x=130, y=62.5})
  painter:beziercurveto({x=130, y=62.5}, {x=130, y=25}, {x=100, y=25})
  painter:beziercurveto({x=85, y=25}, {x=75, y=37}, {x=75, y=40})
  painter:fill()
end

function draw_example4(painter)
  painter:beginpath()
  painter:arc({x=75, y=75}, 50, 0, math.pi * 2)
  painter:moveto(110, 75)
  painter:arc({x=75, y=75}, 35, 0, math.pi)
  painter:moveto(65, 65)
  painter:arc({x=60, y=65}, 5, 0, math.pi * 2)
  painter:moveto(95, 65)
  painter:arc({x=90, y=65}, 5, 0, math.pi * 2)
  painter:stroke()
end

function draw_example5(painter)
  painter:save()
  painter:cliprect(0, 0, 150, 150)

  rounded_rect(painter, {x=12, y=12, width=150, height=150}, 15)
  rounded_rect(painter, {x=19, y=19, width=150, height=150}, 9)
  rounded_rect(painter, {x=53, y=53, width=49, height=33}, 10)
  rounded_rect(painter, {x=53, y=119, width=49, height=16}, 6)
  rounded_rect(painter, {x=135, y=53, width=49, height=33}, 10)
  rounded_rect(painter, {x=135, y=119, width=25, height=49}, 10)

  painter:setfillcolor('#000')
  painter:beginpath()
  painter:arc({x=37, y=37}, 13, math.pi / 7, -math.pi / 7)
  painter:lineto(31, 37)
  painter:fill()

  for i=0, 7, 1 do
    painter:fillrect(51 + i * 16, 35, 4, 4)
  end

  for i=0, 5, 1 do
    painter:fillrect(115, 51 + i * 16, 4, 4)
  end

  for i=0, 7, 1 do
    painter:fillrect(51 + i * 16, 99, 4, 4)
  end

  painter:beginpath()
  painter:moveto(83, 116)
  painter:lineto(83, 102)
  painter:beziercurveto({x=83, y=94}, {x=89, y=88}, {x=97, y=88})
  painter:beziercurveto({x=105, y=88}, {x=111, y=94}, {x=111, y=102})
  painter:lineto(111, 116)
  painter:lineto(106.333, 111.333)
  painter:lineto(101.666, 116)
  painter:lineto(97, 111.333)
  painter:lineto(92.333, 116)
  painter:lineto(87.666, 111.333)
  painter:lineto(83, 116)
  painter:fill()

  painter:setfillcolor('#FFF')
  painter:beginpath()
  painter:moveto(91, 96)
  painter:beziercurveto({x=88, y=96}, {x=87, y=99}, {x=87, y=101})
  painter:beziercurveto({x=87, y=103}, {x=88, y=106}, {x=91, y=106})
  painter:beziercurveto({x=94, y=106}, {x=95, y=103}, {x=95, y=101})
  painter:beziercurveto({x=95, y=99}, {x=94, y=96}, {x=91, y=96})
  painter:moveto(103, 96)
  painter:beziercurveto({x=100, y=96}, {x=99, y=99}, {x=99, y=101})
  painter:beziercurveto({x=99, y=103}, {x=100, y=106}, {x=103, y=106})
  painter:beziercurveto({x=106, y=106}, {x=107, y=103}, {x=107, y=101})
  painter:beziercurveto({x=107, y=99}, {x=106, y=96}, {x=103, y=96})
  painter:fill()

  painter:setfillcolor('#000')
  painter:beginpath()
  painter:arc({x=101, y=102}, 2, 0, math.pi * 2, true)
  painter:fill()

  painter:beginpath()
  painter:arc({x=89, y=102}, 2, 0, math.pi * 2, true)
  painter:fill()

  painter:restore()
end

function rounded_rect(painter, r, radius)
  painter:beginpath()
  local degrees = math.pi / 180
  painter:arc({x=r.x + r.width - radius, y=r.y + radius},
              radius, -90 * degrees, 0)
  painter:arc({x=r.x + r.width - radius, y=r.y + r.height - radius},
              radius, 0, 90 * degrees)
  painter:arc({x=r.x + radius, y=r.y + r.height - radius},
              radius, 90 * degrees, 180 * degrees)
  painter:arc({x=r.x + radius, y=r.y + radius},
              radius, 180 * degrees, 270 * degrees)
  painter:closepath()
  painter:stroke()
end

function draw_example6(painter)
  painter:save()
  painter:rotate(math.pi / 4)
  local text = gui.AttributedText.create("draw example 6", {align='center'})
  local bounds = text:getboundsfor{width=150, height=150}
  bounds.x = 75
  bounds.y = 0
  painter:strokerect(bounds)
  painter:drawattributedtext(text, bounds)
  painter:restore()
end

function draw_example7(painter)
  local text = gui.AttributedText.create("draw example 7", {align='center'})
  text:setfont(gui.Font.create('Arial', 18, 'normal', 'normal'))
  local bounds = text:getboundsfor{width=150, height=150}
  bounds.x = (150 - bounds.width) / 2
  bounds.y = 75 - bounds.height
  painter:drawattributedtext(text, bounds)
  painter:save()
  painter:scale(1, -1)
  bounds.y = -150 + bounds.y
  text:setcolor('#888')
  painter:drawattributedtext(text, bounds)
  painter:restore()
end

function draw_example8(painter)
  local bounds = {x=10, y=10, width=130, height=130}
  rounded_rect(painter, bounds, 3)
  painter:drawtext("aaa", bounds, {align='start', valign='start'})
  painter:drawtext("bbb", bounds, {align='end', valign='start'})
  painter:drawtext("ccc", bounds, {align='start', valign='end'})
  painter:drawtext("ddd", bounds, {align='end', valign='end'})
  painter:drawtext("eee", bounds, {align='center', valign='center'})
end

function draw_example9(painter)
  local frame = gui.Image.createfrompath('frame.png')
  local picture = gui.Image.createfrompath('rhino.jpg')
  painter:drawimagefromrect(picture,
                            {x=33, y=71, width=104, height=124},
                            {x=32, y=21, width=85, height=102})
  local bounds = frame:getsize()
  bounds.x = 10
  bounds.y = 0
  painter:drawimage(frame, bounds)
end

function draw_all(painter)
  draw_example1(painter)
  painter:translate(150, 0)
  draw_example2(painter)
  painter:translate(150, 0)
  draw_example3(painter)
  painter:translate(-300, 150)
  draw_example4(painter)
  painter:translate(150, 0)
  draw_example5(painter)
  painter:translate(150, 0)
  draw_example6(painter)
  painter:translate(-300, 150)
  draw_example7(painter)
  painter:translate(150, 0)
  draw_example8(painter)
  painter:translate(150, 0)
  draw_example9(painter)
end

-- Draw on canvas.
local canvas = gui.Canvas.createformainscreen{width=450, height=450}
draw_all(canvas:getpainter())

-- Create window.
win = gui.Window.create{}
win.onclose = function() gui.MessageLoop.quit() end
win:setcontentsize{width=500, height=500}

local content = gui.Container.create()
content:setbackgroundcolor('#FFF')
content:setstyle{flexgrow = 1}
win:setcontentview(content)

-- Draw from canvas.
function content.ondraw(self, painter, dirty)
  -- draw_all(painter)
  painter:drawcanvas(canvas, {x=25, y=25, width=450, height=450})
  -- painter:drawcanvasfromrect(canvas, src, dirty)
end

win:center()
win:activate()

gui.MessageLoop.run()
