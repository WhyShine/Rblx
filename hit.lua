local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Blox Fruit GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitConfig"})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local enabled = false
local clickCooldown = 0.1 -- Default cooldown
local tweenSpeed = 50 -- Default tween speed

AutoFarmTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(Value)
        enabled = Value
        if enabled then
            AutoFarm()
        end
    end    
})

AutoFarmTab:AddSlider({
    Name = "Click Cooldown",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Increment = 0.05,
    ValueName = "seconds",
    Callback = function(Value)
        clickCooldown = Value
    end
})

AutoFarmTab:AddSlider({
    Name = "Tween Speed",
    Min = 25,
    Max = 100,
    Default = 50,
    Increment = 5,
    ValueName = "studs/second",
    Callback = function(Value)
        tweenSpeed = Value
    end
})

function moveToPosition(character, position)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenService = game:GetService("TweenService")
    local distance = (humanoidRootPart.Position - position).Magnitude
    local time = distance / tweenSpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
    tween.Completed:Wait()
end

function findNearestNPC()
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
    return nearestNPC
end

function attackNPC(npc, tool, humanoidRootPart, npcPosition)
    while npc.Humanoid.Health > 0 and enabled do
        if not humanoidRootPart or not npc.HumanoidRootPart then
            break
        end

        if not game.Players.LocalPlayer.Character:FindFirstChild(tool.Name) then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end

        humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(0, 15, 0))
        local screenPoint = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(npcPosition)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, true, game, 0)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, false, game, 0)
        wait(clickCooldown)
    end
end

function AutoFarm()
    spawn(function()
        while enabled do
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local inventory = player.Backpack:GetChildren()

            if #inventory > 0 then
                local tool = inventory[1]
                if not character:FindFirstChild(tool.Name) then
                    player.Character.Humanoid:EquipTool(tool)
                end

                local npc = findNearestNPC()
                while npc and npc.Humanoid.Health > 0 and enabled do
                    local npcPosition = npc.HumanoidRootPart.Position
                    moveToPosition(character, npcPosition + Vector3.new(0, 15, 0))
                    attackNPC(npc, tool, humanoidRootPart, npcPosition)
                    npc = findNearestNPC()
                end
            end
            wait(1)
        end
    end)
end

OrionLib:Init()
