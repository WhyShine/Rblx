-- Import library GUI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Auto Farm GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local farming = false

-- Buat tab
local Tab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Tambah tombol untuk menghidupkan/mematikan farming
Tab:AddButton({
    Name = "Toggle Farming",
    Callback = function()
        farming = not farming
        if farming then
            print("Farming Started")
            StartFarming()
        else
            print("Farming Stopped")
        end
    end
})

-- Tambah tombol untuk menutup GUI
Tab:AddButton({
    Name = "Close GUI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Fungsi untuk memperbesar area serangan
local function extendHitbox(hitbox, multiplier)
    local size = hitbox.Size
    hitbox.Size = Vector3.new(size.X * multiplier, size.Y * multiplier, size.Z * multiplier)
end

-- Fungsi untuk teleport ke NPC terdekat
local function teleportToNPC(npc)
    local player = game.Players.LocalPlayer
    local hrp = player.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
end

-- Fungsi untuk menyerang NPC
local function attackNPC(npc)
    local player = game.Players.LocalPlayer
    local hum = player.Character:WaitForChild("Humanoid")
    local hrp = player.Character:WaitForChild("HumanoidRootPart")
    while farming and npc.Humanoid.Health > 0 and hum.Health > 0 do
        hum:MoveTo(npc.HumanoidRootPart.Position)
        wait(0.1)
        if (hrp.Position - npc.HumanoidRootPart.Position).Magnitude <= 15 then
            local attackButton = game:GetService("VirtualUser")
            attackButton:CaptureController()
            attackButton:ClickButton1(Vector2.new(0, 0))
            wait(0.1)
        end
    end
end

-- Fungsi utama untuk Auto Farm
local function autoFarm()
    local player = game.Players.LocalPlayer
    local inventory = player.Backpack
    local activeWeapon = inventory:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
    local hum = player.Character:WaitForChild("Humanoid")

    while farming do
        for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
            if not farming then break end
            if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                extendHitbox(npc.HumanoidRootPart, 40)
                if activeWeapon and hum.Health > 0 then
                    teleportToNPC(npc)
                    attackNPC(npc)
                end
            end
        end
        wait(1)
    end
end

-- Fungsi untuk mulai farming
function StartFarming()
    while farming do
        autoFarm()
    end
end

-- Fungsi untuk mendeteksi klik pada tanda X
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
        local mouse = game.Players.LocalPlayer:GetMouse()
        if mouse.Target and mouse.Target.Name == "CloseButton" then
            OrionLib:Destroy()
        end
    end
end)

-- Tampilkan GUI
OrionLib:Init()
