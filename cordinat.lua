local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end

local tools = {}

for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	if v:IsA("Tool") then
		table.insert(tools, v.Name)
	end
end

---autofarm Level
---lv 0-10
function CheckQuest()
	local Lv = game.Players.LocalPlayer.Data.Level.Value
	if Lv == 0 or Lv <= 10 then
		Ms = "Bandit [Lv. 5]"
		NM = "Bandit"
		LQ = 1
		NQ = "BanditQuest1"
		CQ = CFrame.new(1062.64697265625, 16.516624450683594, 1546.55224609375)
	end
end

function TP(P)
	local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	local Speed
	if Distance < 10 then
		Speed = 1000
	elseif Distance < 170 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
		Speed = 350
	elseif Distance < 1000 then
		Speed = 350
	elseif Distance >= 1000 then
		Speed = 300
	end
	game:GetService("TweenService"):Create(
		game.Players.LocalPlayer.Character.HumanoidRootPart,
		TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
		{CFrame = P}
	):Play()
end

spawn(function()
	while task.wait() do
		if _G.AutoFarm then
			CheckQuest()
			if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
				TP(CQ)
				task.wait(0.9)
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NQ,LQ)
			elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if v.Name == Ms then
						TP(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
						v.HumanoidRootPart.Size = Vector3.new(60,60,60)
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
				game:GetService'VirtualUser':Button1Down(Vector2.new(0,1,0,1))
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
	end
})

game.Players.LocalPlayer.Backpack.DescendantAdded:Connect(function(tool)
	local toolName = tool.Name
	if tool:IsA("Tool") then
		table.insert(tools, toolName)
		toolDropdown:Refresh(tools)
	end
end)

game.Players.LocalPlayer.Backpack.DescendantRemoving:Connect(function(tool)
	local toolName = tool.Name
	if tool:IsA("Tool") then
		for i,v in pairs(tools) do
			if v == toolName then
				table.remove(tools, i)
			end
		end	
	end
	toolDropdown:Refresh(tools)
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

StatsSection:AddToggle({
	Name = "Meele",
	Default = false,
	Callback = function(state)
		_G.autoMeeleStats = state
		while _G.autoMeeleStats do
			local args = {
				[1] = "AddPoint",
				[2] = "Melee",
				[3] = 1
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			task.wait(30)
		end
	end
})

StatsSection:AddToggle({
	Name = "Defense",
	Default = false,
	Callback = function(state)
		_G.autoDefenseStats = state
		while _G.autoDefenseStats do
			local args = {
				[1] = "AddPoint",
				[2] = "Defense",
				[3] = 1
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			task.wait(30)
		end
	end
})

StatsSection:AddToggle({
	Name = "Sword",
	Default = false,
	Callback = function(state)
		_G.autoSword = state
		while _G.autoSword do
			local args = {
				[1] = "AddPoint",
				[2] = "Sword",
				[3] = 1
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			task.wait(30)
		end
	end
})

StatsSection:AddToggle({
	Name = "Gun",
	Default = false,
	Callback = function(state)
		_G.autoGun = state
		while _G.autoGun do
			local args = {
				[1] = "AddPoint",
				[2] = "Gun",
				[3] = 1
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			task.wait(30)
		end
	end
})

StatsSection:AddToggle({
	Name = "Devil Fruit",
	Default = false,
	Callback = function(state)
		_G.autoDevilFruit = state
		while _G.autoDevilFruit do
			local args = {
				[1] = "AddPoint",
				[2] = "Demon Fruit",
				[3] = 1
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			task.wait(30)
		end
	end
})

---Teleport
local Teleport = Window:MakeTab({
	Name = "Teleport",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local TeleportSection = Teleport:AddSection({
	Name = "Teleport"
})

TeleportSection:AddButton({
	Name = "Pirate Island",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(1041.8861083984375, 16.273563385009766, 1424.93701171875)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Marine Island",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-2896.6865234375, 41.488861083984375, 2009.27490234375)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Colosseum",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-1541.0882568359375, 7.389348983764648, -2987.40576171875)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Desert",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(1094.3209228515625, 6.569626808166504, 4231.6357421875)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Fountain City",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(5529.7236328125, 429.35748291015625, 4245.5498046875)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Jungle",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-1615.1883544921875, 36.85209655761719, 150.80490112304688)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Marine Fort",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-4846.14990234375, 20.652048110961914, 4393.65087890625)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Middle Town",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-705.99755859375, 7.852255344390869, 1547.5216064453125)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Prison",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(4841.84423828125, 5.651970863342285, 741.329833984375)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Pirate Village",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-1146.42919921875, 4.752060890197754, 3818.503173828125)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Sky 1",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-4967.8369140625, 717.6719970703125, -2623.84326171875)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Sky 2",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-7876.0771484375, 5545.58154296875, -381.19927978515625)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Snow",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(1100.361328125, 5.290674209594727, -1151.5418701171875)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Under Water",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(61135.29296875, 18.47164535522461, 1597.6827392578125)}):Play()
	end
})

TeleportSection:AddButton({
	Name = "Magma Village",
	Callback = function()
		tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(45, Enum.EasingStyle.Linear)
		tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(-5248.27197265625, 8.699088096618652, 8452.890625)}):Play()
	end
})
