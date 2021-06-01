io.stdout:setvbuf("no")

local elevador = require 'elevador'
local cenario = require 'cenario'
local whatsapp = require 'whatsapp'
local app = require 'app'
local menu = require 'menu'
local estado = menu
local sim = false
function vai_para_menu()
  estado = menu 
  sim = false
  menu.load()
  musica_fundo:pause()
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
function love.load()
  estado.load()
  if sim then
    cenario.load()
  end
  whatsapp.load()
  
end

function love.update(dt)
  estado.update(dt)
  if sim then
    cenario.update(dt)
  end
  
  
end

function love.draw()
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
end
function love.mousepressed(x,y, button)
  estado.mousepressed(x,y,button)
  whatsapp.mousepressed(x,y,button)
  if sim then
    app.mousepressed(x,y,button)
  end
end