local objects = {} -- table to hold all our physical objects
local center = 650/2

local function make_wall(world, x, y, width, height)
  local wall = {}
  wall.body = love.physics.newBody(world, x, y, "static")
  wall.shape = love.physics.newRectangleShape(width, height)
  wall.fixture = love.physics.newFixture(wall.body, wall.shape)

  return wall
end

local function draw_fixture(wall)
  love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape:getPoints()))
end

function love.load()
  -- the height of a meter our worlds will be 64px
  love.physics.setMeter(64)
  -- create a world for the bodies to exist in with horizontal gravity
  -- of 0 and vertical gravity of 9.81
  World = love.physics.newWorld(0, 9.81*64, true)

  -- let's create the ground
  objects.ground = make_wall(World, center, 650-10/2, 650, 10)
  objects.ceiling = make_wall(World, center, 0, 650, 10)
  objects.wall1 = make_wall(World, 0, center, 10, 650)
  objects.wall2 = make_wall(World, 650, center, 10, 650)

  objects.player1 = {}
  objects.player1.body = love.physics.newBody(World, center, center, "dynamic")
  objects.player1.shape = love.physics.newPolygonShape(0, 0,
                                                       -50, 20,
                                                       -50, -20)

  objects.player2 = {}
  objects.player2.body = love.physics.newBody(World, center, center, "dynamic")
  objects.player2.shape = love.physics.newPolygonShape(0, 0,
                                                       50, 20,
                                                       50, -20)

  objects.player1.fixture = love.physics.newFixture(objects.player1.body, objects.player1.shape, 1)
  objects.player2.fixture = love.physics.newFixture(objects.player2.body, objects.player2.shape, 1)

  Player_joint = love.physics.newRevoluteJoint(objects.player1.body, objects.player2.body , center, center, true )
  Player_joint:setLimitsEnabled(false)

  -- -- initial graphics setup
  -- -- set the background color to a nice blue
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
  love.window.setMode(650, 650) -- set the window dimensions to 650 by 650
end


function love.update(dt)
  World:update(dt) -- this puts the world into motion
  local isDown = love.keyboard.isDown

  -- Force is applied to player 1
  if isDown("d") then
    objects.player1.body:applyForce(400, 0)
  end
  if isDown("a") then
    objects.player1.body:applyForce(-400, 0)
  end
  if isDown("w") then
    objects.player1.body:applyForce(0, -400)
  end
  if isDown("s") then
    objects.player1.body:applyForce(0, 400)
  end

  -- Force is applied to player 2
  if isDown("right") then
    objects.player2.body:applyForce(400, 0)
  end
  if isDown("left") then
    objects.player2.body:applyForce(-400, 0)
  end
  if isDown("up") then
    objects.player2.body:applyForce(0, -400)
  end
  if isDown("down") then
    objects.player2.body:applyForce(0, 400)
  end

  for k, v in ipairs(World:getContacts()) do
    print(k, v)

  end

end

function love.draw()
  -- set the drawing color to green for the ground
  love.graphics.setColor(0.28, 0.63, 0.05)
  -- draw a "filled in" polygon using the ground's coordinates
  draw_fixture(objects.ceiling)
  draw_fixture(objects.ground)
  draw_fixture(objects.wall1)
  draw_fixture(objects.wall2)

  -- -- set the drawing color to red for the ball
  love.graphics.setColor(0.76, 0.18, 0.05)
  draw_fixture(objects.player1)
  love.graphics.setColor(0, 1, 0)
  draw_fixture(objects.player2)
end
