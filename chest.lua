-- Blox Fruits | Auto Chest Farm | Full Anti-Kick + Anti-Ban v2
-- By Trà Luu | Tele tức thời + ServerHop + AutoMarine

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TeleportService")
local http = game:GetService("HttpService")

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
local label = Instance.new("TextLabel", gui)
label.Text = "lab"
label.Size = UDim2.new(0, 100, 0, 30)
label.Position = UDim2.new(0, 10, 0, 10)
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true

-- Auto chọn team Marines
pcall(function()
    if not plr.Team or plr.Team.Name ~= "Marines" then
        rs:WaitForChild("Remotes").CommF_:InvokeServer("SetTeam", "Marines")
    end
end)

-- Lấy danh sách server khác
local function getServers()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local response = game:HttpGet(url)
    local servers = http:JSONDecode(response)
    local result = {}
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            table.insert(result, s.id)
        end
    end
    return result
end

-- Đổi server
local function hopServer()
    local servers = getServers()
    if #servers > 0 then
        ts:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
    else
        ts:Teleport(game.PlaceId) -- fallback
    end
end

-- Lấy danh sách rương toàn map
local function getChests()
    local list = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") then
            if v.Name:lower():find("chest") or v.Name:lower():find("ch") then
                table.insert(list, v:FindFirstChildWhichIsA("BasePart"))
            end
        end
    end
    return list
end

-- Teleport tức thời
local function teleport(part)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end
end

-- Vòng lặp chính
while task.wait(0.25) do
    pcall(function()
        local chests = getChests()
        if #chests == 0 then
            task.wait(1.5)
            hopServer()
        else
            for _, chest in ipairs(chests) do
                teleport(chest)
                task.wait(0.85) -- delay nhận tiền
            end
        end
    end)
end
