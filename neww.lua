-- UI Service
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

-- Main Frame (Menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- Cho phép kéo menu
frame.Parent = gui

-- Bo góc menu
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15) -- bo góc tròn 15px
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Menu Hack"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- ESP Button
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -20, 0, 30)
espBtn.Position = UDim2.new(0, 10, 0, 40)
espBtn.Text = "ESP Fruits"
espBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Parent = frame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 10)
espCorner.Parent = espBtn

-- Teleport Button
local teleBtn = Instance.new("TextButton")
teleBtn.Size = UDim2.new(1, -20, 0, 30)
teleBtn.Position = UDim2.new(0, 10, 0, 80)
teleBtn.Text = "Teleport Fruits"
teleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleBtn.Parent = frame

local teleCorner = Instance.new("UICorner")
teleCorner.CornerRadius = UDim.new(0, 10)
teleCorner.Parent = teleBtn

-- Server Hop Button
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(1, -20, 0, 30)
hopBtn.Position = UDim2.new(0, 10, 0, 120)
hopBtn.Text = "Server Hop (30s)"
hopBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Parent = frame

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 10)
hopCorner.Parent = hopBtn

-- Mini Logo để ẩn/hiện menu
local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(0, 40, 0, 40)
logoBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
logoBtn.Text = "≡"
logoBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
logoBtn.Parent = gui

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0) -- logo tròn
logoCorner.Parent = logoBtn

-- Toggle menu
local menuVisible = true
logoBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end)

-- Gắn chức năng cho nút (tạm để print test)
espBtn.MouseButton1Click:Connect(function()
    print("ESP Fruits bật/tắt")
end)

teleBtn.MouseButton1Click:Connect(function()
    print("Teleport đến Fruits với tốc độ 300")
end)

hopBtn.MouseButton1Click:Connect(function()
    print("Đổi server sau 30s")
end)