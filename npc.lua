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

function NPC:new(x, y, npc, speed, scale)
    local self = setmetatable({}, NPC)
    self.x = x
    self.y = y
    self.npc = npc
    self.speed = speed or 100
    self.direction = 'down'
    self.frame = 1
    self.images = npcImages[self.npc][self.direction] -- Start with the downwards images
    
    -- Set flip value based on defaultSidewaysDirection
    local defaultDirection = possibleNPCS[self.npc]["defaultSidewaysDirection"]
    self.flip = (defaultDirection == "left") and -1 or 1
    
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
        self.images = npcImages[self.npc][self.direction]
        self.flip = possibleNPCS[self.npc]["defaultSidewaysDirection"] == "left" and -1 or 1
        isMoving = true

    elseif self.behavior == 'follow' and self.target then
        -- Example following logic (follows the player)
        if self.x < self.target.x then
            self.x = self.x + self.speed * dt
            self.direction = 'right'
            self.flip = 1  -- Face right
        elseif self.x > self.target.x then
            self.x = self.x - self.speed * dt
            self.direction = 'left'
            self.flip = -1  -- Face left
        end

        if self.y < self.target.y then
            self.y = self.y + self.speed * dt
            self.direction = 'down'
        elseif self.y > self.target.y then
            self.y = self.y - self.speed * dt
            self.direction = 'up'
        end

        self.images = npcImages[self.npc][self.direction]
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
