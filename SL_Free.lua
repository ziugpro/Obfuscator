game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=111167393120231&w=420&h=420"
getgenv().ToggleUI = "LeftControl"

task.spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0, 5, 0, 5)
        ImageButton.Size = UDim2.new(0, 55, 0, 55)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.Transparency = 1
        UICorner.CornerRadius = UDim.new(0,10)
        UICorner.Parent = ImageButton
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)

local SkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Tool-Hub-Ui"))()

local UI = SkUI:CreateWindow("SkUI V1.73 - By Ziugpro")

local Tab = UI:Create("General")

Tab:AddTextLabel("Left", "Farming")
Tab:AddDropdown("Left", "Select Regime", {"Easy", "Hard", "Insane"}, "Easy", function(choice)
end)
Tab:AddToggle("Left", "Start Farm (In Dev)", false, function(v)
end)
Tab:RealLine("Left")

Tab:AddTextLabel("Left", "Webhook")
Tab:AddTextbox("Left", "Webhook Url", "", function(text)
end)
Tab:AddToggle("Left", "Tag Everyone", false, function(v)
end)
Tab:AddToggle("Left", "Start Webhook", false, function(v)
end)
Tab:AddText("Left", "Please see webhook activity status below if 🔴 is inactive 🟢 is active 🟡 is maintenance")
Tab:AddLabel("Left", "Status : 🔴")
Tab:AddTextLabel("Left", "Setting")
Tab:AddToggle("Left", "When Up Level", false, function(v)
end)
Tab:AddToggle("Left", "When Buy Sword", false, function(v)
end)
Tab:AddToggle("Left", "When You Lose", false, function(v)
end)
Tab:RealLine("Left")


Tab:AddTextLabel("Right", "Click")
Tab:AddButton("Right", "Reset Setting", function()
    _G.ClickPosition_X = nil
    _G.ClickPosition_Y = nil
    _G.ClickVector2 = nil
    _G.ClickCaptured = false
    _G.ClickStarted = false
    _G.ClickDone = false
end)

Tab:AddToggle("Right", "Click (Test)", false, function(v)
    _G.Toggle_ClickAutoClick = v

    _G.ClickPosition_X = nil
    _G.ClickPosition_Y = nil
    _G.ClickVector2 = nil
    _G.ClickCaptured = false
    _G.ClickStarted = false
    _G.ClickDone = false

    if v then
        spawn(function()
            while _G.Toggle_ClickAutoClick do
                wait()

                if not _G.ClickCaptured and not _G.ClickStarted and not _G.ClickVector2 then
                    _G.ClickStarted = true

                    local UserInputService = game:GetService("UserInputService")
                    local MouseLocation = nil
                    local CaptureConnection = nil

                    CaptureConnection = UserInputService.InputBegan:Connect(function(input, isProcessed)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if not isProcessed then
                                MouseLocation = UserInputService:GetMouseLocation()
                                if MouseLocation then
                                    _G.ClickPosition_X = MouseLocation.X
                                    _G.ClickPosition_Y = MouseLocation.Y
                                    _G.ClickVector2 = Vector2.new(_G.ClickPosition_X, _G.ClickPosition_Y)
                                    _G.ClickCaptured = true
                                    if CaptureConnection then
                                        CaptureConnection:Disconnect()
                                    end
                                end
                            end
                        end
                    end)
                end

                if _G.ClickVector2 and not _G.ClickDone and _G.ClickCaptured then
                    wait(2)

                    local VirtualInputManager = game:GetService("VirtualInputManager")

                    if VirtualInputManager and _G.ClickVector2 then
                        VirtualInputManager:SendMouseButtonEvent(
                            _G.ClickVector2.X,
                            _G.ClickVector2.Y,
                            0,
                            true,
                            game,
                            0
                        )
                        VirtualInputManager:SendMouseButtonEvent(
                            _G.ClickVector2.X,
                            _G.ClickVector2.Y,
                            0,
                            false,
                            game,
                            0
                        )
                        _G.ClickDone = true
                    end
                end
            end
        end)
    else
        _G.ClickPosition_X = nil
        _G.ClickPosition_Y = nil
        _G.ClickVector2 = nil
        _G.ClickCaptured = false
        _G.ClickStarted = false
        _G.ClickDone = false
    end
end)
local VirtualInputManager = game:GetService("VirtualInputManager")

