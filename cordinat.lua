-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create a window
local Window = OrionLib:MakeWindow({Name = "User Activity Logger", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Create tabs
local StatusTab = Window:MakeTab({
    Name = "Status",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LogsTab = Window:MakeTab({
    Name = "Logs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables to store data
local lastLogTime = 0
local logCooldown = 2 -- cooldown in seconds
local interactionLogs = {}
local errorLogs = {}

-- Function to get player stats
local function getPlayerStats()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local stats = {
        Health = humanoid.Health,
        MaxHealth = humanoid.MaxHealth,
        Mana = character:FindFirstChild("Mana") and character.Mana.Value or "N/A",
        Strength = player:FindFirstChild("Stats") and player.Stats.Strength.Value or "N/A",
        Defense = player:FindFirstChild("Stats") and player.Stats.Defense.Value or "N/A",
        Fruit = player:FindFirstChild("Stats") and player.Stats.Fruit.Value or "N/A",
        Sword = player:FindFirstChild("Stats") and player.Stats.Sword.Value or "N/A",
    }
    return stats
end

-- Function to update player stats label
local function updatePlayerStats()
    local stats = getPlayerStats()
    statusLabel:Set(string.format(
        "Health: %.2f / %.2f\nMana: %s\nStrength: %s\nDefense: %s\nFruit: %s\nSword: %s",
        stats.Health, stats.MaxHealth, stats.Mana, stats.Strength, stats.Defense, stats.Fruit, stats.Sword
    ))
end

-- Create a label to display player stats
StatusTab:AddLabel("Player Status:")
local statusLabel = StatusTab:AddLabel("")

-- Update the player stats label continuously
spawn(function()
    while true do
        updatePlayerStats()
        wait(1) -- update every 1 second
    end
end)

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

-- Function to log errors
local function logError(errorMessage)
    table.insert(errorLogs, errorMessage)
    updateErrorLabel()
end

-- Box to display coordinates
LogsTab:AddLabel("Coordinates:")
local coordinateLabel = LogsTab:AddLabel("")

-- Box to display interactions
LogsTab:AddLabel("Interactions:")
local interactionLabel = LogsTab:AddLabel("")

-- Box to display errors
LogsTab:AddLabel("Errors:")
local errorLabel = LogsTab:AddLabel("")

-- Update the coordinate label continuously
spawn(function()
    while true do
        coordinateLabel:Set(getCurrentPosition())
        wait(0.1) -- update every 0.1 second
    end
end)

-- Function to update interaction label
local function updateInteractionLabel()
    local logText = table.concat(interactionLogs, "\n")
    interactionLabel:Set(logText)
end

-- Function to update error label
local function updateErrorLabel()
    local logText = table.concat(errorLogs, "\n")
    errorLabel:Set(logText)
end

-- Example interaction events
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    logInteraction("Character spawned: " .. tostring(character))
    updateInteractionLabel()
end)

game.Players.LocalPlayer.Chatted:Connect(function(message)
    logInteraction("User said: " .. message)
    updateInteractionLabel()
end)

-- You can add more events or interactions to log as needed
-- For example, interactions with objects, quests, etc.
-- Example: Logging quest interactions
local function logQuestInteraction(questName, details)
    logInteraction("Quest: " .. questName .. "\nDetails: " .. details)
    updateInteractionLabel()
end

-- Dummy function to simulate quest interaction
local function onQuestInteraction()
    logQuestInteraction("Quest Name", "Quest details and interactions")
end

-- Call the dummy quest interaction function for demonstration
-- You can replace this with actual quest interaction logic
onQuestInteraction()

-- Error and warning capture
game:GetService("LogService").MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError or messageType == Enum.MessageType.MessageWarning then
        logError(message)
    end
end)

-- Initiate Orion library
OrionLib:Init()
