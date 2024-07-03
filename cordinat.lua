local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

local Auto_Farm = false
local SelectToolWeapon = ""
local SelectWeaponBoss = ""
local MagnetActive = false
local Farm_Mode = CFrame.new(0, 20, 0)
local PosMon = nil
local FastAttack = false

local locations = {
    { name = "Second Sea", position = CFrame.new(-41.248611450195, 20.44778251648, 2993.0021972656) },
    { name = "Middle Town", position = CFrame.new(-690.34057617188, 15.094252586365, 1583.8342285156) },
    { name = "Colosseum", position = CFrame.new(-1836.5816650391, 7.2894344329834, 1350.6179199219) },
    { name = "Sky Island 1", position = CFrame.new(-4846.14990234375, 717.6875610351562, -2622.3544921875) },
    { name = "Sky Island 2", position = CFrame.new(-7891.73681640625, 5545.5283203125, -380.2913818359375) },
    { name = "Under Water City", position = CFrame.new(61163.8515625, 11.75231647491455, 1818.8211669921875) },
    { name = "Prison", position = CFrame.new(4851.97265625, 5.651928424835205, 734.74658203125) }
}

function TP(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 200
    if Distance < 250 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 400
    elseif Distance < 1000 then
        Speed = 350
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        {CFrame = P1}
    ):Play()
end

function TP2(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 250
    if Distance < 1000 then
        Speed = 400
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        {CFrame = P1}
    ):Play()
    Clip = true
    wait(Distance / Speed)
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

local RigC = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework) 
local VirtualUser = game:GetService('VirtualUser')
local kkii = require(game.ReplicatedStorage.Util.CameraShaker)

spawn(function()
    game:GetService('RunService').Heartbeat:connect(function()
        if FastAttack then
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
    while true do
        game:GetService('RunService').Heartbeat:wait()
        if FastAttack then
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
        end
    end
end)

local Window = OrionLib:MakeWindow({Name = "Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Teleport = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportSection = Teleport:AddSection({
    Name = "Teleport"
})

local locationNames = {}
for _, location in ipairs(locations) do
    table.insert(locationNames, location.name)
end

local selectedLocation = nil

TeleportSection:AddDropdown({
    Name = "Select Location",
    Default = "",
    Options = locationNames,
    Callback = function(Value)
        for _, location in ipairs(locations) do
            if location.name == Value then
                selectedLocation = location.position
                break
            end
        end
    end
})

TeleportSection:AddButton({
    Name = "Teleport",
    Callback = function()
        if selectedLocation then
            TP(selectedLocation)
        else
            print("No location selected")
        end
    end
})

local Main = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Main:AddToggle({
    Name = "AutoFarm Level",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        MagnetActive = Value
        if _G.AutoFarm and SelectToolWeapon == "" then
            OrionLib:MakeNotification({
                Name = "AutoFarm",
                Content = "Select Weapon First",
                Time = 2
            })
        else
            Auto_Farm = Value
            SelectMonster = ""
            if Value == false then
                wait(1)
                TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
            end
        end
        function UseCode(Text)
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(Text)
        end
        UseCode("UPD16")
        UseCode("2BILLION")
        UseCode("UPD15")
        UseCode("FUDD10")
        UseCode("BIGNEWS")
        UseCode("THEGREATACE")
        UseCode("SUB2GAMERROBOT_EXP1")
        UseCode("StrawHatMaine")
        UseCode("Sub2OfficialNoobie")
        UseCode("SUB2NOOBMASTER123")
        UseCode("Sub2Daigrock")
        UseCode("Axiore")
        UseCode("TantaiGaming")
        UseCode("STRAWHATMAINE")
    end
})

function CheckLevel()
    local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
    if Old_World then
        if Lv == 1 or Lv <= 9 or SelectMonster == "Bandit [Lv. 5]" then -- Bandit
            Ms = "Bandit [Lv. 5]"
            NameQuest = "BanditQuest1"
            QuestLv = 1
            NameMon = "Bandit"
            CFrameQ = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875)
            CFrameMon = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
        elseif Lv == 10 or Lv <= 14 or SelectMonster == "Monkey [Lv. 14]" then -- Monkey
            Ms = "Monkey [Lv. 14]"
            NameQuest = "JungleQuest"
            QuestLv = 1
            NameMon = "Monkey"
            CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
        elseif Lv == 15 or Lv <= 29 or SelectMonster == "Gorilla [Lv. 20]" then -- Gorilla
            Ms = "Gorilla [Lv. 20]"
            NameQuest = "JungleQuest"
            QuestLv = 2
            NameMon = "Gorilla"
            CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(-1142.6488037109, 51.052509307861, -518.04833984375)
        elseif Lv == 30 or Lv <= 39 or SelectMonster == "Pirate [Lv. 35]" then -- Pirate
            Ms = "Pirate [Lv. 35]"
            NameQuest = "BuggyQuest1"
            QuestLv = 1
            NameMon = "Pirate"
            CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
        elseif Lv == 40 or Lv <= 59 or SelectMonster == "Brute [Lv. 45]" then -- Brute
            Ms = "Brute [Lv. 45]"
            NameQuest = "BuggyQuest1"
            QuestLv = 2
            NameMon = "Brute"
            CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(-1387.5324707031, 24.592035293579, 4100.9575195313)
        end
    end
