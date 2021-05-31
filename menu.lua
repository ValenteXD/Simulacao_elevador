local menu={}
local background, placa, mx, my
local function mouse_no_botao(mx,my,x,y,w,h)
  return mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function online(x,y)
  love.graphics.setColor(0,0.6,0)
  love.graphics.rectangle('fill',x-120,y-40,240,120)
  if mouse_no_botao(mx,my,x-120,y-40,240,120) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte70)
  love.graphics.print('online',x-105 ,y-25)
end
local function offline(x,y)
  love.graphics.setColor(0.85,0.85,0)
  love.graphics.rectangle('fill',x-120,y-40,240,120)
  if mouse_no_botao(mx,my,x-120,y-40,240,120) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte70)
  love.graphics.print('offline',x-110,y-25)
end
local function exit(x,y)
  love.graphics.setColor(0.9,0,0)
  love.graphics.rectangle('fill',x-120,y-40,240,120)
  if mouse_no_botao(mx,my,x-120,y-40,240,120) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte90)
  love.graphics.print('exit',x-85,y-37)
end
function menu.load()
  background = love.graphics.newImage ('Assets/fundo_opaco.png')
  placa = love.graphics.newImage ('Assets/prata.png')
  fonte90 = love.graphics.newFont(90)
  fonte70 = love.graphics.newFont(70)
end
function menu.update(dt)
  mx,my = love.mouse.getPosition()
  
end
function menu.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(background)
  love.graphics.draw(placa)
  online(400,140)
  offline(400,270)
  exit(400,440)
end
function menu.keypressed(key)
  
end
function menu.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,280,100,240,120) then
    vai_para_online()
  end
  if button == 1 and mouse_no_botao(x,y,280,230,240,120) then
    vai_para_offline()
  end
  if button == 1 and mouse_no_botao(x,y,280,400,240,120) then
    love.event.quit()
  end
end
return menu
