local adminName = "👾Script By Gia Khiem Dz👾"
local tweenSpeed = 850
local delayBetweenChests = 2
local chestTouchDelay = 0,4

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")

local startTime = tick()
local fps = 60

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "ChestFarmGUI"

local infoLabel = Instance.new("TextLabel", screenGui)
infoLabel.Size = UDim2.new(0, 330, 0, 120)
infoLabel.Position = UDim2.new(0.7, 0, 0.05, 0)
infoLabel.BackgroundTransparency = 0.3
infoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.TextWrapped = true

RunService.RenderStepped:Connect(function(dt)
	local uptime = math.floor(tick() - startTime)
	local fpsNow = math.floor(1 / dt)
	fps = (fps * 0.9) + (fpsNow * 0.1)

	local level = player:FindFirstChild("Data") and player.Data.Level.Value or "???"
	infoLabel.Text = "👑 Admin: "  ..GiaKhiem..
		"\n📶 Server Time: " .. uptime .. "s" ..
		"\n⚡ FPS: " .. math.floor(fps) ..
		"\n🧑‍💻 Acc: " .. player.Name .. " | Level " .. tostring(level)
end)

local function SmoothTP(pos)
	local dist = (hrp.Position - pos).Magnitude
	local time = dist / tweenSpeed
	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
		CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
	})
	tween:Play()
	tween.Completed:Wait()
end

local function GetChests()
	local chests = {}
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Part") and string.find(obj.Name:lower(), "chest") then
			table.insert(chests, obj)
		end
	end
	return chests
end

local function ServerHop()
	local placeId = game.PlaceId
	local req = game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
	local data = HttpService:JSONDecode(req)

	for _, server in pairs(data.data) do
		if server.playing < server.maxPlayers and server.id ~= game.JobId then
			TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
			break
		end
	end
end

local function FarmChest(chest)
	local pos = chest.Position
	SmoothTP(pos)
	wait(chestTouchDelay)
end

while true do
	local chests = GetChests()
	if #chests == 0 then
		infoLabel.Text = infoLabel.Text .. "\n🌐 Đang chuyển server..."
		wait(2)
		ServerHop()
		wait(5)
	else
		for _, chest in pairs(chests) do
			if chest and chest.Parent then
				pcall(function()
					FarmChest(chest)
					wait(delayBetweenChests)
				end)
			end
		end
	end
	wait(2)
end