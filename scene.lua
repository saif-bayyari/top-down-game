-- Define the Scene class
local Scene = {}
Scene.__index = Scene

-- Constructor
function Scene:new(name, objectList)
    local self = setmetatable({}, Scene)
    self.name = name or "Unnamed Scene"
    self.objects = objectList or {}  -- A table to store objects in the scene
    return self
end

-- Method to add an object to the scene
function Scene:addObject(object)
    table.insert(self.objects, object)
end

-- Method to remove an object from the scene
function Scene:removeObject(object)
    for i, obj in ipairs(self.objects) do
        if obj == object then
            table.remove(self.objects, i)
            break
        end
    end
end

-- Method to update the scene
function Scene:update(dt)
    for _, object in ipairs(self.objects) do
        if object.update then
            object:update(dt)
        end
    end
end

-- Method to draw the scene
function Scene:draw()
    for _, object in ipairs(self.objects) do
        if object.draw then
            object:draw()
        end
    end
end

-- Method to clear all objects in the scene permanently
function Scene:clearObjects()
    self.objects = {}
end

-- Method to set the scene's name
function Scene:setName(name)
    self.name = name
end

-- Method to get the scene's name
function Scene:getName()
    return self.name
end

return Scene
