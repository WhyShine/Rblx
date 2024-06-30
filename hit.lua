local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Blox Fruit GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitConfig"})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local enabled = false
local clickCooldown = 0.1 -- Default cooldown

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

                for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
                    if npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
                        local npcHumanoidRootPart = npc.HumanoidRootPart
                        local npcPosition = npcHumanoidRootPart.Position
                        local distance = (humanoidRootPart.Position - npcPosition).Magnitude

                        if distance <= 40 then
                            humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(0, 15, 0))

                            while npc.Humanoid.Health > 0 and enabled do
                                humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(0, 15, 0))
                                if character:FindFirstChild(tool.Name) then
                                    local screenPoint = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(npcPosition)
                                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, true, game, 0)
                                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, false, game, 0)
                                    wait(clickCooldown)
                                end
                            end
                        end
                    end
                end
            end
            wait(1)
        end
    end)
end

OrionLib:Init()
