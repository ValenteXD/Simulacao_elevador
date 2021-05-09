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

function love.keypressed(key, scancode, isrepeat)
  whatsapp.keypressed(key)
  if key=='r' then
    love.event.quit('restart')
  elseif key =='escape' then
    love.event.quit()
  end
end
function love.mousepressed(x,y, button)
  whatsapp.mousepressed(x,y,button)
end