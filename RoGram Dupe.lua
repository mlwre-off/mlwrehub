local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Credit = Instance.new("TextLabel")
local DupeButton = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.4, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 140)
MainFrame.ZIndex = 999999

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.ZIndex = 999999

UICorner_2.CornerRadius = UDim.new(0, 12)
UICorner_2.Parent = TopBar

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "ROGRAM DUPE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.ZIndex = 999999

Credit.Name = "Credit"
Credit.Parent = MainFrame
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 10, 0, 45)
Credit.Size = UDim2.new(1, -20, 0, 20)
Credit.Font = Enum.Font.Gotham
Credit.Text = "Script by t.me/script_robloxx"
Credit.TextColor3 = Color3.fromRGB(150, 150, 160)
Credit.TextSize = 12
Credit.TextXAlignment = Enum.TextXAlignment.Left
Credit.ZIndex = 999999

DupeButton.Name = "DupeButton"
DupeButton.Parent = MainFrame
DupeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DupeButton.BorderSizePixel = 0
DupeButton.Position = UDim2.new(0, 20, 0, 80)
DupeButton.Size = UDim2.new(1, -40, 0, 45)
DupeButton.Font = Enum.Font.GothamBold
DupeButton.Text = "DUPE STARS"
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.TextSize = 16
DupeButton.ZIndex = 999999

UICorner_3.CornerRadius = UDim.new(0, 8)
UICorner_3.Parent = DupeButton

local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local duping = false

DupeButton.MouseButton1Click:Connect(function()
    duping = not duping
    if duping then
        DupeButton.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
        DupeButton.Text = "STOP DUPING"
        for i = 1, 3 do
            task.spawn(function()
                while duping do
                    local args = {
                        buffer.fromstring("\f\099")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("ByteNetUnreliable"):FireServer(unpack(args))
                    task.wait(0)
                end
            end)
        end
    else
        DupeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        DupeButton.Text = "DUPE STARS"
    end
end)
