-- Instances:
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local AimText = Instance.new("TextLabel")
local AimButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local MadeBy = Instance.new("TextLabel")
local PlayerCount = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")

-- Properties:
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Name = "AimFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.390139997, 0, 0.307328612, 0)
Frame.Size = UDim2.new(0, 360, 0, 326)

UICorner.Parent = Frame

AimText.Name = "AimText"
AimText.Parent = Frame
AimText.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimText.BorderColor3 = Color3.fromRGB(170, 0, 0)
AimText.BorderSizePixel = 0
AimText.Size = UDim2.new(0, 360, 0, 44)
AimText.Font = Enum.Font.Bangers
AimText.Text = "Aiming System"
AimText.TextColor3 = Color3.fromRGB(170, 0, 0)
AimText.TextSize = 35.000

AimButton.Name = "AimButton"
AimButton.Parent = Frame
AimButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
AimButton.BorderSizePixel = 0
AimButton.Position = UDim2.new(0.222222224, 0, 0.205521479, 0)
AimButton.Size = UDim2.new(0, 213, 0, 79)
AimButton.Font = Enum.Font.Bangers
AimButton.Text = "Enable Aim"
AimButton.TextColor3 = Color3.fromRGB(170, 0, 0)
AimButton.TextSize = 30.000
AimButton.TextStrokeTransparency = 0.000

UICorner_2.Parent = AimButton

MadeBy.Name = "Made By"
MadeBy.Parent = Frame
MadeBy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MadeBy.BackgroundTransparency = 1.000
MadeBy.BorderColor3 = Color3.fromRGB(0, 0, 0)
MadeBy.BorderSizePixel = 0
MadeBy.Position = UDim2.new(0, 0, 0.846625745, 0)
MadeBy.Size = UDim2.new(0, 360, 0, 50)
MadeBy.Font = Enum.Font.Bangers
MadeBy.Text = "Press 'B' to Toggle"
MadeBy.TextColor3 = Color3.fromRGB(170, 0, 0)
MadeBy.TextSize = 30.000

PlayerCount.Name = "PlayerCount"
PlayerCount.Parent = Frame
PlayerCount.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlayerCount.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerCount.BorderSizePixel = 0
PlayerCount.Position = UDim2.new(0.222222224, 0, 0.604294479, 0)
PlayerCount.Size = UDim2.new(0, 213, 0, 79)
PlayerCount.Font = Enum.Font.Bangers
PlayerCount.Text = "Player Count:"
PlayerCount.TextColor3 = Color3.fromRGB(170, 0, 0)
PlayerCount.TextSize = 27.000

UICorner_3.Parent = PlayerCount

-- Player Count Update Script
local function updatePlayerCount()
    local players = game.Players:GetPlayers()
    PlayerCount.Text = "Player Count: " .. #players
end

updatePlayerCount()
game.Players.PlayerAdded:Connect(updatePlayerCount)
game.Players.PlayerRemoving:Connect(updatePlayerCount)

-- Toggle UI Script
local UserInputService = game:GetService("UserInputService")
local aimEnabled = false

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.B then
        aimEnabled = not aimEnabled
        Frame.Visible = aimEnabled
    end
end)

-- Aim Functionality
AimButton.MouseButton1Click:Connect(function()
    local localPlayer = game.Players.LocalPlayer
    local mouse = localPlayer:GetMouse()

    -- Function to find the closest player
    local function getClosestPlayer()
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end

        return closestPlayer
    end

    -- Function to highlight the target
    local function highlightTarget()
        local targetPlayer = getClosestPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Create a simple part to represent the aim
            local targetPart = Instance.new("Part")
            targetPart.Size = Vector3.new(1, 1, 1)
            targetPart.Position = targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0) -- Position above the target
            targetPart.Anchored = true
            targetPart.CanCollide = false
            targetPart.BrickColor = BrickColor.new("Bright red")
            targetPart.Transparency = 0.5
            targetPart.Parent = workspace
            
            -- Keep updating the target's position
            local updateConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    targetPart.Position = targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                else
                    targetPart:Destroy()
                    updateConnection:Disconnect()
                end
            end)
        end
    end

    -- Call highlight target function
    highlightTarget()
end)
