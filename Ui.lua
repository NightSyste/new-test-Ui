-- ====================================================================
-- NIGHT SYSTEM UI LIBRARY (1:1 Design Replica)
-- ====================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local NightLib = {}

-- Farbpaletten (Exakt wie auf dem Screenshot)
local Theme = {
    MainBg = Color3.fromRGB(15, 16, 23),
    CardBg = Color3.fromRGB(22, 24, 35),
    CardBorder = Color3.fromRGB(35, 38, 52),
    Accent = Color3.fromRGB(123, 97, 255),       -- Night Purple (#7B61FF)
    AccentDark = Color3.fromRGB(90, 68, 210),
    TextWhite = Color3.fromRGB(240, 242, 254),
    TextGray = Color3.fromRGB(135, 138, 158),
    ToggleOff = Color3.fromRGB(38, 41, 56),
    RedDanger = Color3.fromRGB(180, 45, 60),
    RedDangerBorder = Color3.fromRGB(100, 30, 40)
}

-- Hilfsfunktion für UI-Erstellung
local function Create(className, properties, children)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

-- Dragging-System für das Hauptfenster
local function EnableDragging(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function NightLib:MakeWindow(options)
    local WindowName = options.Name or "Night System"
    local WindowVersion = options.Version or "v1.0.0"
    local UserData = options.UserProfile or { Name = LocalPlayer.Name, Rank = "Premium" }

    -- Parent Gui finden
    local ScreenGui = Create("ScreenGui", {
        Name = "NightSystemUI",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })

    -- Hauptfenster
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 850, 0, 520),
        Position = UDim2.new(0.5, -425, 0.5, -260),
        BackgroundColor3 = Theme.MainBg,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ClipsDescendants = true
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 14) }),
        Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1.2 })
    })

    -- Topbar (Titel & Fenster-Buttons)
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    EnableDragging(MainFrame, TopBar)

    -- Logo Icon ("N")
    local LogoBox = Create("Frame", {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 20, 0, 12),
        BackgroundColor3 = Theme.Accent,
        Parent = TopBar
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Create("TextLabel", {
            Text = "N",
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        })
    })

    -- Fenster Titel & Version
    Create("TextLabel", {
        Text = WindowName,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.TextWhite,
        Position = UDim2.new(0, 68, 0, 14),
        Size = UDim2.new(0, 200, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    Create("TextLabel", {
        Text = WindowVersion,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.TextGray,
        Position = UDim2.new(0, 68, 0, 32),
        Size = UDim2.new(0, 200, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    -- Control Buttons (- und X)
    local Controls = Create("Frame", {
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -85, 0, 15),
        BackgroundTransparency = 1,
        Parent = TopBar
    }, {
        Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8) })
    })

    local MinBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Theme.CardBg,
        Text = "—",
        TextColor3 = Theme.TextGray,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = Controls
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })

    local CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Theme.CardBg,
        Text = "✕",
        TextColor3 = Theme.TextGray,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = Controls
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    local minified = false
    MinBtn.MouseButton1Click:Connect(function()
        minified = not minified
        MainFrame:TweenSize(minified and UDim2.new(0, 850, 0, 60) or UDim2.new(0, 850, 0, 520), "Out", "Quart", 0.3, true)
    end)

    -- Sidebar (Tabs Links)
    local SideBar = Create("Frame", {
        Name = "SideBar",
        Size = UDim2.new(0, 210, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local TabContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -24, 1, -80),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = SideBar
    }, {
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
    })

    -- ==================== PROFIL KARTE (Ganz unten links) ====================
    local ProfileCard = Create("Frame", {
        Name = "UserProfileCard",
        Size = UDim2.new(1, -24, 0, 54),
        Position = UDim2.new(0, 12, 1, -66),
        BackgroundColor3 = Theme.CardBg,
        Parent = SideBar
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1 })
    })

    -- Profilbild
    local AvatarImg = Create("ImageLabel", {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 10, 0.5, -18),
        BackgroundColor3 = Theme.MainBg,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Parent = ProfileCard
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    pcall(function()
        local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        AvatarImg.Image = content
    end)

    -- Profil Name & Rank
    Create("TextLabel", {
        Text = UserData.Name or LocalPlayer.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.TextWhite,
        Position = UDim2.new(0, 54, 0, 10),
        Size = UDim2.new(0, 100, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = ProfileCard
    })

    Create("TextLabel", {
        Text = UserData.Rank or "Premium",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.Accent,
        Position = UDim2.new(0, 54, 0, 28),
        Size = UDim2.new(0, 100, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = ProfileCard
    })

    -- Active Status Dot (Lila Punkt rechts)
    Create("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(1, -18, 0.5, -4),
        BackgroundColor3 = Theme.Accent,
        Parent = ProfileCard
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    -- Main Content Container (Rechts)
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -220, 1, -70),
        Position = UDim2.new(0, 210, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local Window = { Tabs = {}, CurrentTab = nil }

    -- ==================== TAB BUILDER ====================
    function Window:MakeTab(tabOptions)
        local TabName = tabOptions.Name or "Tab"
        local IconId = tabOptions.Icon or "rbxassetid://6031265976"

        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Text = "",
            Parent = TabContainer
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 10) })
        })

        local TabIcon = Create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 14, 0.5, -9),
            BackgroundTransparency = 1,
            Image = IconId,
            ImageColor3 = Theme.TextGray,
            Parent = TabButton
        })

        local TabText = Create("TextLabel", {
            Text = TabName,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Theme.TextGray,
            Position = UDim2.new(0, 42, 0, 0),
            Size = UDim2.new(1, -42, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = TabButton
        })

        -- Inhaltsbereich für den Tab
        local TabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = false,
            Parent = ContentArea
        }, {
            Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 16) })
        })

        local Tab = { Content = TabContent, Window = Window }

        -- Switch Logic
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                TweenService:Create(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextGray}):Play()
                TweenService:Create(t.Text, TweenInfo.new(0.2), {TextColor3 = Theme.TextGray}):Play()
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextWhite}):Play()
            TweenService:Create(TabText, TweenInfo.new(0.2), {TextColor3 = Theme.TextWhite}):Play()
        end)

        table.insert(Window.Tabs, {Button = TabButton, Content = TabContent, Icon = TabIcon, Text = TabText})

        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.85
            TabIcon.ImageColor3 = Theme.TextWhite
            TabText.TextColor3 = Theme.TextWhite
        end

        -- ==================== SECTION BUILDER ====================
        function Tab:AddSection(sectionTitle)
            local SectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Parent = TabContent
            })

            -- Lila vertikaler Strich
            Create("Frame", {
                Size = UDim2.new(0, 3, 0, 16),
                Position = UDim2.new(0, 0, 0.5, -8),
                BackgroundColor3 = Theme.Accent,
                Parent = SectionFrame
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            Create("TextLabel", {
                Text = sectionTitle,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Theme.TextWhite,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = SectionFrame
            })

            -- Grid Container für 2-Spalten Layout darunter
            local Grid = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = TabContent
            })

            local UIGrid = Create("UIGridLayout", {
                CellSize = UDim2.new(0.5, -6, 0, 115),
                CellPadding = UDim2.new(0, 12, 0, 12),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Grid
            })

            UIGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Grid.Size = UDim2.new(1, 0, 0, UIGrid.AbsoluteContentSize.Y)
            end)

            local Section = {}

            -- Combined Toggle + Slider Card (wie Walk Speed & Jump Power im Bild)
            function Section:AddCompoundCard(options)
                local Card = Create("Frame", {
                    BackgroundColor3 = Theme.CardBg,
                    Parent = Grid
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1 })
                })

                -- Card Header Icon + Titel
                Create("ImageLabel", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 14, 0, 14),
                    BackgroundTransparency = 1,
                    Image = options.Icon or "rbxassetid://6031265976",
                    ImageColor3 = Theme.Accent,
                    Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Title or "Option",
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 36, 0, 14),
                    Size = UDim2.new(1, -40, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Parent = Card
                })

                -- Toggle Switch Subheader
                Create("TextLabel", {
                    Text = options.ToggleName or "Enable",
                    Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 14, 0, 38), Size = UDim2.new(0, 180, 0, 14),
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.ToggleDesc or "",
                    Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 14, 0, 52), Size = UDim2.new(0, 180, 0, 12),
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Card
                })

                -- Switch Button
                local Switch = Create("TextButton", {
                    Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -50, 0, 42),
                    BackgroundColor3 = Theme.ToggleOff, Text = "", Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local Indicator = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = Theme.TextWhite, Parent = Switch
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local toggled = options.DefaultToggle or false
                local function updateToggle()
                    local pos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local col = toggled and Theme.Accent or Theme.ToggleOff
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = pos}):Play()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
                end
                updateToggle()

                Switch.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                    if options.ToggleCallback then options.ToggleCallback(toggled) end
                end)

                -- Slider
                local min = options.Min or 0
                local max = options.Max or 100
                local val = options.DefaultVal or min
                local suffix = options.Suffix or ""

                local ValueBadge = Create("TextLabel", {
                    Text = tostring(val),
                    Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(1, -50, 0, 72), Size = UDim2.new(0, 36, 0, 16),
                    BackgroundColor3 = Theme.MainBg, Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                Create("TextLabel", {
                    Text = options.SliderName or "Amount",
                    Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 14, 0, 72), Size = UDim2.new(0, 120, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = min .. " " .. suffix,
                    Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 14, 0, 88), Size = UDim2.new(0, 60, 0, 10),
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = max .. " " .. suffix,
                    Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(1, -74, 0, 88), Size = UDim2.new(0, 60, 0, 10),
                    TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, Parent = Card
                })

                local SliderBar = Create("Frame", {
                    Size = UDim2.new(1, -28, 0, 4), Position = UDim2.new(0, 14, 0, 102),
                    BackgroundColor3 = Theme.ToggleOff, Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local SliderFill = Create("Frame", {
                    Size = UDim2.new((val - min)/(max - min), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent, Parent = SliderBar
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local SliderKnob = Create("Frame", {
                    Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -5, 0.5, -5),
                    BackgroundColor3 = Theme.TextWhite, Parent = SliderFill
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                -- Slider Drag Logik
                local sliding = false
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + (max - min) * pos)
                    ValueBadge.Text = tostring(val)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    if options.SliderCallback then options.SliderCallback(val) end
                end

                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true updateSlider(input) end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
                end)
            end

            -- Standard Toggle Card (wie Noclip & Infinite Jump)
            function Section:AddToggle(options)
                local Card = Create("Frame", {
                    BackgroundColor3 = Theme.CardBg,
                    Parent = Grid
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1 })
                })

                Create("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 14, 0, 18),
                    BackgroundTransparency = 1, Image = options.Icon or "rbxassetid://6031265976",
                    ImageColor3 = Theme.Accent, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Name or "Toggle",
                    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 40, 0, 18), Size = UDim2.new(1, -90, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Description or "",
                    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 14, 0, 42), Size = UDim2.new(1, -28, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    BackgroundTransparency = 1, Parent = Card
                })

                local Switch = Create("TextButton", {
                    Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -50, 0, 18),
                    BackgroundColor3 = Theme.ToggleOff, Text = "", Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local Indicator = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = Theme.TextWhite, Parent = Switch
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local toggled = options.Default or false
                local function updateToggle()
                    local pos = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    local col = toggled and Theme.Accent or Theme.ToggleOff
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = pos}):Play()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
                end
                updateToggle()

                Switch.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                    if options.Callback then options.Callback(toggled) end
                end)
            end

            -- Standard Button Card (wie Reset Character, Rejoin Server)
            function Section:AddButton(options)
                local borderCol = options.Danger and Theme.RedDangerBorder or Theme.CardBorder
                local Card = Create("TextButton", {
                    BackgroundColor3 = Theme.CardBg,
                    Text = "",
                    Parent = Grid
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    Create("UIStroke", { Color = borderCol, Thickness = 1.2 })
                })

                Create("ImageLabel", {
                    Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 14, 0, 16),
                    BackgroundTransparency = 1, Image = options.Icon or "rbxassetid://6031265976",
                    ImageColor3 = Theme.TextWhite, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Name or "Button",
                    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 42, 0, 16), Size = UDim2.new(1, -50, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Description or "",
                    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 14, 0, 40), Size = UDim2.new(1, -28, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    BackgroundTransparency = 1, Parent = Card
                })

                Card.MouseButton1Click:Connect(function()
                    if options.Callback then options.Callback() end
                end)
            end

            return Section
        end

        return Tab
    end

    return Window
