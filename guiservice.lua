-- GUIService.lua
local GUIService = {}

-- Draw a button with specified parameters
function GUIService:drawButton(x, y, width, height, text, elementColor, fontColor)
    love.graphics.setColor(elementColor)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(fontColor)
    love.graphics.print(text, x + (width / 2) - (love.graphics.getFont():getWidth(text) / 2), y + (height / 2) - (love.graphics.getFont():getHeight(text) / 2))
end


function GUIService:drawLabel(x, y, text, fontSize, fontColor, alignment)
    -- Set the font size
    local myFont = love.graphics.newFont("fonts/Mekon-Gradient.ttf", fontSize)
    love.graphics.setFont(myFont)
    
    -- Set the font color
    love.graphics.setColor(fontColor)
    
    -- Default alignment if none is provided
    alignment = alignment or 'left'
    
    -- Calculate the width and height of the text
    local textWidth = myFont:getWidth(text)
    local textHeight = myFont:getHeight()
    
    -- Adjust x based on alignment
    if alignment == 'center' then
        x = x - textWidth / 2
    elseif alignment == 'right' then
        x = x - textWidth
    end
    
    -- Draw the text
    love.graphics.print(text, x, y)
    
    -- Optionally, you can draw a rectangle around the label to visualize its bounds
    -- Uncomment the following line if you want to see the label's boundary
    -- love.graphics.rectangle('line', x, y, textWidth, textHeight)
end

function GUIService:drawImage(path,x, y, scale)
    -- Load the image from the specified path
    local image = love.graphics.newImage(path)
    
    -- Set the image scale
    local originalFilter = love.graphics.getDefaultFilter()
    love.graphics.setDefaultFilter("nearest", "nearest")  -- Optional: Adjust the filter as needed
    
    -- Draw the image at the specified position with the specified scale
    love.graphics.draw(image, x, y, 0, scale, scale)
    
    -- Reset the filter to its original setting
    love.graphics.setDefaultFilter(originalFilter)
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
