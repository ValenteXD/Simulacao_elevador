local menu={}
local function mouse_no_botao(mx,my,x,y,w,h)
  return mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function start(x,y)
  love.graphics.setColor(0,1,0)
  love.graphics.rectangle('fill',x-60,y-40,120,60)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(fonte)
  love.graphics.print('start',x-55,y-40)
end
local function exit(x,y)
  love.graphics.setColor(1,0,0)
  love.graphics.rectangle('fill',x-60,y-40,120,60)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(fonte)
  love.graphics.print('exit',x-45,y-37)
end
function menu.load()
  fonte = love.graphics.newFont(45)
end
function menu.update(dt)
  
end
function menu.draw()
  start(400,300)
  exit(400,370)
end
function menu.keypressed(key)
  
end
function menu.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,360,240,80,120) then
    vai_para_sim()
  end
  if button == 1 and mouse_no_botao(x,y,360,310,80,120) then
    love.event.quit()
  end
end
return menu