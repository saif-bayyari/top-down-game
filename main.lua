local GameContainer = require "game_container"

local width, height = love.graphics.getDimensions()

local GameContainer1 = GameContainer:new(width - 20, height - 20, 10, 10)

local console = {} -- Table to store console messages

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- Load images for each direction and remove green shades
    playerImages = {
        up = loadImages("man/upwards", 11, 21),
        down = loadImages("man/downwards", 0, 10),
        left = loadImages("man/sideways", 22, 32),
        right = loadImages("man/sideways", 22, 32)
    }
    
    player = {
        x = 400,
        y = 300,
        speed = 200,
        direction = 'down',
        frame = 1,
        images = playerImages['down'],
        flip = 1,
        scale = 2 -- New scale variable
    }
    
    frameDuration = 0.1
    timeElapsed = 0
end

function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown('w') then
        player.y = player.y - player.speed * dt
        player.direction = 'up'
        player.images = playerImages['up']
        player.flip = 1
        isMoving = true
    elseif love.keyboard.isDown('s') then
        player.y = player.y + player.speed * dt
        player.direction = 'down'
        player.images = playerImages['down']
        player.flip = 1
        isMoving = true
    end

    if love.keyboard.isDown('a') then
        player.x = player.x - player.speed * dt
        player.direction = 'left'
        player.images = playerImages['left']
        player.flip = -1
        isMoving = true
    elseif love.keyboard.isDown('d') then
        player.x = player.x + player.speed * dt
        player.direction = 'right'
        player.images = playerImages['right']
        player.flip = 1
        isMoving = true
    end

    -- Check and stop the player from moving outside the game container bounds

    if player.x < GameContainer1.x then
        player.x = GameContainer1.x
    elseif player.x > (GameContainer1.x + GameContainer1.width) then
        player.x = GameContainer1.x + GameContainer1.width
    end

    if player.y < GameContainer1.y then
        player.y = GameContainer1.y
    elseif player.y > (GameContainer1.y + GameContainer1.height) then
        player.y = GameContainer1.y + GameContainer1.height
    end

    if isMoving then
        timeElapsed = timeElapsed + dt
        if timeElapsed >= frameDuration then
            player.frame = player.frame + 1
            if player.frame > #player.images then
                player.frame = 1
            end
            timeElapsed = timeElapsed - frameDuration
        end
    else
        player.frame = 1
    end

    GameContainer1:printDetails()
    logToConsole("Player position: (" .. player.x .. ", " .. player.y .. ")")
end

function love.draw()
    love.graphics.setBlendMode("alpha")
    local img = player.images[player.frame]
    love.graphics.draw(img, player.x, player.y, 0, player.flip * player.scale, player.scale, img:getWidth() / 2, img:getHeight() / 2)
    
    drawConsole()
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
        end
    end

    return images
end

function logToConsole(message)
    table.insert(console, message)
    if #console > 10 then -- Keep the console log at a reasonable length
        table.remove(console, 1)
    end
end

function drawConsole()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 150)
    love.graphics.setColor(1, 1, 1)
    for i, message in ipairs(console) do
        love.graphics.print(message, 10, 10 + (i - 1) * 15)
    end
end
