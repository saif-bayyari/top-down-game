local Player = require "Player"
local Scene = require "Scene"
local NPC = require("NPC")

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')



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
    player = Player:new(400, 300, playerImages, 200, 2)
    npc = NPC:new(100, 100, pacmanImages, 200, 2)
    npc:setBehavior('follow', player)
    scene1 = Scene:new("scene1", {player, npc})
    scene2 = Scene:new("scene2", {})

    game_sequence = {scene1, scene2}
    current_scene = 1 -- Start with scene1
end

function love.update(dt)
    -- Switch to scene2 when spacebar is pressed
    if love.keyboard.isDown("space") then
        current_scene = 2
    end

    -- Update the current scene
    game_sequence[current_scene]:update(dt)
end

function love.draw()
    gameMap:draw() -- This is how you change the background color of the main screen

    -- Draw the current scene
    game_sequence[current_scene]:draw()
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
