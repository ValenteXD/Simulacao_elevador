local app = {}
local elevador = require 'elevador' 

function app.load()
  love.graphics.setDefaultFilter('nearest','nearest')
  app_logo = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_logo.png')
  app_caregamento = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_loading.png')
  app_manutencao = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_manutencao.png')
  
  app_bool = false
  app_load = false
  
  vx = 133
  v = 75
  vx_motor = 133
  v_motor = 2.5
  vx_eletrica = 133
  v_eletrica = 2
  vx_corda = 133
  v_cordas = 1
  vx_cabina = 133
  v_cabina = 0.5
end

function app.update(dt)
  if vx_motor > 0 then
    vx_motor = vx_motor - dt*v_motor
  else
    vx_motor = 0
  end
  
  if vx_eletrica > 0 then
    vx_eletrica = vx_eletrica - dt*v_eletrica
  else
    vx_eletrica = 0
  end
  
  if vx_corda > 0 then
    vx_corda = vx_corda - dt*v_cordas
  else
    vx_corda = 0
  end
  
  if vx_cabina > 0 then
    vx_cabina = vx_cabina - dt*v_cabina
  else
    vx_cabina = 0
  end
  
  
  if app_bool == true then
    if vx > 0 then
      vx = vx - dt*v
    elseif vx <= 0 then
      vx = 0
      app_load = true
    end
  end
end

function app.draw()
  lg = love.graphics
  
  lg.setColor(1,1,1)
  lg.draw(app_logo, 20, 500 - cam_y, 0, 6, 6)
  if app_bool == true then
    lg.draw(app_caregamento, 20, 375 - cam_y, 0, 3.5 , 3.5)
    lg.rectangle('fill', 227, 524.5 - cam_y, -vx, 12)
    if app_load == true then
      lg.draw(app_manutencao, 20, 375 - cam_y, 0, 3.5, 3.5)
      lg.setColor(.36,.68,.37)
      lg.rectangle('fill', 45, 427 - cam_y, vx_motor, 10.5)
      lg.rectangle('fill', 45, 470 - cam_y, vx_eletrica, 10)
      lg.rectangle('fill', 45, 512 - cam_y, vx_corda, 10)
      lg.rectangle('fill', 45, 554 - cam_y, vx_cabina, 10)
    end
  end
end
function app.mousepressed(x, y, button)
  if button == 1 then
    if app_bool == true then
      if x >= 287 and x <= 297 and y >= 379 and y <= 389 then
        app_bool = false
      end
      if x >= 245 and x <= 285 and y >= 530 and y <= 570 then
        vx_cabina = 133
        vx_corda = 133
        vx_eletrica = 133
        vx_motor = 133
      end
    else
      if x >= 20 and x <= 120 and y >= 520 and y <= 570 then
        app_bool = true
      end
    end
  end
end
return app