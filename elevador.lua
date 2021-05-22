local elevador = {}
local andar = require 'andar'
local whatsapp = require 'whatsapp'
local animacao = {}
local pedidos = {}
local arquivo_csv = {}
local timer_global = 0

function leitura_pedidos(nome)
  local file = io.open(nome, 'r')
  local destino
  local pedido_elev
  local lista_subida = {}
  local lista_descida = {}
  for line in file:lines() do
    pedido_elev = tonumber(line:sub(1,1))
    destino = tonumber(line:sub(3,3))
    if pedido_elev > destino then
      table.insert(lista_descida, pedido_elev)
      table.insert(lista_descida, destino)
    else
      table.insert(lista_subida, pedido_elev)
      table.insert(lista_subida, destino)
    end
  end
  
  table.sort(lista_subida)
  table.sort(lista_descida, function(a,b)
    return a > b
  end)
  
  for i=1, #lista_subida do
    if lista_subida[i] ~= pedidos[#pedidos] then
      table.insert(pedidos, lista_subida[i])
    end
  end
  for i=1, #lista_descida do
    if lista_descida[i] ~= pedidos[pedidos] then
      table.insert(pedidos, lista_descida[i])
    end
  end
  
  file:close()
end


local function gera_csv(nome)
  arquivo_csv = io.open(nome, 'w')
  arquivo_csv:write('Tempo;Altura;Velocidade\n')
end
local function adiciona_csv(tempo, altura, velocidade)
  local line_tempo = tostring(tempo):gsub('%.',',')
  local line_altura = tostring(altura):gsub('%.',',')
  local line_velocidade = tostring(velocidade):gsub('%.',',')
  local line = line_tempo .. ';' .. line_altura .. ';' .. line_velocidade .. '\n'
  arquivo_csv:write(line)
end
function elevador.load()
  -- Atributos elevador--
  pos_y = 350
  vel_y = 0
  acel = 0
  vel_y_max = 150
  vel_porta = 50
  portadir_x = 405
  portaesq_x = 330
  cam_y = 0
  
  love.keyboard.setKeyRepeat(true)
  movendo = false
  subida = false 
  descida = false
  fechado = true
  fechar_elev = false
  abrir_elev = false
  key_origem = nil
  key_destino = nil
  mov = true
  arquivo_fechado = false
  
  --Reconhecedor andar--
  leitura_pedidos('pedidos.txt')
  andar_atual = 0
  andar_pedido = pedidos[1]
  indice_andar = 1
  
  
  --Audio--
  Elevator_Noise1 = love.audio.newSource('Assets/Sfx/Normal/Barulho elevador.mp3', 'static')
  Elevator_Noise2 = love.audio.newSource('Assets/Sfx/Normal/Barulho elevador2.mp3', 'static')
  Elevator_Noise3 = love.audio.newSource('Assets/Sfx/Whatsapp/Barulho do Zap.mp3','static')
  sfx_zap = Elevator_Noise1
  
  --Sprites--
  love.graphics.setDefaultFilter('nearest','nearest')
  fundoelev_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Fundo_Elevador.png')
  fundoelev_img2 = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Fundo_zap_elev.png')
  fundoelev = fundoelev_img
  for i = 1, 11 do
    animacao[i] = love.graphics.newImage('Assets/Sprites/SpriteSheets/Sprite_Elevador/Sprite_Elevador_'..i..'.png')
  end
  elev = animacao[frame]
  
  --Animacao--
  timer = 0
  animacao_Timer = 0
  frame = 1
  tempo_andar = 0
  
  --Csv--
  gera_csv('dados.csv')
end
function elevador.keypressed(key)
  if key >= '0' and key <= '9' then
    if key_origem then
      key_origem = tonumber(key)
    elseif key_destino then
      key_destino = tonumber(key)
    end
  end
end
function andares()
  chao = (y_Tela-100)/2
  for i = 0, 8 do
  tabela_Andar[i] = chao + 300*(i-1)
  tabela_Andar[9] = 300*8
  end
end
function elevador.update(dt)
  local lk = love.keyboard
  
  andares()
  
  timer_global = timer_global + dt
  
  if not arquivo_fechado then
    adiciona_csv(timer_global, 350 - (pos_y - cam_y), vel_y)
  end
  
  -- Mov. elevador --
  vel_y = vel_y + acel*dt
  
  --Animacao--
  if whats_teste == true then
    sfx_zap = Elevator_Noise3
    fundoelev = fundoelev_img2
  end
  
  -- Porta elevador --
  if timer > 0.2 and timer < 3 then
    love.audio.play(sfx_zap)
    frame = frame + 1
    if frame > 11 then
      frame = 11
    end
  elseif timer > 4 and timer < 5 then
    love.audio.play(Elevator_Noise2)
    frame = frame - 1
    if frame < 1 then
      frame = 1
    end
  elseif timer >= 5 then
    indice_andar = indice_andar + 1
    if not arquivo_fechado then
      if indice_andar >= #pedidos + 1 then
        vel_y = 0
        mov = false
        arquivo_csv:close()
        arquivo_fechado = true
      else
        andar_pedido = andar_atual + ( pedidos[indice_andar] - andar_atual)
        timer = 0
      end
    end
  end

  --Reconhecedor de andar atual--
  if subida == true and descida == false then
    if andar_atual == 8 then
      if pos_y < 53 then
        andar_atual = andar_atual + 1
      end
    elseif cam_y >= 300 * andar_atual then
      andar_atual = andar_atual + 1
    end
  elseif subida == false and descida == true then
    if andar_pedido == 0 then
      if cam_y <= (300 * andar_atual) - 300 then
        tempo_andar = tempo_andar + dt
        if tempo_andar >= 0.5 then
          andar_atual = andar_atual - 1
        end
      end
    elseif cam_y <= (300 * andar_atual) -375 then
      andar_atual = andar_atual - 1
    end
  end
  
  -- Parametros para o movimento e animacao --
  if mov == true then
    if andar_atual < pedidos[indice_andar] then
      subida = true
      descida = false
      acel = 50
    elseif andar_atual == pedidos[indice_andar] then
      if cam_y >= tabela_Andar[andar_pedido] - 75 then
        acel = -150
        if andar_pedido == 9 then
          if cam_y == 2400 and pos_y <= 250 then
            subida = false
            timer = timer + dt
          end
        elseif cam_y ~= 0 and cam_y > tabela_Andar[andar_pedido] then
          subida = false
          timer = timer + dt
        end
        if andar_pedido == 0 then
          if pos_y == 350 then
            timer = timer + dt
          end
        end
      end
    else 
      descida = true
      subida = false
      acel = 50
      if cam_y <= tabela_Andar[andar_pedido] + 75 then
        acel = -150
        if cam_y == tabela_Andar[andar_pedido] then
          descida = false
        end
      end
    end
  end
  
  -- Movimento p/ Cima --
  if subida == true then
    if pos_y <= 300 and cam_y < 2400 then
      pos_y = 300
      cam_y = cam_y + vel_y * dt
      if cam_y > 2400 then
          pos_y = pos_y - vel_y * dt
      end
    else
      pos_y = pos_y - vel_y * dt
    end
  -- Movimento p/ Baixo--
elseif descida == true then
    if pos_y < 300 then
      pos_y = pos_y + vel_y * dt
    elseif cam_y > 0  and pos_y >= 300 then
      pos_y = 300
      cam_y = cam_y - vel_y * dt
    else
      pos_y = pos_y + vel_y * dt
    end
  end
  
  -- Limite de velocidade --
  if vel_y >= vel_y_max then
    vel_y = vel_y_max
  end
  if vel_y <= 0 then
    vel_y = 0
  end
  
  -- Limite de Posicao e Camera--
  if pos_y >= 350 then
    pos_y = 350
    cam_y = 0
    descida = false
  end
  if cam_y < 0  then
    cam_y = 0
  end
  if cam_y >= 2400 then
    cam_y = 2400
  end
  if pos_y <= 50 and cam_y >= 2350 then
    pos_y = 50
  end
end

function elevador.draw()
  
  local lg = love.graphics
  --Fundo elevador--
  lg.setColor( 1, 1, 1)
  lg.draw(fundoelev, 330, pos_y-350, 0, 4.7, 75)
  
  --Corda elevador--
  lg.setColor( 0.11, 0.11, 0.11)
  lg.rectangle('fill', 400, pos_y-350, 10, 500)

  --Elevador--
  lg.setColor(1,1,1)
  lg.draw(animacao[frame], 320, pos_y + 35, 0, 10.5, 10.5)
  lg.translate(0, cam_y)
end
return elevador