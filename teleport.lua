local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Membuat UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
local TeleportButton = Instance.new("TextButton", Frame)
local CloseButton = Instance.new("TextButton", Frame)

ScreenGui.ResetOnSpawn = false

-- Konfigurasi UI
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.2
Frame.Active = true -- Agar bisa digeser

ScrollFrame.Size = UDim2.new(1, 0, 0.7, 0)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScrollFrame.ScrollBarThickness = 5

UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

TeleportButton.Size = UDim2.new(1, 0, 0.2, 0)
TeleportButton.Position = UDim2.new(0, 0, 0.75, 0)
TeleportButton.Text = "Teleport"
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

local SelectedPlayer = nil

-- Fungsi untuk memperbarui daftar pemain
local function UpdatePlayerList()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        local Button = Instance.new("TextButton", ScrollFrame)
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.Text = player.Name
        Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)

        Button.MouseButton1Click:Connect(function()
            SelectedPlayer = player
            print("Selected:", player.Name)
        end)
    end

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- Fungsi teleport
TeleportButton.MouseButton1Click:Connect(function()
    if SelectedPlayer then
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character
        local TargetCharacter = SelectedPlayer.Character

        if Character and TargetCharacter then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local TargetRootPart = TargetCharacter:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart and TargetRootPart then
                local TweenService = game:GetService("TweenService")
                local goal = {CFrame = TargetRootPart.CFrame + Vector3.new(0, 5, 0)}
                local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(HumanoidRootPart, tweenInfo, goal)

                tween:Play()
            end
        end
    else
        print("Pilih pemain dulu sebelum teleport!")
    end
end)

-- Fitur geser UI
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Tombol Close
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
