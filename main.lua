local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local ButtonList = Instance.new("Frame")
local isMinimized = false

-- Parent to PlayerGui for Mobile Support
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame Properties
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.Size = UDim2.new(0, 350, 0, 250)
Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Parent = ScreenGui

-- Minimize Button
MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0, 30, 0, 25)
MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
MinimizeButton.Text = "_"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

-- Close Button
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 30, 0, 25)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)

-- Button List Frame
ButtonList.Parent = Frame
ButtonList.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ButtonList.Size = UDim2.new(0, 100, 0, 250)
ButtonList.Position = UDim2.new(1, -100, 0, 25)

-- Adding Buttons
for i = 1, 5 do
    local Button = Instance.new("TextButton")
    Button.Parent = ButtonList
    Button.Size = UDim2.new(0, 90, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, (i - 1) * 50 + 10)
    Button.Text = "Button " .. i
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    Button.MouseButton1Click:Connect(function()
        print("Button " .. i .. " clicked")
    end)
end

-- Minimize/Restore Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        Frame.Size = UDim2.new(0, 350, 0, 250)
        isMinimized = false
    else
        Frame.Size = UDim2.new(0, 350, 0, 25)
        isMinimized = true
    end
end)

-- Close Functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

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
