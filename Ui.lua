local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Theme = {
    Main = Color3.fromRGB(17, 20, 28),
    Panel = Color3.fromRGB(23, 26, 36),
    Card = Color3.fromRGB(28, 31, 42),
    CardHover = Color3.fromRGB(38, 40, 54),
    Stroke = Color3.fromRGB(90, 92, 115),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(155, 157, 170),
    Accent = Color3.fromRGB(145, 95, 255),
    Accent2 = Color3.fromRGB(175, 130, 255),
    Danger = Color3.fromRGB(185, 70, 85)
}

local Character, Humanoid, Root
local function updateCharacter()
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Character:WaitForChild("HumanoidRootPart")
end
updateCharacter()

Player.CharacterAdded:Connect(function()
    task.wait(0.25)
    updateCharacter()
end)

local State = {
    SpeedEnabled = false,
    Speed = 16,
    JumpEnabled = false,
    JumpPower = 50,
    FlyEnabled = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
}

local Connections = {}
local Pages = {}
local TabButtons = {}
local CurrentTab
local Minimized = false
local buttonRefs = {}
local MainNormalSize = UDim2.fromOffset(1050, 680)

local FlyVelocity, FlyGyro, FlyConnection

local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function tween(instance, duration, props)
    local t = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function make(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local ScreenGui = make("ScreenGui", {
    Name = "NightSystemUI",
    Parent = PlayerGui,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local Main = make("Frame", {
    Parent = ScreenGui,
    Size = MainNormalSize,
    Position = UDim2.new(0.5, -525, 0.5, -340),
    BackgroundColor3 = Theme.Main,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    ClipsDescendants = true
})

make("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 18)})
make("UIStroke", {
    Parent = Main,
    Color = Theme.Accent,
    Thickness = 1,
    Transparency = 0.48
})

local Header = make("Frame", {
    Parent = Main,
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundTransparency = 1
})

local DragArea = make("Frame", {
    Parent = Header,
    Size = UDim2.new(1, -180, 1, 0),
    BackgroundTransparency = 1
})

local Logo = make("TextLabel", {
    Parent = Header,
    Position = UDim2.fromOffset(25, 18),
    Size = UDim2.fromOffset(50, 55),
    BackgroundTransparency = 1,
    Text = "N",
    TextColor3 = Theme.Accent2,
    Font = Enum.Font.GothamBlack,
    TextSize = 46
})

local Title = make("TextLabel", {
    Parent = Header,
    Position = UDim2.fromOffset(85, 22),
    Size = UDim2.fromOffset(350, 30),
    BackgroundTransparency = 1,
    Text = "Night System",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Left
})

local Version = make("TextLabel", {
    Parent = Header,
    Position = UDim2.fromOffset(87, 53),
    Size = UDim2.fromOffset(120, 20),
    BackgroundTransparency = 1,
    Text = "v1.0.0",
    TextColor3 = Theme.SubText,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
})

local ControlBox = make("Frame", {
    Parent = Header,
    Position = UDim2.new(1, -150, 0, 22),
    Size = UDim2.fromOffset(125, 55),
    BackgroundColor3 = Theme.Panel,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0
})
make("UICorner", {Parent = ControlBox, CornerRadius = UDim.new(0, 13)})
make("UIStroke", {Parent = ControlBox, Color = Theme.Stroke, Transparency = 0.7})

local Minimize = make("TextButton", {
    Parent = ControlBox,
    Size = UDim2.fromOffset(61, 55),
    Position = UDim2.fromOffset(0, 0),
    BackgroundTransparency = 1,
    Text = "—",
    TextColor3 = Theme.Text,
    Font = Enum.Font.Gotham,
    TextSize = 24,
    AutoButtonColor = false
})

local Close = make("TextButton", {
    Parent = ControlBox,
    Size = UDim2.fromOffset(61, 55),
    Position = UDim2.fromOffset(63, 0),
    BackgroundTransparency = 1,
    Text = "×",
    TextColor3 = Theme.Text,
    Font = Enum.Font.Gotham,
    TextSize = 28,
    AutoButtonColor = false
})

local Divider = make("Frame", {
    Parent = Main,
    Position = UDim2.fromOffset(0, 99),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Theme.Stroke,
    BackgroundTransparency = 0.78,
    BorderSizePixel = 0
})

local Sidebar = make("Frame", {
    Parent = Main,
    Position = UDim2.fromOffset(20, 120),
    Size = UDim2.fromOffset(230, 540),
    BackgroundTransparency = 1
})

local SidebarList = make("UIListLayout", {
    Parent = Sidebar,
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10)
})

local SidebarPaddingBottom = 74

local Content = make("Frame", {
    Parent = Main,
    Position = UDim2.fromOffset(270, 120),
    Size = UDim2.new(1, -290, 1, -140),
    BackgroundTransparency = 1
})

local function createPage(name)
    local page = make("ScrollingFrame", {
        Parent = Content,
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    })

    local list = make("UIListLayout", {
        Parent = page,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local pad = make("UIPadding", {
        Parent = page,
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 20)
    })

    connect(list:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 24)
    end)

    Pages[name] = page
    return page
end

local function section(parent, text)
    local holder = make("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1
    })

    local line = make("Frame", {
        Parent = holder,
        Position = UDim2.fromOffset(2, 5),
        Size = UDim2.fromOffset(4, 24),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0
    })
    make("UICorner", {Parent = line, CornerRadius = UDim.new(1, 0)})

    make("TextLabel", {
        Parent = holder,
        Position = UDim2.fromOffset(18, 0),
        Size = UDim2.new(1, -18, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

local function card(parent, height, order)
    local frame = make("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -4, 0, height),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.28,
        BorderSizePixel = 0,
        LayoutOrder = order or 0
    })
    make("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 13)})
    make("UIStroke", {
        Parent = frame,
        Color = Theme.Stroke,
        Transparency = 0.68,
        Thickness = 1
    })
    return frame
end

local function addTitle(frame, text, desc)
    make("TextLabel", {
        Parent = frame,
        Position = UDim2.fromOffset(20, 11),
        Size = UDim2.new(1, -110, 0, 24),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    if desc then
        make("TextLabel", {
            Parent = frame,
            Position = UDim2.fromOffset(20, 37),
            Size = UDim2.new(1, -110, 0, 20),
            BackgroundTransparency = 1,
            Text = desc,
            TextColor3 = Theme.SubText,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
end

local function addToggle(parent, title, desc, default, callback)
    local frame = card(parent, 74)
    addTitle(frame, title, desc)

    local hit = make("TextButton", {
        Parent = frame,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })

    local switch = make("Frame", {
        Parent = frame,
        Size = UDim2.fromOffset(58, 30),
        Position = UDim2.new(1, -78, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(55, 58, 70),
        BorderSizePixel = 0
    })
    make("UICorner", {Parent = switch, CornerRadius = UDim.new(1, 0)})

    local knob = make("Frame", {
        Parent = switch,
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.fromOffset(4, 4),
        BackgroundColor3 = Color3.fromRGB(220, 220, 225),
        BorderSizePixel = 0
    })
    make("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})

    local state = default and true or false

    local function render(call)
        if state then
            tween(switch, 0.16, {BackgroundColor3 = Theme.Accent})
            tween(knob, 0.16, {Position = UDim2.new(1, -26, 0, 4)})
        else
            tween(switch, 0.16, {BackgroundColor3 = Color3.fromRGB(55, 58, 70)})
            tween(knob, 0.16, {Position = UDim2.fromOffset(4, 4)})
        end

        if call and callback then
            callback(state)
        end
    end

    connect(hit.MouseButton1Click, function()
        state = not state
        render(true)
    end)

    connect(hit.MouseEnter, function()
        tween(frame, 0.12, {BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 0.15})
    end)

    connect(hit.MouseLeave, function()
        tween(frame, 0.12, {BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.28})
    end)

    render(false)
    return frame
end

local function addSlider(parent, title, min, max, default, callback)
    local frame = card(parent, 101)
    addTitle(frame, title)

    local valueLabel = make("TextLabel", {
        Parent = frame,
        Position = UDim2.new(1, -83, 0, 11),
        Size = UDim2.fromOffset(63, 24),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Theme.Accent2,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local minLabel = make("TextLabel", {
        Parent = frame,
        Position = UDim2.fromOffset(20, 43),
        Size = UDim2.fromOffset(90, 18),
        BackgroundTransparency = 1,
        Text = tostring(min),
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local maxLabel = make("TextLabel", {
        Parent = frame,
        Position = UDim2.new(1, -120, 0, 43),
        Size = UDim2.fromOffset(100, 18),
        BackgroundTransparency = 1,
        Text = tostring(max),
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local bar = make("Frame", {
        Parent = frame,
        Position = UDim2.fromOffset(20, 68),
        Size = UDim2.new(1, -40, 0, 7),
        BackgroundColor3 = Color3.fromRGB(54, 57, 68),
        BorderSizePixel = 0
    })
    make("UICorner", {Parent = bar, CornerRadius = UDim.new(1, 0)})

    local fill = make("Frame", {
        Parent = bar,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0
    })
    make("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})

    local knob = make("Frame", {
        Parent = bar,
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Theme.Accent2,
        BorderSizePixel = 0
    })
    make("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})

    local dragging = false

    local function setValueFromX(x)
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * alpha
        value = math.floor(value + 0.5)
        local ratio = (value - min) / (max - min)

        valueLabel.Text = tostring(value)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, -8, 0.5, -8)

        if callback then callback(value) end
    end

    connect(bar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setValueFromX(input.Position.X)
        end
    end)

    connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    connect(UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setValueFromX(input.Position.X)
        end
    end)

    return frame
end

local function addAction(parent, title, desc, callback, danger)
    local frame = card(parent, 70)
    if danger then
        frame.BackgroundColor3 = Color3.fromRGB(54, 29, 37)
    end
    addTitle(frame, title, desc)

    local hit = make("TextButton", {
        Parent = frame,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })

    connect(hit.MouseEnter, function()
        tween(frame, 0.12, {
            BackgroundTransparency = 0.12,
            BackgroundColor3 = danger and Color3.fromRGB(72, 34, 45) or Theme.CardHover
        })
    end)

    connect(hit.MouseLeave, function()
        tween(frame, 0.12, {
            BackgroundTransparency = 0.28,
            BackgroundColor3 = danger and Color3.fromRGB(54, 29, 37) or Theme.Card
        })
    end)

    connect(hit.MouseButton1Click, function()
        if callback then callback() end
    end)

    return frame
end

local function sectionSpacer(parent)
    local spacer = make("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundTransparency = 1
    })
    return spacer
end

local function startFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if not Root then updateCharacter() end

    if FlyVelocity then FlyVelocity:Destroy() end
    if FlyGyro then FlyGyro:Destroy() end

    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyVelocity.Velocity = Vector3.zero
    FlyVelocity.Parent = Root

    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyGyro.P = 10000
    FlyGyro.Parent = Root

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not State.FlyEnabled or not Root or not Root.Parent then return end
        local camera = workspace.CurrentCamera
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

        if dir.Magnitude > 0 then
            dir = dir.Unit * State.FlySpeed
        end

        FlyVelocity.Velocity = dir
        FlyGyro.CFrame = camera.CFrame
    end)
end

local function stopFly()
    State.FlyEnabled = false
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
end

connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F and not Minimized then
        State.FlyEnabled = not State.FlyEnabled
        if State.FlyEnabled then startFly() else stopFly() end
    end
    if input.KeyCode == Enum.KeyCode.Space and State.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

connect(RunService.Stepped, function()
    if not Character then return end
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not State.Noclip
        end
    end
end)

local MovementPage = createPage("Movement")
section(MovementPage, "Character")
addToggle(MovementPage, "Enable Walk Speed", "Activate custom walk speed", false, function(enabled)
    State.SpeedEnabled = enabled
    if Humanoid then Humanoid.WalkSpeed = enabled and State.Speed or 16 end
end)
addSlider(MovementPage, "Speed Amount", 16, 150, 16, function(value)
    State.Speed = value
    if State.SpeedEnabled and Humanoid then Humanoid.WalkSpeed = value end
end)
addToggle(MovementPage, "Enable Jump Power", "Activate custom jump power", false, function(enabled)
    State.JumpEnabled = enabled
    if Humanoid then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = enabled and State.JumpPower or 50
    end
end)
addSlider(MovementPage, "Jump Power", 50, 200, 50, function(value)
    State.JumpPower = value
    if State.JumpEnabled and Humanoid then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = value
    end
end)

sectionSpacer(MovementPage)
section(MovementPage, "Extras")
addToggle(MovementPage, "Noclip", "Walk through all objects", false, function(enabled)
    State.Noclip = enabled
end)
addToggle(MovementPage, "Infinite Jump", "Jump without touching the ground", false, function(enabled)
    State.InfiniteJump = enabled
end)

sectionSpacer(MovementPage)
section(MovementPage, "Actions")
addAction(MovementPage, "Reset Character", "Respawn your character", function()
    if Humanoid then Humanoid.Health = 0 end
end, true)
addAction(MovementPage, "Rejoin Server", "Rejoin the current server", function()
    TeleportService:Teleport(game.PlaceId, Player)
end)
addAction(MovementPage, "Restore Defaults", "Reset all settings to default", function()
    State.SpeedEnabled = false
    State.Speed = 16
    State.JumpEnabled = false
    State.JumpPower = 50
    State.Noclip = false
    State.InfiniteJump = false
    stopFly()
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 50
    end
end)

local FlyPage = createPage("Fly")
section(FlyPage, "Flight")
addToggle(FlyPage, "Fly", "WASD to move, Space up, LeftControl down", false, function(enabled)
    State.FlyEnabled = enabled
    if enabled then startFly() else stopFly() end
end)
addSlider(FlyPage, "Fly Speed", 10, 200, 50, function(value)
    State.FlySpeed = value
end)
addAction(FlyPage, "Toggle Fly [F]", "Use the F key to toggle flight", function()
    State.FlyEnabled = not State.FlyEnabled
    if State.FlyEnabled then startFly() else stopFly() end
end)

local PlayerPage = createPage("Player")
section(PlayerPage, "Player")
addAction(PlayerPage, "Reset Character", "Respawn your character", function()
    if Humanoid then Humanoid.Health = 0 end
end, true)
addAction(PlayerPage, "Restore Defaults", "Reset movement settings", function()
    State.SpeedEnabled = false
    State.JumpEnabled = false
    State.Noclip = false
    State.InfiniteJump = false
    State.Speed = 16
    State.JumpPower = 50
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 50
    end
end)

local VisualsPage = createPage("Visuals")
section(VisualsPage, "Visuals")
addAction(VisualsPage, "Coming Soon", "Add your visual features here")

local TeleportsPage = createPage("Teleports")
section(TeleportsPage, "Teleports")
addAction(TeleportsPage, "Example Teleport", "Replace this callback with your own teleport", function() end)

local SettingsPage = createPage("Settings")
section(SettingsPage, "Settings")
addAction(SettingsPage, "Close UI", "Hide Night System", function()
    ScreenGui.Enabled = false
end)

local function selectTab(name)
    CurrentTab = name
    for tabName, page in pairs(Pages) do
        page.Visible = tabName == name
    end

    for tabName, button in pairs(TabButtons) do
        local active = tabName == name
        tween(button, 0.18, {
            BackgroundColor3 = active and Color3.fromRGB(74, 60, 125) or Color3.fromRGB(28, 31, 42),
            BackgroundTransparency = active and 0.10 or 0.32
        })
        local refs = buttonRefs[button]
        if refs then
            tween(refs.Icon, 0.18, {
                TextColor3 = active and Theme.Accent2 or Theme.SubText
            })
            tween(refs.Title, 0.18, {
                TextColor3 = active and Theme.Text or Color3.fromRGB(212, 213, 220)
            })
        end
    end
end

local tabDefinitions = {
    {"Movement", "✦"},
    {"Fly", "✈"},
    {"Player", "◉"},
    {"Visuals", "◌"},
    {"Teleports", "◎"},
    {"Settings", "☷"}
}

for index, data in ipairs(tabDefinitions) do
    local name, icon = data[1], data[2]

    local button = make("TextButton", {
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Color3.fromRGB(28, 31, 42),
        BackgroundTransparency = 0.32,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = index
    })
    make("UICorner", {Parent = button, CornerRadius = UDim.new(0, 12)})
    make("UIStroke", {
        Parent = button,
        Color = Theme.Stroke,
        Transparency = 0.80,
        Thickness = 1
    })

    local iconLabel = make("TextLabel", {
        Parent = button,
        Position = UDim2.fromOffset(18, 0),
        Size = UDim2.fromOffset(28, 58),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = Theme.SubText,
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })

    local titleLabel = make("TextLabel", {
        Parent = button,
        Position = UDim2.fromOffset(58, 0),
        Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(212, 213, 220),
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    TabButtons[name] = button
    buttonRefs[button] = {Icon = iconLabel, Title = titleLabel}

    connect(button.MouseButton1Click, function()
        selectTab(name)
    end)

    connect(button.MouseEnter, function()
        if CurrentTab ~= name then
            tween(button, 0.12, {BackgroundTransparency = 0.18})
        end
    end)

    connect(button.MouseLeave, function()
        if CurrentTab ~= name then
            tween(button, 0.12, {BackgroundTransparency = 0.32})
        end
    end)
end

local Profile = make("Frame", {
    Parent = Sidebar,
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = Theme.Panel,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    LayoutOrder = 99
})
make("UICorner", {Parent = Profile, CornerRadius = UDim.new(0, 12)})
make("UIStroke", {Parent = Profile, Color = Theme.Accent, Transparency = 0.78})

local Avatar = make("ImageLabel", {
    Parent = Profile,
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.fromOffset(42, 42),
    BackgroundTransparency = 1,
    Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
})
make("UICorner", {Parent = Avatar, CornerRadius = UDim.new(1, 0)})

make("TextLabel", {
    Parent = Profile,
    Position = UDim2.fromOffset(62, 10),
    Size = UDim2.new(1, -70, 0, 22),
    BackgroundTransparency = 1,
    Text = Player.DisplayName,
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamSemibold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
})

make("TextLabel", {
    Parent = Profile,
    Position = UDim2.fromOffset(62, 34),
    Size = UDim2.new(1, -70, 0, 18),
    BackgroundTransparency = 1,
    Text = "Premium",
    TextColor3 = Theme.Accent2,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left
})

local dragging = false
local dragStart
local startPos

connect(DragArea.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

connect(DragArea.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

connect(UserInputService.InputChanged, function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

connect(Minimize.MouseEnter, function()
    tween(Minimize, 0.12, {BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 0.05})
end)
connect(Minimize.MouseLeave, function()
    tween(Minimize, 0.12, {BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.25})
end)
connect(Close.MouseEnter, function()
    tween(Close, 0.12, {BackgroundColor3 = Color3.fromRGB(70, 35, 45), BackgroundTransparency = 0.05})
end)
connect(Close.MouseLeave, function()
    tween(Close, 0.12, {BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.25})
end)

connect(Minimize.MouseButton1Click, function()
    Minimized = not Minimized
    if Minimized then
        tween(Main, 0.25, {Size = UDim2.fromOffset(1050, 100)})
        Sidebar.Visible = false
        Content.Visible = false
        Divider.Visible = false
    else
        tween(Main, 0.25, {Size = MainNormalSize})
        task.wait(0.15)
        Sidebar.Visible = true
        Content.Visible = true
        Divider.Visible = true
    end
end)

connect(Close.MouseButton1Click, function()
    ScreenGui.Enabled = false
end)

selectTab("Movement")

ScreenGui.Destroying:Connect(function()
    for _, c in ipairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    stopFly()
end)
