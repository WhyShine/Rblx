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

local function TP(CFrameTarget)
    local player = game:GetService("Players").LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local distance = (CFrameTarget.Position - humanoidRootPart.Position).Magnitude
        if distance > 5 then -- Adjust the distance threshold as needed
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrameTarget})
            tween:Play()
            tween.Completed:Wait()
        end
    end
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
local function AttackMonster()
    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
        pcall(function()
            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v.Name == Ms and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    repeat wait()
                        EquipWeapon(Weapon)
                        if v:FindFirstChild("HumanoidRootPart") then
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,30,0)
                        end
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                    until not v.Parent or v.Humanoid.Health <= 0 or not v:FindFirstChild("HumanoidRootPart")
                end
            end
        end)
    end
end

spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckLv()
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartQuest()
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CompleteQuest()
                    AttackMonster()
                end
            end)
        end
    end
end)


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
            CFrameQ = CFrame.new(-1139.6826171875, 4.752049446106, 3836.0393066406)
            CFrameMon = CFrame.new(-1201.0902099609, 41.145561218262, 3912.3781738281)
        elseif Lv == 40 or Lv <= 59 or SelectMonster == "Brute [Lv. 45]" then -- Brute
            Ms = "Brute [Lv. 45]"
            NameQuest = "BuggyQuest1"
            QuestLv = 2
            NameMon = "Brute"
            CFrameQ = CFrame.new(-1139.6826171875, 4.752049446106, 3836.0393066406)
            CFrameMon = CFrame.new(-1374.2066650391, 14.809700965881, -37.288352966309)
        elseif Lv == 60 or Lv <= 74 or SelectMonster == "Desert Bandit [Lv. 60]" then -- Desert Bandit
            Ms = "Desert Bandit [Lv. 60]"
            NameQuest = "DesertQuest"
            QuestLv = 1
            NameMon = "Desert Bandit"
            CFrameQ = CFrame.new(896.51721191406, 6.4384613037109, 4390.0961914063)
            CFrameMon = CFrame.new(932.78863525391, 16.815420150757, 4488.2578125)
        elseif Lv == 75 or Lv <= 89 or SelectMonster == "Desert Officer [Lv. 70]" then -- Desert Officer
            Ms = "Desert Officer [Lv. 70]"
            NameQuest = "DesertQuest"
            QuestLv = 2
            NameMon = "Desert Officer"
            CFrameQ = CFrame.new(896.51721191406, 6.4384613037109, 4390.0961914063)
            CFrameMon = CFrame.new(1590.4300537109, 1.5547214746475, 4366.4375)
        elseif Lv == 90 or Lv <= 99 or SelectMonster == "Snow Bandit [Lv. 90]" then -- Snow Bandit
            Ms = "Snow Bandit [Lv. 90]"
            NameQuest = "SnowQuest"
            QuestLv = 1
            NameMon = "Snow Bandit"
            CFrameQ = CFrame.new(1388.1298828125, 87.272789001465, -1297.0689697266)
            CFrameMon = CFrame.new(1330.4361572266, 105.94631195068, -1384.0131835938)
        elseif Lv == 100 or Lv <= 119 or SelectMonster == "Snowman [Lv. 100]" then -- Snowman
            Ms = "Snowman [Lv. 100]"
            NameQuest = "SnowQuest"
            QuestLv = 2
            NameMon = "Snowman"
            CFrameQ = CFrame.new(1388.1298828125, 87.272789001465, -1297.0689697266)
            CFrameMon = CFrame.new(1206.8278808594, 138.0200958252, -1489.5328369141)
        elseif Lv == 120 or Lv <= 149 or SelectMonster == "Chief Petty Officer [Lv. 120]" then -- Chief Petty Officer
            Ms = "Chief Petty Officer [Lv. 120]"
            NameQuest = "MarineQuest2"
            QuestLv = 1
            NameMon = "Chief Petty Officer"
            CFrameQ = CFrame.new(-5034.7568359375, 28.677835464478, 4324.3452148438)
            CFrameMon = CFrame.new(-4850.4956054688, 64.50959777832, 4046.5837402344)
        elseif Lv == 150 or Lv <= 174 or SelectMonster == "Sky Bandit [Lv. 150]" then -- Sky Bandit
            Ms = "Sky Bandit [Lv. 150]"
            NameQuest = "SkyQuest"
            QuestLv = 1
            NameMon = "Sky Bandit"
            CFrameQ = CFrame.new(-4841.9506835938, 717.66967773438, -2624.6960449219)
            CFrameMon = CFrame.new(-4980.3134765625, 278.41088867188, -2828.6323242188)
        elseif Lv == 175 or Lv <= 189 or SelectMonster == "Dark Master [Lv. 175]" then -- Dark Master
            Ms = "Dark Master [Lv. 175]"
            NameQuest = "SkyQuest"
            QuestLv = 2
            NameMon = "Dark Master"
            CFrameQ = CFrame.new(-4841.9506835938, 717.66967773438, -2624.6960449219)
            CFrameMon = CFrame.new(-5220.5854492188, 430.69317626953, -2278.5944824219)
        elseif Lv == 190 or Lv <= 209 or SelectMonster == "Prisoner [Lv. 190]" then -- Prisoner
            Ms = "Prisoner [Lv. 190]"
            NameQuest = "PrisonerQuest"
            QuestLv = 1
            NameMon = "Prisoner"
            CFrameQ = CFrame.new(5304.8725585938, 1.6770845651627, 474.69409179688)
            CFrameMon = CFrame.new(5413.962890625, 95.491775512695, 496.31735229492)
        elseif Lv == 210 or Lv <= 249 or SelectMonster == "Dangerous Prisoner [Lv. 210]" then -- Dangerous Prisoner
            Ms = "Dangerous Prisoner [Lv. 210]"
            NameQuest = "PrisonerQuest"
            QuestLv = 2
            NameMon = "Dangerous Prisoner"
            CFrameQ = CFrame.new(5304.8725585938, 1.6770845651627, 474.69409179688)
            CFrameMon = CFrame.new(5680.3383789063, 103.5811920166, 915.21636962891)
        elseif Lv == 250 or Lv <= 274 or SelectMonster == "Toga Warrior [Lv. 250]" then -- Toga Warrior
            Ms = "Toga Warrior [Lv. 250]"
            NameQuest = "ColosseumQuest"
            QuestLv = 1
            NameMon = "Toga Warrior"
            CFrameQ = CFrame.new(-1576.1175537109, 7.3893361091614, -2983.3071289063)
            CFrameMon = CFrame.new(-1773.8757324219, 44.607257843018, -2736.3547363281)
        elseif Lv == 275 or Lv <= 299 or SelectMonster == "Gladiator [Lv. 275]" then -- Gladiator
            Ms = "Gladiator [Lv. 275]"
            NameQuest = "ColosseumQuest"
            QuestLv = 2
            NameMon = "Gladiator"
            CFrameQ = CFrame.new(-1576.1175537109, 7.3893361091614, -2983.3071289063)
            CFrameMon = CFrame.new(-1284.4926757813, 52.352149963379, -3188.8718261719)
        elseif Lv == 300 or Lv <= 329 or SelectMonster == "Military Soldier [Lv. 300]" then -- Military Soldier
            Ms = "Military Soldier [Lv. 300]"
            NameQuest = "MagmaQuest"
            QuestLv = 1
            NameMon = "Military Soldier"
            CFrameQ = CFrame.new(-5311.0444335938, 12.262831687927, 8517.45703125)
            CFrameMon = CFrame.new(-5478.8334960938, 9.3517980575562, 8461.8662109375)
        elseif Lv == 330 or Lv <= 374 or SelectMonster == "Military Spy [Lv. 330]" then -- Military Spy
            Ms = "Military Spy [Lv. 330]"
            NameQuest = "MagmaQuest"
            QuestLv = 2
            NameMon = "Military Spy"
            CFrameQ = CFrame.new(-5311.0444335938, 12.262831687927, 8517.45703125)
            CFrameMon = CFrame.new(-5801.5278320313, 82.203330993652, 8829.0322265625)
        elseif Lv == 375 or Lv <= 399 or SelectMonster == "Fishman Warrior [Lv. 375]" then -- Fishman Warrior
            Ms = "Fishman Warrior [Lv. 375]"
            NameQuest = "FishmanQuest"
            QuestLv = 1
            NameMon = "Fishman Warrior"
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.6229248047)
            CFrameMon = CFrame.new(60876.60546875, 80.886016845703, 1437.0574951172)
        elseif Lv == 400 or Lv <= 449 or SelectMonster == "Fishman Commando [Lv. 400]" then -- Fishman Commando
            Ms = "Fishman Commando [Lv. 400]"
            NameQuest = "FishmanQuest"
            QuestLv = 2
            NameMon = "Fishman Commando"
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.6229248047)
            CFrameMon = CFrame.new(61880.45703125, 107.05615234375, 1014.4048461914)
        elseif Lv == 450 or Lv <= 474 or SelectMonster == "God's Guard [Lv. 450]" then -- God's Guard
            Ms = "God's Guard [Lv. 450]"
            NameQuest = "SkyExp1Quest"
            QuestLv = 1
            NameMon = "God's Guard"
            CFrameQ = CFrame.new(-4721.8530273438, 845.27661132813, -1913.8916015625)
            CFrameMon = CFrame.new(-4721.8530273438, 845.27661132813, -1913.8916015625)
        elseif Lv == 475 or Lv <= 524 or SelectMonster == "Shanda [Lv. 475]" then -- Shanda
            Ms = "Shanda [Lv. 475]"
            NameQuest = "SkyExp1Quest"
            QuestLv = 2
            NameMon = "Shanda"
            CFrameQ = CFrame.new(-7863.96484375, 5545.4921875, -379.83309936523)
            CFrameMon = CFrame.new(-7651.3374023438, 5620.3159179688, -1530.4815673828)
        elseif Lv == 525 or Lv <= 549 or SelectMonster == "Royal Squad [Lv. 525]" then -- Royal Squad
            Ms = "Royal Squad [Lv. 525]"
            NameQuest = "SkyExp2Quest"
            QuestLv = 1
            NameMon = "Royal Squad"
            CFrameQ = CFrame.new(-7903.4296875, 5634.58984375, -1416.3513183594)
            CFrameMon = CFrame.new(-7557.1938476563, 5615.091796875, -1280.9461669922)
        elseif Lv == 550 or Lv <= 624 or SelectMonster == "Royal Soldier [Lv. 550]" then -- Royal Soldier
            Ms = "Royal Soldier [Lv. 550]"
            NameQuest = "SkyExp2Quest"
            QuestLv = 2
            NameMon = "Royal Soldier"
            CFrameQ = CFrame.new(-7903.4296875, 5634.58984375, -1416.3513183594)
            CFrameMon = CFrame.new(-7822.6938476563, 5667.2241210938, -1790.1881103516)
        elseif Lv == 625 or Lv <= 649 or SelectMonster == "Galley Pirate [Lv. 625]" then -- Galley Pirate
            Ms = "Galley Pirate [Lv. 625]"
            NameQuest = "FountainQuest"
            QuestLv = 1
            NameMon = "Galley Pirate"
            CFrameQ = CFrame.new(5254.5844726563, 38.501136779785, 4050.4323730469)
            CFrameMon = CFrame.new(5737.828125, 38.527229309082, 3984.0310058594)
        elseif Lv == 650 or Lv <= 699 or SelectMonster == "Galley Captain [Lv. 650]" then -- Galley Captain
            Ms = "Galley Captain [Lv. 650]"
            NameQuest = "FountainQuest"
            QuestLv = 2
            NameMon = "Galley Captain"
            CFrameQ = CFrame.new(5254.5844726563, 38.501136779785, 4050.4323730469)
            CFrameMon = CFrame.new(5557.4370117188, 126.08460235596, 4983.2670898438)
        elseif Lv == 700 or Lv <= 724 or SelectMonster == "Raider [Lv. 700]" then -- Raider
            Ms = "Raider [Lv. 700]"
            NameQuest = "Area1Quest"
            QuestLv = 1
            NameMon = "Raider"
            CFrameQ = CFrame.new(-426.16735839844, 72.99494934082, 1836.9147949219)
            CFrameMon = CFrame.new(-820.22778320313, 39.117557525635, 1700.9815673828)
        elseif Lv == 725 or Lv <= 774 or SelectMonster == "Mercenary [Lv. 725]" then -- Mercenary
            Ms = "Mercenary [Lv. 725]"
            NameQuest = "Area1Quest"
            QuestLv = 2
            NameMon = "Mercenary"
            CFrameQ = CFrame.new(-426.16735839844, 72.99494934082, 1836.9147949219)
            CFrameMon = CFrame.new(-912.57702636719, 139.31837463379, 1210.3824462891)
        elseif Lv == 775 or Lv <= 799 or SelectMonster == "Swan Pirate [Lv. 775]" then -- Swan Pirate
            Ms = "Swan Pirate [Lv. 775]"
            NameQuest = "Area2Quest"
            QuestLv = 1
            NameMon = "Swan Pirate"
            CFrameQ = CFrame.new(635.61108398438, 73.045425415039, 917.87896728516)
            CFrameMon = CFrame.new(970.06982421875, 141.22067260742, 1226.2475585938)
        elseif Lv == 800 or Lv <= 874 or SelectMonster == "Factory Staff [Lv. 800]" then -- Factory Staff
            Ms = "Factory Staff [Lv. 800]"
            NameQuest = "Area2Quest"
            QuestLv = 2
            NameMon = "Factory Staff"
            CFrameQ = CFrame.new(635.61108398438, 73.045425415039, 917.87896728516)
            CFrameMon = CFrame.new(381.9873046875, 144.63572692871, 1379.1641845703)
        elseif Lv == 875 or Lv <= 899 or SelectMonster == "Marine Lieutenant [Lv. 875]" then -- Marine Lieutenant
            Ms = "Marine Lieutenant [Lv. 875]"
            NameQuest = "MarineQuest3"
            QuestLv = 1
            NameMon = "Marine Lieutenant"
            CFrameQ = CFrame.new(-2441.2243652344, 73.016342163086, -3217.3552246094)
            CFrameMon = CFrame.new(-2574.7294921875, 73.051223754883, -3339.7541503906)
        elseif Lv == 900 or Lv <= 949 or SelectMonster == "Marine Captain [Lv. 900]" then -- Marine Captain
            Ms = "Marine Captain [Lv. 900]"
            NameQuest = "MarineQuest3"
            QuestLv = 2
            NameMon = "Marine Captain"
            CFrameQ = CFrame.new(-2441.2243652344, 73.016342163086, -3217.3552246094)
            CFrameMon = CFrame.new(-1896.9180908203, 73.072105407715, -3425.5983886719)
        elseif Lv == 950 or Lv <= 974 or SelectMonster == "Zombie [Lv. 950]" then -- Zombie
            Ms = "Zombie [Lv. 950]"
            NameQuest = "ZombieQuest"
            QuestLv = 1
            NameMon = "Zombie"
            CFrameQ = CFrame.new(-5498.2568359375, 48.599689483643, -794.82928466797)
            CFrameMon = CFrame.new(-5636.3486328125, 126.06751251221, -697.0244140625)
        elseif Lv == 975 or Lv <= 999 or SelectMonster == "Vampire [Lv. 975]" then -- Vampire
            Ms = "Vampire [Lv. 975]"
            NameQuest = "ZombieQuest"
            QuestLv = 2
            NameMon = "Vampire"
            CFrameQ = CFrame.new(-5498.2568359375, 48.599689483643, -794.82928466797)
            CFrameMon = CFrame.new(-6032.078125, 6.4026374816895, -1311.7435302734)
        elseif Lv == 1000 or Lv <= 1049 or SelectMonster == "Snow Trooper [Lv. 1000]" then -- Snow Trooper
            Ms = "Snow Trooper [Lv. 1000]"
            NameQuest = "SnowMountainQuest"
            QuestLv = 1
            NameMon = "Snow Trooper"
            CFrameQ = CFrame.new(604.09344482422, 401.42477416992, -5371.1201171875)
            CFrameMon = CFrame.new(537.18084716797, 401.42477416992, -5320.0776367188)
        elseif Lv == 1050 or Lv <= 1099 or SelectMonster == "Winter Warrior [Lv. 1050]" then -- Winter Warrior
            Ms = "Winter Warrior [Lv. 1050]"
            NameQuest = "SnowMountainQuest"
            QuestLv = 2
            NameMon = "Winter Warrior"
            CFrameQ = CFrame.new(604.09344482422, 401.42477416992, -5371.1201171875)
            CFrameMon = CFrame.new(1267.1978759766, 429.79443359375, -5172.7934570313)
        elseif Lv == 1100 or Lv <= 1124 or SelectMonster == "Lab Subordinate [Lv. 1100]" then -- Lab Subordinate
            Ms = "Lab Subordinate [Lv. 1100]"
            NameQuest = "IceSideQuest"
            QuestLv = 1
            NameMon = "Lab Subordinate"
            CFrameQ = CFrame.new(-6062.4741210938, 15.852040290833, -4903.8198242188)
            CFrameMon = CFrame.new(-5742.8579101563, 14.419458389282, -4482.4033203125)
        elseif Lv == 1125 or Lv <= 1174 or SelectMonster == "Horned Warrior [Lv. 1125]" then -- Horned Warrior
            Ms = "Horned Warrior [Lv. 1125]"
            NameQuest = "IceSideQuest"
            QuestLv = 2
            NameMon = "Horned Warrior"
            CFrameQ = CFrame.new(-6062.4741210938, 15.852040290833, -4903.8198242188)
            CFrameMon = CFrame.new(-6400.8461914063, 64.474433898926, -5913.2016601563)
        elseif Lv == 1175 or Lv <= 1199 or SelectMonster == "Magma Ninja [Lv. 1175]" then -- Magma Ninja
            Ms = "Magma Ninja [Lv. 1175]"
            NameQuest = "FireSideQuest"
            QuestLv = 1
            NameMon = "Magma Ninja"
            CFrameQ = CFrame.new(-5428.9536132813, 15.977565765381, -5296.6069335938)
            CFrameMon = CFrame.new(-5538.697265625, 61.051025390625, -5835.6015625)
        elseif Lv == 1200 or Lv <= 1249 or SelectMonster == "Lava Pirate [Lv. 1200]" then -- Lava Pirate
            Ms = "Lava Pirate [Lv. 1200]"
            NameQuest = "FireSideQuest"
            QuestLv = 2
            NameMon = "Lava Pirate"
            CFrameQ = CFrame.new(-5428.9536132813, 15.977565765381, -5296.6069335938)
            CFrameMon = CFrame.new(-5199.9404296875, 5.5862407684326, -4738.1557617188)
        elseif Lv == 1250 or Lv <= 1274 or SelectMonster == "Ship Deckhand [Lv. 1250]" then -- Ship Deckhand
            Ms = "Ship Deckhand [Lv. 1250]"
            NameQuest = "ShipQuest1"
            QuestLv = 1
            NameMon = "Ship Deckhand"
            CFrameQ = CFrame.new(1036.9692382813, 125.09281158447, 32911.62109375)
            CFrameMon = CFrame.new(1229.8333740234, 130.24794006348, 33060.203125)
        elseif Lv == 1275 or Lv <= 1299 or SelectMonster == "Ship Engineer [Lv. 1275]" then -- Ship Engineer
            Ms = "Ship Engineer [Lv. 1275]"
            NameQuest = "ShipQuest1"
            QuestLv = 2
            NameMon = "Ship Engineer"
            CFrameQ = CFrame.new(1036.9692382813, 125.09281158447, 32911.62109375)
            CFrameMon = CFrame.new(917.68328857422, 40.765487670898, 33111.33203125)
        elseif Lv == 1300 or Lv <= 1324 or SelectMonster == "Ship Steward [Lv. 1300]" then -- Ship Steward
            Ms = "Ship Steward [Lv. 1300]"
            NameQuest = "ShipQuest2"
            QuestLv = 1
            NameMon = "Ship Steward"
              CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
              CFrameMon = CFrame.new(943.85504150391, 129.58183288574, 33444.3671875)
        elseif Lv == 1500 or Lv <= 1524 or SelectMonster == "Pirate Millionaire [Lv. 1500]" then -- Pirate Millionaire
            Ms = "Pirate Millionaire [Lv. 1500]"
            NameQuest = "PiratePortQuest"
            QuestLv = 1
            NameMon = "Pirate Millionaire"
            CFrameQ = CFrame.new(-290.07495117188, 43.446998596191, 5583.6083984375)
            CFrameMon = CFrame.new(-300.03125, 78.39949798584, 5891.2978515625)
        elseif Lv == 1525 or Lv <= 1574 or SelectMonster == "Pistol Billionaire [Lv. 1525]" then -- Pistol Billionaire
            Ms = "Pistol Billionaire [Lv. 1525]"
            NameQuest = "PiratePortQuest"
            QuestLv = 2
            NameMon = "Pistol Billionaire"
            CFrameQ = CFrame.new(-290.07495117188, 43.446998596191, 5583.6083984375)
            CFrameMon = CFrame.new(-408.10223388672, 111.35120391846, 6002.5732421875)
        elseif Lv == 1575 or Lv <= 1599 or SelectMonster == "Dragon Crew Warrior [Lv. 1575]" then -- Dragon Crew Warrior
            Ms = "Dragon Crew Warrior [Lv. 1575]"
            NameQuest = "AmazonQuest"
            QuestLv = 1
            NameMon = "Dragon Crew Warrior"
            CFrameQ = CFrame.new(5831.7954101563, 51.68078994751, -1103.9226074219)
            CFrameMon = CFrame.new(6550.498046875, 86.321968078613, -1717.611328125)
        elseif Lv == 1600 or Lv <= 1624 or SelectMonster == "Dragon Crew Archer [Lv. 1600]" then -- Dragon Crew Archer
            Ms = "Dragon Crew Archer [Lv. 1600]"
            NameQuest = "AmazonQuest"
            QuestLv = 2
            NameMon = "Dragon Crew Archer"
            CFrameQ = CFrame.new(5831.7954101563, 51.68078994751, -1103.9226074219)
            CFrameMon = CFrame.new(6883.1518554688, 96.27384185791, -1398.5769042969)
        elseif Lv == 1625 or Lv <= 1649 or SelectMonster == "Female Islander [Lv. 1625]" then -- Female Islander
            Ms = "Female Islander [Lv. 1625]"
            NameQuest = "AmazonQuest2"
            QuestLv = 1
            NameMon = "Female Islander"
            CFrameQ = CFrame.new(5445.0991210938, 601.60339355469, 750.51159667969)
            CFrameMon = CFrame.new(5048.2197265625, 722.56481933594, 38.123291015625)
        elseif Lv == 1650 or Lv <= 1699 or SelectMonster == "Giant Islander [Lv. 1650]" then -- Giant Islander
            Ms = "Giant Islander [Lv. 1650]"
            NameQuest = "AmazonQuest2"
            QuestLv = 2
            NameMon = "Giant Islander"
            CFrameQ = CFrame.new(5445.0991210938, 601.60339355469, 750.51159667969)
            CFrameMon = CFrame.new(4857.7841796875, 646.37316894531, -90.339111328125)
        elseif Lv == 1700 or Lv <= 1724 or SelectMonster == "Marine Commodore [Lv. 1700]" then -- Marine Commodore
            Ms = "Marine Commodore [Lv. 1700]"
            NameQuest = "MarineTreeIsland"
            QuestLv = 1
            NameMon = "Marine Commodore"
            CFrameQ = CFrame.new(2180.3466796875, 28.671403884888, -6738.6274414063)
            CFrameMon = CFrame.new(2163.2631835938, 139.1724395752, -7021.5639648438)
        elseif Lv == 1725 or Lv <= 1774 or SelectMonster == "Marine Rear Admiral [Lv. 1725]" then -- Marine Rear Admiral
            Ms = "Marine Rear Admiral [Lv. 1725]"
            NameQuest = "MarineTreeIsland"
            QuestLv = 2
            NameMon = "Marine Rear Admiral"
            CFrameQ = CFrame.new(2180.3466796875, 28.671403884888, -6738.6274414063)
            CFrameMon = CFrame.new(3556.5708007813, 200.23704528809, -6316.0458984375)
        elseif Lv == 1775 or Lv <= 1799 or SelectMonster == "Fishman Raider [Lv. 1775]" then -- Fishman Raider
            Ms = "Fishman Raider [Lv. 1775]"
            NameQuest = "DeepForestIsland3"
            QuestLv = 1
            NameMon = "Fishman Raider"
            CFrameQ = CFrame.new(-10581.640625, 331.78820800781, -8761.8515625)
            CFrameMon = CFrame.new(-10592.190429688, 365.07907104492, -8311.34765625)
        elseif Lv == 1800 or Lv <= 1824 or SelectMonster == "Fishman Captain [Lv. 1800]" then -- Fishman Captain
            Ms = "Fishman Captain [Lv. 1800]"
            NameQuest = "DeepForestIsland3"
            QuestLv = 2
            NameMon = "Fishman Captain"
            CFrameQ = CFrame.new(-10581.640625, 331.78820800781, -8761.8515625)
            CFrameMon = CFrame.new(-10982.04296875, 401.80584716797, -8507.5244140625)
        elseif Lv == 1825 or Lv <= 1849 or SelectMonster == "Forest Pirate [Lv. 1825]" then -- Forest Pirate
            Ms = "Forest Pirate [Lv. 1825]"
            NameQuest = "DeepForestIsland"
            QuestLv = 1
            NameMon = "Forest Pirate"
            CFrameQ = CFrame.new(-12182.08984375, 389.97189331055, -9926.8857421875)
            CFrameMon = CFrame.new(-12346.573242188, 409.79513549805, -9781.666015625)
        elseif Lv == 1850 or Lv <= 1899 or SelectMonster == "Mythological Pirate [Lv. 1850]" then -- Mythological Pirate
            Ms = "Mythological Pirate [Lv. 1850]"
            NameQuest = "DeepForestIsland"
            QuestLv = 2
            NameMon = "Mythological Pirate"
            CFrameQ = CFrame.new(-12182.08984375, 389.97189331055, -9926.8857421875)
            CFrameMon = CFrame.new(-13318.655273438, 419.28674316406, -10057.713867188)
        elseif Lv == 1900 or Lv <= 1924 or SelectMonster == "Jungle Pirate [Lv. 1900]" then -- Jungle Pirate
            Ms = "Jungle Pirate [Lv. 1900]"
            NameQuest = "DeepForestIsland2"
            QuestLv = 1
            NameMon = "Jungle Pirate"
            CFrameQ = CFrame.new(-11971.19140625, 335.20614624023, -10473.947265625)
            CFrameMon = CFrame.new(-12296.948242188, 332.75323486328, -10573.1953125)
        elseif Lv == 1925 or Lv <= 1974 or SelectMonster == "Musketeer Pirate [Lv. 1925]" then -- Musketeer Pirate
            Ms = "Musketeer Pirate [Lv. 1925]"
            NameQuest = "DeepForestIsland2"
            QuestLv = 2
            NameMon = "Musketeer Pirate"
            CFrameQ = CFrame.new(-11971.19140625, 335.20614624023, -10473.947265625)
            CFrameMon = CFrame.new(-13281.209960938, 523.24011230469, -7903.625)
        elseif Lv == 1975 or Lv <= 1999 or SelectMonster == "Reborn Skeleton [Lv. 1975]" then -- Reborn Skeleton
            Ms = "Reborn Skeleton [Lv. 1975]"
            NameQuest = "HauntedQuest1"
            QuestLv = 1
            NameMon = "Reborn Skeleton"
            CFrameQ = CFrame.new(-9480.9404296875, 142.13009643555, 5566.0712890625)
            CFrameMon = CFrame.new(-8761.85546875, 184.55258178711, 6161.6064453125)
        elseif Lv == 2000 or Lv <= 2024 or SelectMonster == "Living Zombie [Lv. 2000]" then -- Living Zombie
            Ms = "Living Zombie [Lv. 2000]"
            NameQuest = "HauntedQuest1"
            QuestLv = 2
            NameMon = "Living Zombie"
            CFrameQ = CFrame.new(-9480.9404296875, 142.13009643555, 5566.0712890625)
            CFrameMon = CFrame.new(-10120.711914063, 237.30313110352, 6173.3002929688)
        elseif Lv == 2025 or Lv <= 2049 or SelectMonster == "Demonic Soul [Lv. 2025]" then -- Demonic Soul
            Ms = "Demonic Soul [Lv. 2025]"
            NameQuest = "HauntedQuest2"
            QuestLv = 1
            NameMon = "Demonic Soul"
            CFrameQ = CFrame.new(-9515.2373046875, 172.13009643555, 6070.5932617188)
            CFrameMon = CFrame.new(-9509.2919921875, 288.78509521484, 6112.8515625)
        elseif Lv == 2050 or Lv <= 2074 or SelectMonster == "Posessed Mummy [Lv. 2050]" then -- Posessed Mummy
            Ms = "Posessed Mummy [Lv. 2050]"
            NameQuest = "HauntedQuest2"
            QuestLv = 2
            NameMon = "Posessed Mummy"
            CFrameQ = CFrame.new(-9515.2373046875, 172.13009643555, 6070.5932617188)
            CFrameMon = CFrame.new(-9584.58984375, 0.68255853652954, 6149.896484375)
        elseif Lv == 2075 or Lv <= 2099 or SelectMonster == "Peanut Scout [Lv. 2075]" then -- Peanut Scout
            Ms = "Peanut Scout [Lv. 2075]"
            NameQuest = "NutsIslandQuest"
            QuestLv = 1
            NameMon = "Peanut Scout"
            CFrameQ = CFrame.new(-2103.5913085938, 38.237865448952, -10192.3359375)
            CFrameMon = CFrame.new(-2007.0635986328, 192.96649169922, -10505.688476563)
        elseif Lv == 2100 or Lv <= 2124 or SelectMonster == "Peanut President [Lv. 2100]" then -- Peanut President
            Ms = "Peanut President [Lv. 2100]"
            NameQuest = "NutsIslandQuest"
            QuestLv = 2
            NameMon = "Peanut President"
            CFrameQ = CFrame.new(-2103.5913085938, 38.237865448952, -10192.3359375)
            CFrameMon = CFrame.new(-2412.8657226563, 193.3244934082, -10442.198242188)
        elseif Lv == 2125 or Lv <= 2149 or SelectMonster == "Ice Cream Chef [Lv. 2125]" then -- Ice Cream Chef
            Ms = "Ice Cream Chef [Lv. 2125]"
            NameQuest = "IceCreamIslandQuest"
            QuestLv = 1
            NameMon = "Ice Cream Chef"
            CFrameQ = CFrame.new(-820.01672363281, 65.845916748047, -10965.307617188)
            CFrameMon = CFrame.new(-819.25402832031, 137.17877197266, -11132.268554688)
        elseif Lv == 2150 or Lv <= 2199 or SelectMonster == "Ice Cream Commander [Lv. 2150]" then -- Ice Cream Commander
            Ms = "Ice Cream Commander [Lv. 2150]"
            NameQuest = "IceCreamIslandQuest"
            QuestLv = 2
            NameMon = "Ice Cream Commander"
            CFrameQ = CFrame.new(-820.01672363281, 65.845916748047, -10965.307617188)
            CFrameMon = CFrame.new(-612.80773925781, 123.41924285889, -11200.526367188)
        elseif Lv == 2200 or Lv <= 2224 or SelectMonster == "Cookie Crafter [Lv. 2200]" then -- Cookie Crafter
            Ms = "Cookie Crafter [Lv. 2200]"
            NameQuest = "CakeQuest1"
            QuestLv = 1
            NameMon = "Cookie Crafter"
            CFrameQ = CFrame.new(-2021.7159423828, 37.715064025879, -12027.170898438)
            CFrameMon = CFrame.new(-2280.9560546875, 109.59239959717, -12008.977539063)
        elseif Lv == 2225 or Lv <= 2249 or SelectMonster == "Cake Guard [Lv. 2225]" then -- Cake Guard
            Ms = "Cake Guard [Lv. 2225]"
            NameQuest = "CakeQuest1"
            QuestLv = 2
            NameMon = "Cake Guard"
            CFrameQ = CFrame.new(-2021.7159423828, 37.715064025879, -12027.170898438)
            CFrameMon = CFrame.new(-1821.50390625, 198.77183532715, -12294.140625)
        elseif Lv == 2250 or Lv <= 2274 or SelectMonster == "Baking Staff [Lv. 2250]" then -- Baking Staff
            Ms = "Baking Staff [Lv. 2250]"
            NameQuest = "CakeQuest2"
            QuestLv = 1
            NameMon = "Baking Staff"
            CFrameQ = CFrame.new(-1927.1654052734, 37.715064025879, -12842.297851563)
            CFrameMon = CFrame.new(-1784.3166503906, 172.10333251953, -12996.287109375)
        elseif Lv == 2275 or Lv <= 2299 or SelectMonster == "Head Baker [Lv. 2275]" then -- Head Baker
            Ms = "Head Baker [Lv. 2275]"
            NameQuest = "CakeQuest2"
            QuestLv = 2
            NameMon = "Head Baker"
            CFrameQ = CFrame.new(-1927.1654052734, 37.715064025879, -12842.297851563)
            CFrameMon = CFrame.new(-2148.2434082031, 59.873249053955, -12876.280273438)
        elseif Lv == 2300 or Lv <= 2324 or SelectMonster == "Cocoa Warrior [Lv. 2300]" then -- Cocoa Warrior
            Ms = "Cocoa Warrior [Lv. 2300]"
            NameQuest = "ChocQuest1"
            QuestLv = 1
            NameMon = "Cocoa Warrior"
            CFrameQ = CFrame.new(231.17417907715, 23.789911270142, -12188.489257813)
            CFrameMon = CFrame.new(118.34308624268, 87.872886657715, -12448.081054688)
        elseif Lv == 2325 or Lv <= 2349 or SelectMonster == "Chocolate Bar Battler [Lv. 2325]" then -- Chocolate Bar Battler
            Ms = "Chocolate Bar Battler [Lv. 2325]"
            NameQuest = "ChocQuest1"
            QuestLv = 2
            NameMon = "Chocolate Bar Battler"
            CFrameQ = CFrame.new(231.17417907715, 23.789911270142, -12188.489257813)
            CFrameMon = CFrame.new(148.01568603516, 66.174537658691, -12734.663085938)
        elseif Lv == 2350 or Lv <= 2374 or SelectMonster == "Sweet Thief [Lv. 2350]" then -- Sweet Thief
            Ms = "Sweet Thief [Lv. 2350]"
            NameQuest = "ChocQuest2"
            QuestLv = 1
            NameMon = "Sweet Thief"
            CFrameQ = CFrame.new(1497.3482666016, 23.789911270142, -12631.935546875)
            CFrameMon = CFrame.new(1717.1370849609, 23.789911270142, -12560.155273438)
        elseif Lv == 2375 or Lv <= 2400 or SelectMonster == "Candy Rebel [Lv. 2375]" then -- Candy Rebel
            Ms = "Candy Rebel [Lv. 2375]"
            NameQuest = "ChocQuest2"
            QuestLv = 2
            NameMon = "Candy Rebel"
            CFrameQ = CFrame.new(1497.3482666016, 23.789911270142, -12631.935546875)
            CFrameMon = CFrame.new(1490.8382568359, 87.872886657715, -12983.454101563)
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
            local player = game:GetService("Players").LocalPlayer
            local playerGui = player.PlayerGui
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local workspace = game:GetService("Workspace")

            if playerGui.Main.Quest.Visible == false then
                MagnetActive = false
                CheckLevel()
                TP(CFrameQ)
                if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    wait(1.1)
                    CheckLevel()
                    if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        replicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        replicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    else
                        TP(CFrameQ)
                    end
                end
            elseif playerGui.Main.Quest.Visible == true then
                pcall(function()
                    CheckLevel()
                    local enemies = workspace.Enemies
                    if enemies:FindFirstChild(Ms) then
                        for _, v in pairs(enemies:GetChildren()) do
                            if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                repeat
                                    game:GetService("RunService").Heartbeat:wait()
                                    pcall(function()
                                        EquipWeapon(SelectToolWeapon)
                                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 25))
                                        require(player.PlayerScripts.CombatFramework).activeController.hitboxMagnitude = 1000
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                        sethiddenproperty(player, "SimulationRadius", math.huge)
                                    end)
                                until not v.Parent or v.Humanoid.Health <= 0 or not Auto_Farm or playerGui.Main.Quest.Visible == false or not enemies:FindFirstChild(v.Name)
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
spawn(function()
    while wait() do
        if Auto_Farm then
            local player = game:GetService("Players").LocalPlayer
            local playerGui = player.PlayerGui
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local workspace = game:GetService("Workspace")

            if playerGui.Main.Quest.Visible == false then
                MagnetActive = false
                CheckLevel()
                TP(CFrameQ)
                if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    wait(1.1)
                    CheckLevel()
                    if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        replicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        replicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    else
                        TP(CFrameQ)
                    end
                end
            elseif playerGui.Main.Quest.Visible == true then
                pcall(function()
                    CheckLevel()
                    local enemies = workspace.Enemies
                    if enemies:FindFirstChild(Ms) then
                        for _, v in pairs(enemies:GetChildren()) do
                            if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                repeat
                                    game:GetService("RunService").Heartbeat:wait()
                                    pcall(function()
                                        EquipWeapon(SelectToolWeapon)
                                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 25))
                                        require(player.PlayerScripts.CombatFramework).activeController.hitboxMagnitude = 1000
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                        sethiddenproperty(player, "SimulationRadius", math.huge)
                                    end)
                                until not v.Parent or v.Humanoid.Health <= 0 or not Auto_Farm or playerGui.Main.Quest.Visible == false or not enemies:FindFirstChild(v.Name)
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

