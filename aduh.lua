-- Memuat OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Membuat Window GUI
local Window = OrionLib:MakeWindow({
    Name = "Blox Fruits Script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BloxFruitsConfig"
})

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

-- Membuat ScrollingFrame untuk Console Log
local ConsoleLogFrame = Instance.new("ScrollingFrame")
ConsoleLogFrame.Size = UDim2.new(1, 0, 0, 300) -- Adjust the size as needed
ConsoleLogFrame.CanvasSize = UDim2.new(0, 0, 1, 0) -- Allow vertical scrolling
ConsoleLogFrame.ScrollBarThickness = 10
ConsoleLogFrame.Parent = Section.Container

-- Membuat TextLabel untuk menampilkan log di dalam ScrollingFrame
local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Size = UDim2.new(1, -20, 1, 0)
ConsoleLog.Position = UDim2.new(0, 10, 0, 0)
ConsoleLog.TextYAlignment = Enum.TextYAlignment.Top
ConsoleLog.TextWrapped = true
ConsoleLog.Text = ""
ConsoleLog.Parent = ConsoleLogFrame

-- Fungsi untuk memperbarui teks Console Log
local function updateConsoleLog(text)
    ConsoleLog.Text = ConsoleLog.Text .. "\n" .. text
    ConsoleLogFrame.CanvasSize = UDim2.new(0, 0, 0, ConsoleLog.TextBounds.Y)
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

-- Fungsi untuk mendapatkan informasi interaksi dengan NPC
local function getNPCInteractions()
    local interactions = {}
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if (npc:IsA("Model") or npc:IsA("Part")) and (npc:FindFirstChild("HumanoidRootPart")) then
            local distance = (npc.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            if distance < 10 then -- adjust the distance as necessary
                table.insert(interactions, {
                    Name = npc.Name,
                    Position = npc.HumanoidRootPart.Position,
                    ClassName = npc.ClassName
                })
            end
        end
    end

    return interactions
end

-- Menyimpan log interaksi
local interactionLog = {}
local lastInteractionInfo = nil
local sameInteractionCount = 0

-- Fungsi untuk memperbarui log interaksi
local function updateInteractionLog()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Cek apakah pemain menggunakan tool
    local isUsingTool = false
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and item.Parent == character then
            isUsingTool = true
            break
        end
    end

    if isUsingTool then
        -- Dapatkan informasi item yang dikenakan
        local equippedItems = getEquippedItemsInfo()
        for _, item in pairs(equippedItems) do
            local itemInfo = string.format("Equipped Item - Name: %s, ID: %s, ClassName: %s", item.Name, item.ID, item.ClassName)
            table.insert(interactionLog, {time = tick(), info = itemInfo})
            updateConsoleLog(itemInfo)
            sendNotification("Interaction", itemInfo)
            -- Cek apakah informasi ini sama dengan interaksi sebelumnya
            if itemInfo == lastInteractionInfo then
                sameInteractionCount = sameInteractionCount + 1
            else
                sameInteractionCount = 1
                lastInteractionInfo = itemInfo
            end
        end
    end

    -- Dapatkan informasi interaksi dengan NPC
    local npcInteractions = getNPCInteractions()
    for _, interaction in pairs(npcInteractions) do
        local interactionInfo = string.format("Interacted with NPC - Name: %s, Position: %s, ClassName: %s", interaction.Name, tostring(interaction.Position), interaction.ClassName)
        table.insert(interactionLog, {time = tick(), info = interactionInfo})
        updateConsoleLog(interactionInfo)
        sendNotification("Interaction", interactionInfo)
        -- Cek apakah informasi ini sama dengan interaksi sebelumnya
        if interactionInfo == lastInteractionInfo then
            sameInteractionCount = sameInteractionCount + 1
        else
            sameInteractionCount = 1
            lastInteractionInfo = interactionInfo
        end
    end

    -- Hapus log yang lebih dari 30 detik
    local currentTime = tick()
    for i = #interactionLog, 1, -1 do
        if currentTime - interactionLog[i].time > 30 then
            table.remove(interactionLog, i)
        end
    end
end

-- Fungsi untuk menangani interaksi pengguna
local function handleUserInteraction()
    updateInteractionLog()
end

-- Menghubungkan interaksi pengguna dengan fungsi handleUserInteraction
game:GetService("UserInputService").InputBegan:Connect(function(input)
    -- Abaikan input jika berasal dari game GUI
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Jeda berdasarkan jumlah interaksi yang sama
        if sameInteractionCount >= 4 then
            wait(7)
        else
            wait(5)
        end
        handleUserInteraction()
    end
end)

-- Membuat GUI
OrionLib:Init()
