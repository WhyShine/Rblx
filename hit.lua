local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Blox Fruit GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitConfig"})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LogTab = Window:MakeTab({
    Name = "Logs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local logText = ""
local logBox

logBox = LogTab:AddTextbox({
    Name = "Log Box",
    Default = "",
    TextDisappear = false,
    Callback = function() end
})

local function log(message)
    logText = logText .. "\n" .. message
    if logBox and logBox.Object then
        logBox.Object.Text = logText
    end
end

local function errorHandler(err)
    log("Error: " .. tostring(err))
end

LogTab:AddButton({
    Name = "Show All Logs",
    Callback = function()
        if logBox and logBox.Object then
            logBox.Object.Text = logText
        end
    end
})

local enabled = false
local clickCooldown = 0.1 -- Default cooldown
local tweenSpeed = 50 -- Default tween speed

local function moveToPosition(character, position)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenService = game:GetService("TweenService")
    local distance = (humanoidRootPart.Position - position).Magnitude
    local time = distance / tweenSpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position + Vector3.new(0, 15, 0))})
    tween:Play()
    tween.Completed:Wait()
    log("Moved to position: " .. tostring(position))
end

local function findNearestNPC()
    local nearestNPC = nil
    local nearestDistance = math.huge
    for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
            local npcPosition = npc.HumanoidRootPart.Position
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local distance = (humanoidRootPart.Position - npcPosition).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestNPC = npc
            end
        end
    end
    if nearestNPC then
        log("Nearest NPC found: " .. nearestNPC.Name)
    else
        log("No NPC found")
    end
    return nearestNPC
end

local function attackNPC(npc, tool, humanoidRootPart, npcPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    while npc.Humanoid.Health > 0 and enabled do
        if not humanoidRootPart or not npc.HumanoidRootPart then
            break
        end

        if not character:FindFirstChild(tool.Name) then
            character.Humanoid:EquipTool(tool)
        end

        humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(0, 15, 0))

        local screenPoint = game:GetService("Workspace").CurrentCamera.ViewportSize / 2
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, true, game, 0)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, false, game, 0)
        wait(clickCooldown)
    end
    log("Attacked NPC: " .. npc.Name)
end

local function AutoFarm()
    spawn(function()
        while enabled do
            local status, err = pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                local inventory = player.Backpack:GetChildren()

                if #inventory > 0 then
                    local tool = inventory[1]
                    if not character:FindFirstChild(tool.Name) then
                        character.Humanoid:EquipTool(tool)
                    end

                    local npc = findNearestNPC()
                    while npc and npc.Humanoid.Health > 0 and enabled do
                        local npcPosition = npc.HumanoidRootPart.Position
                        if (humanoidRootPart.Position - npcPosition).Magnitude > 15 then
                            moveToPosition(character, npcPosition)
                        end
                        attackNPC(npc, tool, humanoidRootPart, npcPosition)
                        npc = findNearestNPC()
                    end
                end
                wait(1)
            end)
            if not status then
                errorHandler(err)
            end
        end
    end)
end

AutoFarmTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(Value)
        enabled = Value
        if enabled then
            log("Auto Farm enabled")
            AutoFarm()
        else
            log("Auto Farm disabled")
        end
    end    
})

AutoFarmTab:AddTextbox({
    Name = "Click Cooldown",
    Default = "0.1",
    TextDisappear = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            clickCooldown = math.clamp(numValue, 0.05, 1)
            log("Click Cooldown set to " .. tostring(clickCooldown))
        else
            log("Invalid Click Cooldown value")
        end
    end
})

AutoFarmTab:AddTextbox({
    Name = "Tween Speed",
    Default = "50",
    TextDisappear = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            tweenSpeed = math.clamp(numValue, 25, 100)
            log("Tween Speed set to " .. tostring(tweenSpeed))
        else
            log("Invalid Tween Speed value")
        end
    end
})

OrionLib:Init()
