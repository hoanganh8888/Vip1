-- Blox Fruits Tool Demo
-- Menu có logo nhỏ để bật/tắt

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- Tạo ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BloxFruitsTool"

-- Nút logo nhỏ
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,40,0,40)
logo.Position = UDim2.new(0,10,0,200)
logo.BackgroundColor3 = Color3.fromRGB(255,165,0)
logo.Text = "🍊"
logo.TextScaled = true
logo.Visible = true

-- Frame menu chính
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,200,0,150)
menu.Position = UDim2.new(0,60,0,200)
menu.BackgroundColor3 = Color3.fromRGB(30,30,30)
menu.Visible = false

-- Toggle menu khi bấm logo
logo.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Hàm tạo nút
local function makeButton(name, posY)
    local btn = Instance.new("TextButton", menu)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,165,0)
    btn.Text = name
    btn.TextScaled = true
    return btn
end

-- 1. ESP Fruits
local espEnabled = false
local espBtn = makeButton("ESP Fruits",10)
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(100,50,0) or Color3.fromRGB(50,50,50)
end)

-- ESP loop
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                if not v.Handle:FindFirstChild("Esp") then
                    local billboard = Instance.new("BillboardGui", v.Handle)
                    billboard.Name = "Esp"
                    billboard.Size = UDim2.new(0,200,0,50)
                    billboard.AlwaysOnTop = true
                    local text = Instance.new("TextLabel", billboard)
                    text.Size = UDim2.new(1,0,1,0)
                    text.TextColor3 = Color3.fromRGB(255,140,0) -- Cam
                    text.BackgroundTransparency = 1
                    text.TextScaled = true
                    RunService.RenderStepped:Connect(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Handle.Position).magnitude
                            text.Text = v.Name.." - "..math.floor(dist).."m"
                        end
                    end)
                end
            end
        end
    end
end)

-- 2. Teleport Fruits
local tpEnabled = false
local tpBtn = makeButton("Teleport Fruits",50)
tpBtn.MouseButton1Click:Connect(function()
    tpEnabled = not tpEnabled
    tpBtn.BackgroundColor3 = tpEnabled and Color3.fromRGB(100,50,0) or Color3.fromRGB(50,50,50)

    if tpEnabled then
        task.spawn(function()
            while tpEnabled do
                local fruit = nil
                for _,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("Handle") then
                        fruit = v.Handle
                        break
                    end
                end
                if fruit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.CFrame + Vector3.new(0,3,0)
                    task.wait(0.3) -- tốc độ ~300ms
                else
                    task.wait(1)
                end
            end
        end)
    end
end)

-- 3. Auto Server Hop
local hopEnabled = false
local hopBtn = makeButton("Server Hop (30s)",90)
hopBtn.MouseButton1Click:Connect(function()
    hopEnabled = not hopEnabled
    hopBtn.BackgroundColor3 = hopEnabled and Color3.fromRGB(100,50,0) or Color3.fromRGB(50,50,50)

    if hopEnabled then
        task.spawn(function()
            while hopEnabled do
                task.wait(30)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end
end)