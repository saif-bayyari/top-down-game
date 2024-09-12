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
    

    -- Check for diagonal and regular movement
    if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed * dt
        self.dy = self.dy - self.speed * dt
        self.direction = "left"
        
    elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") then
        self.dx = self.dx + self.speed * dt
        self.dy = self.dy - self.speed * dt
        self.direction = "right"
    
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed * dt
        self.dy = self.dy + self.speed * dt
        self.direction = "left"
      
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
        self.dx = self.dx + self.speed * dt
        self.dy = self.dy + self.speed * dt
        self.direction = "right"
       
    elseif love.keyboard.isDown("w") then
        self.dy = self.dy - self.speed * dt
        self.direction = "up"
     
    elseif love.keyboard.isDown("s") then
        self.dy = self.dy + self.speed * dt
        self.direction = "down"
    
    elseif love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed * dt
        self.direction = "left"

    elseif love.keyboard.isDown("d") then
        self.dx = self.dx + self.speed * dt
        self.direction = "right"

    else
        self.direction = "idle"
    end
    
    -- Call the parent class update method to handle movement and animation
    Character.update(self, dt)

    -- Check for death
    
end



return Player
