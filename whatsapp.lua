local whatsapp = {}

function whatsapp.load()
  whats_teste = false
  active=false
end

function whatsapp.mousepressed(x,y, button)
  if active then
    botaozap = x >= 700 and x <= 750 and y >= 500 and y <= 550
    if button == 1 and botaozap then
      whats_teste = not whats_teste
    end
  end
end
function whatsapp.keypressed(key)
  if key=='w' then
    active=not active
  end
end
return whatsapp