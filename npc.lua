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

local possibleNPCS = {
    ["pacman"] = {
        ["defaultSidewaysDirection"] = "left" -- or "right"
    }
}

-- Table to store NPC images
local npcImages = {}

for npcName, _ in pairs(possibleNPCS) do
    -- Create a table for the current NPC type
    npcImages[npcName] = {
        ["up"] = loadImages("characters/"..npcName .. "/up", 0, 0),
        ["down"] = loadImages("characters/"..npcName .. "/down", 0, 0),
        ["left"] = loadImages("characters/"..npcName .. "/left", 0, 0),
        ["right"] = loadImages("characters/"..npcName .. "/right", 0, 0),
    }
end

local NPC = {}
NPC.__index = NPC

function NPC:new(x, y, sprite, speed, scale)
    local self = setmetatable({}, NPC)
    self.x = x
    self.y = y
    self.sprite = sprite
    self.speed = speed or 100
    self.direction = 'down'
    self.frame = 1
    self.images = npcImages[sprite][self.direction] -- Start with the downwards images
    self.flip = 1
    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    self.behavior = 'patrol'  -- Default behavior
    self.target = nil  -- Target to follow, if any
    return self
end

function NPC:update(dt)
    local isMoving = false

    if self.behavior == 'patrol' then
        -- Patrol logic with bouncing back
        if self.direction == 'down' then
            self.y = self.y + self.speed * dt
            if self.y > 550 then  -- Example boundary
                self.direction = 'up'
            end
        elseif self.direction == 'up' then
            self.y = self.y - self.speed * dt
            if self.y < 10 then  -- Example boundary
                self.direction = 'down'
            end
        end
        self.images = npcImages[self.sprite][self.direction]
        isMoving = true

    elseif self.behavior == 'follow' and self.target then
        -- Following logic with bouncing
        local dx = self.target.x - self.x
        local dy = self.target.y - self.y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance > 0 then
            local moveX = (dx / distance) * self.speed * dt
            local moveY = (dy / distance) * self.speed * dt

            -- Update position
            self.x = self.x + moveX
            self.y = self.y + moveY

            -- Determine direction based on movement
            if math.abs(dx) > math.abs(dy) then
                self.direction = (moveX > 0) and 'right' or 'left'
            else
                self.direction = (moveY > 0) and 'down' or 'up'
            end

            -- Set flip based on direction
            self.flip = (self.direction == 'left') and -1 or 1
        end

        -- Check bounds and reverse direction if necessary
        if self.x < 10 or self.x > 790 then  -- Example horizontal boundaries
            self.direction = (self.direction == 'right') and 'left' or 'right'
        end

        if self.y < 10 or self.y > 550 then  -- Example vertical boundaries
            self.direction = (self.direction == 'down') and 'up' or 'down'
        end

        self.images = npcImages[self.sprite][self.direction]
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
