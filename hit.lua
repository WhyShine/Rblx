local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Inisialisasi GUI
local Window = OrionLib:MakeWindow({Name = "Blox Fruit Auto Farm", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local function AutoFarm()
    -- Fungsi untuk mendapatkan NPC terdekat
    local function getNearestNPC()
        local nearestNPC = nil
        local closestDistance = math.huge
        for _, npc in pairs(game.Workspace.NPCs:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
                local distance = (npc.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    nearestNPC = npc
                end
            end
        end
        return nearestNPC
    end

    while true do
        -- Dapatkan item pertama di inventori dan pakai
        local inventory = game.Players.LocalPlayer.Backpack:GetChildren()
        if #inventory > 0 then
            local firstItem = inventory[1]
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(firstItem)
        end

        local nearestNPC = getNearestNPC()
        if nearestNPC then
            local npcPos = nearestNPC.HumanoidRootPart.Position
            -- Tempatkan pemain di atas NPC
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(npcPos.X, npcPos.Y + 15, npcPos.Z)

            -- Serang NPC sampai mati atau NPC tidak bisa diserang
            local previousHealth = nearestNPC.Humanoid.Health
            local isStuck = false
            while nearestNPC.Humanoid.Health > 0 do
                -- Tempatkan pemain di atas NPC setiap saat untuk memastikan posisinya
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(npcPos.X, npcPos.Y + 15, npcPos.Z)
                wait(0.1)
                if game.Players.LocalPlayer:FindFirstChildOfClass("Tool") then
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                end

                -- Cek apakah NPC bisa diserang atau tidak
                if nearestNPC.Humanoid.Health == previousHealth then
                    if not isStuck then
                        isStuck = true
                        wait(1) -- Beri waktu sedikit untuk memastikan apakah NPC benar-benar tidak bisa diserang
                    else
                        break -- Keluar dari loop jika NPC tidak bisa diserang
                    end
                else
                    previousHealth = nearestNPC.Humanoid.Health
                    isStuck = false
                end
            end
        end
        wait(1) -- Tunggu sebentar sebelum mencari NPC lagi
    end
end

AutoFarmTab:AddButton({
    Name = "Start Auto Farm",
    Callback = function()
        AutoFarm()
    end
})

OrionLib:Init()
