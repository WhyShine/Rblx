-- Roblox Script for Blox Fruit
-- This script is for educational purposes only

-- Define the range for hitting NPCs
local hitRange = 30

-- Function to get all NPCs within a certain range
local function getNPCsInRange(player, range)
    local npcsInRange = {}
    local playerPosition = player.Character.HumanoidRootPart.Position
    
    for _, npc in pairs(game.Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local npcPosition = npc.HumanoidRootPart.Position
            local distance = (playerPosition - npcPosition).Magnitude
            if distance <= range then
                table.insert(npcsInRange, npc)
            end
        end
    end
    
    return npcsInRange
end

-- Function to deal damage to an NPC
local function dealDamageToNPC(npc, damage)
    if npc:FindFirstChild("Humanoid") then
        npc.Humanoid:TakeDamage(damage)
    end
end

-- Main function to check inventory and apply damage
local function checkInventoryAndHit(player)
    local inventory = player.Backpack:GetChildren()
    for _, item in pairs(inventory) do
        if item.Name == "YourSpecialItemName" then
            local npcsInRange = getNPCsInRange(player, hitRange)
            for _, npc in pairs(npcsInRange) do
                dealDamageToNPC(npc, 50) -- Change 50 to the amount of damage you want to deal
            end
            break
        end
    end
end

-- Bind the function to the player's mouse click
game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
    checkInventoryAndHit(game.Players.LocalPlayer)
end)
