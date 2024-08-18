-- SceneObjects.lua
local Player = require "Player"
local NPC = require "NPC"
local sti = require 'libraries/sti'
local GUIService = require "GUIService"

-- Define scenes
local SceneObjects = {}

-- Scene 1: Example Scene with GUI elements
SceneObjects[1] = (function()
    local guiElements = {
        {
            type = "button",
            x = 100,
            y = 150,
            width = 200,
            height = 50,
            text = "Go to Scene 2",
            elementColor = {0.0, 0.5, 1.0},
            fontColor = {1.0, 1.0, 1.0},
            action = function()
                if sceneManager then
                    sceneManager:setScene(2)
                end
            end
        }
    }

    local function load()
        -- Scene 1 load logic
    end

    local function update(dt)
        -- Scene 1 update logic
    end

    local function draw()
        love.graphics.clear(0.2, 0.2, 0.2)
        love.graphics.setColor(1, 0, 0)
        local font = love.graphics.newFont("Mekon-Gradient.ttf", 50)
        love.graphics.setFont(font)
        love.graphics.print("ViBe ChEck", 100, 100)
        local image = love.graphics.newImage("pacman/down/tile000.png")
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image, 400, 300, 0, 2.5, 2.5)

        -- Draw GUI elements
        for _, element in ipairs(guiElements) do
            if element.type == "button" then
                GUIService:drawButton(element.x, element.y, element.width, element.height, element.text, element.elementColor, element.fontColor)
            end
        end
    end

    local function mousepressed(x, y, button)
        if button == 1 then  -- Left mouse button
            GUIService:handleMousePressed(guiElements, function(element)
                if element.action then
                    element.action()
                end
            end)
        end
    end

    return {
        load = load,
        update = update,
        draw = draw,
        mousepressed = mousepressed
    }
end)()

-- Scene 2: Game Scene with player and NPC
SceneObjects[2] = (function()
    local gameMap
    local player
    local npc

    local function load()
        love.graphics.setDefaultFilter('nearest', 'nearest')
        player = Player:new(400, 300, "man", 200, 2)
        npc = NPC:new(100, 100, "pacman", 1000, 0.5)
        npc:setBehavior('follow', player)
        gameMap = sti('maps/testMap.lua')
    end

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
    end

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

return SceneObjects
