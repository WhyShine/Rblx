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

-- Function to log errors
local function logError(errorMessage)
    table.insert(errorLogs, errorMessage)
    updateErrorLabel()
end

-- Box to display coordinates
LogsTab:AddLabel("Coordinates:")
local coordinateLabel = LogsTab:AddLabel("")

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

-- Function to update error label
local function updateErrorLabel()
    local logText = table.concat(errorLogs, "\n")
    errorLabel:Set(logText)
end

-- Error and warning capture
game:GetService("LogService").MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError or messageType == Enum.MessageType.MessageWarning then
        logError(message)
    end
end)

-- Create the Farm tab
local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add elements to Farm tab
FarmTab:AddLabel("AutoFarm Settings")

local tools = {}
local function refreshTools()
    tools = {}
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(tools, v.Name)
        end
    end
end
refreshTools()

-- Check and set quest parameters
local function CheckQuest()
    local Lv = game.Players.LocalPlayer.Data.Level.Value
    if Lv == 0 or Lv <= 10 then
        Ms = "Bandit [Lv. 5]"
        NM = "Bandit"
        LQ = 1
        NQ = "BanditQuest1"
        CQ = CFrame.new(1062.64697265625, 16.516624450683594, 1546.55224609375)
    end
end

-- Teleport function
local function TP(P)
    local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 300
    if Distance < 10 then
        Speed = 1000
    elseif Distance < 170 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
        Speed = 350
    elseif Distance < 1000 then
        Speed = 350
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = P}
    ):Play()
end

-- Autofarm function
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            CheckQuest()
            if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                TP(CQ)
                task.wait(0.9)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NQ, LQ)
            else
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == Ms then
                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    end
                end
            end
        end
    end
end)

-- Auto attack
spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.AutoFarm then
            pcall(function()
                game:GetService('VirtualUser'):CaptureController()
                game:GetService('VirtualUser'):Button1Down(Vector2.new(0, 1, 0, 1))
            end)
        end
    end)
end)

local toolDropdown = FarmTab:AddDropdown("Weapon", tools, function(weapon)
    -- Functionality for selecting weapon can be added here
end)

-- Refresh tools on addition/removal
game.Players.LocalPlayer.Backpack.DescendantAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        table.insert(tools, tool.Name)
        toolDropdown:Refresh(tools)
    end
end)

game.Players.LocalPlayer.Backpack.DescendantRemoving:Connect(function(tool)
    if tool:IsA("Tool") then
        for i, v in pairs(tools) do
            if v == tool.Name then
                table.remove(tools, i)
                break
            end
        end
        toolDropdown:Refresh(tools)
    end
end)

-- Toggle for autofarm
FarmTab:AddToggle("AutoFarm", false, function(state)
    _G.AutoFarm = state
end)

-- Initiate Orion library
OrionLib:Init()
