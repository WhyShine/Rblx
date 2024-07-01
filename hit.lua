local Notification = require(game:GetService("ReplicatedStorage").Notification)

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Blox Fruit GUI",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BloxFruitConfig",
    IntroEnabled = false,
    IntroText = "Welcome",
    DefaultSettings = {
        Position = UDim2.new(0.5, 0, 0.5, 0), -- Center position
        Size = UDim2.new(0.25, 0, 0.35, 0) -- Smaller size
    }
})

local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LogTab = Window:MakeTab({
    Name = "Logs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local logText = ""
local logFrame = LogTab:AddSection({
    Name = "Log Box"
})

local logBox = Instance.new("TextBox")
logBox.Size = UDim2.new(1, 0, 1, 0)
logBox.TextWrapped = true
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.ClearTextOnFocus = false
logBox.BackgroundTransparency = 1
logBox.Text = logText
logBox.Parent = logFrame.Frame

local function log(message)
    logText = logText .. "\n" .. message
    logBox.Text = logText
    Notification.new("<Color=Yellow>" .. message .. "<Color=/>"):Display()
end

local function errorHandler(err)
    log("Error: " .. tostring(err))
end

LogTab:AddButton({
    Name = "Show All Logs",
    Callback = function()
        log("All logs displayed in the console.")
        print(logText)
    end
})

local enabled = false
local attackCooldown = 0.1 -- Default cooldown
local tweenSpeed = 75 -- Default tween speed for faster movement
local fastAttack = false -- Fast Attack toggle
local fastAttackSpeed = 0.05 -- Default fast attack speed
local attackRangeIncrease = 50 -- Increase attack range by 50 units
local damageMultiplier = 12 -- Multiply damage by 12 times

local function moveToPosition(character, position)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenService = game:GetService("TweenService")
    local distance = (humanoidRootPart.Position - position).Magnitude
    local time = distance / tweenSpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position + Vector3.new(0, 15, 0))})
    tween:Play()
    tween.Completed:Wait()
    log("Moved to position: " .. tostring(position))
end

local function findNearestNPC()
    local nearestNPC = nil
    local nearestDistance = math.huge
    for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
            local npcPosition = npc.HumanoidRootPart.Position
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local distance = (humanoidRootPart.Position - npcPosition).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestNPC = npc
            end
        end
    end
    if nearestNPC then
        log("Nearest NPC found: " .. nearestNPC.Name)
    else
        log("No NPC found")
    end
    return nearestNPC
end

local function attackNPC(npc, tool, humanoidRootPart)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    while npc.Humanoid.Health > 0 and enabled do
        if not humanoidRootPart or not npc.HumanoidRootPart then
            break
        end

        if not character:FindFirstChild(tool.Name) then
            character.Humanoid:EquipTool(tool)
        end

        humanoidRootPart.CFrame = CFrame.new(npc.HumanoidRootPart.Position + Vector3.new(0, 15, 0))

        local args = {
            [1] = "Combat",
            [2] = "MouseClick"
        }

        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

        npc.Humanoid.Health = npc.Humanoid.Health - (npc.Humanoid.MaxHealth / damageMultiplier)

        if fastAttack then
            wait(fastAttackSpeed)
        else
            wait(attackCooldown)
        end
    end
    log("Attacked NPC: " .. npc.Name)
end

local function preventDamage()
    spawn(function()
        while enabled do
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")

            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end

            wait(0.1)
        end
    end)
end

local function AutoFarm()
    spawn(function()
        preventDamage()
        while enabled do
            local status, err = pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                local inventory = player.Backpack:GetChildren()

                if #inventory > 0 then
                    local tool = inventory[1]
                    if not character:FindFirstChild(tool.Name) then
                        player.Character.Humanoid:EquipTool(tool)
                    end

                    local npc = findNearestNPC()
                    while npc and npc.Humanoid.Health > 0 and enabled do
                        local npcPosition = npc.HumanoidRootPart.Position
                        if (humanoidRootPart.Position - npcPosition).Magnitude > 15 then
                            moveToPosition(character, npcPosition)
                        end
                        attackNPC(npc, tool, humanoidRootPart)
                        npc = findNearestNPC()
                    end
                end
                wait(1)
            end)
            if not status then
                errorHandler(err)
            end
        end
    end)
end

AutoFarmTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(Value)
        enabled = Value
        if enabled then
            log("Auto Farm enabled")
            AutoFarm()
        else
            log("Auto Farm disabled")
        end
    end    
})

AutoFarmTab:AddTextbox({
    Name = "Attack Cooldown",
    Default = "0.1",
    TextDisappear = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            attackCooldown = math.clamp(numValue, 0.05, 1)
            log("Attack Cooldown set to " .. tostring(attackCooldown))
        else
            log("Invalid Attack Cooldown value")
        end
    end
})

AutoFarmTab:AddTextbox({
    Name = "Tween Speed",
    Default = "75",
    TextDisappear = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            tweenSpeed = math.clamp(numValue, 25, 100)
            log("Tween Speed set to " .. tostring(tweenSpeed))
        else
            log("Invalid Tween Speed value")
        end
    end
})

AutoFarmTab:AddToggle({
    Name = "Fast Attack",
    Default = false,
    Callback = function(Value)
        fastAttack = Value
        log("Fast Attack set to " .. tostring(fastAttack))
    end    
})

AutoFarmTab:AddTextbox({
    Name = "Fast Attack Speed",
    Default = "0.05",
    TextDisappear = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            fastAttackSpeed = math.clamp(numValue, 0.01, 0.1)
            log("Fast Attack Speed set to " .. tostring(fastAttackSpeed))
        else
            log("Invalid Fast Attack Speed value")
        end
    end
})

OrionLib:Init()
