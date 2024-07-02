-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create a window
local Window = OrionLib:MakeWindow({Name = "User Activity Logger", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Create a tab for logs
local LogsTab = Window:MakeTab({
    Name = "Logs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables to store data
local lastLogTime = 0
local logCooldown = 2 -- cooldown in seconds
local coordinateLogs = {}

-- Function to get current position with 2 decimal precision
local function getCurrentPosition()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local position = hrp.Position
    return string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)
end

-- Function to log coordinates
local function logCoordinates()
    local currentTime = tick()
    if currentTime - lastLogTime >= logCooldown then
        table.insert(coordinateLogs, getCurrentPosition())
        lastLogTime = currentTime
    end
end

-- Box to display coordinates
LogsTab:AddLabel("Coordinates:")
local coordinateLabel = LogsTab:AddLabel("")

-- Update the coordinate label continuously
spawn(function()
    while true do
        logCoordinates()
        coordinateLabel:Set(table.concat(coordinateLogs, "\n"))
        wait(0.1) -- update every 0.1 second
    end
end)

-- Initiate Orion library
OrionLib:Init()
