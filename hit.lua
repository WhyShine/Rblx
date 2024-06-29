local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Blox Fruit GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitConfig"})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function EquipFirstItem()
    local tool = player.Backpack:FindFirstChildOfClass("Tool")
    if tool then
        character.Humanoid:EquipTool(tool)
    end
end

local function AttackNPC(npc)
    local virtualUser = game:service('VirtualUser')
    while npc and npc.Parent and npc.Humanoid and npc.Humanoid.Health > 0 do
        if character:FindFirstChildOfClass("Tool") then
            virtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(0.1)
            virtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
        wait(0.1)
    end
end

local function AutoFarm()
    EquipFirstItem()
    local toolEquipped = character:FindFirstChildOfClass("Tool") ~= nil

    while toolEquipped do
        local closestNPC = nil
        local closestDistance = math.huge

        for _, npc in pairs(workspace.Enemies:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local distance = (npc.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestNPC = npc
                end
            end
        end

        if closestNPC then
            character.HumanoidRootPart.CFrame = CFrame.new(closestNPC.HumanoidRootPart.Position + Vector3.new(0, 15, 0))
            wait(0.5) -- Give time for movement

            while closestNPC and closestNPC.Parent and closestNPC:FindFirstChild("Humanoid") and closestNPC.Humanoid.Health > 0 do
                if (closestNPC.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 15 then
                    AttackNPC(closestNPC)
                else
                    character.HumanoidRootPart.CFrame = CFrame.new(closestNPC.HumanoidRootPart.Position + Vector3.new(0, 15, 0))
                end
                wait(0.1)
            end
        end

        wait(1)
        EquipFirstItem()
        toolEquipped = character:FindFirstChildOfClass("Tool") ~= nil
    end
end

AutoFarmTab:AddButton({
    Name = "Start Auto Farm",
    Callback = function()
        AutoFarm()
    end
})

OrionLib:Init()