end

-- ====================================================================
-- IMPLEMENTIERUNG & SCRIPT BEISPIEL (Exakt wie auf deinem Bild)
-- ====================================================================

local Window = NightLib:MakeWindow({
    Name = "Night System",
    Version = "v1.0.0",
    UserProfile = {
        Name = "Night",
        Rank = "Premium"
    }
})

-- Movement Tab (Aktiver Tab auf Screenshot)
local MovementTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://6031265976"
})

-- Weitere Tabs aus dem Bild
local FlyTab = Window:MakeTab({ Name = "Fly", Icon = "rbxassetid://6031265976" })
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://6031265976" })
local VisualsTab = Window:MakeTab({ Name = "Visuals", Icon = "rbxassetid://6031265976" })
local TeleportsTab = Window:MakeTab({ Name = "Teleports", Icon = "rbxassetid://6031265976" })
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://6031265976" })

-- 1. SECTION: Character
local CharacterSection = MovementTab:AddSection("Character")

-- Walk Speed Card
CharacterSection:AddCompoundCard({
    Title = "Walk Speed",
    Icon = "rbxassetid://6031265976",
    ToggleName = "Enable Walk Speed",
    ToggleDesc = "Activate custom walk speed",
    DefaultToggle = true,
    SliderName = "Speed Amount",
    Min = 16, Max = 150, DefaultVal = 16, Suffix = "studs/s",
    ToggleCallback = function(enabled)
        _G.WalkSpeedEnabled = enabled
    end,
    SliderCallback = function(val)
        _G.WalkSpeedValue = val
    end
})

