
local andar = require 'andar'
local leitor = require 'leitor'
local elevador = require 'elevador'
local whatsapp = require 'whatsapp'
local app = require 'app'
local cenario = {}
local whats = {}
local anima_tempo = 0
local frame = 1

function cenario.load()
  --Carregado--
  andar.load()
  --elevador.load()
  app.load()
  
  --Sprites--
  love.graphics.setDefaultFilter('nearest','nearest')
  fundo_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/fundo.png')
  fundo_img_zap1 = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Fundo_zap.png')
  fundo_img_zap2 = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Fundo_zap2.png')
  leitura_sprite('Assets/Sprites/SpriteSheets/Whatsapp/Sprite_Whatsapp.png', whats, 16, 16)
  mark_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Janela_Zap_2.png')
  escuro = love.graphics.newImage('Assets/Sprites/SpriteSheets/Escuro.png')
  
  
  fundo1 = fundo_img
  fundo2 = fundo_img
  tempo = 0
  
  --audio--
  background_Sound1 = love.audio.newSource('Assets/Sfx/Normal/Musica_Elevador.mp3', 'stream')
  background_Sound2 = love.audio.newSource('Assets/Sfx/Whatsapp/A dança do Whatsapp.mp3', 'stream')
  musica_fundo = background_Sound1
  

end
function cenario.update(dt)
  app.update(dt)
  andar.update(dt)
  --elevador.update(dt)
  
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
  
  --[[if not eletrica then
    escuro = escuro1
  end
  if eletrica then
    escuro = escuro2
  end]]
  
end
function cenario.draw()
  local lg = love.graphics
  
  --fundo--
  lg.setColor( 1, 1, 1)
  --lg.draw(fundo1, 0, 2400, 0, 10.3, -600*9)
  --lg.draw(fundo2, 479, 2400, 0, 10, -600*9)
  for i = 0, 9, 1 do
    lg.draw(fundo1,0,300 - 300*(i))
    --lg.draw(fundo2, -300, 0)
  end
  --lg.draw(fundo2, -300, 0)
  
  
  --elevador.draw()
  andar.draw()
  
  if not eletrica then
    lg.draw(escuro, 0, 0 - cam_y)
  end
  
  --app--
  app.draw()
  if active then
    lg.setColor( 1, 1, 1)
    lg.draw(img, whats[frame], 700, -cam_y + 500, 0, 5, 5)
  end
  
  lg.setColor(1,0.2,.2)
  lg.print('Pos_y: '..pos_y, 0, -cam_y)
  lg.print('Cam_y: '..cam_y, 0, -cam_y+15)
  lg.print('Velocidade: '..vel_y, 0, -cam_y+30)
  lg.print('Subida: '..tostring(subida), 0, -cam_y+ 60)
  lg.print('Descida: '..tostring(descida), 0, -cam_y+ 75)
  lg.print('Andar atual: '..tostring(andar_atual), 0, -cam_y+ 90)
  lg.print('Andar pedido: '..tostring(andar_pedido), 0, -cam_y + 105)
  lg.print('Timer andar: '..tostring(timer), 0, -cam_y + 150)
  lg.print('Whatsapp: '..tostring(whats_teste), 0, -cam_y + 165)
  lg.print('Timer Debounce: '..tostring(timer_debounce), 0, -cam_y + 200)
  lg.print('Debounce: '..tostring(debounce), 0, -cam_y + 225)
  lg.print('Pos_y_Ctp: '..tostring(pos_y_ctp), 0, -cam_y + 250)
  lg.print('Bool Mov: '..tostring(mov), 0, -cam_y + 275)
  lg.print('Indice andar: '..tostring(indice_andar), 0, -cam_y + 295)
  
  --lg.print(cam_y, 0, -cam_y+400)
  lg.print('Posicao pedida: '..tabela_Andar[andar_pedido], 0, -cam_y+450)
  
  lg.print('Pedidos: ', 0, -cam_y + 335)
  for i=1, #pedidos do
    lg.print(tostring(pedidos[i]), 15*(i-2), -cam_y + 355)
  end

  if whats_teste == true then
    fundo1 = fundo_img_zap1
    fundo2 = fundo_img_zap2
    lg.setColor(1,1,1)
    lg.draw(mark_img, 590, 380, 0, 7, 7)
  end
  
  
  
end
return cenario
