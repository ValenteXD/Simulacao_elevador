local leitor = {}

function leitura_sprite(nome, quad, frame_largura, frame_altura)
  img = love.graphics.newImage(nome)
  local larguraImg = img:getWidth()
  local alturaImg = img:getHeight()
  
  
  for i=1, 2, 1 do 
    quad[i] = love.graphics.newQuad(frame_largura*(i-1), 0, frame_largura, frame_altura, larguraImg, alturaImg)
  end
end


return leitor