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
local interactionLogs = {}

-- Function to get current position with 2 decimal precision
local function getCurrentPosition()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local position = hrp.Position
    return string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)
end

-- Function to log interactions
local function logInteraction(interaction)
    local currentTime = tick()
    if currentTime - lastLogTime >= logCooldown then
        table.insert(interactionLogs, interaction)
        lastLogTime = currentTime
    end
end

-- Box to display coordinates
LogsTab:AddLabel("Coordinates:")
local coordinateLabel = LogsTab:AddLabel("")

-- Box to display interactions
LogsTab:AddLabel("Interactions:")
local interactionBox = LogsTab:AddTextbox({
    Name = "Interaction Log",
    Default = "",
    TextDisappear = false,
    Callback = function() end
})

-- Update the coordinate label continuously
spawn(function()
    while true do
        coordinateLabel:Set(getCurrentPosition())
        wait(0.1) -- update every 0.1 second
    end
end)

-- Function to update interaction box
local function updateInteractionBox()
    if interactionBox and interactionBox.Set then
        local logText = table.concat(interactionLogs, "\n")
        interactionBox:Set(logText)
    end
end

-- Example interaction events
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    logInteraction("Character spawned: " .. tostring(character))
    updateInteractionBox()
end)

game.Players.LocalPlayer.Chatted:Connect(function(message)
    logInteraction("User said: " .. message)
    updateInteractionBox()
end)

-- You can add more events or interactions to log as needed
-- For example, interactions with objects, quests, etc.
-- Example: Logging quest interactions
local function logQuestInteraction(questName, details)
    logInteraction("Quest: " .. questName .. "\nDetails: " .. details)
    updateInteractionBox()
end

-- Dummy function to simulate quest interaction
local function onQuestInteraction()
    logQuestInteraction("Quest Name", "Quest details and interactions")
end

-- Call the dummy quest interaction function for demonstration
-- You can replace this with actual quest interaction logic
onQuestInteraction()

-- Initiate Orion library
OrionLib:Init()
