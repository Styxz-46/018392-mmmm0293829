local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local stats = game:GetService("Stats")

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Merah
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Buat label "Takashi Tools"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Takashi Tools"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame

-- Debug Section (Hitam)
local debugContainer = Instance.new("Frame")
debugContainer.Size = UDim2.new(1, 0, 0, 100)
debugContainer.Position = UDim2.new(0, 0, 0, 40)
debugContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
debugContainer.Parent = frame

local debugTitle = Instance.new("TextLabel")
debugTitle.Size = UDim2.new(1, 0, 0, 20)
debugTitle.BackgroundTransparency = 1
debugTitle.Text = "Debug"
debugTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
debugTitle.Font = Enum.Font.GothamBlack
debugTitle.TextSize = 16
debugTitle.Parent = debugContainer

local debugInfo = Instance.new("TextLabel")
debugInfo.Size = UDim2.new(1, 0, 0, 60)
debugInfo.Position = UDim2.new(0, 0, 0, 20)
debugInfo.BackgroundTransparency = 1
debugInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
debugInfo.Font = Enum.Font.SourceSans
debugInfo.TextSize = 14
debugInfo.Parent = debugContainer

-- Position Section (Hitam)
local positionContainer = Instance.new("Frame")
positionContainer.Size = UDim2.new(1, 0, 0, 100)
positionContainer.Position = UDim2.new(0, 0, 0, 130)
positionContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
positionContainer.Parent = frame

local positionTitle = Instance.new("TextLabel")
positionTitle.Size = UDim2.new(1, 0, 0, 20)
positionTitle.BackgroundTransparency = 1
positionTitle.Text = "Position"
positionTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
positionTitle.Font = Enum.Font.GothamBlack
positionTitle.TextSize = 16
positionTitle.Parent = positionContainer

local posLabel = Instance.new("TextButton")
posLabel.Size = UDim2.new(1, 0, 0, 20)
posLabel.Position = UDim2.new(0, 0, 0, 20)
posLabel.BackgroundTransparency = 1
posLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
posLabel.Font = Enum.Font.SourceSans
posLabel.TextSize = 14
posLabel.Parent = positionContainer

local copiedLabel = Instance.new("TextLabel")
copiedLabel.Size = UDim2.new(0, 200, 0, 30)
copiedLabel.Position = UDim2.new(0.5, -100, 0.8, 0)
copiedLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
copiedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
copiedLabel.Font = Enum.Font.GothamBlack
copiedLabel.TextSize = 16
copiedLabel.Text = "Copied!"
copiedLabel.Visible = false
copiedLabel.Parent = screenGui

local startTime = tick()
runService.RenderStepped:Connect(function()
    if character and rootPart then
        local pos = rootPart.Position
        posLabel.Text = string.format("📍 %d, %d, %d", pos.X, pos.Y, pos.Z)
    end
    
    local elapsedTime = tick() - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = math.floor(elapsedTime % 60)
    local fps = math.floor(1 / runService.RenderStepped:Wait())
    local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    
    debugInfo.Text = string.format("⌛ Time: %dH %dM %dS\n🟢 FPS: %d\n📶 Ping: %d ms\n😎 UID: %d", hours, minutes, seconds, fps, ping, player.UserId)
end)

posLabel.MouseButton1Click:Connect(function()
    if setclipboard then
        local coords = posLabel.Text:gsub("📍 ", "")
        setclipboard(coords)
    else
        warn("Clipboard tidak didukung di perangkat ini!")
    end
    copiedLabel.Visible = true
    wait(1)
    copiedLabel.Visible = false
end)
-- Buat tombol close (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = frame

-- Fungsi untuk menutup UI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Fungsi untuk membuat UI bisa digeser
local dragging, dragInput, startPos, startInputPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startInputPos = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - startInputPos
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Fungsi untuk membuat UI bisa digeser di PC dan HP
local dragging, dragInput, startPos, startInputPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startInputPos = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - startInputPos
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
