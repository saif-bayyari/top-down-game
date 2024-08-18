-- SceneManager.lua
local json = require("dkjson")
local sti = require('libraries/sti')
local SceneObjects = require "SceneObjects"  -- Load SceneObjects module

local SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager:new(initialScene)
    local self = setmetatable({}, SceneManager)
    self.currentScene = initialScene
    return self
end

function SceneManager:load()
    local scene = SceneObjects[self.currentScene]
    if scene and scene.load then
        scene:load()
    end
end

function SceneManager:update(dt)
    local scene = SceneObjects[self.currentScene]
    if scene and scene.update then
        scene:update(dt)
    end
end

function SceneManager:draw()
    local scene = SceneObjects[self.currentScene]
    if scene and scene.draw then
        scene:draw()
    end
end

return SceneManager