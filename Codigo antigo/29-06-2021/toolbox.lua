toolbox = {}
local texto, atual
local function caixa_texto(t,x,y,i)
  lg.setColor(1,1,1)
  lg.rectangle('fill', x-150, y, 300, 50, 5)
  if atual == i then
    lg.setColor(0,0.8,1)
  else
    lg.setColor(0,0,0)
  end
  lg.rectangle('line', x-150, y, 300, 50, 5)
  lg.setColor(0,0,0)
  lg.setFont(fonte50)
  lg.print(t,x-150,y)
end
local function mouse_no_botao(mx,my,x,y,w,h)
  return mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function botao(x,y)
  love.graphics.setColor(0,0.6,0)
  love.graphics.rectangle('fill',x-80,y,160,60,5)
  if mouse_no_botao(mx,my,x-80,y,160,60) then
    love.graphics.setColor(0,0.8,1)
  else
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setFont(fonte50)
  love.graphics.print('salvar',x-77,y)
end
function toolbox.load()
  background = love.graphics.newImage ('Assets/fundo_opaco.png')
  placa = love.graphics.newImage ('Assets/prata.png')
  fonte50 = love.graphics.newFont(50)
  fonte20 = love.graphics.newFont(20)
  texto = {}
  local file = io.open('valores.txt','r')
  for line in file:lines() do
    local linha = line
    table.insert(texto,line)
  end
  atual = 1
end
function toolbox.update(dt)
  mx,my = love.mouse.getPosition()
end
function toolbox.draw()
  lg = love.graphics
  lg.setColor(1,1,1)
  lg.draw(background)
  lg.draw(placa)
  botao(400,470)
  lg.setColor(1,1,1)
  lg.setFont(fonte20)
  lg.print('Pressione "ENTER" para selecionar a caixa de texto para editar',90,20)
  lg.setColor(0,0,0)
  lg.print('Massa da cabina',310,95)
  lg.print('Massa do contrapeso',300,185)
  lg.print('Velocidade máxima',340,275)
  --lg.print('Aceleração',310,365)
  caixa_texto(texto[1],400,125,1)
  caixa_texto(texto[2],400,215,2)
  caixa_texto(texto[3],400,305,3)
  --caixa_texto(texto[4],400,395,4)
end
function toolbox.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,320,470,160,60) then
    local file = io.open('valores.txt','w')
    for i = 1,#texto do
      if texto[i] == '' or texto[i] == '.' then
        if i == 1 then
          texto[i]=500
        elseif i == 2 then
          texto[i]=500
        else
          texto[i]=150
        end
      end
      file:write(texto[i]..'\n')
    end
    file:close()
    vai_para_menu()
  end
end
function toolbox.keypressed(key)
  if string.len(texto[atual]) <= 8 then
    if key>='0' and key<='9' then
      texto[atual] = texto[atual]..key
    elseif key>='kp0' and key<='kp9' then
      texto[atual] = texto[atual]..string.sub(key,3)
    end
    if key == '.' and string.find(texto[atual],'%.') == nil then
      texto[atual] = texto[atual]..key
    end
  end
  if key == 'backspace' then
    texto[atual] = string.sub(texto[atual],1,-2)
  end
  if key == 'return' then
    if atual < 3 then
      atual = atual + 1
    else
      atual = 1
    end
  end
end
return toolbox