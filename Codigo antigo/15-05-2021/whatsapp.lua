local whatsapp = {}

function whatsapp.load()
  whats_teste = false
end

function whatsapp.mousepressed(x,y, button)
  botaozap = x >= 700 and x <= 750 and y >= 500 and y <= 550
  if button == 1 and botaozap then
    whats_teste = true
  end
end

return whatsapp