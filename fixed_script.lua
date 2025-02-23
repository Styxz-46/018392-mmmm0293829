local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local stats = game:GetService("Stats")
local contextActionService = game:GetService("ContextActionService")

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Label "Alchemy Tools"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Alchemy Tools"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame

-- UID Section
local uidContainer = Instance.new("Frame")
uidContainer.Size = UDim2.new(1, 0, 0, 30)
uidContainer.Position = UDim2.new(0, 0, 0, 40)
uidContainer.BackgroundTransparency = 1
uidContainer.Parent = frame

local uidLabel = Instance.new("TextLabel")
uidLabel.Size = UDim2.new(1, 0, 0, 30)
uidLabel.BackgroundTransparency = 1
uidLabel.Text = "UID: " .. player.UserId
uidLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
uidLabel.Font = Enum.Font.SourceSans
uidLabel.TextSize = 14
uidLabel.Parent = uidContainer

-- Tools Section
local toolsContainer = Instance.new("Frame")
toolsContainer.Size = UDim2.new(1, 0, 0, 80)
toolsContainer.Position = UDim2.new(0, 0, 0, 70)
toolsContainer.BackgroundTransparency = 1
toolsContainer.Parent = frame

local toolsLabel = Instance.new("TextLabel")
toolsLabel.Size = UDim2.new(1, 0, 0, 80)
toolsLabel.BackgroundTransparency = 1
toolsLabel.Text = "Dark Dex\nSimple Spy\nHydroxide\nSave Instance"
toolsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toolsLabel.Font = Enum.Font.SourceSans
toolsLabel.TextSize = 14
toolsLabel.Parent = toolsContainer

-- Position Section (Dengan Fitur Copy)
local positionContainer = Instance.new("Frame")
positionContainer.Size = UDim2.new(1, 0, 0, 30)
positionContainer.Position = UDim2.new(0, 0, 0, 150)
positionContainer.BackgroundTransparency = 1
positionContainer.Parent = frame

-- Ganti TextLabel menjadi TextButton untuk bisa diklik
local posLabel = Instance.new("TextButton") -- <-- Diubah ke TextButton
posLabel.Size = UDim2.new(1, 0, 0, 30)
posLabel.BackgroundTransparency = 1
posLabel.Text = "X: 0, Y: 0, Z: 0"
posLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
posLabel.Font = Enum.Font.SourceSans
posLabel.TextSize = 14
posLabel.Parent = positionContainer

-- Label "Copied!" yang muncul saat copy
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

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = frame

-- Fungsi Copy Koordinat
posLabel.MouseButton1Click:Connect(function()
    if setclipboard then
        local coords = posLabel.Text:gsub("X: ", ""):gsub("Y: ", ""):gsub("Z: ", "")
        setclipboard(coords)
        copiedLabel.Visible = true
        task.wait(1)
        copiedLabel.Visible = false
    else
        warn("Clipboard tidak didukung!")
    end
end)

-- Fungsi Update Posisi
runService.RenderStepped:Connect(function()
    if rootPart then
        local pos = rootPart.Position
        posLabel.Text = string.format("X: %d, Y: %d, Z: %d", pos.X, pos.Y, pos.Z)
    end)

-- Sisanya (fungsi close dan drag) tetap sama...
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
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
