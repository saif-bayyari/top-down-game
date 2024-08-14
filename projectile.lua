
--shooting projectiles from the player

local Projectile = {}

Projectile.__index = Projectile

function Projectile:new(x, y, direction, speed, size)
    local self = setmetatable({}, Projectile)
    self.x = x
    self.y = y
    self.direction = direction
    self.speed = speed or 300
    self.size = size or 10
    return self
end

function Projectile:update(dt)
    if self.direction == 'up' then
        self.y = self.y - self.speed * dt
    elseif self.direction == 'down' then
        self.y = self.y + self.speed * dt
    elseif self.direction == 'left' then
        self.x = self.x - self.speed * dt
    elseif self.direction == 'right' then
        self.x = self.x + self.speed * dt
    end
end

function Projectile:draw()
    love.graphics.setColor(1, 0, 0)  -- Set color to red (R, G, B with values between 0 and 1)
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    love.graphics.setColor(1, 1, 1)  -- Reset color to white (default color)
end

return Projectile
