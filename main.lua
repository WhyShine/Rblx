-- Membuat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitsGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Membuat Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.Parent = screenGui

-- Membuat Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleLabel.Text = "Blox Fruits GUI"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

-- Membuat Tombol Auto Farm
local autoFarmButton = Instance.new("TextButton")
autoFarmButton.Size = UDim2.new(0, 200, 0, 50)
autoFarmButton.Position = UDim2.new(0.5, -100, 0.5, -25)
autoFarmButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
autoFarmButton.Text = "Auto Farm"
autoFarmButton.TextColor3 = Color3.new(1, 1, 1)
autoFarmButton.Font = Enum.Font.SourceSans
autoFarmButton.TextSize = 18
autoFarmButton.Parent = mainFrame
-- Fungsi untuk mendapatkan level pemain
local function getPlayerLevel()
    local player = game.Players.LocalPlayer
    local stats = player:WaitForChild("Data"):WaitForChild("Level")
    return stats.Value
end

-- Fungsi untuk mendapatkan target berdasarkan level
local function getTargetBasedOnLevel(level)
    if level >= 1 and level < 50 then
        return "Bandit", CFrame.new(1036, 16, 1542) -- Contoh koordinat
    elseif level >= 50 and level < 100 then
        return "Monkey", CFrame.new(-1571, 0, 156) -- Contoh koordinat
    elseif level >= 100 and level < 200 then
        return "Gorilla", CFrame.new(-1246, 6, 1584) -- Contoh koordinat
    elseif level >= 200 and level < 300 then
        return "Pirate", CFrame.new(-1211, 4, 109) -- Contoh koordinat
    elseif level >= 300 and level < 400 then
        return "Snow Bandit", CFrame.new(1182, 138, -1350) -- Contoh koordinat
    elseif level >= 400 and level < 500 then
        return "Desert Bandit", CFrame.new(895, 6, 4438) -- Contoh koordinat
    elseif level >= 500 and level < 600 then
        return "Sky Bandit", CFrame.new(-4973, 718, -2787) -- Contoh koordinat
    else
        return "Boss", CFrame.new(-772, 6, -1241) -- Contoh koordinat
    end
end
-- Fungsi untuk teleport
local function teleport(location)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        player.Character.HumanoidRootPart.CFrame = location
    end
end

-- Fungsi untuk menyerang musuh
local function attackTarget(targetName)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
        if enemy.Name == targetName and enemy:FindFirstChild("HumanoidRootPart") then
            humanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
            -- Logika serangan bisa disesuaikan di sini
            while enemy.Humanoid.Health > 0 do
                -- Serangan terus menerus hingga musuh mati
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer("Attack")
                wait(0.1) -- Delay antara serangan
            end
        end
    end
end
-- Fungsi utama auto farm
local function autoFarm()
    while true do
        local level = getPlayerLevel()
        local targetName, targetLocation = getTargetBasedOnLevel(level)
        teleport(targetLocation)
        wait(1) -- Waktu tunggu sebelum menyerang
        attackTarget(targetName)
        wait(1) -- Waktu tunggu sebelum mencari target berikutnya
    end
end

-- Menambahkan tombol untuk memulai auto farm
autoFarmButton.MouseButton1Click:Connect(autoFarm)
