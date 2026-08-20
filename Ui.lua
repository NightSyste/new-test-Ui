-- NightUI – Orion‑kompatible Version, 1:1 wie auf dem Bild
local NightUI = {}
NightUI.__index = NightUI

-- Hilfsfunktion
local function create(obj, parent, props)
    local inst = Instance.new(obj)
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end

-- Hauptfunktion: MakeWindow
function NightUI:MakeWindow(options)
    local self = setmetatable({}, NightUI)
    options = options or {}
    self.tabs = {}
    self.activeTab = nil

    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = create("ScreenGui", playerGui, {
        Name = "NightUI",
        ResetOnSpawn = false,
    })

    -- Hauptframe (dunkelgrau, abgerundet)
    local main = create("Frame", screenGui, {
        Size = UDim2.new(0, 520, 0, 420),
        Position = UDim2.new(0.5, -260, 0.5, -210),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main

    -- Titel + Version
    create("TextLabel", main, {
        Size = UDim2.new(0, 200, 0, 30),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundTransparency = 1,
        Text = options.Name or "Night System",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    create("TextLabel", main, {
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(0, 15, 0, 38),
        BackgroundTransparency = 1,
        Text = options.Version or "v1.0.0",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Tab‑Leiste
    local tabBar = create("Frame", main, {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
    })
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar

    -- Container für Tab‑Inhalte
    local container = create("Frame", main, {
        Size = UDim2.new(1, -20, 1, -110),
        Position = UDim2.new(0, 10, 0, 105),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    })

    self.main = main
    self.tabBar = tabBar
    self.container = container
    self.screenGui = screenGui

    -- Tabelle mit MakeTab und anderen Methoden
    local windowInterface = {}

    function windowInterface:MakeTab(tabOptions)
        local name = tabOptions.Name or "Tab"
        if self.tabs[name] then return self.tabs[name].interface end

        -- Tab‑Button
        local btn = create("TextButton", self.tabBar, {
            Size = UDim2.new(0, 110, 0, 30),
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
        cornerBtn.Parent = btn

        -- Tab‑Frame (Inhalt)
        local frame = create("Frame", self.container, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
        })
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Parent = frame

        local tabInterface = {}

        -- Toggle (Schalter)
        function tabInterface:AddToggle(toggleOptions)
            local labelText = toggleOptions.Name or "Toggle"
            local default = toggleOptions.Default or false
            local callback = toggleOptions.Callback or function() end
            local description = toggleOptions.Description or ""

            local line = create("Frame", frame, {
                Size = UDim2.new(1, -10, 0, 30 + (description ~= "" and 18 or 0)),
                BackgroundTransparency = 1,
            })
            local lbl = create("TextLabel", line, {
                Size = UDim2.new(0.7, 0, 0.5, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = labelText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 15,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            if description ~= "" then
                create("TextLabel", line, {
                    Size = UDim2.new(0.7, 0, 0.4, 0),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text = description,
                    TextColor3 = Color3.fromRGB(150, 150, 150),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end

            -- Switch
            local sw = create("Frame", line, {
                Size = UDim2.new(0, 50, 0, 26),
                Position = UDim2.new(1, -55, 0.5, -13),
                BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                BorderSizePixel = 0,
            })
            local cornerSw = Instance.new("UICorner")
            cornerSw.CornerRadius = UDim.new(1, 0)
            cornerSw.Parent = sw

            local knob = create("Frame", sw, {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220),
                BorderSizePixel = 0,
            })
            local cornerKnob = Instance.new("UICorner")
            cornerKnob.CornerRadius = UDim.new(1, 0)
            cornerKnob.Parent = knob

            local state = default
            local button = Instance.new("ImageButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Parent = sw
            button.AutoButtonColor = false

            local function update()
                if state then
                    sw.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                    knob.Position = UDim2.new(1, -23, 0.5, -10)
                else
                    sw.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    knob.Position = UDim2.new(0, 3, 0.5, -10)
                end
            end
            update()

            button.MouseButton1Click:Connect(function()
                state = not state
                update()
                callback(state)
            end)
            return line
        end

        -- Slider (mit Wertanzeige)
        function tabInterface:AddSlider(sliderOptions)
            local labelText = sliderOptions.Name or "Slider"
            local min = sliderOptions.Min or 0
            local max = sliderOptions.Max or 100
            local default = sliderOptions.Default or min
            local callback = sliderOptions.Callback or function() end
            local valueName = sliderOptions.ValueName or ""

            local line = create("Frame", frame, {
                Size = UDim2.new(1, -10, 0, 44),
                BackgroundTransparency = 1,
            })
            local lbl = create("TextLabel", line, {
                Size = UDim2.new(0.5, 0, 0.4, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = labelText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 15,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local valLbl = create("TextLabel", line, {
                Size = UDim2.new(0.3, 0, 0.4, 0),
                Position = UDim2.new(0.7, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(default) .. (valueName ~= "" and " " .. valueName or ""),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 15,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            local track = create("Frame", line, {
                Size = UDim2.new(0.7, 0, 0.25, 0),
                Position = UDim2.new(0, 0, 0.55, 0),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
            })
            local cornerTrack = Instance.new("UICorner")
            cornerTrack.CornerRadius = UDim.new(1, 0)
            cornerTrack.Parent = track

            local fill = create("Frame", track, {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 150, 255),
                BorderSizePixel = 0,
            })
            local cornerFill = Instance.new("UICorner")
            cornerFill.CornerRadius = UDim.new(1, 0)
            cornerFill.Parent = fill

            local knob = create("TextButton", track, {
                Size = UDim2.new(0, 16, 1.5, 0),
                Position = UDim2.new(0, -8, -0.25, 0),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220),
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
                if width <= 0 then return end
                local percent = math.clamp(pos / width, 0, 1)
                local value = min + (max - min) * percent
                value = math.floor(value + 0.5)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -8, -0.25, 0)
                valLbl.Text = tostring(value) .. (valueName ~= "" and " " .. valueName or "")
                callback(value)
            end

            knob.MouseButton1Down:Connect(function() dragging = true end)
            knob.MouseButton1Up:Connect(function() dragging = false end)
            knob.MouseMoved:Connect(function()
                if dragging then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local trackPos = track.AbsolutePosition
                    local relX = mouse.X - trackPos.X
                    updateSlider({Position = UDim2.new(0, relX, 0, 0)})
                end
            end)
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local trackPos = track.AbsolutePosition
                    local relX = mouse.X - trackPos.X
                    updateSlider({Position = UDim2.new(0, relX, 0, 0)})
                end
            end)

            -- Initial setzen (default)
            local initPercent = (default - min) / (max - min)
            fill.Size = UDim2.new(initPercent, 0, 1, 0)
            knob.Position = UDim2.new(initPercent, -8, -0.25, 0)
            valLbl.Text = tostring(default) .. (valueName ~= "" and " " .. valueName or "")
            callback(default)

            return line
        end

        -- Button
        function tabInterface:AddButton(buttonOptions)
            local btn = create("TextButton", frame, {
                Size = UDim2.new(0.85, 0, 0, 32),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Text = buttonOptions.Name or "Button",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                AutoButtonColor = false,
            })
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if buttonOptions.Callback then buttonOptions.Callback() end
            end)
            return btn
        end

        -- Label (nur Text)
        function tabInterface:AddLabel(labelOptions)
            local lbl = create("TextLabel", frame, {
                Size = UDim2.new(1, -10, 0, 20),
                BackgroundTransparency = 1,
                Text = labelOptions.Name or "",
                TextColor3 = labelOptions.Color or Color3.fromRGB(200, 200, 200),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            return lbl
        end

        -- Tab speichern
        self.tabs[name] = { button = btn, frame = frame, interface = tabInterface }

        -- Ersten Tab aktivieren
        if not self.activeTab then
            self:SelectTab(name)
        end

        btn.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)

        return tabInterface
    end

    function windowInterface:SelectTab(name)
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

    -- Optionale Init-Methode (wie Orion)
    function windowInterface:Init()
        -- nichts zu tun
    end

    return windowInterface
end

-- Rückgabe für loadstring
return NightUI
