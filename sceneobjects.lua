-- SceneObjects.lua
local dkjson = require "dkjson"
local GUIService = require "GUIService"
local sti = require 'libraries/sti'
local Player = require "Player"
local NPC = require "NPC"
local SceneManager = require "SceneManager"

local SceneObjects = {}
local json = dkjson

-- Utility function to load scene data from a JSON file
local function loadSceneData(filename)
    local file = love.filesystem.read(filename)
    return json.decode(file)
end

-- Create a scene based on JSON data
local function createScene(sceneName, sceneData)
    local scene = {}

    if sceneData.type == "gui" then
        local guiElements = sceneData.guiElements or {}

        function scene:load()
            -- Load GUI elements if needed
        end

        function scene:update(dt)
            -- Update GUI elements
            GUIService:update(dt, guiElements)
        end

        function scene:draw()
            -- Draw GUI elements
            GUIService:draw(guiElements)
        end

    elseif sceneData.type == "game" then
        local gameMap
        local player
        local npcs = {}

        function scene:load()
            -- Load the game map and entities
            if sceneData.tilemap then
                gameMap = sti(sceneData.tilemap)
            end

            if sceneData.playerStart then
                player = Player:new(sceneData.playerStart[1], sceneData.playerStart[2], "man", 200, 2)
            end

            if sceneData.npcs then
                for _, npcData in ipairs(sceneData.npcs) do
                    local npc = NPC:new(npcData.x, npcData.y, npcData.type, 1000, 0.5)
                    table.insert(npcs, npc)
                end
            end
        end

        function scene:update(dt)
            -- Update player and NPCs
            if player then
                player:update(dt)
            end
            for _, npc in ipairs(npcs) do
                npc:update(dt)
            end
        end

        function scene:draw()
            -- Draw the game map
            if gameMap then
                gameMap:draw()
            end

            -- Draw player and NPCs
            if player then
                player:draw()
            end
            for _, npc in ipairs(npcs) do
                npc:draw()
            end
        end
    end

    return scene
end

-- Load scenes from JSON files
local function loadScenes()
    local sceneFiles = {
        "scenes/gui/main-menu.json",
        "scenes/game/zone1.json"
    }

    for _, file in ipairs(sceneFiles) do
        local sceneData = loadSceneData(file)
        local sceneName = sceneData.name
        SceneObjects[sceneName] = createScene(sceneName, sceneData)
    end
end

-- Initialize scenes
loadScenes()

return SceneObjects
