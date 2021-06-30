local menu={}
local background, placa, mx, my, mudo, volume1, volume0
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
  musica_menu = love.audio.newSource('Assets/Sfx/Normal/Musica_menu.mp3','stream')
  musica_menu:setLooping(true)
  volume1 = love.graphics.newImage('Assets/Sprites/SpriteSheets/volume.png')
  volume0 = love.graphics.newImage('Assets/Sprites/SpriteSheets/mudo.png')
  if startup then
    love.audio.play(musica_menu)
    startup = false
  end
end
function menu.update(dt)
  if mudo then
    love.audio.setVolume(0)
  else
    love.audio.setVolume(1)
  end
  mx,my = love.mouse.getPosition()
  startup = false
end
function menu.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.print(tostring(mx)..','..tostring(my),0,0)
  love.graphics.draw(background)
  love.graphics.draw(placa)
  online(400,140)
  offline(400,240)
  toolbox(400,340)
  exit(400,450)
  love.graphics.setColor(1,1,1)
  if mudo then
    love.graphics.draw(volume0,190,275)
  else
    love.graphics.draw(volume1,190,275)
  end
end
function menu.keypressed(key)
  if key == 'm' then
    mudo = not mudo
  end
end
function menu.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,300,100,200,90) then
    vai_para_online()
    love.audio.stop()
  end
  if button == 1 and mouse_no_botao(x,y,300,200,200,90) then
    vai_para_offline()
    love.audio.stop()
  end
    if button == 1 and mouse_no_botao(x,y,300,300,200,90) then
    vai_para_toolbox()
  end
  if button == 1 and mouse_no_botao(x,y,300,410,200,90) then
    love.event.quit()
  end
  if button == 1 and mouse_no_botao(x,y,190,275,50,50) then
    mudo = not mudo
  end
end
return menu