_G.ClickStep = 20
_G.ToggleClickAllPositions = false

Tab:AddSlider("Right", "Radius Click", 30, 500, _G.ClickStep, function(value)
    _G.ClickStep = math.floor(value)
end)

Tab:AddToggle("Right", "Click (v2)", false, function(state)
    _G.ToggleClickAllPositions = state

    if state then
        while _G.ToggleClickAllPositions do
            wait(2)

            local viewportSize = workspace.CurrentCamera.ViewportSize
            local step = _G.ClickStep or 20
            local clicks = {}

            local x = 0
            while x <= viewportSize.X do
                local y = 0
                while y <= viewportSize.Y do
                    table.insert(clicks, {x = x, y = y})
                    y = y + step
                end
                x = x + step
            end

            local i = 1
            while i <= #clicks do
                local pos = clicks[i]

                VirtualInputManager:SendMouseButtonEvent(pos.x, pos.y, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(pos.x, pos.y, 0, false, game, 0)

                i = i + 1
            end

            local dummy = 0
            dummy = dummy + 1
            dummy = dummy * 2
            dummy = dummy - 3
            dummy = dummy / 4
            dummy = dummy ^ 2
            dummy = dummy % 5

            local str = "a"
            str = str .. "b"
            str = str:sub(1,1)
            str = string.upper(str)
            str = str:rep(3)

            wait(1)
        end
    end
end)
Tab:RealLine("Right")
Tab:AddTextLabel("Right", "Esp")
Tab:AddToggle("Right", "🏝️ Island ESP", false, function(v)
    _G.ToggleESPIslandModels = v

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:lower():find("island") then
            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")

            if v and not existingESP then
                local primary = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local ESPGui = Instance.new("BillboardGui")
                    ESPGui.Name = "SUPER_ESP_GUI"
                    ESPGui.Adornee = primary
                    ESPGui.Size = UDim2.new(0, 200, 0, 50)
                    ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                    ESPGui.AlwaysOnTop = true
                    ESPGui.ResetOnSpawn = false
                    ESPGui.Parent = model

                    local BackgroundFrame = Instance.new("Frame")
                    BackgroundFrame.Name = "BackgroundFrame"
                    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    BackgroundFrame.BackgroundTransparency = 0.5
                    BackgroundFrame.BorderSizePixel = 0
                    BackgroundFrame.Parent = ESPGui

                    local StrokeFrame = Instance.new("UIStroke")
                    StrokeFrame.Color = Color3.fromRGB(0, 255, 127)
                    StrokeFrame.Thickness = 2
                    StrokeFrame.Transparency = 0.1
                    StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    StrokeFrame.Parent = BackgroundFrame

                    local Label = Instance.new("TextLabel")
                    Label.Name = "IslandName"
                    Label.Size = UDim2.new(1, 0, 1, 0)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = "🏝️ " .. model.Name
                    Label.TextColor3 = Color3.fromRGB(135, 206, 235)
                    Label.TextStrokeTransparency = 0
                    Label.TextScaled = true
                    Label.Font = Enum.Font.GothamBold
                    Label.Parent = BackgroundFrame
                end
            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:AddToggle("Right", "🧍 Player ESP", false, function(v)
    _G.ToggleESPPlayers = v

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local existingESP = char:FindFirstChild("SUPER_ESP_GUI")

                if v and not existingESP then
                    local ESPGui = Instance.new("BillboardGui")
                    ESPGui.Name = "SUPER_ESP_GUI"
                    ESPGui.Adornee = char:FindFirstChild("HumanoidRootPart")
                    ESPGui.Size = UDim2.new(0, 200, 0, 50)
                    ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                    ESPGui.AlwaysOnTop = true
                    ESPGui.ResetOnSpawn = false
                    ESPGui.Parent = char

                    local BackgroundFrame = Instance.new("Frame")
                    BackgroundFrame.Name = "BackgroundFrame"
                    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    BackgroundFrame.BackgroundTransparency = 0.5
                    BackgroundFrame.BorderSizePixel = 0
                    BackgroundFrame.Parent = ESPGui

                    local StrokeFrame = Instance.new("UIStroke")
                    StrokeFrame.Color = Color3.fromRGB(255, 85, 85)
                    StrokeFrame.Thickness = 2
                    StrokeFrame.Transparency = 0.1
                    StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    StrokeFrame.Parent = BackgroundFrame

                    local Label = Instance.new("TextLabel")
                    Label.Name = "PlayerName"
                    Label.Size = UDim2.new(1, 0, 1, 0)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = "🧍 " .. player.DisplayName
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextStrokeTransparency = 0
                    Label.TextScaled = true
                    Label.Font = Enum.Font.GothamBold
                    Label.Parent = BackgroundFrame
                elseif not v and existingESP then
                    existingESP:Destroy()
                end
            end
        end
    end
end)
Tab:AddToggle("Right", "🤖 NPC ESP", false, function(v)
    _G.ToggleESPNPCs = v

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local isPlayerChar = false
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character == model then
                    isPlayerChar = true
                    break
                end
            end

            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")

            if v and not isPlayerChar and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model:FindFirstChild("HumanoidRootPart")
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model

                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui

                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(255, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "🤖 " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame

            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:AddToggle("Right", "🧍 Sword ESP", false, function(v)
    _G.ToggleESPPlayerTools = v

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local existingESP = char:FindFirstChild("SUPER_ESP_GUI")

                if v and not existingESP then
                    local ESPGui = Instance.new("BillboardGui")
                    ESPGui.Name = "SUPER_ESP_GUI"
                    ESPGui.Adornee = char:FindFirstChild("HumanoidRootPart")
                    ESPGui.Size = UDim2.new(0, 200, 0, 50)
                    ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                    ESPGui.AlwaysOnTop = true
                    ESPGui.ResetOnSpawn = false
                    ESPGui.Parent = char

                    local BackgroundFrame = Instance.new("Frame")
                    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    BackgroundFrame.BackgroundTransparency = 0.5
                    BackgroundFrame.BorderSizePixel = 0
                    BackgroundFrame.Parent = ESPGui

                    local StrokeFrame = Instance.new("UIStroke")
                    StrokeFrame.Color = Color3.fromRGB(0, 255, 255)
                    StrokeFrame.Thickness = 2
                    StrokeFrame.Transparency = 0.1
                    StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    StrokeFrame.Parent = BackgroundFrame

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, 0, 1, 0)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextStrokeTransparency = 0
                    Label.TextScaled = true
                    Label.Font = Enum.Font.GothamBold
                    Label.TextWrapped = true
                    Label.TextYAlignment = Enum.TextYAlignment.Top
                    Label.Parent = BackgroundFrame

                    task.spawn(function()
                        while _G.ToggleESPPlayerTools and ESPGui.Parent ~= nil do
                            local toolNames = {}

                            for _, tool in pairs(player.Backpack:GetChildren()) do
                                if tool:IsA("Tool") then
                                    table.insert(toolNames, tool.Name)
                                end
                            end
                            for _, tool in pairs(char:GetChildren()) do
                                if tool:IsA("Tool") then
                                    table.insert(toolNames, tool.Name)
                                end
                            end

                            Label.Text = "🧰 Tools:\n" .. (#toolNames > 0 and table.concat(toolNames, "\n") or "None")

                            task.wait(0.5)
                        end
                    end)
                elseif not v and existingESP then
                    existingESP:Destroy()
                end
            end
        end
    end
end)
Tab:RealLine("Right")
