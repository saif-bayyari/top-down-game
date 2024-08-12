-- Define the GameContainer class
GameContainer = {}
GameContainer.__index = GameContainer

-- Table to keep track of used IDs
local usedIDs = {}

-- Function to generate a unique random ID
local function generateUniqueID()
    local id
    repeat
        id = tostring(math.random(1, 1000000)) -- Generate a random number as ID
    until not usedIDs[id]
    usedIDs[id] = true
    return id
end

-- Constructor for the GameContainer class
function GameContainer:new(width, height, x, y)
    local maxWidth = love.graphics.getWidth()
    local maxHeight = love.graphics.getHeight()

    -- Assert that the dimensions and position are within bounds
    assert(width >= 0 and height >= 0, "Width and height must be non-negative")
    assert(x >= 0 and y >= 0, "X and Y coordinates must be non-negative")
    assert(x + width <= maxWidth, "GameContainer is out of bounds on the right side")
    assert(y + height <= maxHeight, "GameContainer is out of bounds on the bottom side")

    local self = setmetatable({}, GameContainer)
    self.id = generateUniqueID()
    self.width = width or 0
    self.height = height or 0
    self.x = x or 0
    self.y = y or 0
    return self
end

-- Method to print the GameContainer's details
function GameContainer:printDetails()
    print("ID: " .. self.id)
    print("Width: " .. self.width)
    print("Height: " .. self.height)
    print("X: " .. self.x)
    print("Y: " .. self.y)
end

return GameContainer

--https://isavii.itch.io/grass-bush-labyrinth-tileset-32x32