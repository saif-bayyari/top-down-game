local Player = {}
Player.__index = Player
local Projectile = require "Projectile"

-- Function to load images
local function loadImages(folder, startFrame, endFrame)
    local images = {}
    for i = startFrame, endFrame do
        local path = string.format("%s/tile%03d.png", folder, i)
        if love.filesystem.getInfo(path) then
            local image = love.graphics.newImage(path)
            table.insert(images, image)
        else
            print("Error: Image not found at path: " .. path)
        end
    end
    return images
end

local possibleSprites = {
    ["man"] = {
        ["defaultSidewaysDirection"] = "right" -- or "left"
    }
}

-- Table to store Player images
local playerImages = {}

for spriteName, _ in pairs(possibleSprites) do
    -- Create a table for the current player type
    playerImages[spriteName] = {
        ["up"] = loadImages("characters/"..spriteName .. "/up", 11, 21),
        ["down"] = loadImages("characters/"..spriteName .. "/down", 0, 10),
        ["sideways"] = loadImages("characters/"..spriteName .. "/sideways", 22, 32)
    }
end

function Player:new(x, y, playerSprite, speed, scale)
    local self = setmetatable({}, Player)
    self.playerSprite = playerSprite
    self.x = x
    self.y = y
    self.speed = speed or 200
    self.direction = 'down'
    self.frame = 1
    self.images = playerImages[self.playerSprite][self.direction] -- Start with the downwards images

    -- Set flip value based on defaultSidewaysDirection
    local defaultDirection = possibleSprites[self.playerSprite]["defaultSidewaysDirection"]
    self.flip = (defaultDirection == "left") and -1 or 1

    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    self.projectiles = {}
    self.sound = love.audio.newSource("laser.mp3", "static")
    return self
end

function Player:update(dt)
    local isMoving = false

    if love.keyboard.isDown('w') then
        self.y = self.y - self.speed * dt
        self.direction = 'up'
        self.flip = 1
        isMoving = true
    elseif love.keyboard.isDown('s') then
        self.y = self.y + self.speed * dt
        self.direction = 'down'
        self.flip = 1
        isMoving = true
    end

    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
        self.direction = 'sideways'
        self.flip = -1 -- Flip to left
        isMoving = true
    elseif love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
        self.direction = 'sideways'
        self.flip = 1 -- Flip to right
        isMoving = true
    end

    -- Update the images based on the direction
    self.images = playerImages[self.playerSprite][self.direction]

    if love.keyboard.isDown('space') then
        self.sound:play()
        self:shoot()
    end

    -- Update all projectiles
    for _, projectile in ipairs(self.projectiles) do
        projectile:update(dt)
    end

    if isMoving then
        self.timeElapsed = self.timeElapsed + dt
        if self.timeElapsed >= self.frameDuration then
            self.frame = self.frame + 1
            if self.frame > #self.images then
                self.frame = 1
            end
            self.timeElapsed = self.timeElapsed - self.frameDuration
        end
    else
        self.frame = 1
    end
end

function Player:draw()
    local img = self.images[self.frame]
    if img then
        love.graphics.draw(img, self.x, self.y, 0, self.flip * self.scale, self.scale, img:getWidth() / 2, img:getHeight() / 2)
    else
        print("Error: img is nil for frame " .. tostring(self.frame))
    end

    -- Draw all projectiles
    for _, projectile in ipairs(self.projectiles) do
        projectile:draw()
    end
end

function Player:shoot()
    local projectile = Projectile:new(self.x, self.y, self.direction, 1000, 10)
    table.insert(self.projectiles, projectile)
end

return Player
