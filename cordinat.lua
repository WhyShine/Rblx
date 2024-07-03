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

OrionLib:Init()
