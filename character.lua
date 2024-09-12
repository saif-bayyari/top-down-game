local Character = {}
Character.__index = Character

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
    },
    ["pacman"] = {
        ["defaultSidewaysDirection"] = "left" -- or "right"
    }
}

local characterImages = {}

for spriteName, _ in pairs(possibleSprites) do
    characterImages[spriteName] = {
        ["up"] = loadImages("sprites/" .. spriteName .. "/up", 11, 21),
        ["down"] = loadImages("sprites/" .. spriteName .. "/down", 0, 10),
        ["sideways"] = loadImages("sprites/" .. spriteName .. "/sideways", 22, 32)
    }
end

function Character:new(x, y, characterSprite, speed, scale, initDirection, initAnimation)
    local self = setmetatable({}, Character)
    self.characterSprite = characterSprite
    self.x = x
    self.y = y
    self.dx = 0
    self.dy = 0
    self.speed = speed or 200
    self.direction = "idle"
    self.animation = "down"
    self.frame = 1
    self.images = characterImages[self.characterSprite][self.animation]
    self.health = 100

    local defaultDirection = possibleSprites[self.characterSprite]["defaultSidewaysDirection"]
    self.flip = (defaultDirection == "left") and -1 or 1

    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    
    return self
end




function Character:update(dt)
    -- Reset dx and dy to 0 at the beginning of each update
    self.dx = 0
    self.dy = 0

    -- Set dx and dy based on direction

    
    if self.direction == "up" then
        self.dy = -self.speed
        self.flip = 1
        self.animation = "up"
    elseif self.direction == "down" then
        self.dy = self.speed
        self.flip = 1
        self.animation = "down"
    elseif self.direction == "left" then
        self.dx = -self.speed
        self.flip = -1
        self.animation = "sideways"
    elseif self.direction == "right" then
        self.dx = self.speed
        self.flip = 1
        self.animation = "sideways"
    elseif self.direction == "idle" then
        self.dx = 0
        self.dy = 0
    end

    self.images = characterImages[self.characterSprite][self.animation]

    -- Factor in dt to ensure consistent movement speed
    if self.dx ~= 0 or self.dy ~= 0 then
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
        self.timeElapsed = self.timeElapsed + dt
        if self.timeElapsed >= self.frameDuration then
            self.frame = self.frame + 1
            if self.frame > #self.images then
                self.frame = 1
            end
            self.timeElapsed = self.timeElapsed - self.frameDuration
        end
    else
        -- Reset frame to 1 if the character is not moving
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
