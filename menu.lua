local menu={}
local background, placa, mx, my
local function mouse_no_botao(mx,my,x,y,w,h)
  return mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function online(x,y)
  love.graphics.setColor(0,0.6,0)
  love.graphics.rectangle('fill',x-100,y-40,200,90,10)
  if mouse_no_botao(mx,my,x-100,y-40,200,90) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte50)
  love.graphics.print('online',x-80 ,y-25)
end
local function offline(x,y)
  love.graphics.setColor(0.85,0.85,0)
  love.graphics.rectangle('fill',x-100,y-40,200,90,10)
  if mouse_no_botao(mx,my,x-100,y-40,200,90) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte50)
  love.graphics.print('offline',x-80,y-25)
end
local function toolbox(x,y)
  love.graphics.setColor(0,0,0.6)
  love.graphics.rectangle('fill',x-100,y-40,200,90,10)
  if mouse_no_botao(mx,my,x-100,y-40,200,90) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte50)
  love.graphics.print('toolbox',x-90 ,y-25)
end
local function exit(x,y)
  love.graphics.setColor(0.9,0,0)
  love.graphics.rectangle('fill',x-100,y-40,200,90,10)
  if mouse_no_botao(mx,my,x-120,y-40,200,90) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte70)
  love.graphics.print('exit',x-70,y-37)
end
function menu.load()
  background = love.graphics.newImage ('Assets/fundo_opaco.png')
  placa = love.graphics.newImage ('Assets/prata.png')
  fonte70 = love.graphics.newFont(70)
  fonte50 = love.graphics.newFont(50)
end
function menu.update(dt)
  mx,my = love.mouse.getPosition()
  
end
function menu.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(background)
  love.graphics.draw(placa)
  online(400,140)
  offline(400,240)
  toolbox(400,340)
  exit(400,450)
end
function menu.keypressed(key)
  
end
function menu.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,300,100,200,90) then
    vai_para_online()
  end
  if button == 1 and mouse_no_botao(x,y,300,200,200,90) then
    vai_para_offline()
  end
    if button == 1 and mouse_no_botao(x,y,300,300,200,90) then
    vai_para_toolbox()
  end
  if button == 1 and mouse_no_botao(x,y,300,410,200,90) then
    love.event.quit()
  end
end
return menu
