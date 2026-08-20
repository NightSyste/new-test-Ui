local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local NightLib = {}
local AccentColor = Color3.fromRGB(123, 97, 255) -- Das Night System Lila
local BackgroundColor = Color3.fromRGB(15, 15, 20)
local CardColor = Color3.fromRGB(25, 25, 30)
local TextColor = Color3.fromRGB(255, 255, 255)
local SubTextColor = Color3.fromRGB(150, 150, 160)

-- Hilfsfunktion für schnelles Erstellen von UI-Elementen
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

function NightLib:MakeWindow(options)
    local WindowName = options.Name or "Night System"
    local WindowVersion = options.Version or "v1.0.0"

    local ScreenGui = Create("ScreenGui", {
        Name = "NightSystemUI",
        Parent = (game:GetService("RunService"):IsStudio() and game.Players.LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })

    local MainFrame = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 800, 0, 500),
        Position = UDim2.new(0.5, -400, 0.5, -250),
        BackgroundColor3 = BackgroundColor,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ClipsDescendants = true
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = MainFrame })
    Create("UIStroke", { Color = Color3.fromRGB(40, 40, 50), Thickness = 1, Parent = MainFrame })

    -- Topbar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local Title = Create("TextLabel", {
        Text = WindowName,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = TextColor,
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 60, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    local Version = Create("TextLabel", {
        Text = WindowVersion,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = SubTextColor,
        Size = UDim2.new(0, 200, 0, 15),
        Position = UDim2.new(0, 60, 0, 35),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    -- Sidebar
    local SideBar = Create("Frame", {
        Name = "SideBar",
        Size = UDim2.new(0, 200, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -80),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = SideBar
    })
    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = TabContainer })

    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -200, 1, -60),
        Position = UDim2.new(0, 200, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:MakeTab(tabOptions)
        local TabName = tabOptions.Name or "Tab"
        
        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = AccentColor,
            BackgroundTransparency = 1, -- Start transparent (inactive)
            Text = "  " .. TabName,
            TextColor3 = SubTextColor,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabContainer
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabButton })

        local TabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 0, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = AccentColor,
            Visible = false,
            Parent = ContentArea
        })
        -- Grid Layout for Cards (wie im Bild: 2 Spalten)
        Create("UIGridLayout", {
            CellSize = UDim2.new(0.5, -5, 0, 100), -- 50% Breite minus Padding
            CellPadding = UDim2.new(0, 10, 0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })

        local Tab = {}

        -- Tab Switch Logic
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = SubTextColor}):Play()
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, TextColor3 = AccentColor}):Play()
        end)

        table.insert(Window.Tabs, {Button = TabButton, Content = TabContent})
        
        -- Erster Tab ist standardmäßig aktiv
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.8
            TabButton.TextColor3 = AccentColor
        end

        -- Elemente hinzufügen (API)
        function Tab:AddToggle(options)
            local ToggleFrame = Create("Frame", {
                BackgroundColor3 = CardColor,
                Parent = TabContent
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ToggleFrame })
            Create("UIStroke", { Color = Color3.fromRGB(40, 40, 50), Thickness = 1, Parent = ToggleFrame })

            local TTitle = Create("TextLabel", {
                Text = options.Name or "Toggle",
                Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = TextColor,
                Size = UDim2.new(1, -60, 0, 20), Position = UDim2.new(0, 15, 0, 15),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame
            })

            local TDesc = Create("TextLabel", {
                Text = options.Description or "",
                Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = SubTextColor,
                Size = UDim2.new(1, -60, 0, 15), Position = UDim2.new(0, 15, 0, 35),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame
            })

            local Switch = Create("TextButton", {
                Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -55, 0, 20),
                BackgroundColor3 = Color3.fromRGB(40, 40, 45), Text = "", Parent = ToggleFrame
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Switch })
            
            local Indicator = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = TextColor, Parent = Switch
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Indicator })

            local toggled = options.Default or false
            
            local function updateVisuals()
                local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetColor = toggled and AccentColor or Color3.fromRGB(40, 40, 45)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            end
            
            updateVisuals()

            Switch.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateVisuals()
                if options.Callback then options.Callback(toggled) end
            end)
        end

        return Tab
    end

    return Window
end

return NightLib
