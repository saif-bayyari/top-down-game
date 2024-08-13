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
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return Projectile
