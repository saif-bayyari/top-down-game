local json = require("dkjson")  -- or your preferred JSON library
local sti = require('libraries/sti')  -- Simple Tilemap Implementation (optional, if using Tiled)
local Player = require "Player"
local NPC = require "NPC"

-- Define SceneManager class
local SceneManager = {}
SceneManager.__index = SceneManager

-- Constructor
function SceneManager:new(initialScene)
    local self = setmetatable({}, SceneManager)
    self.currentScene = initialScene
    self.SceneObjects = {}
    self.SceneTransitions = {}  -- To track transitions if needed
    self:loadScenesFromJSON("data/scenes.json")  -- Load scenes from JSON file
    return self
end

-- Method to load scenes from JSON file
function SceneManager:loadScenesFromJSON(filename)
    local file = love.filesystem.read(filename)
    local scenes = json.decode(file)
    for name, data in pairs(scenes) do
        self.SceneObjects[name] = self:createScene(data)
    end
end

-- Method to create a scene based on its data
function SceneManager:createScene(data)
    return (function()
        local gameMap
        local player
        local npc
        local backgroundColor
        local backgroundImage
        local tilemap
        local guiElements = {}

        -- Load function
        local function load()
            if data.backgroundColor then
                backgroundColor = data.backgroundColor
            elseif data.backgroundImage then
                backgroundImage = love.graphics.newImage(data.backgroundImage)
            elseif data.tilemap then
                tilemap = sti(data.tilemap)  -- Assuming you use STI (Simple Tiled Implementation)
            end

            if data.type == "game" then
                player = Player:new(data.playerStart.x or 400, data.playerStart.y or 300, "man", 200, 2)
                npc = NPC:new(data.npcs[1].x, data.npcs[1].y, "pacman", 1000, 0.5)  -- Assuming first NPC
                npc:setBehavior('follow', player)
                if data.tilemap then
                    gameMap = tilemap
                end
            elseif data.type == "gui" then
                guiElements = data.guiElements
            end

            if data.transitions then
                for _, transition in ipairs(data.transitions) do
                    self.SceneTransitions[transition.trigger] = transition.toScene
                end
            end
        end

        local function performAction(action, transition)
            if action == "start_game" then
                -- Perform the action associated with "start_game"
                print("Starting game...")
            end

            if transition then
                -- Perform the transition
                self:setScene(transition)
            end
        end


        -- Handle GUI Interactions
        local function handleGuiInteractions()
            local mouseX, mouseY = love.mouse.getPosition()

            for _, element in ipairs(guiElements) do
                if element.type == "button" then
                    local left = element.x
                    local top = element.y
                    local right = element.x + element.width
                    local bottom = element.y + element.height

                    if mouseX >= left and mouseX <= right and mouseY >= top and mouseY <= bottom then
                        -- Hovering over button
                        if love.mouse.isDown(1) then  -- Left mouse button
                            performAction(element.action, element.transition)
                        end
                    end
                end
            end
        end

       
        -- Update function
        local function update(dt)
            if gameMap then
                gameMap:update(dt)
            end

            if player then
                player:update(dt)
            end

            if npc then
                npc:update(dt)
            end

            if player then
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

            if data.type == "gui" then
                handleGuiInteractions()
            end
        end

        local function drawGuiElements()
            for _, element in ipairs(guiElements) do
                if element.type == "button" then
                    love.graphics.setColor(element.elementColor or {0.2, 0.2, 0.2})  -- Default color if not specified
                    love.graphics.rectangle("fill", element.x, element.y, element.width, element.height)
                    love.graphics.setColor(element.fontColor or {1, 1, 1})  -- Default to white if not specified
                    love.graphics.printf(element.text, element.x, element.y + 10, element.width, "center")
                elseif element.type == "label" then
                    love.graphics.setColor(element.fontColor or {1, 1, 1})  -- Default to white if not specified
                    love.graphics.printf(element.text, element.x, element.y, love.graphics.getWidth(), "center")
                end
            end
        end
        -- Draw function
        local function draw()
            if backgroundColor then
                love.graphics.setBackgroundColor(backgroundColor)
                love.graphics.clear()
            elseif backgroundImage then
                love.graphics.draw(backgroundImage, 0, 0)
            elseif tilemap then
                tilemap:draw()
            end

            if gameMap then
                gameMap:draw()
            end

            if player then
                player:draw()
            end

            if npc then
                npc:draw()
            end

            if data.type == "gui" then
                drawGuiElements()
            end
        end

       

        return {
            load = load,
            update = update,
            draw = draw
        }
    end)()
end

-- Method to set a new scene
function SceneManager:setScene(name)
    self.currentScene = name
    local scene = self.SceneObjects[self.currentScene]
    if scene and scene.load then
        scene.load()
    end
end

-- Method to load the current scene
function SceneManager:load()
    local scene = self.SceneObjects[self.currentScene]
    if scene and scene.load then
        scene.load()
    end
end

-- Method to update the current scene
function SceneManager:update(dt)
    local scene = self.SceneObjects[self.currentScene]
    if scene and scene.update then
        scene.update(dt)
    end
end

-- Method to draw the current scene
function SceneManager:draw()
    local scene = self.SceneObjects[self.currentScene]
    if scene and scene.draw then
        scene.draw()
    end
end

return SceneManager
