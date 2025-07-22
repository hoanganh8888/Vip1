repeat wait() until game:IsLoaded() local player = game.Players.LocalPlayer local http = game:HttpGet local hop = loadstring(http("https://raw.githubusercontent.com/RobloxScriptsFarming/ServerHop/main/Main.lua"))() local function getChests() local chests = {} for _, v in pairs(workspace:GetDescendants()) do if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("MeshPart") and v.Parent.Transparency < 1 then table.insert(chests, v.Parent) end end return chests end

local function tpTo(pos) local char = player.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(pos) end end

local function hopServer() pcall(function() hop:Teleport() end) end

local function autoFarm() while task.wait(1) do local chests = getChests() if #chests == 0 then hopServer() return end for _, chest in pairs(chests) do if chest and chest.Parent then tpTo(chest.Position + Vector3.new(0, 3, 0)) task.wait(0.5) end end end end

game:GetService("Players").PlayerAdded:Connect(function(plr) if plr == player then local team = "Marines" for _, v in pairs(game:GetService("Teams"):GetChildren()) do if v.Name == team then player.Team = v break end end end end)

autoFarm()

