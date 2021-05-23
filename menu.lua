local menu={}
function mouse_no_botao(mx,my,x,y,w,h)
  return mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function botao(x,y)
  love.graphics.setColor(0,1,0)
  love.graphics.rectangle('fill',x-60,y-40,120,60)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(fonte)
  love.graphics.print('start',x-55,y-40)
end
function menu.load()
  fonte = love.graphics.newFont(45)
end
function menu.update(dt)
  
end
function menu.draw()
  botao(400,300)
end
function menu.keypressed(key)
  
end
function menu.mousepressed(x,y,button)
  if button == 1 and mouse_no_botao(x,y,360,240,80,120) then
    vai_para_sim()
    sucesso=true
  end
end

return menu