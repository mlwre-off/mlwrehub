local toggleKey = Enum.KeyCode.LeftControl
local correctKey = "kotak"  -- Updated password
local keyValidated = false

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Function to create tweens
local function TweenObject(obj, props, time, style, direction)
    TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props):Play()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScriptsGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Toggle Message Label
local ToggleMessage = Instance.new("TextLabel")
ToggleMessage.Name = "ToggleMessage"
ToggleMessage.Size = UDim2.new(0, 300, 0, 40)
ToggleMessage.Position = UDim2.new(0.5, 0, 0, 10)
ToggleMessage.AnchorPoint = Vector2.new(0.5, 0)
ToggleMessage.BackgroundTransparency = 1
ToggleMessage.Text = "Press Left Control to open GUI"
ToggleMessage.Font = Enum.Font.GothamBlack
ToggleMessage.TextSize = 18
ToggleMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMessage.TextTransparency = 1
ToggleMessage.Parent = ScreenGui

local function showToggleMessage()
    -- Сначала сделаем текст видимым
    ToggleMessage.TextTransparency = 1
    TweenObject(ToggleMessage, {TextTransparency = 0}, 0.5)
    -- Через 4 секунды плавно исчезаем
    task.delay(2, function()
        TweenObject(ToggleMessage, {TextTransparency = 1}, 1)
    end)
end

-- Function to create a styled background frame with shadow and gradient
local function createBackground(parent, size, position)
    local Frame = Instance.new("Frame")
    Frame.Size = size
    Frame.Position = position
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 12)

    local UIGradient = Instance.new("UIGradient", Frame)
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    UIGradient.Rotation = 45

    local DropShadow = Instance.new("ImageLabel", Frame)
    DropShadow.Size = UDim2.new(1, 10, 1, 10)
    DropShadow.Position = UDim2.new(0, -5, 0, -5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://6014261993" -- Shadow image
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.7
    DropShadow.ZIndex = Frame.ZIndex - 1

    return Frame
end

-- Enlarged Key Input Frame (Center)
local KeyFrame = createBackground(ScreenGui, UDim2.new(0, 400, 0, 250), UDim2.new(0.5, 0, 0.5, 0))
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 64, 0, 64)
Logo.Position = UDim2.new(0.5, -32, 0, 20)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6031075935"
Logo.Parent = KeyFrame

-- Key Title
local KeyTitle = Instance.new("TextLabel")
KeyTitle.Name = "KeyTitle"
KeyTitle.Text = "Enter Key"
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.TextSize = 24
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.AnchorPoint = Vector2.new(0.5, 0)
KeyTitle.Position = UDim2.new(0.5, 0, 0.3, 0)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

-- Key Input Box
local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(0, 250, 0, 50)
KeyBox.AnchorPoint = Vector2.new(0.5, 0)
KeyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Enter key..."
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.ClearTextOnFocus = false
KeyBox.Text = ""
KeyBox.Parent = KeyFrame

local KeyBoxCorner = Instance.new("UICorner", KeyBox)
KeyBoxCorner.CornerRadius = UDim.new(0, 10)

-- Submit Button
local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.Size = UDim2.new(0, 120, 0, 50)
SubmitButton.AnchorPoint = Vector2.new(0.5, 0)
SubmitButton.Position = UDim2.new(0.5, 0, 0.8, 0)
SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Text = "Submit"
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 18
SubmitButton.AutoButtonColor = false
SubmitButton.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner", SubmitButton)
SubmitCorner.CornerRadius = UDim.new(0, 10)

local SubmitGradient = Instance.new("UIGradient", SubmitButton)
SubmitGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
SubmitGradient.Rotation = 90

-- Button Animations
SubmitButton.MouseEnter:Connect(function()
    TweenObject(SubmitButton, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}, 0.2)
end)

SubmitButton.MouseLeave:Connect(function()
    TweenObject(SubmitButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
end)

-- Main GUI (Symmetrical Design, No Close Button)
local MainFrame = createBackground(ScreenGui, UDim2.new(0, 450, 0, 400), UDim2.new(0.5, 0, 0.5, 0))
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Visible = false

-- Title Bar (Centered Title)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner", TitleBar)
TitleBarCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Mlwre Hub"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Position = UDim2.new(0.5, 0, 0.5, 0)
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

-- Decorative Separator Line
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, -20, 0, 2)
Separator.Position = UDim2.new(0.5, 0, 1, -5)
Separator.AnchorPoint = Vector2.new(0.5, 1)
Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Separator.Parent = TitleBar

