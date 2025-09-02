--не могу пофиксить баг что при включении авто колектора кнопки в гуи уменьшаются
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoCollectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 160)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -60, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Ball Collector"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame
local authorLabel = Instance.new("TextLabel")
authorLabel.Name = "Author"
authorLabel.Size = UDim2.new(1, -20, 0, 20)
authorLabel.Position = UDim2.new(0, 10, 0, 45)
authorLabel.BackgroundTransparency = 1
authorLabel.Text = "by mlwre"
authorLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
authorLabel.TextSize = 12
authorLabel.Font = Enum.Font.Gotham
authorLabel.Parent = mainFrame
local autoCollectButton = Instance.new("TextButton")
autoCollectButton.Name = "AutoCollectButton"
autoCollectButton.Size = UDim2.new(0, 200, 0, 45)
autoCollectButton.Position = UDim2.new(0.5, -100, 0, 80)
autoCollectButton.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
autoCollectButton.BorderSizePixel = 0
autoCollectButton.Text = "AUTO COLLECT: OFF"
autoCollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoCollectButton.TextSize = 14
autoCollectButton.Font = Enum.Font.GothamBold
autoCollectButton.Parent = mainFrame
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = autoCollectButton
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -75, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 15)
minimizeCorner.Parent = minimizeButton
local mobileButton = Instance.new("TextButton")
mobileButton.Name = "MobileButton"
mobileButton.Size = UDim2.new(0, 60, 0, 60)
mobileButton.Position = UDim2.new(0, 20, 0, 100)
mobileButton.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
mobileButton.BorderSizePixel = 0
mobileButton.Text = "AC"
mobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileButton.TextSize = 16
mobileButton.Font = Enum.Font.GothamBold
mobileButton.Visible = false
mobileButton.Active = true
mobileButton.Draggable = true
mobileButton.Parent = screenGui
local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 30)
mobileCorner.Parent = mobileButton
local autoCollecting = false
local function teleportAndCollect(part)
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if not part.Parent then return end
    
    local partPosition = part.Position
    
    humanoidRootPart.CFrame = CFrame.new(partPosition)
    humanoidRootPart.CFrame = CFrame.new(partPosition + Vector3.new(1, 0, 1))
    humanoidRootPart.CFrame = CFrame.new(partPosition + Vector3.new(-1, 0, 1))
    humanoidRootPart.CFrame = CFrame.new(partPosition)
end
local function startAutoCollect()
    spawn(function()
        while autoCollecting do
            local spawnedBalls = workspace:FindFirstChild("SpawnedBalls")
            if spawnedBalls then
                for _, ball in pairs(spawnedBalls:GetChildren()) do
                    if not autoCollecting then break end
                    if ball:IsA("BasePart") and ball.Parent then
                        teleportAndCollect(ball)
                        task.wait(0.03)
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end
local function stopAutoCollect()
    autoCollecting = false
end
autoCollectButton.MouseButton1Click:Connect(function()
    autoCollecting = not autoCollecting
    
    if autoCollecting then
        autoCollectButton.Text = "AUTO COLLECT: ON"
        autoCollectButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startAutoCollect()
    else
        autoCollectButton.Text = "AUTO COLLECT: OFF"
        autoCollectButton.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
        stopAutoCollect()
    end
end)
closeButton.MouseButton1Click:Connect(function()
    autoCollecting = false
    screenGui:Destroy()
end)
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    mobileButton.Visible = true
end)
mobileButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    mobileButton.Visible = false
end)
print("Auto Ball Collector by mlwre загружен!")
