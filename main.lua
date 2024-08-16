-- Require necessary modules
local Player = require "Player"
local SceneManager = require "SceneManager"
local NPC = require("NPC")

-- Global variable to hold the SceneManager instance
local sceneManager

-- Initialize the SceneManager and other resources
function love.load()
    -- Create a SceneManager instance with a name
    sceneManager = SceneManager:new("Main Scene")

    -- Load the initial scene
    sceneManager:load()
end

-- Update the current scene and check for input
function love.update(dt)
    -- Update the current scene
    sceneManager:update(dt)

    -- Example: Switch to another scene when the spacebar is pressed
    if love.keyboard.isDown("space") then
        -- Assuming you have a scene with index 2
        sceneManager.currentScene = 2
        sceneManager:load()  -- Load the new scene
    end
end

-- Draw the current scene
function love.draw()
    sceneManager:draw()
end

-- Function to load images from a folder
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
