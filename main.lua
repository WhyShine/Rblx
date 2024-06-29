local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local isMinimized = false

-- Parent to PlayerGui for Mobile Support
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame Properties
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Parent = ScreenGui

-- Minimize Button
MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0, 50, 0, 25)
MinimizeButton.Position = UDim2.new(1, -110, 0, 0)
MinimizeButton.Text = "_"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Close Button
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 50, 0, 25)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)

-- Minimize/Restore Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        Frame.Size = UDim2.new(0, 300, 0, 200)
        isMinimized = false
    else
        Frame.Size = UDim2.new(0, 300, 0, 25)
        isMinimized = true
    end
end)

-- Close Functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Example Label
local ExampleLabel = Instance.new("TextLabel")
ExampleLabel.Parent = Frame
ExampleLabel.Size = UDim2.new(0, 280, 0, 50)
ExampleLabel.Position = UDim2.new(0, 10, 0, 50)
ExampleLabel.Text = "Blox Fruits GUI"
ExampleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleLabel.BackgroundTransparency = 1

-- Draggable Frame
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, mousePos, framePos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mousePos
        Frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
