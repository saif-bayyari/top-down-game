-- Define the Conversation class
Conversation = {}
Conversation.__index = Conversation

-- Constructor for the Conversation class
function Conversation:new(dialogue)
    local obj = {
        dialogue = dialogue or {},   -- List of dialogue strings
        currentLine = 1,             -- Index of the current dialogue line
        isFinished = false           -- Boolean to check if the conversation has ended
    }
    setmetatable(obj, Conversation)
    return obj
end

-- Method to advance to the next line of dialogue
function Conversation:nextLine()
    if self.currentLine < #self.dialogue then
        self.currentLine = self.currentLine + 1
    else
        self.isFinished = true  -- End of conversation
    end
end

-- Method to get the current dialogue line
function Conversation:getCurrentLine()
    return self.dialogue[self.currentLine]
end

-- Method to reset the conversation (optional)
function Conversation:reset()
    self.currentLine = 1
    self.isFinished = false
end

-- Method to draw the current line of dialogue on the screen
function Conversation:draw()
    if not self.isFinished then
        love.graphics.setColor(1, 1, 1)  -- Set text color (white)
        love.graphics.printf(self:getCurrentLine(), 50, love.graphics.getHeight() - 100, love.graphics.getWidth() - 100, "center")
    else
        love.graphics.printf("End of conversation.", 50, love.graphics.getHeight() - 100, love.graphics.getWidth() - 100, "center")
    end
end
