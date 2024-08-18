-- Require necessary modules
local Player = require "Player"
local SceneManager = require "SceneManager"
local NPC = require "NPC"

-- Global variable to hold the SceneManager instance
local sceneManager

-- Initialize the SceneManager and other resources
function love.load()
    -- Create a SceneManager instance with a starting scene
    sceneManager = SceneManager:new("scene1")  -- Assuming "scene1" is the starting scene

    -- Load the initial scene
    sceneManager:load()
end

-- Update the current scene and check for input
function love.update(dt)
    -- Update the current scene
    sceneManager:update(dt)

    -- Example: Switch to another scene when the spacebar is pressed
    -- This part is for manual testing; adjust or remove as needed
    if love.keyboard.isDown("space") then
        -- Example transition to "scene3"
        sceneManager:setScene("scene3")  -- Change to the desired scene
    end
end

-- Draw the current scene
function love.draw()
    sceneManager:draw()
end
