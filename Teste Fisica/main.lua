PixToMet = 32
love.physics.setMeter(PixToMet)

local world = love.physics.newWorld(0, 9.81*PixToMet, true)

local objects = {}
objects.box = {}

--Criando uma caixa --
objects.box.x = 10
objects.box.y = 20
objects.box.w = 32
objects.box.h = 32

-- Esqueleto --
objects.box.body = love.physics.newBody(world, objects.box.x, objects.box.y, 'dynamic')

-- Pele --
objects.box.shape = love.physics.newRectangleShape(objects.box.w, objects.box.h)

-- Fisica de fato --                                                              
objects.box.fixture = love.physics.newFixture(objects.box.body, objects.box.shape, 1) -- 1 = densidade do objeto --
objects.box.fixture:setRestitution(.9)

function love.load()
  
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.rectangle('line', objects.box.body:getX(), objects.box.body:getY(), objects.box.w, objects.box.h)
end