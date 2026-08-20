-- NightUI Modul
local NightUI = {}
NightUI.__index = NightUI

-- Hilfsfunktion für UI‑Elemente
local function createUI(parent, className, properties)
    local obj = Instance.new(className)
    for prop, val in pairs(properties) do
        obj[prop] = val
    end
    obj.Parent = parent
    return obj
end

function NightUI.new()
    local self = setmetatable({}, NightUI)
    self.tabs = {}
    self.activeTab = nil

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NightUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Hauptframe
    local mainFrame = createUI(screenGui, "Frame", {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    -- Titel
    local title = createUI(mainFrame, "TextLabel", {
        Size = UDim2.new(0, 200, 0, 30),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundTransparency = 1,
        Text = "Night System",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local version = createUI(mainFrame, "TextLabel", {
        Size = UDim2.new(0, 100, 0, 20),
        Position = UDim2.new(0, 15, 0, 40),
        BackgroundTransparency = 1,
        Text = "v1.0.0",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Tab‑Leiste
    local tabBar = createUI(mainFrame, "Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
    })
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar

    -- Container für die Tab‑Inhalte
    local tabContainer = createUI(mainFrame, "Frame", {
        Size = UDim2.new(1, -20, 1, -110),
        Position = UDim2.new(0, 10, 0, 105),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    })

    self.mainFrame = mainFrame
    self.tabBar = tabBar
    self.tabContainer = tabContainer
    self.screenGui = screenGui

    return self
end

function NightUI:MakeTab(name)
    if self.tabs[name] then
        return self.tabs[name].interface
    end

    -- Tab‑Button
    local button = createUI(self.tabBar, "TextButton", {
        Size = UDim2.new(0, 100, 0, 30),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Text = name,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(0, 4)
    cornerBtn.Parent = button

    -- Tab‑Frame (Inhaltsbereich)
    local frame = createUI(self.tabContainer, "Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
    })
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = frame

    -- Tab‑Interface (Methoden)
    local tabInterface = {}

    function tabInterface:AddToggle(labelText, callback)
        local toggleFrame = createUI(frame, "Frame", {
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundTransparency = 1,
        })
        local label = createUI(toggleFrame, "TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        -- Switch
        local switchFrame = createUI(toggleFrame, "Frame", {
            Size = UDim2.new(0, 50, 0, 25),
            Position = UDim2.new(1, -55, 0.5, -12.5),
            BackgroundColor3 = Color3.fromRGB(80, 80, 80),
            BorderSizePixel = 0,
        })
        local cornerSwitch = Instance.new("UICorner")
        cornerSwitch.CornerRadius = UDim.new(1, 0)
        cornerSwitch.Parent = switchFrame

        local knob = createUI(switchFrame, "Frame", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 2, 0.5, -10),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
            BorderSizePixel = 0,
        })
        local cornerKnob = Instance.new("UICorner")
        cornerKnob.CornerRadius = UDim.new(1, 0)
        cornerKnob.Parent = knob

        local state = false
        local toggleButton = Instance.new("ImageButton")
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.BackgroundTransparency = 1
        toggleButton.Parent = switchFrame
        toggleButton.AutoButtonColor = false

        local function updateSwitch()
            if state then
                switchFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                knob.Position = UDim2.new(1, -22, 0.5, -10)
            else
                switchFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                knob.Position = UDim2.new(0, 2, 0.5, -10)
            end
        end
        updateSwitch()

        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            updateSwitch()
            if callback then callback(state) end
        end)

        return toggleFrame
    end

    function tabInterface:AddSlider(labelText, min, max, callback)
        local sliderFrame = createUI(frame, "Frame", {
            Size = UDim2.new(1, -10, 0, 40),
            BackgroundTransparency = 1,
        })
        local label = createUI(sliderFrame, "TextLabel", {
            Size = UDim2.new(0.5, 0, 0.5, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local valueLabel = createUI(sliderFrame, "TextLabel", {
            Size = UDim2.new(0.3, 0, 0.5, 0),
            Position = UDim2.new(0.7, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(min),
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
        })

        local track = createUI(sliderFrame, "Frame", {
            Size = UDim2.new(0.7, 0, 0.3, 0),
            Position = UDim2.new(0, 0, 0.6, 0),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            BorderSizePixel = 0,
        })
        local cornerTrack = Instance.new("UICorner")
        cornerTrack.CornerRadius = UDim.new(1, 0)
        cornerTrack.Parent = track

        local fill = createUI(track, "Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 150, 255),
            BorderSizePixel = 0,
        })
        local cornerFill = Instance.new("UICorner")
        cornerFill.CornerRadius = UDim.new(1, 0)
        cornerFill.Parent = fill

        local knob = createUI(track, "TextButton", {
            Size = UDim2.new(0, 16, 1.5, 0),
            Position = UDim2.new(0, -8, -0.25, 0),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
        })
        local cornerKnob = Instance.new("UICorner")
        cornerKnob.CornerRadius = UDim.new(1, 0)
        cornerKnob.Parent = knob

        local dragging = false
        local function updateSlider(input)
            local pos = input.Position.X.Offset
            local width = track.AbsoluteSize.X
            local percent = math.clamp(pos / width, 0, 1)
            local value = min + (max - min) * percent
            value = math.floor(value + 0.5)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -8, -0.25, 0)
            valueLabel.Text = tostring(value)
            if callback then callback(value) end
        end

        knob.MouseButton1Down:Connect(function()
            dragging = true
        end)
        knob.MouseButton1Up:Connect(function()
            dragging = false
        end)
        knob.MouseMoved:Connect(function()
            if dragging then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local trackPos = track.AbsolutePosition
                local relativeX = mouse.X - trackPos.X
                updateSlider({Position = UDim2.new(0, relativeX, 0, 0)})
            end
        end)
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local trackPos = track.AbsolutePosition
                local relativeX = mouse.X - trackPos.X
                updateSlider({Position = UDim2.new(0, relativeX, 0, 0)})
            end
        end)

        -- Initial auf Minimum setzen
        updateSlider({Position = UDim2.new(0, 0, 0, 0)})
    end

    function tabInterface:AddButton(labelText, callback)
        local button = createUI(frame, "TextButton", {
            Size = UDim2.new(0.8, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Text = labelText,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
        })
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        return button
    end

    function tabInterface:AddLabel(labelText)
        local label = createUI(frame, "TextLabel", {
            Size = UDim2.new(1, -10, 0, 20),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        return label
    end

    -- Tab speichern
    self.tabs[name] = {
        button = button,
        frame = frame,
        interface = tabInterface,
    }

    -- Ersten Tab automatisch aktivieren
    if not self.activeTab then
        self:SelectTab(name)
    end

    button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    return tabInterface
end

function NightUI:SelectTab(name)
    if not self.tabs[name] then return end
    for _, data in pairs(self.tabs) do
        data.frame.Visible = false
        data.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        data.button.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    local data = self.tabs[name]
    data.frame.Visible = true
    data.button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    data.button.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.activeTab = name
end

return NightUI
