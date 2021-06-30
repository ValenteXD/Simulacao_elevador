local chocante = {}

local caos = require 'caos'

function chocante.load()
  
  love.graphics.setDefaultFilter('nearest','nearest')
  go_chocante = love.graphics.newImage('Assets/Sprites/SpriteSheets/game_over.png')
  musica_chocante = love.audio.newSource('Assets/Sfx/Normal/Chocante.mp3','stream')
  musica_chocante:setLooping(true)
  batida = love.audio.newSource('Assets/Sfx/Normal/Batida.mp3','static')
end

function chocante.update(dt)
  
  if musica_fundo:isPlaying() then
    musica_fundo:pause()
  end
  
  musica_chocante:play()
  
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
  --lg.points(235, 450, 565, 510)
  
end

function chocante.keypressed()
  
end

function chocante.mousepressed(x,y,button)
 
end

return chocante