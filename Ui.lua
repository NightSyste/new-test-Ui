local Library = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local Colors = {
    Background = Color3.fromRGB(12, 16, 24),
    Window = Color3.fromRGB(18, 22, 32),
    Card = Color3.fromRGB(24, 29, 40),
    CardHover = Color3.fromRGB(29, 34, 47),
    Stroke = Color3.fromRGB(55, 61, 78),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(155, 160, 175),
    Purple = Color3.fromRGB(132, 83, 255),
    Purple2 = Color3.fromRGB(165, 108, 255),
    Red = Color3.fromRGB(180, 55, 70)
}

local function Tween(object, time, properties)
    TweenService:Create(
        object,
        TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = object
    return corner
end

local function Stroke(object, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Stroke
    stroke.Transparency = transparency or 0
    stroke.Thickness = 1
    stroke.Parent = object
    return stroke
end

local function Label(parent, text, size, color, font)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Colors.Text
    label.TextSize = size or 14
    label.Font = font or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

function Library:CreateWindow(options)

    options = options or {}

    local WindowTitle = options.Title or "Night System"
    local Version = options.Version or "v1.0.0"

    local gui = Instance.new("ScreenGui")
    gui.Name = "NightSystem"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.fromOffset(925, 640)
    Main.Position = UDim2.new(0.5, -462, 0.5, -320)
    Main.BackgroundColor3 = Colors.Window
    Main.BackgroundTransparency = 0.08
    Main.Parent = gui

    Corner(Main, 22)
    Stroke(Main, Color3.fromRGB(82, 71, 145), 0.25)

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 26, 38)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 19, 29)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 24, 35))
    })
    Gradient.Rotation = 25
    Gradient.Parent = Main

    local Top = Instance.new("Frame")
    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 74)
    Top.Parent = Main

    local Logo = Instance.new("TextLabel")
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.fromOffset(25, 17)
    Logo.Size = UDim2.fromOffset(40, 40)
    Logo.Text = "N"
    Logo.TextColor3 = Colors.Purple2
    Logo.TextSize = 39
    Logo.Font = Enum.Font.GothamBold
    Logo.Parent = Top

    local Title = Label(Top, WindowTitle, 17, Colors.Text, Enum.Font.GothamMedium)
    Title.Position = UDim2.fromOffset(73, 16)
    Title.Size = UDim2.fromOffset(300, 25)

    local Ver = Label(Top, Version, 12, Colors.SubText)
    Ver.Position = UDim2.fromOffset(74, 39)
    Ver.Size = UDim2.fromOffset(100, 20)

    local Minimize = Instance.new("TextButton")
    Minimize.AutoButtonColor = false
    Minimize.BackgroundColor3 = Colors.Card
    Minimize.BackgroundTransparency = 0.25
    Minimize.Position = UDim2.new(1, -111, 0, 18)
    Minimize.Size = UDim2.fromOffset(40, 38)
    Minimize.Text = "−"
    Minimize.TextColor3 = Colors.Text
    Minimize.TextSize = 22
    Minimize.Font = Enum.Font.Gotham
    Minimize.Parent = Top

    Corner(Minimize, 10)
    Stroke(Minimize, Colors.Stroke, 0.3)

    local Close = Instance.new("TextButton")
    Close.AutoButtonColor = false
    Close.BackgroundColor3 = Colors.Card
    Close.BackgroundTransparency = 0.25
    Close.Position = UDim2.new(1, -58, 0, 18)
    Close.Size = UDim2.fromOffset(40, 38)
    Close.Text = "×"
    Close.TextColor3 = Colors.Text
    Close.TextSize = 27
    Close.Font = Enum.Font.Gotham
    Close.Parent = Top

    Corner(Close, 10)
    Stroke(Close, Colors.Stroke, 0.3)

    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Position = UDim2.fromOffset(18, 74)
    Content.Size = UDim2.new(1, -36, 1, -92)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 3
    Content.ScrollBarImageColor3 = Colors.Purple
    Content.CanvasSize = UDim2.new()
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.Parent = Main

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 4)
    Padding.PaddingRight = UDim.new(0, 4)
    Padding.PaddingTop = UDim.new(0, 4)
    Padding.PaddingBottom = UDim.new(0, 15)
    Padding.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 15)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Content

    local dragging = false
    local dragStart
    local startPosition

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local minimized = false

    Minimize.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            Tween(Main, 0.25, {
                Size = UDim2.fromOffset(925, 74)
            })
        else
            Tween(Main, 0.25, {
                Size = UDim2.fromOffset(925, 640)
            })
        end
    end)

    Close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local Window = {}

    function Window:AddSection(text)

        local SectionHolder = Instance.new("Frame")
        SectionHolder.BackgroundTransparency = 1
        SectionHolder.Size = UDim2.new(1, 0, 0, 32)
        SectionHolder.Parent = Content

        local Accent = Instance.new("Frame")
        Accent.BackgroundColor3 = Colors.Purple
        Accent.Position = UDim2.fromOffset(0, 5)
        Accent.Size = UDim2.fromOffset(3, 18)
        Accent.Parent = SectionHolder

        Corner(Accent, 4)

        local SectionText = Label(
            SectionHolder,
            text,
            15,
            Colors.Text,
            Enum.Font.GothamMedium
        )

        SectionText.Position = UDim2.fromOffset(14, 0)
        SectionText.Size = UDim2.new(1, -14, 1, 0)

        return SectionHolder
    end

    function Window:AddCard(options)

        options = options or {}

        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Colors.Card
        Card.BackgroundTransparency = 0.18
        Card.Size = UDim2.new(1, 0, 0, options.Height or 70)
        Card.Parent = Content

        Corner(Card, 11)
        Stroke(Card, Colors.Stroke, 0.45)

        local CardTitle = Label(
            Card,
            options.Title or "Option",
            14,
            Colors.Text,
            Enum.Font.GothamMedium
        )

        CardTitle.Position = UDim2.fromOffset(17, 13)
        CardTitle.Size = UDim2.new(1, -34, 0, 22)

        if options.Description then

            local Desc = Label(
                Card,
                options.Description,
                12,
                Colors.SubText
            )

            Desc.Position = UDim2.fromOffset(17, 36)
            Desc.Size = UDim2.new(1, -34, 0, 20)
        end

        return Card
    end

    function Window:AddToggle(options)

        options = options or {}

        local Card = Window:AddCard({
            Title = options.Title or "Toggle",
            Description = options.Description,
            Height = 64
        })

        local Toggle = Instance.new("TextButton")
        Toggle.AutoButtonColor = false
        Toggle.BackgroundColor3 = Color3.fromRGB(45, 50, 62)
        Toggle.Position = UDim2.new(1, -56, 0.5, -12)
        Toggle.Size = UDim2.fromOffset(40, 24)
        Toggle.Text = ""
        Toggle.Parent = Card

        Corner(Toggle, 20)
        Stroke(Toggle, Colors.Stroke, 0.35)

        local Dot = Instance.new("Frame")
        Dot.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        Dot.Position = UDim2.fromOffset(4, 4)
        Dot.Size = UDim2.fromOffset(16, 16)
        Dot.Parent = Toggle

        Corner(Dot, 20)

        local Enabled = options.Default == true

        local function Update(value)

            Enabled = value

            if Enabled then
                Tween(Toggle, 0.2, {
                    BackgroundColor3 = Colors.Purple
                })

                Tween(Dot, 0.2, {
                    Position = UDim2.new(1, -20, 0, 4)
                })
            else
                Tween(Toggle, 0.2, {
                    BackgroundColor3 = Color3.fromRGB(45, 50, 62)
                })

                Tween(Dot, 0.2, {
                    Position = UDim2.fromOffset(4, 4)
                })
            end

            if options.Callback then
                task.spawn(options.Callback, Enabled)
            end
        end

        Toggle.MouseButton1Click:Connect(function()
            Update(not Enabled)
        end)

        Update(Enabled)

        return {
            Set = Update,
            Get = function()
                return Enabled
            end
        }
    end

    function Window:AddButton(options)

        options = options or {}

        local Card = Window:AddCard({
            Title = options.Title or "Button",
            Description = options.Description,
            Height = 62
        })

        local Button = Instance.new("TextButton")
        Button.AutoButtonColor = false
        Button.BackgroundColor3 = Colors.CardHover
        Button.Position = UDim2.new(1, -115, 0.5, -19)
        Button.Size = UDim2.fromOffset(96, 38)
        Button.Text = options.Text or "Execute"
        Button.TextColor3 = Colors.Text
        Button.TextSize = 13
        Button.Font = Enum.Font.GothamMedium
        Button.Parent = Card

        Corner(Button, 9)
        Stroke(Button, Colors.Stroke, 0.35)

        Button.MouseEnter:Connect(function()
            Tween(Button, 0.15, {
                BackgroundColor3 = Colors.Purple
            })
        end)

        Button.MouseLeave:Connect(function()
            Tween(Button, 0.15, {
                BackgroundColor3 = Colors.CardHover
            })
        end)

        Button.MouseButton1Click:Connect(function()
            if options.Callback then
                task.spawn(options.Callback)
            end
        end)

        return Button
    end

    function Window:AddSlider(options)

        options = options or {}

        local Minimum = options.Min or 0
        local Maximum = options.Max or 100
        local Value = options.Default or Minimum

        local Card = Window:AddCard({
            Title = options.Title or "Slider",
            Description = options.Description,
            Height = 102
        })

        local ValueBox = Instance.new("TextLabel")
        ValueBox.BackgroundColor3 = Colors.CardHover
        ValueBox.Position = UDim2.new(1, -54, 0, 11)
        ValueBox.Size = UDim2.fromOffset(36, 25)
        ValueBox.Text = tostring(Value)
        ValueBox.TextColor3 = Colors.Text
        ValueBox.TextSize = 12
        ValueBox.Font = Enum.Font.Gotham
        ValueBox.Parent = Card

        Corner(ValueBox, 7)
        Stroke(ValueBox, Colors.Stroke, 0.4)

        local MinText = Label(
            Card,
            tostring(Minimum),
            11,
            Colors.SubText
        )

        MinText.Position = UDim2.fromOffset(17, 61)
        MinText.Size = UDim2.fromOffset(80, 18)

        local MaxText = Label(
            Card,
            tostring(Maximum),
            11,
            Colors.SubText
        )

        MaxText.Position = UDim2.new(1, -85, 0, 61)
        MaxText.Size = UDim2.fromOffset(68, 18)
        MaxText.TextXAlignment = Enum.TextXAlignment.Right

        local SliderBack = Instance.new("Frame")
        SliderBack.BackgroundColor3 = Color3.fromRGB(48, 53, 66)
        SliderBack.Position = UDim2.fromOffset(17, 79)
        SliderBack.Size = UDim2.new(1, -34, 0, 5)
        SliderBack.Parent = Card

        Corner(SliderBack, 5)

        local SliderFill = Instance.new("Frame")
        SliderFill.BackgroundColor3 = Colors.Purple
        SliderFill.Size = UDim2.new(0, 0, 1, 0)
        SliderFill.Parent = SliderBack

        Corner(SliderFill, 5)

        local Knob = Instance.new("Frame")
        Knob.BackgroundColor3 = Colors.Purple2
        Knob.AnchorPoint = Vector2.new(0.5, 0.5)
        Knob.Size = UDim2.fromOffset(14, 14)
        Knob.Parent = SliderBack

        Corner(Knob, 20)

        local draggingSlider = false

        local function SetValue(value)

            Value = math.clamp(value, Minimum, Maximum)

            local percent = (Value - Minimum) / (Maximum - Minimum)

            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            Knob.Position = UDim2.new(percent, 0, 0.5, 0)
            ValueBox.Text = tostring(math.floor(Value))

            if options.Callback then
                task.spawn(options.Callback, Value)
            end
        end

        SliderBack.InputBegan:Connect(function(input)

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = true

                local percent = math.clamp(
                    (input.Position.X - SliderBack.AbsolutePosition.X)
                    / SliderBack.AbsoluteSize.X,
                    0,
                    1
                )

                SetValue(
                    Minimum + ((Maximum - Minimum) * percent)
                )
            end
        end)

        UserInputService.InputChanged:Connect(function(input)

            if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then

                local percent = math.clamp(
                    (input.Position.X - SliderBack.AbsolutePosition.X)
                    / SliderBack.AbsoluteSize.X,
                    0,
                    1
                )

                SetValue(
                    Minimum + ((Maximum - Minimum) * percent)
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = false
            end
        end)

        SetValue(Value)

        return {
            Set = SetValue,
            Get = function()
                return Value
            end
        }
    end

    function Window:AddParagraph(options)

        options = options or {}

        local Card = Window:AddCard({
            Title = options.Title or "",
            Description = options.Text or "",
            Height = options.Height or 65
        })

        return Card
    end

    function Window:AddSpacer(height)

        local Spacer = Instance.new("Frame")
        Spacer.BackgroundTransparency = 1
        Spacer.Size = UDim2.new(1, 0, 0, height or 5)
        Spacer.Parent = Content

        return Spacer
    end

    function Window:Destroy()
        gui:Destroy()
    end

    return Window
end

return Library