local function MagnetNPCs()
    local workspace = game:GetService("Workspace")
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-10, 10), 0, math.random(-10, 10))
        end
    end
end

spawn(function()
    while wait() do
        if Auto_Farm then
            local player = game:GetService("Players").LocalPlayer
            local playerGui = player.PlayerGui
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local workspace = game:GetService("Workspace")

            if playerGui.Main.Quest.Visible == false then
                MagnetActive = false
                CheckLevel()
                TP(CFrameQ)
                if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    wait(1.1)
                    CheckLevel()
                    if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        replicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        replicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    else
                        TP(CFrameQ)
                    end
                end
            elseif playerGui.Main.Quest.Visible == true then
                pcall(function()
                    CheckLevel()
                    local enemies = workspace.Enemies
                    if enemies:FindFirstChild(Ms) then
                        MagnetNPCs()
                        for _, v in pairs(enemies:GetChildren()) do
                            if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                repeat
                                    game:GetService("RunService").Heartbeat:wait()
                                    pcall(function()
                                        EquipWeapon(SelectToolWeapon)
                                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 25))
                                        require(player.PlayerScripts.CombatFramework).activeController.hitboxMagnitude = 1000
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                        sethiddenproperty(player, "SimulationRadius", math.huge)
                                    end)
                                until not v.Parent or v.Humanoid.Health <= 0 or not Auto_Farm or playerGui.Main.Quest.Visible == false or not enemies:FindFirstChild(v.Name)
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
