--------------------------------------------------------------------------------
--                             СЕРВИСЫ И ПЕРЕМЕННЫЕ                           --
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
--                         ТОЛЬКО АНГЛИЙСКИЙ ЯЗЫК                             --
--------------------------------------------------------------------------------
local Strings = {
    Title = "SCRIPTER TOOLS",
    NewTab = "New Tab",
    RunOnce = "Run Once",
    RunLoop = "Run Loop",
    Stop = "Stop",
    CloseTab = "Close Tab",
    ClearAllTabs = "Clear All Tabs",
    ClearLogs = "Clear Logs",
    Delay = "Delay:",
    ScriptPlaceholder = "Enter your script here",
    EmptyScriptMsg = "[!] Script is empty, nothing to run.",
    CompileErrorMsg = "[!] Compile Error: ",
    RuntimeErrorMsg = "[!] Runtime Error: ",
    LoopStartMsg = "[+] Started loop.",
    LoopAlreadyMsg = "[!] Already looping...",
    LoopStoppedMsg = "[+] Stopped loop.",
    NoLoopMsg = "[!] No loop running...",
    LogsClearedMsg = "[~] Logs cleared.",
    ScriptRanOnceMsg = "[+] Ran script once successfully."
}

-- Удобная функция для получения строк
local function S(key)
    return Strings[key] or key
end

--------------------------------------------------------------------------------
--                          ПЕРЕМЕННЫЕ ДЛЯ GUI                                 --
--------------------------------------------------------------------------------
local isOpen = true  -- флаг, открыто ли окно

-- Вкладки
local tabs = {}
local currentTab = nil
local tabCount = 0

--------------------------------------------------------------------------------
--                          ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ                           --
--------------------------------------------------------------------------------
local function removeTab(tabData)
    if tabData.Running and tabData.LoopConnection then
        tabData.LoopConnection:Disconnect()
        tabData.LoopConnection = nil
        tabData.Running = false
    end
    if tabData.Frame then
        tabData.Frame:Destroy()
    end
    if tabData.Button then
        tabData.Button:Destroy()
    end
    for i, t in ipairs(tabs) do
        if t == tabData then
            table.remove(tabs, i)
            break
        end
    end
end

local function switchTab(targetTab)
    if currentTab then
        currentTab.Frame.Visible = false
    end
    currentTab = targetTab
    currentTab.Frame.Visible = true
end

--------------------------------------------------------------------------------
--                           ОСНОВНОЙ GUI (buildMainGUI)                      --
--------------------------------------------------------------------------------
local screenGui
local mainFrame
local tabContainer
local contentFrame
local closeButton
local newTabButton

