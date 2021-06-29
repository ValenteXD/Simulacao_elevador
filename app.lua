local app = {}
local n = {}

--local elevador = require 'elevador' 

function app.load()
  love.graphics.setDefaultFilter('nearest','nearest')
  app_logo = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_logo.png')
  app_caregamento = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_loading.png')
  app_manutencao = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_manutencao.png')
  app_tempos = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/app_tempos.png')
  numeros = love.graphics.newImage('Assets/Sprites/SpriteSheets/App/numeros.png')
  for i = 1,10 do
    n[i] = love.graphics.newQuad((i-1) * 4 , 0, 4, 5, numeros:getWidth(), numeros:getHeight())
  end
  
  
  app_crono = false
  
  vx = 133
  v = 75
  vx_motor = 133
  v_motor = 1.2       -- 1.2
  vx_eletrica = 133
  v_eletrica = 2      -- 2.0
  vx_corda = 133
  v_cordas = 1        -- 1.0
  vx_cabina = 133
  v_cabina = 1.7      -- 1.7
end

function app.update(dt)
  if vx_motor > 0 then
    vx_motor = vx_motor - dt*v_motor
  else
    vx_motor = 0
    motor = false
  end
  
  if vx_eletrica > 0 then
    vx_eletrica = vx_eletrica - dt*v_eletrica
  else
    vx_eletrica = 0
    eletrica = false
    mov_elev = false
  end
  
  if vx_corda > 0 then
    vx_corda = vx_corda - dt*v_cordas
  else
    vx_corda = 0
    corda = false
  end
  
  if vx_cabina > 0 then
    vx_cabina = vx_cabina - dt*v_cabina
  else
    vx_cabina = 0
    cabina = false
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
      
      --[[lg.setColor(0,1,0)
      lg.rectangle('fill', 190, 427 - cam_y, 12, 12)
      lg.rectangle('fill', 190, 470 - cam_y, 12, 12)
      lg.rectangle('fill', 190, 510 - cam_y, 12, 12)
      lg.rectangle('fill', 190, 552 - cam_y, 12, 12)]]
      if app_crono then
        lg.setColor(1,1,1)
        lg.draw(app_tempos, 20, 375 - cam_y, 0, 3.5, 3.5)
        if tempo_max ~= nil then
          d1 = tonumber(tempo_max:sub(1,1))
          u1 = tonumber(tempo_max:sub(2,2))
          if d1 == 0 then
            d1 = 10
          end
          if u1 == 0 then
            u1 = 10
          end
          lg.draw(numeros,n[d1],190,430 - cam_y,0,3)
          if u1 ~= nil then
            lg.draw(numeros,n[u1],202,430 - cam_y,0,3)
          end
        end
        
        if tempo_atual ~= nil then
          d2 = tonumber(tempo_atual:sub(1,1))
          u2 = tonumber(tempo_atual:sub(2,2))
          if d2 == 0 then
            d2 = 10
          end
          if u2 == 0 then
            u2 = 10
          end
          lg.draw(numeros,n[d2],190,517 - cam_y,0,3)
          if u2 ~= nil then
            lg.draw(numeros,n[u2],202,517 - cam_y,0,3)
          end
        end
      end
    end
  end
end
function app.mousepressed(x, y, button)
  if button == 1 then
    if app_bool == true then
      if x >= 287 and x <= 297 and y >= 379 and y <= 389 then
        app_bool = false
        app_crono = false
      end
      if x >= 245 and x <= 285 and y >= 450 and y <= 490 then
        app_crono = true
      end
      if app_crono and x >= 235 and x <= 285 and y >= 540 and y <= 600 then
        app_crono = false
      end
      if x >= 245 and x <= 285 and y >= 530 and y <= 570  and not app_crono then
        if vx_cabina == 0 then
          if not subida and not descida then
            vx_cabina = 133
            cabina = true
          end
          
          if subida or descida then
            frame = 1
          else 
            frame = 11
          end
          
        elseif vx_corda == 0 then
          vx_corda = 133
          corda = true
          
        elseif vx_eletrica == 0 then
          vx_eletrica = 133
          eletrica = true
          
        elseif vx_motor == 0 then
          if not subida and not descida then
            vx_motor = 133
            motor = true
          end
          
        end
        mov_elev = true
      end
    else
      if x >= 20 and x <= 120 and y >= 520 and y <= 570 then
        app_bool = true
      end
    end
  end
end
return app