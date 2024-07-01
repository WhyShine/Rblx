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

-- Menambahkan Button
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

-- Membuat GUI
OrionLib:Init()
