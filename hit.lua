-- Inisialisasi Variabel
local player = game.Players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local inventory = player.Backpack
local activeWeapon = inventory:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")

-- Membuat GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = game.CoreGui

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.Position = UDim2.new(0, 0, 0.5, -50)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Active = true
Frame.Draggable = true

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
ToggleButton.Size = UDim2.new(0, 200, 0, 100)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Text = "Start Auto Farm"
ToggleButton.TextSize = 20

-- Variabel status Auto Farm
local isAutoFarmActive = false

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
    while isAutoFarmActive and npc.Humanoid.Health > 0 and hum.Health > 0 do
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
    while isAutoFarmActive do
        for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
            if not isAutoFarmActive then break end
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

-- Mengaktifkan/Menonaktifkan Auto Farm
ToggleButton.MouseButton1Click:Connect(function()
    isAutoFarmActive = not isAutoFarmActive
    if isAutoFarmActive then
        ToggleButton.Text = "Stop Auto Farm"
        ToggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
        autoFarm()
    else
        ToggleButton.Text = "Start Auto Farm"
        ToggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
    end
end)
