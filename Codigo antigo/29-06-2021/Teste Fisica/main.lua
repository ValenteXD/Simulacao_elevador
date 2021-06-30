local STI = require 'sti'

require ('player')

function love.load()
  
  Map = STI('mapa/1.lua', {'box2d'})
  World = love.physics.newWorld(0, 0)
  Map:box2d_init(World)
  Map.layers.solid.visible = true
  
  Player:load()
end

function love.update(dt)
  World:update(dt)
  Player:update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(.1, .5, .8)
  
  Map:draw(0, 0, 1.5, 1.5)
  
  love.graphics.push()
  love.graphics.scale(1.5, 1.5)
  
  Player:draw()
  
  love.graphics.pop()

end