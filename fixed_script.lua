local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local stats = game:GetService("Stats")
local contextActionService = game:GetService("ContextActionService")
local tweenService = game:GetService("TweenService")

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400) -- Lebar dan tinggi frame ditambah
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Warna latar belakang gelap
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = screenGui

-- Tambahkan bayangan
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217" -- ID gambar bayangan
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = frame

-- Buat gradient background
local gradient = Instance.new("UIGradient")
gradient.Rotation = 90
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
})
gradient.Parent = frame

-- Buat label "Takashi Tools"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Takashi Tools"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.Parent = frame

-- Debug Section
local debugContainer = Instance.new("Frame")
debugContainer.Size = UDim2.new(1, -20, 0, 100)
debugContainer.Position = UDim2.new(0, 10, 0, 50)
debugContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
debugContainer.BorderSizePixel = 0
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

-- Position Section
local positionContainer = Instance.new("Frame")
positionContainer.Size = UDim2.new(1, -20, 0, 100)
positionContainer.Position = UDim2.new(0, 10, 0, 160)
positionContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
positionContainer.BorderSizePixel = 0
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

-- Teleport Section
local teleportContainer = Instance.new("Frame")
teleportContainer.Size = UDim2.new(1, -20, 0, 70)
teleportContainer.Position = UDim2.new(0, 10, 0, 270)
teleportContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportContainer.BorderSizePixel = 0
teleportContainer.Parent = frame

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Size = UDim2.new(1, 0, 0, 20)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "Teleport"
teleportTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
teleportTitle.Font = Enum.Font.GothamBlack
teleportTitle.TextSize = 16
teleportTitle.Parent = teleportContainer

local teleportInput = Instance.new("TextBox")
teleportInput.Size = UDim2.new(1, -10, 0, 20)
teleportInput.Position = UDim2.new(0, 5, 0, 25)
teleportInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
teleportInput.TextColor3 = Color3.fromRGB(0, 0, 0)
teleportInput.Font = Enum.Font.SourceSans
teleportInput.TextSize = 14
teleportInput.PlaceholderText = "Masukkan koordinat (X, Y, Z)"
teleportInput.Teks = ""
teleportInput.Parent = teleportContainer

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -10, 0, 20)
teleportButton.Position = UDim2.new(0, 5, 0, 50)
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 14
teleportButton.Text = "Teleport"
teleportButton.Parent = teleportContainer

-- Animasi tombol teleport
teleportButton.MouseEnter:Connect(function()
    tweenService:Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 150, 150)}):Play()
end)

teleportButton.MouseLeave:Connect(function()
    tweenService:Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

-- Fungsi untuk teleport ke koordinat yang dimasukkan
teleportButton.MouseButton1Click:Connect(function()
    local coords = teleportInput.Text
    local x, y, z = coords:match("([%d%.%-]+),%s*([%d%.%-]+),%s*([%d%.%-]+)")
    
    if x and y and z then
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        if rootPart then
            rootPart.CFrame = CFrame.new(x, y, z)
            print("Teleport To Coordinates:", x, y, z)
        else
            warn("RootPart tidak ditemukan!")
        end
    else
        warn("Format koordinat tidak valid! Gunakan format: X, Y, Z")
    end
end)

local startTime = tick()
runService.RenderStepped:Connect(function()
    if character and rootPart then
        local pos = rootPart.Position
        posLabel.Text = string.format("📍: %d, %d, %d", pos.X, pos.Y, pos.Z)
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
        local coords = posLabel.Text:gsub("📍: ", "")
        setclipboard(coords)
    else
        warn("Clipboard is not supported on this device!")
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

-- Animasi tombol close
closeButton.MouseEnter:Connect(function()
    tweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)

closeButton.MouseLeave:Connect(function()
    tweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
end)

-- Fungsi untuk menutup UI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Fungsi untuk membuat UI bisa digeser di PC dan HP
local dragging, dragInput, startPos, startInputPos

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startInputPos = input.Position
        startPos = frame.Position

        -- Blokir input sementara untuk menggeser UI
        contextActionService:BindActionAtPriority("BlockCameraInput", function()
            return Enum.ContextActionResult.Sink
        end, false, 10000, input.UserInputType)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                -- Lepaskan blokir input setelah selesai menggeser
                contextActionService:UnbindAction("BlockCameraInput")
            end
        end)
    end
end

frame.InputBegan:Connect(onInputBegan)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - startInputPos
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
