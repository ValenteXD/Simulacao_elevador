local andar = require 'andar'
local leitor = require 'leitor'
local elevador = require 'elevador'
local whatsapp = require 'whatsapp'
local cenario = {}
local whats = {}
local anima_tempo = 0
local frame = 1

function cenario.load()
  --Carregado--
  andar.load()
  elevador.load()
  
  --Sprites--
  love.graphics.setDefaultFilter('nearest','nearest')
  fundo_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Fundo.png')
  fundo_img_zap1 = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Fundo_zap.png')
  fundo_img_zap2 = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Fundo_zap2.png')
  leitura_sprite('Assets/Sprites/SpriteSheets/Whatsapp/Sprite_Whatsapp.png', whats, 16, 16)
  
  fundo1 = fundo_img
  fundo2 = fundo_img
  tempo = 0
  
  --audio--
  background_Sound1 = love.audio.newSource('Assets/Sfx/Normal/Musica_Elevador.mp3', 'stream')
  background_Sound2 = love.audio.newSource('Assets/Sfx/Whatsapp/A dança do Whatsapp.mp3', 'stream')
  musica_fundo = background_Sound1
  

end
function cenario.update(dt)
  
  --Audio:Musica de fundo--
  love.audio.play(musica_fundo)
  if whats_teste == true then
    musica_fundo:pause()
    musica_fundo = background_Sound2
    if musica_fundo == background_Sound2 then
      love.audio.play(musica_fundo)
    end
  end
  
  
  --Animação: Botão whatsapp--
  anima_tempo = anima_tempo + dt
  if anima_tempo > 0.5 then
    frame = frame + 1
    anima_tempo = 0
    if frame > 2 then
      frame = 1
    end
  end
end
function cenario.draw()
  local lg = love.graphics
  if whats_teste == true then
    fundo1 = fundo_img_zap1
    fundo2 = fundo_img_zap2
  end
  
  --fundo--
  lg.setColor( 1, 1, 1)
  lg.draw(fundo1, 0, 2400, 0, 10.3, -600*9)
  lg.draw(fundo2, 479, 2400, 0, 10, -600*9)

  andar.draw()
  if active then
    lg.setColor( 1, 1, 1)
    lg.draw(img, whats[frame], 700, -cam_y + 500, 0, 5, 5)
  end
  --[[lg.setColor(1,0,1)
  lg.print(pos_y, 0, -cam_y)
  lg.print(cam_y, 0, -cam_y+15)
  lg.print(vel_y, 0, -cam_y+30)
  lg.print(tostring(subida), 0, -cam_y+ 60)
  lg.print(tostring(descida), 0, -cam_y+ 75)
  lg.print(tostring(andar_atual), 0, -cam_y+ 90)
  lg.print(tostring(andar_pedido), 0, -cam_y + 105)
  lg.print(tostring(timer), 0, -cam_y + 150)
  lg.print(tostring(whats_teste), 0, -cam_y + 165)]]
end
return cenario