-- SceneManager.lua
local json = require("dkjson")
local sti = require('libraries/sti')
local Player = require "Player"
local NPC = require "NPC"
local GUIService = require "GUIService"
local love = require "love"

local SceneManager = {}
SceneManager.__index = SceneManager

local instance

-- Singleton pattern
function SceneManager:getInstance()
    if not instance then
        instance = setmetatable({}, SceneManager)
        instance.currentScene = nil
        instance.scenes = {} -- Initialize scenes
        instance.guiScenes = {} -- Initialize GUI scenes
    end
    return instance
end

function SceneManager:new(initialScene)
    local self = self:getInstance()
    self.currentScene = initialScene
    self:loadScenes()
    return self
end

-- Load scenes from JSON files
function SceneManager:loadScenes()
    -- Load game scenes
    self:loadSceneDirectory("scenes/game", self.scenes, "createGameScene")

    -- Load GUI scenes
    self:loadSceneDirectory("scenes/gui", self.guiScenes, "createGUIScene")
end

-- Load scenes from a directory
function SceneManager:loadSceneDirectory(directory, sceneTable, createSceneFunction)
    for _, filename in ipairs(love.filesystem.getDirectoryItems(directory)) do
        local filePath = directory .. "/" .. filename
        local fileData = love.filesystem.read(filePath)
        local sceneData = json.decode(fileData)
        if sceneData then
            local sceneName = filename:match("^(.*)%.json$")
            if sceneName then
                sceneTable[sceneName] = self[createSceneFunction](self, sceneData)
            end
        end
    end
end

-- Create a game scene from JSON data
function SceneManager:createGameScene(data)
    local gameMap
    local player
    local npcs = {}

    local function load()
        if data.tilemap then
            gameMap = sti(data.tilemap)
        end
        if data.playerStart then
            player = Player:new(data.playerStart[1], data.playerStart[2], "man", 200, 2)
        end
        if data.npcs then
            for _, npcData in ipairs(data.npcs) do
                local npc = NPC:new(npcData.x, npcData.y, npcData.type, npcData.speed, npcData.scale)
                npc:setBehavior("follow", player)
                table.insert(npcs, npc)
            end
        end
    end

    local function update(dt)
        if player then
            player:update(dt)
        end
        for _, npc in ipairs(npcs) do
            npc:update(dt)
        end
    end

    local function draw()
        if gameMap then
            gameMap:draw()
        end
        if player then
            player:draw()
        end
        for _, npc in ipairs(npcs) do
            npc:draw()
        end
    end

    return {
        load = load,
        update = update,
        draw = draw
    }
end

-- Create a GUI scene from JSON data
function SceneManager:createGUIScene(data)
    local guiElements = {}
    local backgroundColor = data.backgroundColor or {1, 1, 1}

    local function load()
        for _, element in ipairs(data.guiElements) do
            table.insert(guiElements, element)
        end
    end

    local function update(dt)
        -- GUI scenes typically don’t need update logic but can be added if necessary
    end

    local function draw()
        love.graphics.clear(backgroundColor)
        for _, element in ipairs(guiElements) do
            if element.type == "button" then
                GUIService:drawButton(element.x, element.y, element.width, element.height, element.text, element.elementColor, element.fontColor)
            end

            if element.type == "label" then
                GUIService:drawLabel(element.x, element.y, element.text, element.fontSize, element.fontColor, element.alignment)
            end
        end
    end

    local function mousepressed(x, y, button)
        if button == 1 then  -- Left mouse button
            GUIService:handleMousePressed(guiElements, function(element)
                if element.action then
                    self:performAction(element.action)
                end
            end)
        end
    end

    load()

    return {
        update = update,
        draw = draw,
        mousepressed = mousepressed
    }
end

-- Perform actions based on the element's action
function SceneManager:performAction(action)
    if action == "goToZone1" then
        self:setScene("zone1")
    end
end

-- Set the current scene
function SceneManager:setScene(name)
    self.currentScene = name
    local scene = self.scenes[name] or self.guiScenes[name]
    if scene and scene.load then
        scene.load()
    end
end

-- Update the current scene
function SceneManager:update(dt)
    local scene = self.scenes[self.currentScene] or self.guiScenes[self.currentScene]
    if scene and scene.update then
        scene.update(dt)
    end
end

-- Draw the current scene
function SceneManager:draw()
    local scene = self.scenes[self.currentScene] or self.guiScenes[self.currentScene]
    if scene and scene.draw then
        scene.draw()
    end
end

-- Handle mouse input
function SceneManager:mousepressed(x, y, button)
    local scene = self.scenes[self.currentScene] or self.guiScenes[self.currentScene]
    if scene and scene.mousepressed then
        scene.mousepressed(x, y, button)
    end
end

return SceneManager
