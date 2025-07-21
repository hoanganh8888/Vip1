local adminName = "Gia Khiem Dz"
local chestTouchDelay = 0.5

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
	infoLabel.Text = "👑 Admin: " .. GiaKhiem ..
		"\n📶 Server Time: " .. uptime ..
		"\n⚡ FPS: " .. math.floor(fps) ..
		"\n🎖 Level: " .. level
end)

pcall(function()
	repeat wait() until player.Team ~= nil or ReplicatedStorage:FindFirstChild("Remotes")
	if player.Team == nil then
		local chooseTeam = ReplicatedStorage.Remotes["CommF_"]
		chooseTeam:InvokeServer("SetTeam", "Marines")
	end
end)

function GetChests()
	local chests = {}
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("TouchInterest") and v.Name:lower():find("chest") then
			table.insert(chests, v)
		end
	end
	return chests
end

function FarmChest(chest)
	local root = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChildWhichIsA("BasePart")
	if root then
		hrp.CFrame = root.CFrame + Vector3.new(0, 5, 0)
		wait(chestTouchDelay)
	end
end

function ServerHop()
	local servers = {}
	local req = syn and syn.request or http_request or request
	local gameId = game.PlaceId
	local jobId = game.JobId
	local url = "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Desc&limit=100"
	local body = HttpService:JSONDecode(req({Url=url,Method="GET"}).Body)

	for _, v in pairs(body.data) do
		if v.playing < v.maxPlayers and v.id ~= jobId then
			table.insert(servers, v.id)
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(gameId, servers[math.random(1, #servers)], player)
	end
end

spawn(function()
	while task.wait(0.1) do
		local chests = GetChests()
		if #chests == 0 then
			ServerHop()
			break
		else
			for _, chest in pairs(chests) do
				if chest and chest:IsDescendantOf(Workspace) then
					FarmChest(chest)
				end
			end
		end
	end
end)