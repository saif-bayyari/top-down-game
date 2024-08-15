
-- you run the game by double clicking the run.bat executable :)


local Player = require "Player"
local Scene = require "Scene"
local NPC = require("NPC")

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local playerImages = {
        up = loadImages("man/upwards", 11, 21),
        down = loadImages("man/downwards", 0, 10),
        left = loadImages("man/sideways", 22, 32),
        right = loadImages("man/sideways", 22, 32)
    }
    player = Player:new(400, 300, playerImages, 200, 2)
    npc = NPC:new(100, 100, playerImages, 200, 2)
    npc:setBehavior('follow', player)
    scene1 = Scene:new("scene1", {player,npc})
    
end

function love.update(dt)
    scene1:update(dt)
end

function love.draw()
    love.graphics.clear(0.5, 0.7, 0.9, 1) --this is how you change the background color of the main screen
    scene1:draw()
end

function loadImages(folder, startFrame, endFrame)
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
