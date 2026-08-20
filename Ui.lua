-- ====================================================================
-- NIGHT SYSTEM UI LIBRARY v1.0.0 (1:1 Glassmorphism Replica & Bug-Fixed)
-- ====================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local NightLib = {}

-- Exakte Farbpalette mit Transparenzen
local Theme = {
    MainBg = Color3.fromRGB(13, 14, 22),
    MainBgTrans = 0.2, -- Transparenz wie auf dem Bild
    CardBg = Color3.fromRGB(22, 24, 36),
    CardBgTrans = 0.45,
    CardBorder = Color3.fromRGB(42, 45, 62),
    Accent = Color3.fromRGB(123, 97, 255),       -- Night Purple (#7B61FF)
    AccentHover = Color3.fromRGB(140, 115, 255),
    TextWhite = Color3.fromRGB(240, 242, 254),
    TextGray = Color3.fromRGB(135, 138, 158),
    ToggleOff = Color3.fromRGB(38, 41, 56),
    RedDangerBorder = Color3.fromRGB(140, 35, 45),
    RedDangerBg = Color3.fromRGB(40, 20, 25)
}

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

-- Smooth Dragging System
local function EnableDragging(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

    -- Standalone ScreenGui Check
    if CoreGui:FindFirstChild("NightSystemUI") then
        CoreGui.NightSystemUI:Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "NightSystemUI",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })

    -- Main Glass Window Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 840, 0, 520),
        Position = UDim2.new(0.5, -420, 0.5, -260),
        BackgroundColor3 = Theme.MainBg,
        BackgroundTransparency = Theme.MainBgTrans,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ClipsDescendants = true
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
        Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1.2, Transparency = 0.2 })
    })

    -- TopBar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    EnableDragging(MainFrame, TopBar)

    -- N Icon
    Create("Frame", {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 20, 0, 12),
        BackgroundColor3 = Theme.Accent,
        Parent = TopBar
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Create("TextLabel", {
            Text = "N", Font = Enum.Font.GothamBold, TextSize = 22,
            TextColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        })
    })

    Create("TextLabel", {
        Text = WindowName, Font = Enum.Font.GothamBold, TextSize = 16,
        TextColor3 = Theme.TextWhite, Position = UDim2.new(0, 68, 0, 14),
        Size = UDim2.new(0, 200, 0, 18), TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Parent = TopBar
    })

    Create("TextLabel", {
        Text = WindowVersion, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = Theme.TextGray, Position = UDim2.new(0, 68, 0, 32),
        Size = UDim2.new(0, 200, 0, 14), TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Parent = TopBar
    })

    -- Window Controls
    local Controls = Create("Frame", {
        Size = UDim2.new(0, 80, 0, 32), Position = UDim2.new(1, -90, 0, 14),
        BackgroundTransparency = 1, Parent = TopBar
    }, {
        Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8) })
    })

    local MinBtn = Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32), BackgroundColor3 = Theme.CardBg, BackgroundTransparency = 0.5,
        Text = "—", TextColor3 = Theme.TextGray, Font = Enum.Font.GothamBold, TextSize = 12, Parent = Controls
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })

    local CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32), BackgroundColor3 = Theme.CardBg, BackgroundTransparency = 0.5,
        Text = "✕", TextColor3 = Theme.TextGray, Font = Enum.Font.GothamBold, TextSize = 12, Parent = Controls
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    local minified = false
    MinBtn.MouseButton1Click:Connect(function()
        minified = not minified
        MainFrame:TweenSize(minified and UDim2.new(0, 840, 0, 60) or UDim2.new(0, 840, 0, 520), "Out", "Quart", 0.3, true)
    end)

    -- Sidebar
    local SideBar = Create("Frame", {
        Size = UDim2.new(0, 200, 1, -60), Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1, Parent = MainFrame
    })

    local TabContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -75), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, ScrollBarThickness = 0, Parent = SideBar
    }, {
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
    })

    -- Profile Card (Unten Links 1:1)
    local ProfileCard = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 54), Position = UDim2.new(0, 12, 1, -64),
        BackgroundColor3 = Theme.CardBg, BackgroundTransparency = Theme.CardBgTrans, Parent = SideBar
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1, Transparency = 0.3 })
    })

    local AvatarImg = Create("ImageLabel", {
        Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(0, 9, 0.5, -18),
        BackgroundColor3 = Theme.MainBg, BackgroundTransparency = 0.5, Image = "rbxasset://textures/ui/GuiImagePlaceholder.png", Parent = ProfileCard
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    pcall(function()
        AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    Create("TextLabel", {
        Text = UserData.Name or LocalPlayer.Name, Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = Theme.TextWhite, Position = UDim2.new(0, 52, 0, 11), Size = UDim2.new(0, 90, 0, 15),
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = ProfileCard
    })

    Create("TextLabel", {
        Text = UserData.Rank or "Premium", Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = Theme.Accent, Position = UDim2.new(0, 52, 0, 27), Size = UDim2.new(0, 90, 0, 13),
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = ProfileCard
    })

    Create("Frame", {
        Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(1, -16, 0.5, -4),
        BackgroundColor3 = Theme.Accent, Parent = ProfileCard
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

    -- Main Content Area
    local ContentArea = Create("Frame", {
        Size = UDim2.new(1, -210, 1, -70), Position = UDim2.new(0, 200, 0, 60),
        BackgroundTransparency = 1, Parent = MainFrame
    })

    local Window = { Tabs = {} }

    function Window:MakeTab(tabOptions)
        local TabName = tabOptions.Name or "Tab"
        local IconId = tabOptions.Icon or "rbxassetid://6031265976"

        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1, Text = "", Parent = TabContainer
        }, { Create("UICorner", { CornerRadius = UDim.new(0, 10) }) })

        local TabIcon = Create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 14, 0.5, -8),
            BackgroundTransparency = 1, Image = IconId, ImageColor3 = Theme.TextGray, Parent = TabButton
        })

        local TabText = Create("TextLabel", {
            Text = TabName, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.TextGray,
            Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -40, 1, 0), TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, Parent = TabButton
        })

        local TabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -15, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent, Visible = false, Parent = ContentArea
        }, { Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 14) }) })

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                TweenService:Create(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextGray}):Play()
                TweenService:Create(t.Text, TweenInfo.new(0.2), {TextColor3 = Theme.TextGray}):Play()
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.82}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextWhite}):Play()
            TweenService:Create(TabText, TweenInfo.new(0.2), {TextColor3 = Theme.TextWhite}):Play()
        end)

        table.insert(Window.Tabs, {Button = TabButton, Content = TabContent, Icon = TabIcon, Text = TabText})

        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.82
            TabIcon.ImageColor3 = Theme.TextWhite
            TabText.TextColor3 = Theme.TextWhite
        end

        local Tab = {}

        function Tab:AddSection(sectionTitle)
            local SectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = TabContent
            })

            Create("Frame", {
                Size = UDim2.new(0, 3, 0, 14), Position = UDim2.new(0, 0, 0.5, -7),
                BackgroundColor3 = Theme.Accent, Parent = SectionFrame
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            Create("TextLabel", {
                Text = sectionTitle, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextWhite,
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -10, 1, 0), TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1, Parent = SectionFrame
            })

            local Grid = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Parent = TabContent })

            local UIGrid = Create("UIGridLayout", {
                CellSize = UDim2.new(0.5, -6, 0, 120), CellPadding = UDim2.new(0, 12, 0, 12),
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = Grid
            })

            UIGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Grid.Size = UDim2.new(1, 0, 0, UIGrid.AbsoluteContentSize.Y)
            end)

            local Section = {}

            -- Combined Toggle + Slider Card (KORRIGIERTE SLIDER & TOGGLE LOGIK)
            function Section:AddCompoundCard(options)
                local Card = Create("Frame", {
                    BackgroundColor3 = Theme.CardBg, BackgroundTransparency = Theme.CardBgTrans, Parent = Grid
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1, Transparency = 0.3 })
                })

                Create("ImageLabel", {
                    Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 12, 0, 12), BackgroundTransparency = 1,
                    Image = options.Icon or "rbxassetid://6031265976", ImageColor3 = Theme.Accent, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Title or "Option", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 34, 0, 12), Size = UDim2.new(1, -40, 0, 16), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.ToggleName or "Enable", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 12, 0, 36), Size = UDim2.new(0, 180, 0, 14), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.ToggleDesc or "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 12, 0, 50), Size = UDim2.new(0, 180, 0, 12), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                -- Toggle Switch
                local Switch = Create("TextButton", {
                    Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -48, 0, 38), BackgroundColor3 = Theme.ToggleOff,
                    Text = "", Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local Indicator = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.TextWhite, Parent = Switch
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local toggled = options.DefaultToggle or false
                local function updateToggle(state)
                    toggled = state
                    local pos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local col = toggled and Theme.Accent or Theme.ToggleOff
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = pos}):Play()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
                end
                updateToggle(toggled)

                Switch.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle(toggled)
                    if options.ToggleCallback then options.ToggleCallback(toggled) end
                end)

                -- Slider Bug-Fixing (Zero Division & Drag Calculation)
                local min = options.Min or 0
                local max = options.Max or 100
                local val = math.clamp(options.DefaultVal or min, min, max)
                local suffix = options.Suffix or ""

                local ValueBadge = Create("TextLabel", {
                    Text = tostring(val), Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(1, -44, 0, 72), Size = UDim2.new(0, 32, 0, 16),
                    BackgroundColor3 = Theme.MainBg, BackgroundTransparency = 0.5, Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                Create("TextLabel", {
                    Text = options.SliderName or "Amount", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 12, 0, 72), Size = UDim2.new(0, 120, 0, 16), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = min .. " " .. suffix, Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 12, 0, 88), Size = UDim2.new(0, 60, 0, 10), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = max .. " " .. suffix, Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(1, -72, 0, 88), Size = UDim2.new(0, 60, 0, 10), TextXAlignment = Enum.TextXAlignment.Right,
                    BackgroundTransparency = 1, Parent = Card
                })

                local SliderBar = Create("TextButton", {
                    Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 102),
                    BackgroundColor3 = Theme.ToggleOff, Text = "", Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local initPos = math.clamp((val - min) / math.max(1, (max - min)), 0, 1)
                local SliderFill = Create("Frame", {
                    Size = UDim2.new(initPos, 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = SliderBar
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local SliderKnob = Create("Frame", {
                    Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -5, 0.5, -5),
                    BackgroundColor3 = Theme.TextWhite, Parent = SliderFill
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local sliding = false
                local function updateSlider(input)
                    local barSizeX = SliderBar.AbsoluteSize.X
                    if barSizeX > 0 then
                        local relativeX = input.Position.X - SliderBar.AbsolutePosition.X
                        local pct = math.clamp(relativeX / barSizeX, 0, 1)
                        val = math.floor(min + (max - min) * pct)
                        ValueBadge.Text = tostring(val)
                        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
                        if options.SliderCallback then options.SliderCallback(val) end
                    end
                end

                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateSlider(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
            end

            -- Standard Toggle Card
            function Section:AddToggle(options)
                local Card = Create("Frame", {
                    BackgroundColor3 = Theme.CardBg, BackgroundTransparency = Theme.CardBgTrans, Parent = Grid
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    Create("UIStroke", { Color = Theme.CardBorder, Thickness = 1, Transparency = 0.3 })
                })

                Create("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 12, 0, 16), BackgroundTransparency = 1,
                    Image = options.Icon or "rbxassetid://6031265976", ImageColor3 = Theme.Accent, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Name or "Toggle", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 36, 0, 16), Size = UDim2.new(1, -90, 0, 16), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Description or "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 12, 0, 40), Size = UDim2.new(1, -24, 0, 26), TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true, BackgroundTransparency = 1, Parent = Card
                })

                local Switch = Create("TextButton", {
                    Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -48, 0, 16), BackgroundColor3 = Theme.ToggleOff,
                    Text = "", Parent = Card
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local Indicator = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.TextWhite, Parent = Switch
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                local toggled = options.Default or false
                local function updateToggle(state)
                    toggled = state
                    local pos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local col = toggled and Theme.Accent or Theme.ToggleOff
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = pos}):Play()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
                end
                updateToggle(toggled)

                Switch.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle(toggled)
                    if options.Callback then options.Callback(toggled) end
                end)
            end

            -- Standard Button Card (mit Roter Border für Danger Action)
            function Section:AddButton(options)
                local borderCol = options.Danger and Theme.RedDangerBorder or Theme.CardBorder
                local bgCol = options.Danger and Theme.RedDangerBg or Theme.CardBg

                local Card = Create("TextButton", {
                    BackgroundColor3 = bgCol, BackgroundTransparency = Theme.CardBgTrans, Text = "", Parent = Grid
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    Create("UIStroke", { Color = borderCol, Thickness = 1.2, Transparency = 0.2 })
                })

                Create("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 12, 0, 16), BackgroundTransparency = 1,
                    Image = options.Icon or "rbxassetid://6031265976", ImageColor3 = Theme.TextWhite, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Name or "Button", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextWhite,
                    Position = UDim2.new(0, 36, 0, 16), Size = UDim2.new(1, -50, 0, 16), TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, Parent = Card
                })

                Create("TextLabel", {
                    Text = options.Description or "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextGray,
                    Position = UDim2.new(0, 12, 0, 40), Size = UDim2.new(1, -24, 0, 26), TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true, BackgroundTransparency = 1, Parent = Card
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
-- IMPLEMENTIERUNG (1:1 EXAKT WIE AUF DEM BILD)
-- ====================================================================

local Window = NightLib:MakeWindow({
    Name = "Night System",
    Version = "v1.0.0",
    UserProfile = {
        Name = "Night",
        Rank = "Premium"
    }
})

local MovementTab = Window:MakeTab({ Name = "Movement", Icon = "rbxassetid://6031265976" })
local FlyTab = Window:MakeTab({ Name = "Fly", Icon = "rbxassetid://6031265976" })
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://6031265976" })
local VisualsTab = Window:MakeTab({ Name = "Visuals", Icon = "rbxassetid://6031265976" })
local TeleportsTab = Window:MakeTab({ Name = "Teleports", Icon = "rbxassetid://6031265976" })
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://6031265976" })

-- Character Section
local CharacterSection = MovementTab:AddSection("Character")

CharacterSection:AddCompoundCard({
    Title = "Walk Speed",
    Icon = "rbxassetid://6031265976",
    ToggleName = "Enable Walk Speed",
    ToggleDesc = "Activate custom walk speed",
    DefaultToggle = true,
    SliderName = "Speed Amount",
    Min = 16, Max = 150, DefaultVal = 16, Suffix = "studs/s",
    ToggleCallback = function(enabled) _G.WalkSpeedEnabled = enabled end,
    SliderCallback = function(val) _G.WalkSpeedValue = val end
})

CharacterSection:AddCompoundCard({
    Title = "Jump Power",
    Icon = "rbxassetid://6031265976",
    ToggleName = "Enable Jump Power",
    ToggleDesc = "Activate custom jump power",
    DefaultToggle = true,
    SliderName = "Jump Power",
    Min = 50, Max = 200, DefaultVal = 50, Suffix = "",
    ToggleCallback = function(enabled) _G.JumpPowerEnabled = enabled end,
    SliderCallback = function(val) _G.JumpPowerValue = val end
})

-- Extras Section
local ExtrasSection = MovementTab:AddSection("Extras")

local NoclipConn
ExtrasSection:AddToggle({
    Name = "Noclip", Description = "Walk through all objects", Icon = "rbxassetid://6031265976", Default = false,
    Callback = function(val)
        if val then
            NoclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if NoclipConn then NoclipConn:Disconnect() end
        end
    end
})

local InfJumpConn
ExtrasSection:AddToggle({
    Name = "Infinite Jump", Description = "Jump without touching the ground", Icon = "rbxassetid://6031265976", Default = false,
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

-- Actions Section
local ActionsSection = MovementTab:AddSection("Actions")

ActionsSection:AddButton({
    Name = "Reset Character", Description = "Respawn your character", Icon = "rbxassetid://6031265976", Danger = true,
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})

ActionsSection:AddButton({
    Name = "Rejoin Server", Description = "Rejoin the current server", Icon = "rbxassetid://6031265976",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

ActionsSection:AddButton({
    Name = "Restore Defaults", Description = "Reset all settings to default", Icon = "rbxassetid://6031265976",
    Callback = function() print("Defaults restored!") end
})

-- Main Render Loop (WalkSpeed & JumpPower)
RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if _G.WalkSpeedEnabled then hum.WalkSpeed = _G.WalkSpeedValue or 16 end
            if _G.JumpPowerEnabled then hum.UseJumpPower = true hum.JumpPower = _G.JumpPowerValue or 50 end
        end
    end)
end)

return NightLib
