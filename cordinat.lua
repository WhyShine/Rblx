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
local FarmOffset = CFrame.new(20, 20, 0)
local MonsterPosition = nil
local Type = 1
local Y = 20
local UseMagnet = false
local SelectMonster = "" -- Deklarasi SelectMonster
local SafeMode = false

local RigC = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local VirtualUser = game:GetService('VirtualUser')
local kkii = require(game.ReplicatedStorage.Util.CameraShaker)

spawn(function()
    game:GetService('RunService').Heartbeat:connect(function()
        if _G.FastAtttk then
            pcall(function()
                RigC.activeController.timeToNextAttack = 0
                RigC.activeController.attacking = false
                RigC.activeController.blocking = false
                RigC.activeController.timeToNextAttack = 0
                RigC.activeController.timeToNextBlock = 0
                RigC.activeController.increment = 3
                RigC.activeController.hitboxMagnitude = 100
                game.Players.LocalPlayer.Character.Stun.Value = 0
                game.Players.LocalPlayer.Character.Humanoid.Sit = false

                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
                kkii:Stop()
            end)
        end
    end)
end)

spawn(function()
    for i = 1, math.huge do
        game:GetService('RunService').Heartbeat:wait()
        if _G.FastAtttk then
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
        end
    end
end)

spawn(function()
    pcall(function()
        while wait() do
            if SafeMode then
                local X = math.random(1, 100)
                local Z = math.random(1, 100)
                TP(CFrame.new(X, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y, Z))
            end
        end
    end)
end)

local function EquipWeapon(ToolSe)
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
    if tool then
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

local function TP(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed
    if Distance < 250 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 400
    elseif Distance < 1000 then
        Speed = 350
    else
        Speed = 200
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = P1}
    ):Play()
end

local function TP2(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed
    if Distance < 1000 then
        Speed = 400
    else
        Speed = 250
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = P1}
    ):Play()
    local Clip = true -- Tambahkan deklarasi ini
    wait(Distance/Speed)
    Clip = false
end

local Old_World = false
local New_World = false
local Three_World = false
local placeId = game.PlaceId
if placeId == 2753915549 then
    Old_World = true
elseif placeId == 4442272183 then
    New_World = true
elseif placeId == 7449423635 then
    Three_World = true
end

local function Click()
    game:GetService('VirtualUser'):CaptureController()
    game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
end

spawn(function()
    while wait(0.1) do
        if Type == 1 then
            FarmOffset = CFrame.new(20, Y, 0)
        elseif Type == 2 then
            FarmOffset = CFrame.new(20, Y, 0)
        end
    end
end)

spawn(function()
    while wait(0.1) do
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
                TP(questInfo.questCFrame)
                if (questInfo.questCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    wait(1.1)
                    if (questInfo.questCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", questInfo.questName, questInfo.questLevel)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    else
                        TP(questInfo.questCFrame)
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
                                            if enemy.Humanoid.Health > 0 then
                                                if UseMagnet then
                                                    MagnetActive = true
                                                    enemy.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * FarmOffset
                                                else
                                                    TP(enemy.HumanoidRootPart.CFrame * FarmOffset)
                                                end
                                            elseif enemy.Humanoid.Health <= 0 or not enemy.Parent or not AutoFarm then
                                                break
                                            end
                                            EquipWeapon(selectedWeapon)
                                            Click()
                                        else
                                            MagnetActive = false
                                            TP(questInfo.questCFrame)
                                        end
                                    end
                                until enemy.Humanoid.Health <= 0 or not enemy.Parent or not AutoFarm
                            end
                        end
                    end
                end)
            end
        end
    end
end)

OrionLib:Init()
