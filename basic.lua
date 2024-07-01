-- Memuat OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Membuat Window GUI
local Window = OrionLib:MakeWindow({Name = "Blox Fruits Script", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitsConfig"})

-- Membuat Tab
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Menambahkan Section
local Section = Tab:AddSection({
    Name = "Console Log"
})

-- Menambahkan Console Log
local ConsoleLog = Section:AddLabel("Console Log:")
local function updateConsoleLog(text)
    ConsoleLog:Set(text)
end

-- Menambahkan Notifikasi
local function sendNotification(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

-- Fungsi untuk mendapatkan informasi item yang dikenakan
local function getEquippedItemsInfo()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local equippedItems = {}

    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Accessory") then
            table.insert(equippedItems, {
                Name = item.Name,
                ID = item:GetAttribute("ID") or "N/A",
                ClassName = item.ClassName
            })
        end
    end

    return equippedItems
end

-- Fungsi untuk mendapatkan informasi NPC yang berinteraksi
local function getNPCInfo(npc)
    return {
        Name = npc.Name,
        ClassName = npc.ClassName,
        Position = npc.Position,
        Attributes = npc:GetAttributes()
    }
end

-- Fungsi untuk mencatat interaksi dengan NPC
local function logNPCInteraction(npc, interactionType)
    local npcInfo = getNPCInfo(npc)
    local infoText = string.format("Interacted with NPC: %s (Class: %s, Position: %s), Interaction Type: %s", 
                                   npcInfo.Name, npcInfo.ClassName, tostring(npcInfo.Position), interactionType)
    
    for attrName, attrValue in pairs(npcInfo.Attributes) do
        infoText = infoText .. string.format(", %s: %s", attrName, tostring(attrValue))
    end
    
    updateConsoleLog(infoText)
    sendNotification("NPC Interaction", infoText)
end

-- Menambahkan Button untuk menjalankan script
Section:AddButton({
    Name = "Run Script",
    Callback = function()
        local success, errorMessage = pcall(function()
            -- Mulai Script
            updateConsoleLog("Running Script...")
            sendNotification("Script Status", "Running Script...")
            
            -- (Tambahkan kode script di sini)

            updateConsoleLog("Script Ran Successfully.")
            sendNotification("Script Status", "Script Ran Successfully.")
        end)
        
        if not success then
            updateConsoleLog("Script Failed: " .. errorMessage)
            sendNotification("Script Status", "Script Failed: " .. errorMessage)
        end
    end
})

-- Menambahkan Button untuk menampilkan item yang dikenakan
Section:AddButton({
    Name = "Show Equipped Items",
    Callback = function()
        local success, errorMessage = pcall(function()
            updateConsoleLog("Fetching Equipped Items...")
            sendNotification("Inventory", "Fetching Equipped Items...")
            
            local equippedItems = getEquippedItemsInfo()
            if #equippedItems > 0 then
                for _, item in pairs(equippedItems) do
                    local itemInfo = string.format("Name: %s, ID: %s, ClassName: %s", item.Name, item.ID, item.ClassName)
                    updateConsoleLog(itemInfo)
                    sendNotification("Equipped Item", itemInfo)
                end
            else
                updateConsoleLog("No Equipped Items Found.")
                sendNotification("Inventory", "No Equipped Items Found.")
            end
        end)
        
        if not success then
            updateConsoleLog("Failed to Fetch Equipped Items: " .. errorMessage)
            sendNotification("Inventory", "Failed to Fetch Equipped Items: " .. errorMessage)
        end
    end
})

-- Menambahkan Button untuk mencatat interaksi dengan NPC
Section:AddButton({
    Name = "Log NPC Interaction",
    Callback = function()
        local success, errorMessage = pcall(function()
            updateConsoleLog("Logging NPC Interaction...")
            sendNotification("NPC Interaction", "Logging NPC Interaction...")
            
            -- Contoh interaksi dengan NPC
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local npc = workspace:FindFirstChild("SomeNPC") -- Ganti dengan NPC yang ingin dicatat interaksinya
            
            if npc then
                logNPCInteraction(npc, "Talked")
            else
                updateConsoleLog("NPC not found.")
                sendNotification("NPC Interaction", "NPC not found.")
            end
        end)
        
        if not success then
            updateConsoleLog("Failed to Log NPC Interaction: " .. errorMessage)
            sendNotification("NPC Interaction", "Failed to Log NPC Interaction: " .. errorMessage)
        end
    end
})

-- Membuat GUI
OrionLib:Init()
