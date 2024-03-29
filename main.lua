io.stdout:setvbuf("no")

local elevador = require 'elevador'
local cenario = require 'cenario'
local whatsapp = require 'whatsapp'
local app = require 'app'
local menu = require 'menu'
local toolbox = require 'toolbox'
local estado = menu
local sim = false
local caos = require 'caos'
local chocante = require 'chocante'
--pedidos_online = true
function vai_para_menu()
  estado = menu
  sim = false
  menu.load()
  if musica_fundo ~= nil then
    musica_fundo:pause()
  end
end
function vai_para_online()
  estado = elevador
  pedidos_online = true
  pedidos_offline = false
  sim = true
  elevador.load()
  cenario.load()
end
function vai_para_offline()
  estado = elevador
  pedidos_online = false
  pedidos_offline = true
  sim = true
  elevador.load()
  cenario.load()
end
function vai_para_toolbox()
  estado = toolbox
  toolbox.load()
end
function love.load()
  flash_timer = 0.5
  flash = false
  game_over = false
  startup = true
  estado.load()
  if sim then
    cenario.load()
  end
  whatsapp.load()
  caos.load()
  chocante.load()
end

function love.update(dt)
  estado.update(dt)
  if sim then
    cenario.update(dt)
  end
  caos.update(dt)
  
  if game_over then
    estado = chocante
    sim = false
  end
  if flash then
    flash_timer = flash_timer - dt
  end
  if flash_timer == 0 then
    flash_timer = 0.8
    flash = false
  end
end

function love.draw()
  if flash then
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),love.graphics.getHeight())
  end
  estado.draw()
  if sim then
    cenario.draw()
  end
end

function love.keypressed(key, scancode, isrepeat)
  estado.keypressed(key)
  whatsapp.keypressed(key)
  if key=='r' then
    love.event.quit('restart')
  end
  if sim then
    if key == ',' and pedido_atual ~= 1 then
      pedido_atual = pedido_atual - 1
    elseif key == '.' then
      pedido_atual = pedido_atual + 1
    end
  end
  if key == 'h' then
    game_over = false
    if pedidos_offline then
      vai_para_offline()
    elseif pedidos_online then
      vai_para_online()
    end
  end
  
end
function love.mousepressed(x,y, button)
  estado.mousepressed(x,y,button)
  --chocante.mousepressed(x,y,button)
  whatsapp.mousepressed(x,y,button)
  if sim then
    app.mousepressed(x,y,button)
  end
  
  if button == 1 then
    if game_over and x >= 235 and x <= 565 and y >= 450 and y <= 510 then
    game_over = false
    if pedidos_offline then
      vai_para_offline()
      love.audio.stop()
    elseif pedidos_online then
      vai_para_online()
      love.audio.stop()
    end
    end
  end
  
end