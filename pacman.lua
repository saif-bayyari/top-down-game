local Character = require "Character"  -- Assuming your Character class is saved in a file called Character.lua
local Pacman = {}
Pacman.__index = Pacman
setmetatable(Pacman, { __index = Character })  -- Inherit from Character class

function Pacman:new(x, y, speed, scale)
    local self = Character.new(self, x, y, "pacman", speed, scale)  -- Call the Character's constructor
    setmetatable(self, Pacman)  -- Set the metatable to Pacman
    
    self.behavior = 'patrol'
    self.direction = "down" --this is why the pacman was freezing before cause we didnt have this
    
    return self
end

function Pacman:update(dt)

   

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
        

    elseif self.behavior == 'follow' and self.target then
        -- Following logic with bouncing
        self.self.dx = self.target.x - self.x
        self.dy = self.target.y - self.y
        local distance = math.sqrt(self.dx * self.dx + self.dy * self.dy)

        if distance > 0 then
            local moveX = (self.dx / distance) * self.speed * dt
            local moveY = (self.dy / distance) * self.speed * dt

            -- Update position
            self.x = self.x + moveX
            self.y = self.y + moveY

            -- Determine direction based on movement
            if math.abs(self.dx) > math.abs(self.dy) then
                self.direction = (moveX > 0) and 'right' or 'left'
            else
                self.direction = (moveY > 0) and 'down' or 'up'
            end

            -- Set flip based on direction
            self.flip = (self.direction == 'left') and -1 or 1
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

       
    end

    

    Character.update(self, dt)
    
end

function Pacman:setBehavior(behavior, target)
    self.behavior = behavior
    if behavior == 'follow' then
        self.target = target
    else
        self.target = nil
    end
end



return Pacman
