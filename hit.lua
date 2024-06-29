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
    while npc and npc.Parent and npc.Humanoid.Health > 0 do
        if character:FindFirstChildOfClass("Tool") then
            character:FindFirstChildOfClass("Tool"):Activate()
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

            if (closestNPC.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 15 then
                AttackNPC(closestNPC)
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
