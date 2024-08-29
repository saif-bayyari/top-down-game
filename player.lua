local Character = require "Character"  -- Assuming your Character class is saved in a file called Character.lua
local Player = {}
Player.__index = Player
setmetatable(Player, { __index = Character })  -- Inherit from Character class

function Player:new(x, y, speed, scale)
    local self = Character.new(self, x, y, "man", speed, scale)  -- Call the Character's constructor
    setmetatable(self, Player)  -- Set the metatable to Player
    self.health = 100
    self.isAlive = true  -- Track if the player is alive
    return self
end

function Player:update(dt)
    if not self.isAlive then return end  -- Don't update if the player is dead

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
        self.direction = nil  -- Stop moving if no key is pressed
    end

    -- Call the parent class update method to handle movement and animation
    Character.update(self, dt, self.direction)

    -- Check for death
    if self.health <= 0 then
        self:die()
    end
end

function Player:die()
    self.isAlive = false
    print("Player has died")
    self = nil
    -- You can add more logic here to remove the player from the game objects list
    -- or trigger any death animations, sound effects, etc.
end

return Player