-- Jump Power Card
CharacterSection:AddCompoundCard({
    Title = "Jump Power",
    Icon = "rbxassetid://6031265976",
    ToggleName = "Enable Jump Power",
    ToggleDesc = "Activate custom jump power",
    DefaultToggle = true,
    SliderName = "Jump Power",
    Min = 50, Max = 200, DefaultVal = 50, Suffix = "",
    ToggleCallback = function(enabled)
        _G.JumpPowerEnabled = enabled
    end,
    SliderCallback = function(val)
        _G.JumpPowerValue = val
    end
})

-- 2. SECTION: Extras
local ExtrasSection = MovementTab:AddSection("Extras")

local NoclipConnection
ExtrasSection:AddToggle({
    Name = "Noclip",
    Description = "Walk through all objects",
    Icon = "rbxassetid://6031265976",
    Default = false,
    Callback = function(val)
        if val then
            NoclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if NoclipConnection then NoclipConnection:Disconnect() end
        end
    end
})

local InfJumpConn
ExtrasSection:AddToggle({
    Name = "Infinite Jump",
    Description = "Jump without touching the ground",
    Icon = "rbxassetid://6031265976",
    Default = false,
    Callback = function(val)
        if val then
            InfJumpConn = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if InfJumpConn then InfJumpConn:Disconnect() end
        end
    end
})

-- 3. SECTION: Actions
local ActionsSection = MovementTab:AddSection("Actions")

ActionsSection:AddButton({
    Name = "Reset Character",
    Description = "Respawn your character",
    Icon = "rbxassetid://6031265976",
    Danger = true, -- Erzeugt die rote Umrandung
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})

ActionsSection:AddButton({
    Name = "Rejoin Server",
    Description = "Rejoin the current server",
    Icon = "rbxassetid://6031265976",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

ActionsSection:AddButton({
    Name = "Restore Defaults",
    Description = "Reset all settings to default",
    Icon = "rbxassetid://6031265976",
    Callback = function()
        print("Settings Restored!")
    end
})

-- Loop für WalkSpeed / JumpPower Ausführung
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if _G.WalkSpeedEnabled then
            hum.WalkSpeed = _G.WalkSpeedValue or 16
        end
        if _G.JumpPowerEnabled then
            hum.UseJumpPower = true
            hum.JumpPower = _G.JumpPowerValue or 50
        end
    end
end)

return NightLib
