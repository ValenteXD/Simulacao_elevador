local elevador = {}
local andar = require 'andar'
local whatsapp = require 'whatsapp'
local fisica = require 'fisica'
local app = require 'app'
local animacao = {}
pedidos = {0,}
local arquivo_csv = {}
local timer_global = 0


pedidos_online = false
pedidos_offline = false
function leitura_pedidos(nome)
  local file = io.open(nome, 'r')
  local destino
  local pedido_elev
  local lista_subida = {}
  local lista_descida = {}
  
  for line in file:lines() do
    pedido_elev = tonumber(line:sub(1,1))
    destino = tonumber(line:sub(3,3))
    --table.insert(pedidos, destino)
    --table.insert(pedidos, pedido_elev)
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
function organiza_pedidos(origem, destino)
  local lista_subida = {}
  local lista_descida = {}
  local lista_complementar = {}
  
  function andar_nao_listado(andar)
    for i=1, #pedidos do
      if andar == pedidos[i] then
        return false
      end
    end
    return true
  end
  
  function unificador(lista_subida, lista_descida)
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
  end
  
  if pedidos_online == true then
    local function separador_pedidos()
      local inicia_subindo = false
      local preencheu_subida = false
      local preencheu_descida = false
      local ultimo_preenchido
      
      if #pedidos <= 1 then
        table.insert(lista_subida, pedidos[1])
      else
        if pedidos[1] < pedidos[2] then
          table.insert(lista_subida, pedidos[1])
          preenchido = 's'
          inicia_subindo = true
        else
          table.insert(lista_descida, pedidos[1])
          preenchido = 'd'
          inicia_subindo = false
        end
      end
      for i = 2, #pedidos - 1 do
        if pedidos[i] < pedidos[i+1] then
          
          if not inicia_subindo then
            preencheu_subida = true
          end
          
          if preencheu_descida then
            table.insert(lista_complementar, pedidos[i])
            ultimo_preenchido = 'c'
          else
            table.insert(lista_subida, pedidos[i])
            ultimo_preenchido = 's'
          end
        else
          if inicia_subindo then
            preencheu_descida = true
          end
          
          if preencheu_subida then
            table.insert(lista_complementar, pedidos[i])
            ultimo_preenchido = 'c'
          else
            table.insert(lista_descida, pedidos[i])
            ultimo_preenchido = 'd'
          end
        end
      end
      if #pedidos >= 2 then
        local ultimo = pedidos[#pedidos]
        if ultimo_preenchido == 'c' then
          table.insert(lista_complementar, ultimo)
        elseif ultimo_preenchido == 'd' then
          table.insert(lista_descida, ultimo)
        else
          table.insert(lista_subida, ultimo)
        end
      end
      return lista_subida, lista_descida, lista_complementar
    end
    
    local function unificador_pedidos(primeira, segunda, lista_complementar)
      
      pedidos = {}
      
      for i = 1, #primeira do
        table.insert(pedidos, primeira[i])
      end
      
      for i = 1, #segunda do
        table.insert(pedidos, segunda[i])
      end
      
      for i = 1, #lista_complementar do
        table.insert(pedidos, lista_complementar[i])
      end
      
      for i = #pedidos, 2, -1 do
        if pedidos[i] == pedidos[i-1] then
          table.remove(pedidos, i)
        end
      end
    end
    
    local function andar_nao_lista(pedidos, andar)
      for i=1, #pedidos do
        if andar == pedidos[i] then
          return false
        end
      end
      return true
    end
    
    local function reorganiza_pedidos(pedidos, andar, subindo)
      
      if andar_nao_lista(pedidos, andar) then
        
        local pedidos_novos = {}
        local inserido = false
        local condicao
        
        for i=1, #pedidos do
          if subindo then
            condicao = pedidos[i] > andar
          else
            condicao = pedidos[i] < andar
          end
          
          if condicao and not inserido then
            table.insert(pedidos_novos, andar)
            inserido = true
          end
          
          table.insert(pedidos_novos, pedidos[i])
        end
        
        if not inserido then
          table.insert(pedidos_novos, andar)
        end
        return pedidos_novos
      end
      return pedidos
    end
    
    local function mostra_tabela(nome, tabela)
      print(nome)
      for i=1, #tabela do
        io.write(tabela[i]..',')
      end
      io.write('\n')
    end
    
    local function ordena_pedidos(origem, destino)
      print('origem atual:', origem)
      print('destino atual:', destino)
      
      if #pedidos > 1 then
        print('Lista preenchida')
        local lista_subida, lista_descida, lista_complementar = separador_pedidos()
        
        if (andar_atual > pedidos[1]) or (#pedidos >= 2 and andar_atual == pedidos[1] and andar_atual < pedidos[2]) then
          print('Elevador subindo!')
          
          if origem < destino then
            print('Quer subir')
            
            if andar_atual < origem then
              print('Da tempo de atender')
              
              lista_subida = reorganiza_pedidos(lista_subida, origem, true)
              lista_subida = reorganiza_pedidos(lista_subida, destino, true)
            else
              print('Nao da tempo')
              
              lista_complementar = reorganiza_pedidos(lista_complementar, origem, true)
              lista_complementar = reorganiza_pedidos(lista_complementar, destino, true)
            end
          else
            print('Quer descer')
            lista_descida = reorganiza_pedidos(lista_descida, origem, false)
            lista_descida = reorganiza_pedidos(lista_descida, destino, false)
          end
          
          unificador_pedidos(lista_subida, lista_descida, lista_complementar)
          
        elseif (andar_atual < pedidos[1] or (#pedidos >= 2 and andar_atual == pedidos[1] and andar_atual > pedidos[2])) then
          print('Elevador descendo')
          
          if origem < destino then
            print('Cliente que subir')
            
            lista_subida = reorganiza_pedidos(lista_subida, origem, true)
            lista_subida = reorganiza_pedidos(lista_subida, destino, true)
          else
            print('Cliente quer descer')
            
            if andar_atual < origem then
              print('Da para atender')
              
              lista_descida = reorganiza_pedidos(lista_descida, origem, false)
              lista_descida = reorganiza_pedidos(lista_descida, destino, false)
            else
              print('Nao da tempo, vai para complementar')
              
              lista_complementar = reorganiza_pedidos(lista_complementar, origem, false)
              lista_complementar = reorganiza_pedidos(lista_complementar, destino, false)
            end
          end
          unificador_pedidos(lista_descida, lista_subida, lista_complementar)
        end
      mostra_tabela('Subida:', lista_subida)
      mostra_tabela('Descida:', lista_descida)
      mostra_tabela('Complementar:', lista_complementar)
      mostra_tabela('Pedidos:', pedidos)
    else
      print('Lista vazia ou com elemento unico')
      
      table.insert(pedidos, origem)
      table.insert(pedidos, destino)
      
      mostra_tabela('Pedido:', pedidos)
      end
    end
    ordena_pedidos(origem, destino)
  end
  if pedidos_offline == true then
    if origem > destino then
      table.insert(lista_descida, origem)
      table.insert(lista_descida, destino)
    else
      table.insert(lista_subida, origem)
      table.insert(lista_subida, destino)
    end
    table.sort(lista_subida)
    table.sort(lista_descida, function(a,b)
      return a > b
    end)
    unificador(lista_subida, lista_descida)
  end
  andar_pedido = pedidos[indice_andar]
end
local function gera_csv(nome)
  arquivo_csv = io.open(nome, 'w')
  arquivo_csv:write('Tempo;Altura;Velocidade;Forca_Tracao;Forca_Motor;Energia_Motor\n')
end

local function adiciona_csv(tempo, altura, velocidade, forca_tracao, forca_motor, energia_motor)
  local line_tempo = tostring(tempo):gsub('%.',',')
  local line_altura = tostring(altura):gsub('%.',',')
  local line_velocidade = tostring(velocidade):gsub('%.',',')
  local line_forca_tracao = tostring(forca_tracao):gsub('%.',',')
  local line_forca_motor = tostring(forca_motor):gsub('%.',',')
  local line_energia_motor = tostring(energia_motor):gsub('%.',',')
  local line = line_tempo .. ';' .. line_altura .. ';' .. line_velocidade .. ';' .. line_forca_tracao .. ';' .. line_forca_motor .. ';' .. line_energia_motor .. '\n'
  arquivo_csv:write(line)
end
function elevador.load()
  --Atributos customizados--
  local file = io.open('valores.txt','r')
  local input={}
  for line in file:lines() do
    local linha = line
    table.insert(input,tonumber(line))
  end
  massa_elevador = input[1] --500
  massa_contrapeso = input[2] --500 --250
  vel_y_max = input[3] --150
  
  -- Atributos elevador--
  pos_y = 350 --350
  pos_y_ctp = 350
  vel_y = 0
  acel = 0
  
  vel_porta = 50
  portadir_x = 405
  portaesq_x = 330
  cam_y = 2700
  timer_debounce = 0
  
  tracao = 0
  forca_motor = 0
  energia_motor = 0
  
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
  debounce = false
  arquivo_fechado = false
  organiza = false
  mov_elev = true
  
  app_bool = false
  app_load = false
  
  
  
  -- catastrofes --
  motor = true
  eletrica = true
  corda = true
  
  cabina = true
  cab_ida = false
  
  vel_motor = 0
  
  --Reconhecedor andar--
  if pedidos_offline then
    leitura_pedidos('pedidos.txt')
  end
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
  contrapeso = love.graphics.newImage('Assets/Sprites/SpriteSheets/contrapeso.png')
  
  --Animacao--
  timer = 0
  animacao_Timer = 0
  frame = 1
  tempo_andar = 0
  
  --Csv--
  gera_csv('dados.csv')
  
  --Cronometro--
  elevador.tempo_final = {}
  elevador.tempos = {}
  pedido_atual = 1
end
local input1 = true
function elevador.keypressed(key)
  if key >= '0' and key <= '9' then
    debounce = true
    if key_origem == nil then
      key_origem = tonumber(key)
    elseif key_destino == nil then
      key_destino = tonumber(key)
    end

    if organiza == true then
      if key_destino then
        organiza_pedidos(key_origem, key_destino)
        organiza = false
        if mov == false then
          --mov = true
          --andar_pedido = andar_atual + ( pedidos[indice_andar] - andar_atual)
        end
      end
    end
    if input1 then
      input1=false
    else
      input1 = true
      table.insert(elevador.tempos, {0, key_destino, key_origem, false})
      io.write('peguei o pedido\no destino é '..elevador.tempos[1][2]..'\ne aorigem é '..elevador.tempos[1][3])
    end
  end
  print(key_origem, key_destino)
  --volta pro menu--
  if key == 'escape' then
    vai_para_menu()
    musica_menu:play()
  end
end

function elevador.mousepressed(x,y,button)
  
end

function andares()
  chao = (y_Tela-100)/2
  for i = 0, 9 do
  tabela_Andar[i] = chao + 300*(i-1)
  --tabela_Andar[9] = 300*8
  end
end
function elevador.update(dt)
  local lk = love.keyboard
  
  
  
  andares()
  
  timer_global = timer_global + dt
  
  -- fisica --
  tracao = fisica.tracao(massa_contrapeso, acel)
  forca_motor = fisica.forcaMotor(massa_contrapeso, massa_elevador, acel)
  energia_motor = energia_motor + fisica.energia(vel_y,timer_global, massa_contrapeso, massa_elevador, acel)
  
  
  if debounce == true then
    timer_debounce = timer_debounce + dt
    if timer_debounce > 2 then
      key_origem = nil
      key_destino = nil
      timer_debounce = 0
      debounce = false
      organiza = false
    elseif timer_debounce < 2 then
      organiza = true
    end
  end
  
  if not arquivo_fechado then
    adiciona_csv(timer_global, 350 - (pos_y - cam_y), vel_y, tracao, forca_motor, energia_motor)
  end
  
  -- Mov. elevador --
  vel_y = vel_y + acel*dt
  
  --Animacao--
  if whats_teste == true then
    sfx_zap = Elevator_Noise3
    fundoelev = fundoelev_img2
  end
  
  -- Porta elevador --
  if cabina then
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
          andar_pedido = pedidos[indice_andar]
        end
        timer = 0
      end
    end
  end

  --Reconhecedor de andar atual--
  if subida == true and descida == false then
    if cam_y >= 300 * andar_atual then
      andar_atual = andar_atual + 1
    end
    --[[if andar_atual == 8 then
      if pos_y < 53 then
        andar_atual = andar_atual + 1
      end
    elseif cam_y >= 300 * andar_atual then
      andar_atual = andar_atual + 1
    end]]
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
  if mov == true and motor then
    --subir--
    if andar_atual < pedidos[indice_andar] then
      subida = true
      descida = false
      acel = 50
    --chegou no andar--
    elseif andar_atual == pedidos[indice_andar] then
      --freiar--
      if cam_y >= tabela_Andar[andar_pedido] - 75 and cam_y <= tabela_Andar[andar_pedido] or andar_pedido == 0 then
        acel = -150
        --para o elevador e abre a porta--
        if cam_y ~= 0 and cam_y >= tabela_Andar[andar_pedido] -1 then
          --print('hahahhahahahahah')
          subida = false
          timer = timer + dt
        end
        if andar_pedido == 0 then
          if pos_y == 350 then
            timer = timer + dt
          end
        end
      end
    elseif andar_atual > pedidos[indice_andar] then
      descida = true
      subida = false
      acel = 50
      if cam_y <= tabela_Andar[andar_pedido] + 75 then
        acel = -150
        if cam_y <= tabela_Andar[andar_pedido] then
          descida = false
          timer = timer + dt
        end
      end
    end
  end
  
  -- Movimento p/ Cima --
  if mov_elev and motor then
    if subida == true then
      if pos_y <= 300 and cam_y < 2700 then
        pos_y = 300
        cam_y = cam_y + vel_y * dt
        --[[if cam_y > 2400 then
            pos_y = pos_y - vel_y * dt
        end]]
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
  end
    
  -- Limite de velocidade --
  if motor then
    if vel_y >= vel_y_max then
      vel_y = vel_y_max
    end
    if vel_y <= 0 then
      vel_y = 0
    end
  end
  
  -- Mov contrapeso --
  if mov_elev then
    if subida == true and descida == false then
      pos_y_ctp = pos_y_ctp + vel_y * dt
      
    elseif descida == true  and subida == false then
      pos_y_ctp = pos_y_ctp - vel_y * dt
    end
  end
  
  -- Limite de Posicao e Camera--
  if pos_y >= 350 then
    pos_y = 350
    cam_y = 0
    descida = false
  end
  --[[if pos_y_ctp >= 350 then
    pos_y_ctp = 350
  end]]
  if motor then
    if cam_y < 0  then
      cam_y = 0
    end
  elseif not motor then
    if cam_y < -50 then
      cam_y = -50
    end
  end
  if cam_y >= 2740 then
    cam_y = 2740
  end
  --[[if pos_y <= 50 and cam_y >= 2350 then
    pos_y = 50
  end]]
  
  --cronometro de pedidos--
  for i = 1, #elevador.tempos do
      if elevador.tempos[i][1] >= 0 then
        elevador.tempos[i][1] = elevador.tempos[i][1] + dt
      end
      if andar_atual == elevador.tempos[i][3] then
        elevador.tempos[i][4] = true
      end
      if andar_atual == elevador.tempos[i][2] and elevador.tempos[i][4] == true then
        io.write('terminei o pedido!\nsó levei '..tostring(elevador.tempos[i][1])..'s\n')
        table.insert(elevador.tempo_final,elevador.tempos[i][1])
        elevador.tempos[i] = {-1,99}
        pedido_atual = pedido_atual + 1
        table.sort(elevador.tempo_final)
        tempo_max = string.format('%.0f', tostring(elevador.tempo_final[table.maxn(elevador.tempo_final)]))
        io.write('o tempo máximo de espera é '..tostring(tempo_max)..'\n')
      end
  end
  if #elevador.tempos >= pedido_atual then
    tempo_atual = string.format('%.0f',tostring(elevador.tempos[pedido_atual][1]))
  end
  
  -- Catastrofes -- 
  
  -- Portas -- 
  if not cabina then
    local var = math.random (1,2)
    
    love.audio.play(sfx_zap)
    
    if var == 1 then
      if not cab_ida then
        frame = frame + 1
      end
      if frame > 11 then
        cab_ida = true
      end
      if cab_ida then
        frame = frame - 1
        if frame < 1 then
          cab_ida = false
          frame = 1
          love.audio.play(sfx_zap)
        end
      end
    elseif var == 2 then
      if frame > 11 then
        frame = 11
      end
    end
  end
  
  -- Motor (Chocante) --
  if not motor then
    if subida then
      if cam_y <= 2750 then
        cam_y = cam_y + vel_y * dt
      end
    elseif descida then
      cam_y = cam_y - vel_y * dt
    end
  end
  
  -- Eletrica --
  if not eletrica then
    
  end

  -- Cordas --
  if not corda then
    
  end
  
end

function elevador.draw()
  
  local lg = love.graphics
  --Fundo elevador--
  lg.setColor( 1, 1, 1)
  lg.draw(fundoelev, 330, pos_y-350, 0, 4.8, 75)
  lg.translate(0, cam_y)
  
  --Corda contrapeso--
  lg.setColor( 0.11, 0.11, 0.11)
  lg.rectangle('fill', 400, -2240, 10, pos_y_ctp+70)
  
  --Contrapeso--
  lg.setColor(1,1,1)
  lg.draw(contrapeso, 323.5, pos_y_ctp -2240, 0, 10, 10)
  
  lg.translate(0, -cam_y)

  --Corda elevador--
  lg.setColor( 0.11, 0.11, 0.11)
  lg.rectangle('fill', 400, pos_y-350, 10, 500)

  --Elevador--
  lg.setColor(1,1,1)
  lg.draw(animacao[frame], 320, pos_y + 35, 0, 10.5, 10.5)
  lg.translate(0, cam_y)
  
  
  
end

function leitura_pedidos(nome)
  local file = io.open(nome, 'r')
  local destino
  local pedido_elev
  for line in file:lines() do
    pedido_elev = tonumber(line:sub(1,1))
    destino = tonumber(line:sub(3,3))
    organiza_pedidos(pedido_elev, destino)
  end
  file:close()
end

function elevador.mousepressed(x,y,button)
  app.mousepressed(x,y,button)
end

return elevador
