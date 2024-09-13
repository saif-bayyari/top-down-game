local Character = require "Character"  -- Assuming your Character class is saved in a file called Character.lua
local Player = {}
Player.__index = Player
setmetatable(Player, { __index = Character })  -- Inherit from Character class

function Player:new(x, y, speed, scale)
    local self = Character.new(self, x, y, "man", speed, scale)  -- Call the Character's constructor
    setmetatable(self, Player)  -- Set the metatable to Player
    
   
    
    return self
end

function Player:update(dt)
    local isMoving = false

    -- Reset dx and dy before applying movement
    self.dx, self.dy = 0, 0

    -- Check for diagonal and regular movement
    if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed * dt
        self.dy = self.dy - self.speed * dt
        self:setDirection("left")
        isMoving = true
    elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") then
        self.dx = self.dx + self.speed * dt
        self.dy = self.dy - self.speed * dt
        self:setDirection("right")
        isMoving = true
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed * dt
        self.dy = self.dy + self.speed * dt
        self:setDirection("left")
        isMoving = true
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
        self.dx = self.dx + self.speed * dt
        self.dy = self.dy + self.speed * dt
        self:setDirection("right")
        isMoving = true
    elseif love.keyboard.isDown("w") then
        self.dy = self.dy - self.speed * dt
        self:setDirection("up")
        isMoving = true
    elseif love.keyboard.isDown("s") then
        self.dy = self.dy + self.speed * dt
        self:setDirection("down")
        isMoving = true
    elseif love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed * dt
        self:setDirection("left")
        isMoving = true
    elseif love.keyboard.isDown("d") then
        self.dx = self.dx + self.speed * dt
        self:setDirection("right")
        isMoving = true
    end

    -- Apply movement to the player's position
    self.x = self.x + self.dx
    self.y = self.y + self.dy

    -- If no keys are pressed, set direction to "idle"
    if not isMoving then
        self:setDirection("idle")
    end

    -- Call the parent class update method to handle other updates
    Character.update(self, dt)

    return isMoving
end

-- Assuming you have a `setDirection` method in your Player or Character class
function Player:setDirection(direction)
    local directions = {"up", "down", "left", "right", "idle"}
    
    -- Assert that the direction is valid
    local isValidDirection = false
    for _, validDirection in ipairs(directions) do
        if direction == validDirection then
            isValidDirection = true
            break
        end
    end
    
    assert(isValidDirection, "Invalid direction: " .. tostring(direction))
    
    -- Set the direction if valid
    self.direction = direction
end



return Player
