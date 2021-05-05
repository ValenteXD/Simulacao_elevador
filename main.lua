local elevador = require 'elevador'
local cenario = require 'cenario'
local whatsapp = require 'whatsapp'

function love.load()
  cenario.load()
  whatsapp.load()
  
end

function love.update(dt)
  elevador.update(dt)
  cenario.update(dt)
  
end

function love.draw()
  elevador.draw()
  cenario.draw()
end


function love.keyreleased(key)
  elevador.keyreleased(key)
  
  end
function love.keypressed(key, scancode, isrepeat)
  elevador.keypressed(key, scancode, isrepeat)
end
function love.mousepressed(x,y, button)
  whatsapp.mousepressed(x,y,button)
end