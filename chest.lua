-- [Trà Luu] Auto Farm Rương | CFrame Teleport | Không delay Tween

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- UI Hiển thị "lab"
local gui = Instance.new("ScreenGui", game.CoreGui)
local label = Instance.new("TextLabel", gui)
label.Text = "lab"
label.Size = UDim2.new(0, 100, 0, 30)
label.Position = UDim2.new(0, 10, 0, 10)
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true

-- Tự chọn phe Marines nếu chưa chọn
pcall(function()
	if not player.Team or player.Team.Name ~= "Marines" then
		ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
	end
end)

-- Hàm lấy toàn bộ rương
local function GetChests()
	local chests = {}
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") and string.find(v.Name:lower(), "chest") then
			table.insert(chests, v:FindFirstChildWhichIsA("BasePart"))
		end
	end
	return chests
end

-- Hàm dịch chuyển đến vị trí
local function TeleportTo(part)
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root and part then
		root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
	end
end

-- Tự động vào lại nếu bị đá
local function Rejoin()
	TeleportService:Teleport(game.PlaceId)
end

-- Vòng lặp farm
while true do
	pcall(function()
		local chests = GetChests()
		if #chests == 0 then
			wait(2)
			Rejoin()
		else
			for _, chest in ipairs(chests) do
				TeleportTo(chest)
				wait(0.5) -- Delay nhận tiền
			end
		end
	end)
	wait(0.25)
end