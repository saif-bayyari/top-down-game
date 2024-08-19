-- main.lua
local SceneManager = require("SceneManager")
local json = require("dkjson")

-- Create a global instance of SceneManager
local sceneManager

function love.load()
    -- Initialize SceneManager and load scenes
    sceneManager = SceneManager:getInstance()
    sceneManager:new("main-menu") -- Set the initial scene to "main-menu" or your desired starting scene
end

function love.update(dt)
    if sceneManager then
        sceneManager:update(dt)
    end
end

function love.draw()
    if sceneManager then
        sceneManager:draw()
    end
end

function love.mousepressed(x, y, button)
    if sceneManager then
        sceneManager:mousepressed(x, y, button)
    end
end
