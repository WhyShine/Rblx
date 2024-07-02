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

function CheckQuest()
	local Lv = game.Players.LocalPlayer.Data.Level.Value
	if Lv == 0 or Lv <= 10 then
		Ms = "Bandit [Lv. 5]"
		NameQuest = "BanditQuest1"
		QuestLv = 1
		NameMon = "Bandit"
		CFrameQ = CFrame.new(1062.64697265625, 16.516624450683594, 1546.55224609375)
		CFrameMon = nil -- Tidak diperlukan untuk level ini
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
	elseif Lv == 30 or Lv <= 39 or SelectMonster == "Pirate [Lv. 35]" then
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
	local Speed = 300 -- Default speed for large distances
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

spawn(function()
	while task.wait() do
		if _G.AutoFarm then
			CheckQuest()
			if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
				TP(CFrameQ)
				task.wait(0.9)
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
			else
				for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if v.Name == Ms then
						TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
						v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
					end
				end
			end
		end
	end
end)

spawn(function()
	game:GetService("RunService").RenderStepped:Connect(function()
		if _G.AutoFarm then
			pcall(function()
				game:GetService'VirtualUser':CaptureController()
				game:GetService'VirtualUser':Button1Down(Vector2.new(0, 1, 0, 1))
			end)
		end
	end)
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
		-- Add logic to use the selected weapon
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
		_G.AutoFarm = state
	end
})

MainSection:AddTextbox({
	Name = "Fake Beli",
	Default = "",
	TextDisappear = true,
	Callback = function(fakebeli)
		game.Players.LocalPlayer.Data.Level.Value = fakebeli
	end
})

---Stats
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

---Teleport
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
			local tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
			tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = position}):Play()
		end
	})
end

AddTeleportButton("Pirate Island", CFrame.new(1041.8861083984375, 16.273563385009766, 1424.93701171875))
AddTeleportButton("Marine Island", CFrame.new(-2896.6865234375, 41.488861083984375, 2009.27490234375))
AddTeleportButton("Colosseum", CFrame.new(-1541.0882568359375, 7.389348983764648, -2987.40576171875))
AddTeleportButton("Desert", CFrame.new(1094.3209228515625, 6.569626808166504, 4231.6357421875))
AddTeleportButton("Fountain City", CFrame.new(5529.7236328125, 429.35748291015625, 4245.5498046875))
AddTeleportButton("Jungle", CFrame.new(-1615.1883544921875, 36.85209655761719, 150.80490112304688))
AddTeleportButton("Marine Fort", CFrame.new(-4846.14990234375, 20.652048110961914, 4393.65087890625))
AddTeleportButton("Middle Town", CFrame.new(-705.99755859375, 7.852255344390869, 1547.3697509765625))
AddTeleportButton("Sky Island 1", CFrame.new(-4846.14990234375, 717.6875610351562, -2622.3544921875))
AddTeleportButton("Sky Island 2", CFrame.new(-7891.73681640625, 5545.5283203125, -380.2913818359375))
AddTeleportButton("Under Water City", CFrame.new(61163.8515625, 11.75231647491455, 1818.8211669921875))
AddTeleportButton("Prison", CFrame.new(4851.97265625, 5.651928424835205, 734.74658203125))

OrionLib:Init()
