local menu={}
local background, placa, mx, my
local function mouse_no_botao(mx,my,x,y,w,h)
  return mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function start(x,y)
  love.graphics.setColor(0,0.6,0)
  love.graphics.rectangle('fill',x-120,y-40,240,120)
  if mouse_no_botao(mx,my,280,190,240,120) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte)
  love.graphics.print('start',x-105 ,y-40)
end
local function exit(x,y)
  love.graphics.setColor(0.9,0,0)
  love.graphics.rectangle('fill',x-120,y-40,240,120)
  if mouse_no_botao(mx,my,280,330,240,120) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte)
  love.graphics.print('exit',x-85,y-37)
end
function menu.load()
  background = love.graphics.newImage ('Assets/fundo_opaco.png')
  placa = love.graphics.newImage ('Assets/prata.png')
  fonte = love.graphics.newFont(90)
  
end
function menu.update(dt)
  mx,my = love.mouse.getPosition()
  
end
function menu.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(background)
  love.graphics.draw(placa)
  start(400,230)
  exit(400,370)
end
function menu.keypressed(key)
  
end
function menu.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,280,190,240,120) then
    vai_para_sim()
  end
  if button == 1 and mouse_no_botao(x,y,280,330,240,120) then
    love.event.quit()
  end
end
return menu
