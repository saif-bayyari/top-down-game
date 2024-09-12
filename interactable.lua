-- Define the Interactable class
Interactable = {}
Interactable.__index = Interactable

-- Static table (class-level dictionary of interaction functions)
Interactable.funcDict = {
    ["convo_object"] = function(interactable, player)
        print("Default interaction executed!")
    end,

    ["greet"] = function()
        print("Hello! You interacted with the object.")
    end,

    ["open"] = function()
        print("Opening the object...")
    end,

    ["close"] = function()
        print("Closing the object...")
    end
}

-- Constructor for the Interactable class
function Interactable:new(x, y, width, height, interactionName)
    local obj = {
        x = x or 0,             -- X position
        y = y or 0,             -- Y position
        width = width or 50,    -- Width of the object
        height = height or 50,  -- Height of the object
        isInteracted = false,   -- Boolean to track interaction state
        interactionName = interactionName or "default" -- Function name to call from the dictionary
    }
    setmetatable(obj, Interactable)
    return obj
end

-- Method to check if the object is hovered by the mouse
function Interactable:isHovered(mouseX, mouseY)
    return mouseX >= self.x and mouseX <= (self.x + self.width) and
           mouseY >= self.y and mouseY <= (self.y + self.height)
end

-- Method to trigger interaction by calling a function from the dictionary
function Interactable:interact()
    if not self.isInteracted then
        local interactionFunction = Interactable.funcDict[self.interactionName]
        
        if interactionFunction then
            interactionFunction()  -- Call the function from the dictionary
            self.isInteracted = true
        else
            print("Interaction function not found!")
        end
    else
        print("Object already interacted with!")
    end
end

-- Method to draw the object
function Interactable:draw()
    if self.isInteracted then
        love.graphics.setColor(0, 1, 0)  -- Green when interacted
    else
        love.graphics.setColor(1, 1, 1)  -- White before interaction
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

-- Method to handle interaction on mouse click
function Interactable:update(mouseX, mouseY, mouseClicked)
    if self:isHovered(mouseX, mouseY) and mouseClicked then
        self:interact()
    end
end
