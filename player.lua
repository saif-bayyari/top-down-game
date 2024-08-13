local Player = {}
Player.__index = Player
local Projectile = require "Projectile"

function Player:new(x, y, images, speed, scale)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.speed = speed or 200
    self.direction = 'down'
    self.frame = 1
    self.images = images['down'] -- Start with the downwards images
    self.flip = 1
    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    self.imageSet = images
    self.projectiles = {}
    return self
end

function Player:update(dt)
    local isMoving = false

    if love.keyboard.isDown('w') then
        self.y = self.y - self.speed * dt
        self.direction = 'up'
        self.images = self.imageSet['up']
        self.flip = 1
        isMoving = true
    elseif love.keyboard.isDown('s') then
        self.y = self.y + self.speed * dt
        self.direction = 'down'
        self.images = self.imageSet['down']
        self.flip = 1
        isMoving = true
    end

    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
        self.direction = 'left'
        self.images = self.imageSet['left']
        self.flip = -1
        isMoving = true
    elseif love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
        self.direction = 'right'
        self.images = self.imageSet['right']
        self.flip = 1
        isMoving = true
    end

    if love.keyboard.isDown('space') then
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
    local projectile = Projectile:new(self.x, self.y, self.direction, 400, 10)
    table.insert(self.projectiles, projectile)
end

return Player

