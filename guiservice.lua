-- GUIService.lua
local GUIService = {}

-- Draw a button with specified parameters
function GUIService:drawButton(x, y, width, height, text, elementColor, fontColor)
    love.graphics.setColor(elementColor)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(fontColor)
    love.graphics.print(text, x + (width / 2) - (love.graphics.getFont():getWidth(text) / 2), y + (height / 2) - (love.graphics.getFont():getHeight(text) / 2))
end

-- Handle mouse press events
function GUIService:handleMousePressed(elements, actionCallback)
    for _, element in ipairs(elements) do
        if element.type == "button" then
            local mx, my = love.mouse.getPosition()
            if mx >= element.x and mx <= element.x + element.width and my >= element.y and my <= element.y + element.height then
                actionCallback(element)
            end
        end
    end
end

return GUIService
