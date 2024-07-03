local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end

local tools = {}

for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	if v:IsA("Tool") then
		table.insert(tools, v.Name)
	end
end

local Auto_Farm = false
local SelectToolWeapon = ""
local SelectWeaponBoss = ""
local MagnetActive = false
local Farm_Mode = CFrame.new(0, 20, 0)
local PosMon = nil
local FastAttack = false

function CheckLevel()
	local Lv = game.Players.LocalPlayer.Data.Level.Value
	if Lv == 0 or Lv <= 10 then
		Ms = "Bandit [Lv. 5]"
		NameQuest = "BanditQuest1"
		QuestLv = 1
		NameMon = "Bandit"
		CFrameQ = CFrame.new(1062.64697265625, 16.516624450683594, 1546.55224609375)
		CFrameMon = nil
	elseif Lv == 10 or Lv <= 14 or SelectMonster == "Monkey [Lv. 14]" then
		Ms = "Monkey [Lv. 14]"
		NameQuest = "JungleQuest"
		QuestLv = 1
		NameMon = "Monkey"
		CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
		CFrameMon = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
	elseif Lv == 15 or Lv <= 29 or SelectMonster == "Gorilla [Lv. 20]" then
		Ms = "Gorilla [Lv. 20]"
		NameQuest = "JungleQuest"
		QuestLv = 2
		NameMon = "Gorilla"
		CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
		CFrameMon = CFrame.new(-1142.6488037109, 40.462348937988, -515.39227294922)
	elseif Lv == 30 atau Lv <= 39 or SelectMonster == "Pirate [Lv. 35]" then
		Ms = "Pirate [Lv. 35]"
		NameQuest = "BuggyQuest1"
		QuestLv = 1
		NameMon = "Pirate"
		CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
		CFrameMon = CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
	end
end

function TP(P)
	local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	local Speed = 300
	if Distance < 10 then
		Speed = 1000
	elseif Distance < 170 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
		Speed = 350
	elseif Distance < 1000 then
		Speed = 350
	end
	game:GetService("TweenService"):Create(
		game.Players.LocalPlayer.Character.HumanoidRootPart,
		TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
		{CFrame = P}
	):Play()
end

function Click()
	game:GetService'VirtualUser':CaptureController()
	game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
end

spawn(function()
	while task.wait() do
		if Auto_Farm then
			if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
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
			elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
				pcall(function()
					CheckLevel()
					if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
						for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
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
									until not v.Parent or v.Humanoid.Health <= 0 or not Auto_Farm or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible or not game:GetService("Workspace").Enemies:FindFirstChild(v.Name)
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

local Window = OrionLib:MakeWindow({Name = "BloxFruits Script Test", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

---Main
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
		SelectToolWeapon = weapon
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
	Name = "AutoFarm Level",
	Default = false,
	Callback = function(vu)
		_G.AutoFarm = vu
		Magnet = vu
		if _G.AutoFarm and SelectToolWeapon == "" then
			ui:Notification("AutoFarm", "SelectWeapon First", 2)
		else
			Auto_Farm = vu
			SelectMonster = ""
			if not vu then
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

MainSection:AddToggle({
	Name = "Fast Attack",
	Default = false,
	Callback = function(Value)
		FastAttack = Value
	end
})

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
			TP(position)
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
