-- Blox Fruits Auto Chest Farm V4 - Full Map, Anti Kick, Auto Hop, No UI

--// Config
local delayAfterChest = 0.5
local teleportHeight = 10
local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local ws = game:GetService("Workspace")
local http = game:GetService("HttpService")

--// Anti Kick (heartbeat alive)
spawn(function()
    while rs.Heartbeat:Wait() do
        sethiddenproperty(player, "SimulationRadius", math.huge)
    end
end)

--// Safe Teleport Function
function safeTweenTeleport(pos)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local tween = ts:Create(root, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos + Vector3.new(0, teleportHeight, 0))})
        tween:Play()
        tween.Completed:Wait()
    end
end

--// Get All Chests In Map
function getAllChests()
    local chests = {}
    for _, obj in pairs(ws:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildWhichIsA("ProximityPrompt") then
            table.insert(chests, obj)
        end
    end
    return chests
end

--// Auto Hop Server
function hopToAnotherServer()
    local servers = {}
    local req = syn and syn.request or http_request or request
    local data = req({
        Url = "https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=Asc&limit=100"
    })
    local decoded = http:JSONDecode(data.Body)
    for _, server in pairs(decoded.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
    end
end

--// Auto Select Marines
spawn(function()
    pcall(function()
        local chooseTeam = player:WaitForChild("PlayerGui"):WaitForChild("ChooseTeam")
        wait(1)
        chooseTeam:FindFirstChild("Marines").Frame.ViewportFrame.TextButton.Size = UDim2.new(999,999,999,999)
        firetouchinterest(chooseTeam:FindFirstChild("Marines"), player.Character.HumanoidRootPart, 0)
        firetouchinterest(chooseTeam:FindFirstChild("Marines"), player.Character.HumanoidRootPart, 1)
    end)
end)

--// Main Auto Farm Loop
while task.wait(0.1) do
    local chests = getAllChests()
    if #chests == 0 then
        hopToAnotherServer()
    else
        for _, chest in pairs(chests) do
            local pos = chest.HumanoidRootPart.Position
            safeTweenTeleport(pos)
            task.wait(delayAfterChest)
            local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end
    end
end
