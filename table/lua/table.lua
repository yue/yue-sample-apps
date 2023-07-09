local gui = require('yue.gui')

local win = gui.Window.create({})
win:setcontentsize({width = 400, height = 400})
win.onclose = function() gui.MessageLoop.quit() end

local model = gui.AbstractTableModel.create(3)
function model.getrowcount(self)
  return 10000
end

local editedText = {}
function model.getvalue(self, column, row)
  if (column == 1) then
    return tostring(row)
  elseif (column == 2) then
    if (editedText[row]) then
      return editedText[row]
    else
      return 'Edit Me ' .. row
    end
  elseif (column == 3) then
    local r = (row % 5) * 40 + (row % 55) * 1
    local g = (row % 4) * 40 + (row % 20) * 4
    local b = (row % 3) * 40 + (row % 10) * 13
    return {name = 'rgb(' .. r .. ', ' .. g .. ', ' .. b .. ')', value = gui.Color.rgb(r, g, b)}
  end
end
function model.setvalue(self, column, row, value)
  print('setValue', column, row, value)
  if (column == 2) then
    editedText[row] = value
  elseif (column == 3) then
    editedCheckbox[row] = value
  end
end

local ondraw = function(painter, rect, value)
  painter:setfillcolor(value.value)
  painter:fillrect(rect)
  painter:drawtext(value.name, rect, {color = '#FFF'})
end

local table = gui.Table.create()
table:addcolumnwithoptions('ID', {width = 40})
table:addcolumnwithoptions('Editable Text', {type = 'edit', width = 100})
table:addcolumnwithoptions('Custom Color', {type = 'custom', ondraw = ondraw})
table:setmodel(model)

local contentView = gui.Container.create()
table:setstyle({margin = 10, flex = 1})
table:sethasborder(true)
contentView:addchildview(table)

win:setcontentview(contentView)

win:center()
win:activate()

gui.MessageLoop.run()
