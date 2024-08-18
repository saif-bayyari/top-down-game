-- GUIService.lua
local GUIService = {}

-- Function to draw a button
function GUIService:drawButton(x, y, width, height, text, elementColor, fontColor)
    love.graphics.setColor(elementColor or {0.2, 0.2, 0.2})
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(fontColor or {1, 1, 1})
    love.graphics.printf(text, x, y + 10, width, "center")
end

-- Function to draw a label
function GUIService:drawLabel(x, y, text, fontColor)
    love.graphics.setColor(fontColor or {1, 1, 1})
    love.graphics.printf(text, x, y, love.graphics.getWidth(), "center")
end

-- Function to check if the mouse is over a GUI element
function GUIService:isMouseOver(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
end

-- Function to handle button clicks
function GUIService:handleMousePressed(guiElements, actionCallback)
    local mouseX, mouseY = love.mouse.getPosition()
    for _, element in ipairs(guiElements) do
        if element.type == "button" and self:isMouseOver(element.x, element.y, element.width, element.height) then
            if love.mouse.isDown(1) then  -- Left mouse button
                if actionCallback then
                    actionCallback(element)
                end
            end
        end
    end
end

return GUIService
