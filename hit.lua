local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Blox Fruit GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitConfig"})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local enabled = false

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

function AutoFarm()
    while enabled do
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local inventory = player.Backpack:GetChildren()
        
        if #inventory > 0 then
            local tool = inventory[1]
            character.Humanoid:EquipTool(tool)

            for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
                if npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
                    local npcHumanoidRootPart = npc.HumanoidRootPart
                    local npcPosition = npcHumanoidRootPart.Position
                    local distance = (humanoidRootPart.Position - npcPosition).magnitude

                    if distance <= 40 then
                        humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(0, 15, 0))

                        while npc.Humanoid.Health > 0 and enabled do
                            humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(0, 15, 0))
                            local screenPoint = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(npcPosition)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, true, game, 0)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, false, game, 0)
                            wait(0.1)
                        end
                    end
                end
            end
        end
        wait(1)
    end
end

OrionLib:Init()
