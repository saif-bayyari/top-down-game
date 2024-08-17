-- Define the Scene class
local Player = require "Player"
local NPC = require("NPC")
local sti = require 'libraries/sti'

-- Function to load images
local function loadImages(folder, startFrame, endFrame)
    local images = {}
    for i = startFrame, endFrame do
        local path = string.format("%s/tile%03d.png", folder, i)
        if love.filesystem.getInfo(path) then
            local image = love.graphics.newImage(path)
            table.insert(images, image)
        else
            print("Error: Image not found at path: " .. path)
        end
    end
    return images
end

-- Define image sets
local playerImages = {
    up = loadImages("man/upwards", 11, 21),
    down = loadImages("man/downwards", 0, 10),
    left = loadImages("man/sideways", 22, 32),
    right = loadImages("man/sideways", 22, 32)
}

local pacmanImages = {
    up = loadImages("pacman/down", 0, 0),
    down = loadImages("pacman/down", 0, 0),
    left = loadImages("pacman/down", 0, 0),
    right = loadImages("pacman/down", 0, 0)
}

-- Define SceneObjects with a scene that contains a game map, player, and NPC
local SceneObjects = {
    [1] = (function()
        local myImage
        local arabicFont
        local imageX = 400
        local imageY = 300
        local isHovering = false -- Ensure isHovering is declared

        -- Load function
        local function load()
            myImage = love.graphics.newImage("pacman/down/tile000.png")
            arabicFont = love.graphics.newFont("Mekon-Gradient.ttf", 50)
            love.graphics.setFont(arabicFont)
        end

        -- Update function
        local function update(dt)
            local mouseX, mouseY = love.mouse.getPosition()

            if myImage then
                
                local imageWidth = myImage:getWidth()
                local imageHeight = myImage:getHeight()

                local left = imageX
                local top = imageY
                local right = imageX + imageWidth
                local bottom = imageY + imageHeight

                if mouseX >= left and mouseX <= right and mouseY >= top and mouseY <= bottom then
                    isHovering = true
                    
                else
                    isHovering = false
                    
                end
            end
        end

        -- Draw function
        local function draw()
            if arabicFont and myImage then
                love.graphics.clear(0.2, 0.2, 0.2)
                love.graphics.setColor(1, 0, 0)
                love.graphics.print("ViBe ChEck!", 100, 100)
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(myImage, imageX, imageY, 0, 2.5, 2.5) -- Replace None with 0
                if isHovering then
                    love.graphics.print("hello", 200, 200)
                end
            end
        end

        return {
            load = load,
            update = update,
            draw = draw
        }
    end)(),

    [2] = (function()
        local gameMap
        local npc
        local player

        -- Load function
        local function load()
            love.graphics.setDefaultFilter('nearest', 'nearest')
            player = Player:new(400, 300, playerImages, 200, 2)
            npc = NPC:new(100, 100, pacmanImages, 1000, 0.5)
            npc:setBehavior('follow', player)
            gameMap = sti('maps/testMap.lua')
        end

        -- Update function
        local function update(dt)
            if gameMap then
                gameMap:update(dt)
            end

            player:update(dt)
            npc:update(dt)

            if love.keyboard.isDown("lshift") then
                npc:setBehavior("patrol")
            elseif love.keyboard.isDown("rshift") then
                npc:setBehavior("follow", player)
            end

            -- Handle player boundaries
            if player.x >= 790 then
                player.x = 790
            elseif player.x <= 10 then
                player.x = 10
            end

            if player.y >= 590 then
                player.y = 590
            elseif player.y <= 10 then
                player.y = 10
            end
        end

        -- Draw function
        local function draw()
            love.graphics.setColor(1, 1, 1)
            if gameMap then
                gameMap:draw()
            end

            player:draw()
            npc:draw()
        end

        return {
            load = load,
            update = update,
            draw = draw
        }
    end)()
}

-- Define SceneManager class
local SceneManager = {}
SceneManager.__index = SceneManager

-- Constructor
function SceneManager:new(name, objectList)
    local self = setmetatable({}, SceneManager)
    self.name = name or "Default Scene"
    self.currentScene = 1
    return self
end

-- Method to load the current scene
function SceneManager:load()
    local scene = SceneObjects[self.currentScene]
    if scene and scene.load then
        scene.load()
    end
end

-- Method to update the current scene
function SceneManager:update(dt)
    local scene = SceneObjects[self.currentScene]
    if scene and scene.update then
        scene.update(dt)
    end
end

-- Method to draw the current scene
function SceneManager:draw()
    local scene = SceneObjects[self.currentScene]
    if scene and scene.draw then
        scene.draw()
    end
end

return SceneManager
