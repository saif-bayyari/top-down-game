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
    -- Use WASD input to control the character's direction
    if love.keyboard.isDown('w') then
        self.direction = "up"
    elseif love.keyboard.isDown('s') then
       
        self.direction = "down"
    elseif love.keyboard.isDown('a') then
       
        self.direction = "left"
    elseif love.keyboard.isDown('d') then
       
        self.direction = "right"
    else
        -- If no key is pressed, set the direction to nil so the character stops moving
        self.direction = nil
    end

    -- Call the parent class update method to handle movement and animation
    Character.update(self, dt, self.direction)

   
end

return Player