-- Scrolling Frame for Script Buttons
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -30, 1, -130)
ScrollingFrame.Position = UDim2.new(0, 15, 0, 70)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Credits Frame (Centered)
local CreditsFrame = Instance.new("Frame")
CreditsFrame.Name = "CreditsFrame"
CreditsFrame.Size = UDim2.new(1, 0, 0, 40)
CreditsFrame.Position = UDim2.new(0, 0, 1, -45)
CreditsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CreditsFrame.BackgroundTransparency = 0.3
CreditsFrame.BorderSizePixel = 0
CreditsFrame.Parent = MainFrame

local CreditsCorner = Instance.new("UICorner", CreditsFrame)
CreditsCorner.CornerRadius = UDim.new(0, 10)

local Credits = Instance.new("TextLabel")
Credits.Name = "Credits"
Credits.Text = "by mlwr.e"
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 18
Credits.TextColor3 = Color3.fromRGB(200, 200, 200)
Credits.AnchorPoint = Vector2.new(0.5, 0.5)
Credits.Position = UDim2.new(0.5, 0, 0.5, 0)
Credits.BackgroundTransparency = 1
Credits.Parent = CreditsFrame

-- Optional: Background image
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://YOUR_BACKGROUND_IMAGE_ID"
BackgroundImage.ImageTransparency = 0.5
BackgroundImage.Parent = MainFrame

-- Update Canvas Size
local function UpdateCanvas()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

-- Function to create script buttons
local function CreateScriptButton(name, url)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(0, 400, 0, 60)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = name
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 20
    Button.AutoButtonColor = false
    Button.Parent = ScrollingFrame

    local BtnCorner = Instance.new("UICorner", Button)
    BtnCorner.CornerRadius = UDim.new(0, 12)

    local ButtonGradient = Instance.new("UIGradient", Button)
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }
    ButtonGradient.Rotation = 90

    Button.MouseEnter:Connect(function()
        TweenObject(Button, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
        TweenObject(Button, {TextSize = 22}, 0.2)
    end)

    Button.MouseLeave:Connect(function()
        TweenObject(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
        TweenObject(Button, {TextSize = 20}, 0.2)
    end)

    Button.MouseButton1Click:Connect(function()
        local success, errorMsg = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if success then
            TweenObject(Button, {TextColor3 = Color3.fromRGB(0, 255, 0)}, 0.2)
            task.wait(0.2)
            TweenObject(Button, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        else
            warn(errorMsg)
            TweenObject(Button, {TextColor3 = Color3.fromRGB(255, 0, 0)}, 0.2)
            task.wait(0.2)
            TweenObject(Button, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end
    end)
end

-- Adding script buttons
CreateScriptButton("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source")
CreateScriptButton("Arsenal", "https://raw.githubusercontent.com/Insertl/QuotasHub/main/BETAv1.3")
CreateScriptButton("Build a Boat for Treasure", "https://raw.githubusercontent.com/catblox1346/BBHscript/main/owo?token=$(date%20+%s)")
CreateScriptButton("Ring UnAnchored Parts", "https://rawscripts.net/raw/Universal-Script-FE-SUPER-RING-PART-REUPLOADED-22395")
CreateScriptButton("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
CreateScriptButton("Gym Race Simulator", "https://raw.githubusercontent.com/mlwre-off/mlwrehub/refs/heads/main/Gym%20Race%20Simulator%20BETA")
CreateScriptButton("Simple Spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/refs/heads/master/SimpleSpy.lua")

UpdateCanvas()

-- Animation for MainFrame appearance
local originalSize = MainFrame.Size
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local isOpen = false
local lastPosition = MainFrame.Position

local function toggleGUI()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Position = lastPosition
        TweenObject(MainFrame, {Size = originalSize}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        TweenObject(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        MainFrame.Visible = false
        -- Показать сообщение снова после закрытия
        showToggleMessage()
    end
end

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                lastPosition = MainFrame.Position
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Submit button logic
SubmitButton.MouseButton1Click:Connect(function()
    if KeyBox.Text:lower() == correctKey:lower() then
        keyValidated = true
        TweenObject(KeyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        task.wait(0.3)
        KeyFrame:Destroy()
        toggleGUI()
    else
        TweenObject(KeyTitle, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
        KeyTitle.Text = "Invalid Key"
        task.wait(1)
        KeyTitle.Text = "Enter Key"
        TweenObject(KeyTitle, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end
end)

-- Initially show toggle message
showToggleMessage()

-- Toggle GUI with the specified key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey and keyValidated then
        toggleGUI()
    end
end)
