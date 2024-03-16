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
  objects.ground = make_wall(World, 650/2, 650-10/2, 650, 10)
  objects.ceiling = make_wall(World, 650/2, 0, 650, 10)
  objects.wall1 = make_wall(World, 0, (650/2), 10, 650)
  objects.wall2 = make_wall(World, 650, (650/2), 10, 650)

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
  Player_joint:setLimitsEnabled(true)

  -- -- initial graphics setup
  -- -- set the background color to a nice blue
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
  love.window.setMode(650, 650) -- set the window dimensions to 650 by 650

  -- Adding random rectangular blocks--
  objects.blockOddRow1 = {}
  objects.blockOddRow1.body = love.physics.newBody(World, 10, 10, "dynamic")
  objects.blockOddRow1.shape = love.physics.newRectangleShape(100, 0, 50, 100, 90)
  objects.blockOddRow1.fixture = love.physics.newFixture(objects.blockOddRow1.body, objects.blockOddRow1.shape, 0.2)
  objects.blockOddRow1.body:setLinearDamping(0.999)

  objects.blockOddRow2 = {}
  objects.blockOddRow2.body = love.physics.newBody(World, 15, 15, "dynamic")
  objects.blockOddRow2.shape = love.physics.newRectangleShape(300, 0, 50, 100, 90)
  objects.blockOddRow2.fixture = love.physics.newFixture(objects.blockOddRow2.body, objects.blockOddRow2.shape, 0.2)
  objects.blockOddRow2.body:setLinearDamping(0.9)
  
  objects.blockOddRow3 = {}
  objects.blockOddRow3.body = love.physics.newBody(World, 20, 20, "dynamic")
  objects.blockOddRow3.shape = love.physics.newRectangleShape(500, 0, 50, 100, 90)
  objects.blockOddRow3.fixture = love.physics.newFixture(objects.blockOddRow3.body, objects.blockOddRow3.shape, 0.2)
  objects.blockOddRow3.body:setLinearDamping(0.999)

  ------------------------------------------------------------
  objects.blockEvenRow1 = {}
  objects.blockEvenRow1.body = love.physics.newBody(World, 25, 25, "dynamic")
  objects.blockEvenRow1.shape = love.physics.newRectangleShape(200, 0, 50, 100)
  objects.blockEvenRow1.fixture = love.physics.newFixture(objects.blockEvenRow1.body, objects.blockEvenRow1.shape, 0.2)
  objects.blockEvenRow1.body:setLinearDamping(0.999)

  objects.blockEvenRow2 = {}
  objects.blockEvenRow2.body = love.physics.newBody(World, 30, 30, "dynamic")
  objects.blockEvenRow2.shape = love.physics.newRectangleShape(400, 0, 50, 100)
  objects.blockEvenRow2.fixture = love.physics.newFixture(objects.blockEvenRow2.body, objects.blockEvenRow2.shape, 0.2)
  objects.blockEvenRow2.body:setLinearDamping(0.9)
  x
  objects.blockEvenRow3 = {}
  objects.blockEvenRow3.body = love.physics.newBody(World, 35, 35, "dynamic")
  objects.blockEvenRow3.shape = love.physics.newRectangleShape(600, 0, 50, 100)
  objects.blockEvenRow3.fixture = love.physics.newFixture(objects.blockEvenRow3.body, objects.blockEvenRow3.shape, 0.2)
  objects.blockEvenRow3.body:setLinearDamping(0.999)
  

  
end


function love.update(dt)
  World:update(dt) -- this puts the world into motion

  -- here we are going to create some keyboard events
  -- press the right arrow key to push the ball to the right
  if love.keyboard.isDown("right") then
    objects.player2.body:applyForce(400, 0)
  -- press the left arrow key to push the player2 to the left
  elseif love.keyboard.isDown("left") then
    objects.player2.body:applyForce(-400, 0)
  -- press the up arrow key to set the player2 in the air
  elseif love.keyboard.isDown("up") then
    objects.player2.body:setPosition(650/2, 650/2)
    -- we must set the velocity to zero to prevent a potentially large
    -- velocity generated by the change in position
    objects.player2.body:setLinearVelocity(0, 0)
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

  draw_fixture(objects.blockOddRow1)
  draw_fixture(objects.blockOddRow2)
  draw_fixture(objects.blockOddRow3)

  draw_fixture(objects.blockEvenRow1)
  draw_fixture(objects.blockEvenRow2)
  draw_fixture(objects.blockEvenRow3)

  love.graphics.setColor(0, 1, 1)

end
