-- Blox Fruits Auto Chest Farm v2.1 - FIX TOÀN BỘ
-- By Trà Luu | CFrame Teleport | Anti Kick | Đa đảo | Check Tiền | Auto Server Hop

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TeleportService")
local http = game:GetService("HttpService")
local oldBeli = plr.Data.Beli.Value

-- Giao diện chữ "lab"
pcall(function()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local label = Instance.new("TextLabel", gui)
    label.Text = "lab"
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
end)

-- Tự chọn Marines
pcall(function()
    if not plr.Team or plr.Team.Name ~= "Marines" then
        rs:WaitForChild("Remotes").CommF_:InvokeServer("SetTeam", "Marines")
    end
end)

-- Lấy danh sách rương toàn bản đồ
local function getAllChests()
    local chests = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") then
            if v.Name:lower():find("chest") then
                table.insert(chests, v:FindFirstChildWhichIsA("BasePart"))
            end
        end
    end
    return chests
end

-- Teleport tức thời
local function tpTo(part)
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end
end

-- Hop server khi cần
local function hopServer()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local servers = http:JSONDecode(game:HttpGet(url))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            ts:TeleportToPlaceInstance(game.PlaceId, s.id)
            return
        end
    end
end

-- Kiểm tra có nhận tiền hay không
local function waitForBeliChange(timeout)
    local old = plr.Data.Beli.Value
    local timer = 0
    while timer < timeout do
        task.wait(0.1)
        timer += 0.1
        if plr.Data.Beli.Value > old then
            return true
        end
    end
    return false
end

-- Vòng lặp chính
while true do
    local gotChest = false
    local chests = getAllChests()
    if #chests == 0 then
        hopServer()
        task.wait(4)
    else
        for _, chest in pairs(chests) do
            tpTo(chest)
            task.wait(math.random(85,120)/100) -- delay random 0.85–1.2s
            if waitForBeliChange(1.2) then
                gotChest = true
            end
        end
        if not gotChest then
            hopServer()
            task.wait(4)
        end
    end
    task.wait(0.25)
end