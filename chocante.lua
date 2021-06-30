local chocante = {}

local caos = require 'caos'

function chocante.load()
  
  love.graphics.setDefaultFilter('nearest','nearest')
  go_chocante = love.graphics.newImage('Assets/Sprites/SpriteSheets/game_over.png')
  
  
end

function chocante.update(dt)
  
  if musica_fundo ~= nil then
    musica_fundo:pause()
  end
  
  if #pedidos > 1 then
    pedidos = {0,}
  end
  
end

function chocante.draw()
  
  lg.setColor(1,1,1)
  lg.draw(go_chocante, 0,0, 0, 10, 10)
  caos.draw(335,400) --Essa função recebe X e Y
  caos.draw(535,410)
  caos.draw(460,400)
  caos.draw(360,420)
  caos.draw(310,410 )
  --lg.rectangle('fill', 235, 450, 330, 60 )
  lg.points(235, 450, 565, 510)
  
end

function chocante.keypressed()
  
end

function chocante.mousepressed(x,y,button)
 
end

return chocante