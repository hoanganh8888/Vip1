-- 🧠 Trade Scam GUI – Việt hóa + Icon mở/ẩn Menu

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local CommF = RS:WaitForChild("Remotes"):FindFirstChild("CommF_")
local CoreGui = game:GetService("CoreGui")

-- 🔁 Trạng thái
local enableAutoAdd = false
local enableHoldFruit = false
local enableFakeAccept = false

-- 🍇 Bảng giá trái
local fruitValues = {
	["Leopard"] = 90,
	["Dragon"] = 100,
	["Dough"] = 85,
	["Venom"] = 55,
	["Control"] = 65,
	["Shadow"] = 60,
	["Spirit"] = 55
	["Kitsune"] = 95
	["Yeti"] = 95
	["buddha"] = 75
}

-- 🥇 Tìm trái đắt nhất
local function getBestFruit()
	local best, val = nil, 0
	for _, tool in pairs(LP.Backpack:GetChildren()) do
		if tool:IsA("Tool") and fruitValues[tool.Name] and fruitValues[tool.Name] > val then
			best, val = tool.Name, fruitValues[tool.Name]
		end
	end
	return best
end

-- ❌ Xóa GUI cũ nếu có
pcall(function()
	if CoreGui:FindFirstChild("TradeMenuGUI") then
		CoreGui.TradeMenuGUI:Destroy()
	end
end)

-- 🧱 Giao diện chính
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "TradeMenuGUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 170)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

-- 🧸 Nút mở/ẩn menu (Icon Doremon)
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.01, 0, 0.85, 0)
toggleBtn.Image = "rbxassetid://4483345998" -- Doremon icon
toggleBtn.BackgroundTransparency = 1
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- 📌 Tạo từng nút bật/tắt
local function createToggle(label, posY, stateVarName)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = "[TẮT] " .. label

	local isEnabled = false
	btn.MouseButton1Click:Connect(function()
		isEnabled = not isEnabled
		btn.Text = (isEnabled and "[BẬT] " or "[TẮT] ") .. label
		if stateVarName == "autoAdd" then
			enableAutoAdd = isEnabled
		elseif stateVarName == "holdFruit" then
			enableHoldFruit = isEnabled
		elseif stateVarName == "fakeAccept" then
			enableFakeAccept = isEnabled
		end
	end)
end

-- 🎛️ Tạo 3 chức năng
createToggle("Tự động thêm trái đắt nhất", 10, "autoAdd")
createToggle("Giữ trái không biến mất", 60, "holdFruit")
createToggle("Giả người kia đã đồng ý", 110, "fakeAccept")

-- 🔁 Auto Add trái
task.spawn(function()
	while task.wait(1) do
		if enableAutoAdd and CommF then
			local fruit = getBestFruit()
			if fruit then
				CommF:FireServer("AddFruitToTrade", fruit)
			end
		end
	end
end)

-- 🔁 Giữ trái ảo
task.spawn(function()
	while task.wait(0.3) do
		if enableHoldFruit and CommF then
			local fruit = getBestFruit()
			if fruit then
				CommF:FireServer("AddFruitToTrade", fruit)
				task.wait(0.2)
				CommF:FireServer("RemoveFruitFromTrade", fruit)
			end
		end
	end
end)

-- 🔁 Giả trạng thái Accept
task.spawn(function()
	while task.wait(1) do
		if enableFakeAccept then
			local gui = LP:FindFirstChild("PlayerGui"):FindFirstChild("TradeGui")
			if gui and gui:FindFirstChild("OtherPlayerAccepted") then
				gui.OtherPlayerAccepted.Visible = true
			end
		end
	end
end)