local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local TeleportButton = Instance.new("TextButton")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- Parent UI ke PlayerGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Properti Frame
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 2

-- Properti TextBox
TextBox.Parent = Frame
TextBox.Size = UDim2.new(0, 280, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 10)
TextBox.PlaceholderText = "Masukkan JobId"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.ClearTextOnFocus = false

-- Properti Tombol Teleport
TeleportButton.Parent = Frame
TeleportButton.Size = UDim2.new(0, 280, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 0, 60)
TeleportButton.Text = "Teleport"
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi Teleport
TeleportButton.MouseButton1Click:Connect(function()
    local jobId = TextBox.Text

    -- Hapus karakter yang tidak diinginkan
    jobId = jobId:gsub("```", ""):gsub("arm", ""):gsub("%s+", "")

    -- Teleport jika JobId valid
    if jobId and jobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Players.LocalPlayer)
    end
end)
