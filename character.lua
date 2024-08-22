local Character = {}
Character.__index = Character

local Projectile = require "Projectile"

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
        ["defaultSidewaysDirection"] = "right"
    }
}

local characterImages = {}

for spriteName, _ in pairs(possibleSprites) do
    characterImages[spriteName] = {
        ["up"] = loadImages("characters/" .. spriteName .. "/up", 11, 21),
        ["down"] = loadImages("characters/" .. spriteName .. "/down", 0, 10),
        ["sideways"] = loadImages("characters/" .. spriteName .. "/sideways", 22, 32)
    }
end

function Character:new(x, y, characterSprite, speed, scale)
    local self = setmetatable({}, Character)
    self.characterSprite = characterSprite
    self.x = x
    self.y = y
    self.speed = speed or 200
    self.direction = 'down'
    self.frame = 1
    self.images = characterImages[self.characterSprite][self.direction]

    local defaultDirection = possibleSprites[self.characterSprite]["defaultSidewaysDirection"]
    self.flip = (defaultDirection == "left") and -1 or 1

    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    
    return self
end

function Character:setDirection(direction)
    -- This method will set the direction and update the sprite images accordingly.
    self.direction = direction

    if direction == "up" then
        self.flip = 1
    elseif direction == "down" then
        self.flip = 1
    elseif direction == "left" then
        self.flip = -1
        self.direction = "sideways"
    elseif direction == "right" then
        self.flip = 1
        self.direction = "sideways"
    end

    self.images = characterImages[self.characterSprite][self.direction]
end

function Character:move(dt, direction)
    local isMoving = false

    if direction == 'up' then
        self.y = self.y - self.speed * dt
        self:setDirection("up")
        isMoving = true
    elseif direction == 'down' then
        self.y = self.y + self.speed * dt
        self:setDirection("down")
        isMoving = true
    elseif direction == 'left' then
        self.x = self.x - self.speed * dt
        self:setDirection("left")
        isMoving = true
    elseif direction == 'right' then
        self.x = self.x + self.speed * dt
        self:setDirection("right")
        isMoving = true
    end

    return isMoving
end

function Character:update(dt, direction)
    -- Call the move method
    local isMoving = self:move(dt, direction)

    

  
    -- Animate frames when moving
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

function Character:draw()
    local img = self.images[self.frame]
    if img then
        love.graphics.draw(img, self.x, self.y, 0, self.flip * self.scale, self.scale, img:getWidth() / 2, img:getHeight() / 2)
    else
        print("Error: img is nil for frame " .. tostring(self.frame))
    end

    
end
--

return Character
