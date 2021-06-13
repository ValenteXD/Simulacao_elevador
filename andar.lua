local andar = {}
local zap = {}
local r = 0
local particula = {}
function andar.load()
  -- Atributos cenario--
  x_tela = love.graphics.getWidth()
  y_Tela = love.graphics.getHeight()
  font = love.graphics.newFont(15)
  tabela_Andar = {}
  
  
  --Sprites--
  love.graphics.setDefaultFilter('nearest','nearest')
  janela_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Janela.png')
  janela_zap = love.graphics.newImage('Assets/Sprites/SpriteSheets/Whatsapp/Janela_Zap_1.png')
  jan = janela_img
  botao_cima = love.graphics.newImage('Assets/Sprites/SpriteSheets/Botao_cima.png')
  botao_baixo = love.graphics.newImage('Assets/Sprites/SpriteSheets/Botao_baixo.png')
  chao_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Chao.png')
  flor_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Flor.png')
  mesa_img = love.graphics.newImage('Assets/Sprites/SpriteSheets/Mesa.png')
  
  eletrica = love.graphics.newImage('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/eletrica.png')
  part = love.graphics.newImage('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/sparks.png')
  --leitura_sprite('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/sparks.png', particula, 16, 16)
  for i = 1,4 do
    particula[i] = love.graphics.newQuad((i-1) * 16 , 0, 16, 16, part:getWidth(), part:getHeight())
  end
  motor = love.graphics.newImage('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/motor.png')
  polia = love.graphics.newImage('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/polia.png')
  polia_2 = love.graphics.newImage('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/polia_2.png')
  fundo_maquinas = love.graphics.newImage('Assets/Sprites/SpriteSheets/Casa_de_Maquinas/fundo_maquinas.png')
  
  indice_part = 1
  timer_part = 0
end
function andar.update(dt)
  if subida == true then
    r = r + 1*dt
  elseif descida == true then
    r = r -1*dt
  end
  
  
  timer_part = timer_part + dt
  
  if timer_part > 0.1 then
      indice_part = indice_part + 1
      timer_part = 0
  end
  if indice_part > 4 then
    indice_part = 1
  end
    
  end
function andar.draw()
  local lg = love.graphics
  local chao = (y_Tela-100)/2
  local y_Jan = y_Tela/7.5
  
  if whats_teste == true then
    jan = janela_zap
  end
  
  function janela(x,y)
    lg.setColor(1, 1, 1)
    lg.draw(jan, x, y, 0, 7, 7)
    lg.draw(jan, x+500, y, 0, 7, 7)
  end
  function botao(x,y)
  --botões elevador--
  lg.setColor( 1, 1, 1)
  lg.draw(botao_cima, x, y, 0, 2, 2)
  lg.draw(botao_baixo, x, y+15, 0, 2, 2)
  end
  function placa(x, y, z)
    --placa--
    lg.setColor(0.7,0.65,0.25)
    lg.rectangle('fill', x+230, y+43, x+80, 35)
      
    --texto placa--
    lg.setColor(0, 0, 0)
    lg.setFont(font)
    lg.print(z, x+240, y+50)
  end
  function andar (z)
    for i = 0, z, 1 do
      
      --janela--
      janela(90,y_Jan - 300*(i-1))
      
      --chao--
      lg.draw(chao_img , x_tela/2, chao - 300*(i-1), 0 , 1, 1, chao_img:getWidth()/2, 0)
      
      --botao--
      botao(490,455 - 300 *(i))
      
      --Placa--
      placa(0, -300*(i-1), tostring(i)..'ºAndar')
      
      if i == 0 then
        --janela--
        janela(90,y_Jan + 300)
        
        --Placa--
        placa(0, 300,' Térreo')
        
        --Placa--
        botao(490,455)
        
        --Mesa--
        lg.draw(mesa_img, 260, 455, 0, 6, 6, mesa_img:getWidth()/2)
        
        --Vaso
        lg.draw(flor_img, 240, 440, 0, 4, 4)
        
      end
    end
  end
  -- fundo --
  lg.setColor(1,1,1)
  lg.draw(fundo_maquinas, 0, -2700)
  
  --chao--
  lg.draw(chao_img , x_tela/2, chao - 2700, 0 , 1, 1, chao_img:getWidth()/2, 0)
  
  -- Motor --
  lg.setColor(1,1,1)
  lg.draw(motor, 550, 358 - 3000, 0, 12, 12)
  lg.draw(part,particula[indice_part], 550, 358 - 3000, 0, 12, 12)
  
  -- Eletrica --
  lg.draw(eletrica, 160, 400 - 3000, 0, 8, 8)
  
  -- Polias --
  lg.draw(polia, 405, 500 - 3000, r, 6, 6, 15/2, 15/2)
  lg.draw(polia_2, 360, 460 - 3000, 0, 6, 6)
  
  andar(9)
end

return andar