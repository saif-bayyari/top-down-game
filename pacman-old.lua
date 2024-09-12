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

local possiblePacMans = {
    ["pacman"] = {
        ["defaultSidewaysDirection"] = "left" -- or "right"
    }
}

-- Table to store PacMan images
local pacManImages = {}

for pacManName, _ in pairs(possiblePacMans) do
    -- Create a table for the current PacMan type
    pacManImages[pacManName] = {
        ["up"] = loadImages("sprites/"..pacManName .. "/down", 0, 0),
        ["down"] = loadImages("sprites/"..pacManName .. "/down", 0, 0),
        ["left"] = loadImages("sprites/"..pacManName .. "/down", 0, 0),
        ["right"] = loadImages("sprites/"..pacManName .. "/down", 0, 0),
    }
end

local PacMan = {}
PacMan.__index = PacMan

function PacMan:new(x, y, sprite, speed, scale)
    local self = setmetatable({}, PacMan)
    self.x = x
    self.y = y
    self.sprite = sprite
    self.speed = speed or 100
    self.direction = 'down'
    self.frame = 1
    self.images = pacManImages[sprite][self.direction] -- Start with the downwards images
    self.flip = 1
    self.scale = scale or 2
    self.timeElapsed = 0
    self.frameDuration = 0.1
    self.behavior = 'patrol'  -- Default behavior
    self.target = nil  -- Target to follow, if any
    return self
end

function PacMan:update(dt)
    local isMoving = false

    if self.behavior == 'patrol' then
        -- Patrol logic with bouncing back
        if self.direction == 'down' then
            self.y = self.y + self.speed * dt
            if self.y > 550 then  -- Example boundary
                self.y = 550  -- Fix the position at the boundary
                self.direction = 'up'
            end
        elseif self.direction == 'up' then
            self.y = self.y - self.speed * dt
            if self.y < 10 then  -- Example boundary
                self.y = 10  -- Fix the position at the boundary
                self.direction = 'down'
            end
        end
        self.images = pacManImages[self.sprite][self.direction]
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

        if distance <= 6 then
            self.behavior = "killed_player"
        end

        -- Horizontal boundary check
        if self.x < 10 then
            self.x = 10  -- Fix the position at the boundary
            self.direction = 'right'
        elseif self.x > 790 then
            self.x = 790  -- Fix the position at the boundary
            self.direction = 'left'
        end

        -- Vertical boundary check
        if self.y < 10 then
            self.y = 10  -- Fix the position at the boundary
            self.direction = 'down'
        elseif self.y > 550 then
            self.y = 550  -- Fix the position at the boundary
            self.direction = 'up'
        end

        self.images = pacManImages[self.sprite][self.direction]
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

function PacMan:draw()
    local img = self.images[self.frame]
    if img then
        love.graphics.draw(img, self.x, self.y, 0, self.flip * self.scale, self.scale, img:getWidth() / 2, img:getHeight() / 2)
    else
        print("Error: img is nil for frame " .. tostring(self.frame))
    end
end

-- Method to set the PacMan's behavior (e.g., 'patrol', 'follow')
function PacMan:setBehavior(behavior, target)
    self.behavior = behavior
    if behavior == 'follow' then
        self.target = target
    else
        self.target = nil
    end
end

return PacMan
