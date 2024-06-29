-- Inisialisasi Variabel
local player = game.Players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local inventory = player.Backpack
local activeWeapon = inventory:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")

-- Fungsi untuk memperbesar area serangan
local function extendHitbox(hitbox, multiplier)
    local size = hitbox.Size
    hitbox.Size = Vector3.new(size.X * multiplier, size.Y * multiplier, size.Z * multiplier)
end

-- Fungsi untuk teleport ke NPC terdekat
local function teleportToNPC(npc)
    hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
end

-- Fungsi untuk menyerang NPC
local function attackNPC(npc)
    while npc.Humanoid.Health > 0 do
        hum:MoveTo(npc.HumanoidRootPart.Position)
        wait(0.1)
        local attackButton = game:GetService("VirtualUser")
        attackButton:CaptureController()
        attackButton:ClickButton1(Vector2.new(0, 0))
        wait(0.1)
    end
end

-- Fungsi utama untuk Auto Farm
local function autoFarm()
    while wait(1) do
        for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                extendHitbox(npc.HumanoidRootPart, 40)
                if activeWeapon and hum.Health > 0 then
                    teleportToNPC(npc)
                    attackNPC(npc)
                end
            end
        end
    end
end

-- Mulai Auto Farm
autoFarm()
