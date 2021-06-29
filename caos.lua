local img, particula, timer
local caos = {}
function caos.load()
  
 img = love.graphics.newImage('Assets/Sprites/SpriteSheets/fogo.png')
 
 particula = love.graphics.newParticleSystem(img,50)
 
 particula:setParticleLifetime(0.5,1.2)
 
 particula:setLinearAcceleration(0, -50, 0, -150)
 
 particula:setSpeed(-20,20)
 
 particula:setSpin(5,6)
 
end
function caos.update(dt)
  
  particula:update(dt)
  
  particula:emit(8)
  
end
function caos.draw(x,y)
  
  love.graphics.draw(particula, x, y)
  
end
return caos