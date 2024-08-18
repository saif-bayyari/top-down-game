GuiService = {}
GuiService.__index = GuiService

-- Constructor
function GuiService:new()
    local instance = setmetatable({}, GuiService)
    -- Initialize any properties you want for your class here
    instance.elements = {} -- Example: A table to hold GUI elements
    return instance
end
-- Method to add a GUI element
function GuiService:addElement(element)
    table.insert(self.elements, element)
end

-- Method to remove a GUI element
function GuiService:removeElement(element)
    for i, e in ipairs(self.elements) do
        if e == element then
            table.remove(self.elements, i)
            break
        end
    end
end

-- Method to update all GUI elements
function GuiService:update(dt)
    for _, element in ipairs(self.elements) do
        if element.update then
            element:update(dt)
        end
    end
end

-- Method to draw all GUI elements
function GuiService:draw()
    for _, element in ipairs(self.elements) do
        if element.draw then
            element:draw()
        end
    end
end

return GuiService