local function buildMainGUI()
    -- ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScripterToolsGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Главное окно (800×480)
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 800, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -240)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- Заголовок (TitleBar)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    -- Заголовок (текст)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = S("Title")
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Надпись "by mlwr.e" (сверху, чуть левее, чтобы не закрывалась кнопкой)
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Name = "CreditLabel"
    creditLabel.Size = UDim2.new(0, 80, 1, 0)
    creditLabel.Position = UDim2.new(1, -150, 0, 0) -- Сдвинули левее (было -110)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Text = "by mlwr.e"
    creditLabel.Font = Enum.Font.SourceSansBold
    creditLabel.TextSize = 18
    creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditLabel.TextXAlignment = Enum.TextXAlignment.Center
    creditLabel.Parent = titleBar

    closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    -- Полоса вкладок (Tab Bar)
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    local tabBarCorner = Instance.new("UICorner")
    tabBarCorner.CornerRadius = UDim.new(0, 0)
    tabBarCorner.Parent = tabBar

    -- Прокрутка вкладок (ScrollingFrame)
    tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -120, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    tabContainer.ScrollBarThickness = 6
    tabContainer.BorderSizePixel = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 1, 0)
    tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabContainer.Parent = tabBar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer

    -- Кнопка "New Tab"
    newTabButton = Instance.new("TextButton")
    newTabButton.Name = "NewTabButton"
    newTabButton.Size = UDim2.new(0, 80, 1, 0)
    newTabButton.Position = UDim2.new(1, -80, 0, 0)
    newTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    newTabButton.BorderSizePixel = 0
    newTabButton.Text = S("NewTab")
    newTabButton.Font = Enum.Font.SourceSansBold
    newTabButton.TextSize = 16
    newTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    newTabButton.Parent = tabBar

    -- Основная зона контента
    contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -70) -- 40 + 30 = 70
    contentFrame.Position = UDim2.new(0, 0, 0, 70)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame

    ----------------------------------------------------------------------------
    -- ДРАГ ОКНА (перетаскивание за TitleBar)
    ----------------------------------------------------------------------------
    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    ----------------------------------------------------------------------------
    -- СВЕРНУТЬ / РАЗВЕРНУТЬ
    ----------------------------------------------------------------------------
    local function toggleGUI()
        if isOpen then
            local tween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }
            )
            tween:Play()
            tween.Completed:Connect(function()
                mainFrame.Visible = false
            end)
        else
            mainFrame.Visible = true
            local tween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 800, 0, 480), Position = UDim2.new(0.5, -400, 0.5, -240) }
            )
            tween:Play()
        end
        isOpen = not isOpen
    end

    closeButton.MouseButton1Click:Connect(toggleGUI)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            toggleGUI()
        end
    end)

    -- Сбрасываем вкладки
    tabs = {}
    currentTab = nil
    tabCount = 0

    ----------------------------------------------------------------------------
    -- Создание новой вкладки
    ----------------------------------------------------------------------------
    local function createNewTab()
        tabCount += 1
        local tabData = {
            Name = "Tab" .. tostring(tabCount),
            Frame = nil,
            Button = nil,
            Running = false,
            LoopConnection = nil
        }

        -- Кнопка вкладки
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 1, 0)
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        button.BorderSizePixel = 0
        button.Text = tabData.Name
        button.Font = Enum.Font.SourceSansBold
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 16
        button.LayoutOrder = tabCount
        button.Parent = tabContainer

        -- Сам фрейм вкладки
        local tabFrame = Instance.new("Frame")
        tabFrame.Name = tabData.Name .. "_Frame"
        tabFrame.Size = UDim2.new(1, -20, 1, -20)
        tabFrame.Position = UDim2.new(0, 10, 0, 10)
        tabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabFrame.Visible = false
        tabFrame.Parent = contentFrame

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 10)
        frameCorner.Parent = tabFrame

        -- Левая половина (Script Box)
        local scriptFrame = Instance.new("Frame")
        scriptFrame.Size = UDim2.new(0.5, -10, 1, -60)
        scriptFrame.Position = UDim2.new(0, 10, 0, 10)
        scriptFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        scriptFrame.Parent = tabFrame

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 8)
        sCorner.Parent = scriptFrame

        local scriptBox = Instance.new("TextBox")
        scriptBox.Size = UDim2.new(1, -10, 1, -10)
        scriptBox.Position = UDim2.new(0, 5, 0, 5)
        scriptBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        scriptBox.BorderSizePixel = 0
        scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptBox.TextSize = 16
        scriptBox.Font = Enum.Font.SourceSans
        scriptBox.PlaceholderText = S("ScriptPlaceholder")
        scriptBox.TextWrapped = true
        scriptBox.MultiLine = true
        scriptBox.ClearTextOnFocus = false
        scriptBox.Parent = scriptFrame

        local sbCorner = Instance.new("UICorner")
        sbCorner.CornerRadius = UDim.new(0, 6)
        sbCorner.Parent = scriptBox

        -- Правая половина (Logs)
        local logsFrame = Instance.new("Frame")
        logsFrame.Size = UDim2.new(0.5, -10, 1, -60)
        logsFrame.Position = UDim2.new(0.5, 0, 0, 10)
        logsFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        logsFrame.Parent = tabFrame

        local lfCorner = Instance.new("UICorner")
        lfCorner.CornerRadius = UDim.new(0, 8)
        lfCorner.Parent = logsFrame

        local scrollingLogs = Instance.new("ScrollingFrame")
        scrollingLogs.Size = UDim2.new(1, -10, 1, -50)
        scrollingLogs.Position = UDim2.new(0, 5, 0, 5)
        scrollingLogs.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        scrollingLogs.ScrollBarThickness = 8
        scrollingLogs.BorderSizePixel = 0
        scrollingLogs.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollingLogs.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingLogs.Parent = logsFrame

        local slCorner = Instance.new("UICorner")
        slCorner.CornerRadius = UDim.new(0, 6)
        slCorner.Parent = scrollingLogs

        local logsLayout = Instance.new("UIListLayout")
        logsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        logsLayout.Padding = UDim.new(0, 4)
        logsLayout.Parent = scrollingLogs

        local clearLogsButton = Instance.new("TextButton")
        clearLogsButton.Size = UDim2.new(1, -10, 0, 40)
        clearLogsButton.Position = UDim2.new(0, 5, 1, -45)
        clearLogsButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        clearLogsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        clearLogsButton.Font = Enum.Font.SourceSansBold
        clearLogsButton.TextSize = 16
        clearLogsButton.Text = S("ClearLogs")
        clearLogsButton.Parent = logsFrame

        local clCorner = Instance.new("UICorner")
        clCorner.CornerRadius = UDim.new(0, 6)
        clCorner.Parent = clearLogsButton

        ----------------------------------------------------------------------------
        -- НИЖНЯЯ ПАНЕЛЬ: слева Delay, справа кнопки
        ----------------------------------------------------------------------------
        local controlsFrame = Instance.new("Frame")
        controlsFrame.Name = "ControlsFrame"
        controlsFrame.Size = UDim2.new(1, -20, 0, 40)
        controlsFrame.Position = UDim2.new(0, 10, 1, -50)
        controlsFrame.BackgroundTransparency = 1
        controlsFrame.Parent = tabFrame

        -- DelayFrame (слева)
        local delayFrame = Instance.new("Frame")
        delayFrame.Name = "DelayFrame"
        delayFrame.Size = UDim2.new(0.5, 0, 1, 0)
        delayFrame.BackgroundTransparency = 1
        delayFrame.Parent = controlsFrame

        local delayLabel = Instance.new("TextLabel")
        delayLabel.Size = UDim2.new(0, 80, 0, 30)
        delayLabel.Position = UDim2.new(0, 0, 0.5, -15)
        delayLabel.BackgroundTransparency = 1
        delayLabel.Text = S("Delay")
        delayLabel.Font = Enum.Font.SourceSansBold
        delayLabel.TextSize = 14
        delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        delayLabel.TextXAlignment = Enum.TextXAlignment.Right
        delayLabel.Parent = delayFrame

        local delayBox = Instance.new("TextBox")
        delayBox.Name = "DelayBox"
        delayBox.Size = UDim2.new(0, 70, 0, 30)
        delayBox.Position = UDim2.new(0, 90, 0.5, -15)
        delayBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        delayBox.Font = Enum.Font.SourceSans
        delayBox.TextSize = 14
        delayBox.Text = "1"
        delayBox.ClearTextOnFocus = false
        delayBox.Parent = delayFrame

        local delayCorner = Instance.new("UICorner")
        delayCorner.CornerRadius = UDim.new(0, 6)
        delayCorner.Parent = delayBox

        -- ButtonsFrame (справа)
        local buttonsFrame = Instance.new("Frame")
        buttonsFrame.Name = "ButtonsFrame"
        buttonsFrame.Size = UDim2.new(0.5, 0, 1, 0)
        buttonsFrame.Position = UDim2.new(0.5, 0, 0, 0)
        buttonsFrame.BackgroundTransparency = 1
        buttonsFrame.Parent = controlsFrame

        local buttonsLayout = Instance.new("UIListLayout")
        buttonsLayout.FillDirection = Enum.FillDirection.Horizontal
        buttonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        buttonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        buttonsLayout.Padding = UDim.new(0, 5)
        buttonsLayout.Parent = buttonsFrame

        -- Кнопки: Run Once, Run Loop, Stop, Close Tab, Clear All Tabs (NO Clear All)
        local buttonNames = {
            { Name="RunOnce",       Text=S("RunOnce"),       Color=Color3.fromRGB(0, 200, 0) },
            { Name="RunLoop",       Text=S("RunLoop"),       Color=Color3.fromRGB(255,165,0) },
            { Name="Stop",          Text=S("Stop"),          Color=Color3.fromRGB(200, 0, 0) },
            { Name="CloseTab",      Text=S("CloseTab"),      Color=Color3.fromRGB(128, 0, 128) },
            { Name="ClearAllTabs",  Text=S("ClearAllTabs"),  Color=Color3.fromRGB(80,80,200) },
        }

        local runOnceButton, runLoopButton, stopButton
        local closeTabButton, clearTabsButton

        for _, info in ipairs(buttonNames) do
            local b = Instance.new("TextButton")
            b.Name = info.Name
            b.Size = UDim2.new(0, 80, 0, 35)
            b.BackgroundColor3 = info.Color
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.SourceSansBold
            b.TextSize = 14
            b.Text = info.Text
            b.Parent = buttonsFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = b

            if info.Name == "RunOnce" then
                runOnceButton = b
            elseif info.Name == "RunLoop" then
                runLoopButton = b
            elseif info.Name == "Stop" then
                stopButton = b
            elseif info.Name == "CloseTab" then
                closeTabButton = b
            elseif info.Name == "ClearAllTabs" then
                clearTabsButton = b
            end
        end

        ----------------------------------------------------------------------------
        -- ЛОГИКА: ЗАПУСК СКРИПТОВ, ОЧИСТКА, УДАЛЕНИЕ ВКЛАДОК
        ----------------------------------------------------------------------------
        local function printLog(msg, color)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.TextWrapped = true
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
            lbl.Text = msg
            lbl.Parent = scrollingLogs
        end

        local function runScriptOnce()
            local code = scriptBox.Text
            if code == "" then
                printLog(S("EmptyScriptMsg"), Color3.fromRGB(255,220,0))
                return
            end
            local f, err = loadstring(code)
            if f then
                local ok, execErr = pcall(f)
                if ok then
                    printLog(S("ScriptRanOnceMsg"))
                else
                    printLog(S("RuntimeErrorMsg")..execErr, Color3.fromRGB(255,100,100))
                end
            else
                printLog(S("CompileErrorMsg")..err, Color3.fromRGB(255,100,100))
            end
        end

        local function startLoop()
            if tabData.Running then
                printLog(S("LoopAlreadyMsg"), Color3.fromRGB(255,220,0))
                return
            end
            tabData.Running = true
            printLog(S("LoopStartMsg"))

            local code = scriptBox.Text
            local delayTime = 1
            if delayBox and delayBox:IsA("TextBox") then
                delayTime = tonumber(delayBox.Text) or 1
            end

            tabData.LoopConnection = RunService.Heartbeat:Connect(function()
                if not tabData.Running then return end
                local f, err = loadstring(code)
                if f then
                    pcall(f)
                else
                    printLog(S("CompileErrorMsg")..err, Color3.fromRGB(255,100,100))
                end
                wait(delayTime)
            end)
        end

        local function stopLoop()
            if not tabData.Running then
                printLog(S("NoLoopMsg"), Color3.fromRGB(255,220,0))
                return
            end
            tabData.Running = false
            if tabData.LoopConnection then
                tabData.LoopConnection:Disconnect()
                tabData.LoopConnection = nil
            end
            printLog(S("LoopStoppedMsg"))
        end

        runOnceButton.MouseButton1Click:Connect(runScriptOnce)
        runLoopButton.MouseButton1Click:Connect(startLoop)
        stopButton.MouseButton1Click:Connect(stopLoop)

        -- Очистка логов
        clearLogsButton.MouseButton1Click:Connect(function()
            for _, c in ipairs(scrollingLogs:GetChildren()) do
                if c:IsA("TextLabel") then
                    c:Destroy()
                end
            end
            printLog(S("LogsClearedMsg"))
        end)

        local function closeTab()
            removeTab(tabData)
            if currentTab == tabData then
                if #tabs > 0 then
                    switchTab(tabs[#tabs])
                else
                    createNewTab()
                end
            end
        end
        closeTabButton.MouseButton1Click:Connect(closeTab)

        clearTabsButton.MouseButton1Click:Connect(function()
            for i = #tabs, 1, -1 do
                removeTab(tabs[i])
            end
            createNewTab()
        end)

        -- Кнопки "Clear All" нет

        -- Переключение вкладки
        button.MouseButton1Click:Connect(function()
            switchTab(tabData)
        end)

        tabData.Button = button
        tabData.Frame = tabFrame
        table.insert(tabs, tabData)
        switchTab(tabData)
    end

    newTabButton.MouseButton1Click:Connect(createNewTab)

    ----------------------------------------------------------------------------
    -- Анимация появления: из 0×0 → 800×480
    ----------------------------------------------------------------------------
    mainFrame.Visible = false
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    task.wait(0.1)
    mainFrame.Visible = true

    local openTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 800, 0, 480), Position = UDim2.new(0.5, -400, 0.5, -240) }
    )
    openTween:Play()

    isOpen = true

    -- Создаём первую вкладку
    createNewTab()
end

--------------------------------------------------------------------------------
--      СТРОИМ ОСНОВНОЙ GUI (Только EN, Без "Clear All", "by mlwr.e" сверху)  --
--------------------------------------------------------------------------------
buildMainGUI()
