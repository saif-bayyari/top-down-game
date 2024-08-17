

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

local images = {
    up = loadImages("pacman/down", 0, 0),
    down = loadImages("pacman/down", 0, 0),
    left = loadImages("pacman/down", 0, 0),
    right = loadImages("pacman/down", 0, 0)
}


local NPC = {}
NPC.__index = NPC

function NPC:new(x, y,  speed, scale)
    local self = setmetatable({}, NPC)
    self.x = x
    self.y = y
    self.speed = speed or 100
    self.direction = 'down'
    self.frame = 1
    self.images = images['down'] -- Start with the downwards images
    self.flip = 1
    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    self.imageSet = images
    self.behavior = 'patrol'  -- Default behavior
    self.target = nil  -- Target to follow, if any
    return self
end

function NPC:update(dt)
    local isMoving = false

    if self.behavior == 'patrol' then
        -- Example patrol logic (moves up and down)
        if self.direction == 'down' then
            self.y = self.y + self.speed * dt
            if self.y > 400 then  -- Example boundary
                self.direction = 'up'
            end
        elseif self.direction == 'up' then
            self.y = self.y - self.speed * dt
            if self.y < 100 then  -- Example boundary
                self.direction = 'down'
            end
        end
        self.images = self.imageSet[self.direction]
        isMoving = true

    elseif self.behavior == 'follow' and self.target then
        -- Example following logic (follows the player)
        if self.x < self.target.x then
            self.x = self.x + self.speed * dt
            self.direction = 'right'
        elseif self.x > self.target.x then
            self.x = self.x - self.speed * dt
            self.direction = 'left'
        end

        if self.y < self.target.y then
            self.y = self.y + self.speed * dt
            self.direction = 'down'
        elseif self.y > self.target.y then
            self.y = self.y - self.speed * dt
            self.direction = 'up'
        end

        self.images = self.imageSet[self.direction]
        isMoving = true
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

function NPC:draw()
    local img = self.images[self.frame]
    if img then
        love.graphics.draw(img, self.x, self.y, 0, self.flip * self.scale, self.scale, img:getWidth() / 2, img:getHeight() / 2)
    else
        print("Error: img is nil for frame " .. tostring(self.frame))
    end
end

-- Method to set the NPC's behavior (e.g., 'patrol', 'follow')
function NPC:setBehavior(behavior, target)
    self.behavior = behavior
    if behavior == 'follow' then
        self.target = target
    else
        self.target = nil
    end
end

return NPC
