local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local isMinimized = false

-- Properties
ScreenGui.Parent = game.CoreGui

Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)

MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0, 50, 0, 25)
MinimizeButton.Position = UDim2.new(1, -110, 0, 0)
MinimizeButton.Text = "_"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 50, 0, 25)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)

-- Functions
MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        Frame.Size = UDim2.new(0, 300, 0, 200)
        isMinimized = false
    else
        Frame.Size = UDim2.new(0, 300, 0, 25)
        isMinimized = true
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Example elements (add your own features)
local ExampleLabel = Instance.new("TextLabel")
ExampleLabel.Parent = Frame
ExampleLabel.Size = UDim2.new(0, 280, 0, 50)
ExampleLabel.Position = UDim2.new(0, 10, 0, 50)
ExampleLabel.Text = "Blox Fruits GUI"
ExampleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleLabel.BackgroundTransparency = 1