end

function EquipWeapon(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(.4)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

Type = 1
spawn(function()
    while wait(.1) do
        if Type == 1 then
            Farm_Mode = CFrame.new(20, 0, 0)
        elseif Type == 2 then
            Farm_Mode = CFrame.new(20, 0, 0)
        end
    end
end)

spawn(function()
    while wait(.1) do
        Type = 1
        wait(5)
        Type = 2
        wait(5)
    end
end)

pcall(function()
    for i,v in pairs(game:GetService("Workspace").Map.Dressrosa.Tavern:GetDescendants()) do
        if v.ClassName == "Seat" then
            v:Destroy()
        end
    end
end)

spawn(function()
    while wait() do
        if Auto_Farm then
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                MagnetActive = false
                CheckLevel()
                TP(CFrameQ)
                if (CFrameQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    wait(1.1)
                    CheckLevel()
                    if (CFrameQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    else
                        TP(CFrameQ)
                    end
                end
            elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                pcall(function()
                    CheckLevel()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == Ms and v:FindFirstChild("Humanoid") then
                                if v.Humanoid.Health > 0 then
                                    repeat game:GetService("RunService").Heartbeat:wait()
                                        if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
                                            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                                EquipWeapon(SelectToolWeapon)
                                                TP(v.HumanoidRootPart.CFrame * Farm_Mode)
                                                v.HumanoidRootPart.CanCollide = false
                                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670), workspace.CurrentCamera.CFrame)
                                                PosMon = v.HumanoidRootPart.CFrame
                                                MagnetActive = true
                                            else
                                                MagnetActive = false    
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        else
                                            MagnetActive = false
                                            CheckLevel()
                                            TP(CFrameMon)
                                        end
                                    until not v.Parent or v.Humanoid.Health <= 0 or Auto_Farm == false or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false or not game:GetService("Workspace").Enemies:FindFirstChild(v.Name)
                                end
                            end
                        end
                    else
                        MagnetActive = false
                        CheckLevel()
                        TP(CFrameMon)
                    end
                end)
            end
        end
    end
end)

function Click()
    game:GetService('VirtualUser'):CaptureController()
    game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
end

Main:AddDropdown({
    Name = "Select Weapon",
    Default = "",
    Options = {"Combat", "Sword", "Gun"},
    Callback = function(Value)
        SelectToolWeapon = Value
    end
})

Main:AddToggle({
    Name = "Fast Attack",
    Default = false,
    Callback = function(vu)
        FastAttack = vu
    end
})

Main:AddButton({
    Name = "Log Current Coordinates",
    Callback = function()
        local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        print("Current Coordinates: X: " .. playerPosition.X .. " Y: " .. playerPosition.Y .. " Z: " .. playerPosition.Z)
        OrionLib:MakeNotification({
            Name = "Coordinates Logged",
            Content = "X: " .. playerPosition.X .. " Y: " .. playerPosition.Y .. " Z: " .. playerPosition.Z,
            Time = 5
        })
    end
})

Main:AddToggle({
    Name = "Auto Attack Nearby Monsters",
    Default = false,
    Callback = function(Value)
        AutoAttack = Value
        while AutoAttack do
            wait(0.1)
            for _, enemy in ipairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    if (enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                        EquipWeapon(SelectToolWeapon)
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670), workspace.CurrentCamera.CFrame)
                    end
                end
            end
        end
    end
})

if SelectToolWeapon == "" then
    SelectToolWeapon = "Combat"
end
