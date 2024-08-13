local Player = require "Player"

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Load images for each direction and ensure they are correctly indexed
    local playerImages = {
        up = loadImages("man/upwards", 11, 21),
        down = loadImages("man/downwards", 0, 10),
        left = loadImages("man/sideways", 22, 32),
        right = loadImages("man/sideways", 22, 32)
    }

    -- Create the player object using the Player class
    player = Player:new(400, 300, playerImages, 200, 2)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end

function loadImages(folder, startFrame, endFrame)
    local images = {}
    local greenThreshold = 50 -- Threshold for green color detection

    for i = startFrame, endFrame do
        local path = string.format("%s/tile%03d.png", folder, i)
        if love.filesystem.getInfo(path) then
            local imageData = love.image.newImageData(path)
            imageData:mapPixel(function(x, y, r, g, b, a)
                -- Check if the pixel is green based on the threshold
                if g > r + greenThreshold and g > b + greenThreshold then
                    return r, g, b, 0 -- Make green pixels transparent
                else
                    return r, g, b, a
                end
            end)
            table.insert(images, love.graphics.newImage(imageData))
        else
            print("Error: Image not found at path: " .. path)
        end
    end

    return images
end
