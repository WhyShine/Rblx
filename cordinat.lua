local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Disable Idle Connections
for _, connection in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    connection:Disable()
end

local tools = {}

for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if item:IsA("Tool") then
        table.insert(tools, item.Name)
    end
end

local AutoFarm = false
local selectedWeapon = ""
local MagnetActive = false
local FarmOffset = CFrame.new(0, 20, 0)
local MonsterPosition = nil
local Type = 1
local Y = 20

local function EquipWeapon(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(0.4)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

local function CheckLevel()
    local level = game.Players.LocalPlayer.Data.Level.Value
    local questInfo = {}

    if level <= 10 then
        questInfo = {
            monster = "Bandit [Lv. 5]",
            questName = "BanditQuest1",
            questLevel = 1,
            monsterName = "Bandit",
            questCFrame = CFrame.new(1062.64697265625, 16.516624450683594, 1546.55224609375),
            monsterCFrame = nil
        }
    elseif level <= 14 or SelectMonster == "Monkey [Lv. 14]" then
        questInfo = {
            monster = "Monkey [Lv. 14]",
            questName = "JungleQuest",
            questLevel = 1,
            monsterName = "Monkey",
            questCFrame = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102),
            monsterCFrame = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
        }
    elseif level <= 29 or SelectMonster == "Gorilla [Lv. 20]" then
        questInfo = {
            monster = "Gorilla [Lv. 20]",
            questName = "JungleQuest",
            questLevel = 2,
            monsterName = "Gorilla",
            questCFrame = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102),
            monsterCFrame = CFrame.new(-1142.6488037109, 40.462348937988, -515.39227294922)
        }
    elseif level <= 39 or SelectMonster == "Pirate [Lv. 35]" then
        questInfo = {
            monster = "Pirate [Lv. 35]",
            questName = "BuggyQuest1",
            questLevel = 1,
            monsterName = "Pirate",
            questCFrame = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188),
            monsterCFrame = CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
        }
    end

    return questInfo
end

local function Teleport(position)
    local distance = (position.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local speed = 300

    if distance < 10 then
        speed = 1000
    elseif distance < 170 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = position
        speed = 350
    elseif distance < 1000 then
        speed = 350
    end

    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(distance / speed, Enum.EasingStyle.Linear),
        {CFrame = position}
    ):Play()
end

local function Click()
    game:GetService('VirtualUser'):CaptureController()
    game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
end

spawn(function()
    while task.wait(0.1) do
        if Type == 1 then
            FarmOffset = CFrame.new(20, Y, 0)
        elseif Type == 2 then
            FarmOffset = CFrame.new(20, Y, 0)
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        Type = 1
        wait(5)
        Type = 2
        wait(5)
    end
end)

pcall(function()
    for _, v in pairs(game:GetService("Workspace").Map.Dressrosa.Tavern:GetDescendants()) do
        if v.ClassName == "Seat" then
            v:Destroy()
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoFarm then
            local questInfo = CheckLevel()
            if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                MagnetActive = false
                Teleport(questInfo.questCFrame)
                if (questInfo.questCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    wait(1.1)
                    if (questInfo.questCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", questInfo.questName, questInfo.questLevel)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    else
                        Teleport(questInfo.questCFrame)
                    end
                end
            else
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild(questInfo.monster) then
                        for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if enemy.Name == questInfo.monster and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                repeat game:GetService("RunService").Heartbeat:wait()
                                    if game:GetService("Workspace").Enemies:FindFirstChild(questInfo.monster) then
                                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, questInfo.monsterName) then
                                            EquipWeapon(selectedWeapon)
                                            Teleport(enemy.HumanoidRootPart.CFrame * FarmOffset)
                                            enemy.HumanoidRootPart.CanCollide = false
                                            enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                            game:GetService("VirtualUser"):CaptureController()
                                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670), workspace.CurrentCamera.CFrame)
                                            MonsterPosition = enemy.HumanoidRootPart.CFrame
                                            MagnetActive = true
                                        else
                                            MagnetActive = false    
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    else
                                        MagnetActive = false
                                        Teleport(questInfo.monsterCFrame)
                                    end
                                until not enemy.Parent or enemy.Humanoid.Health <= 0 or not AutoFarm or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible or not game:GetService("Workspace").Enemies:FindFirstChild(enemy.Name)
                            end
                        end
                    else
                        MagnetActive = false
                        Teleport(questInfo.monsterCFrame)
                    end
                end)
            end
        end
    end
end)

local Window = OrionLib:MakeWindow({Name = "BloxFruits Script Test", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Main Tab
local Main = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MainSection = Main:AddSection({
    Name = "Main"
})

local toolDropdown = MainSection:AddDropdown({
    Name = "Weapon",
    Default = "",
    Options = tools,
    Callback = function(weapon)
        selectedWeapon = weapon
    end
})

game.Players.LocalPlayer.Backpack.DescendantAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        table.insert(tools, tool.Name)
        toolDropdown:Refresh(tools)
    end
end)

game.Players.LocalPlayer.Backpack.DescendantRemoving:Connect(function(tool)
    if tool:IsA("Tool") then
        for i, v in pairs(tools) do
            if v == tool.Name then
                table.remove(tools, i)
            end
        end    
        toolDropdown:Refresh(tools)
    end
end)

MainSection:AddToggle({
    Name = "AutoFarm",
    Default = false,
    Callback = function(state)
        AutoFarm = state
    end
})

MainSection:AddTextbox({
    Name = "Fake Beli",
    Default = "",
    TextDisappear = true,
    Callback = function(fakeLevel)
        game.Players.LocalPlayer.Data.Level.Value = fakeLevel
    end
})

-- Stats Tab
local Stats = Window:MakeTab({
    Name = "Stats",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local StatsSection = Stats:AddSection({
    Name = "Stats"
})

local function AddAutoStatToggle(name, stat)
    StatsSection:AddToggle({
        Name = name,
        Default = false,
        Callback = function(state)
            _G["auto" .. stat .. "Stats"] = state
            while _G["auto" .. stat .. "Stats"] do
                local args = {
                    [1] = "AddPoint",
                    [2] = stat,
                    [3] = 1
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                task.wait(30)
            end
        end
    })
end

AddAutoStatToggle("Meele", "Melee")
AddAutoStatToggle("Defense", "Defense")
AddAutoStatToggle("Sword", "Sword")
AddAutoStatToggle("Gun", "Gun")
AddAutoStatToggle("Devil Fruit", "Demon Fruit")

-- Teleport Tab
local Teleport = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportSection = Teleport:AddSection({
    Name = "Teleport"
})

local function AddTeleportButton(name, position)
    TeleportSection:AddButton({
        Name = name,
        Callback = function()
            Teleport(position)
        end
    })
end

AddTeleportButton("Second Sea", CFrame.new(-41.248611450195, 20.44778251648, 2993.0021972656))
AddTeleportButton("Middle Town", CFrame.new(-690.34057617188, 15.094252586365, 1583.8342285156))
AddTeleportButton("Colosseum", CFrame.new(-1836.5816650391, 7.2894344329834, 1350.6179199219))
AddTeleportButton("Sky Island 1", CFrame.new(-4846.14990234375, 717.6875610351562, -2622.3544921875))
AddTeleportButton("Sky Island 2", CFrame.new(-7891.73681640625, 5545.5283203125, -380.2913818359375))
AddTeleportButton("Under Water City", CFrame.new(61163.8515625, 11.75231647491455, 1818.8211669921875))
AddTeleportButton("Prison", CFrame.new(4851.97265625, 5.651928424835205, 734.74658203125))

OrionLib:Init()
