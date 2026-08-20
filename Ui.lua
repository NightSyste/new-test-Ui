local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Character
local Humanoid
local Root

local function updateCharacter()
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	Root = Character:WaitForChild("HumanoidRootPart")
end

updateCharacter()

Player.CharacterAdded:Connect(function()
	task.wait(.3)
	updateCharacter()
end)

local SpeedEnabled = false
local SpeedValue = 16

local JumpEnabled = false
local JumpValue = 50

local FlyEnabled = false
local FlySpeed = 50

local NoclipEnabled = false
local InfiniteJump = false

local FlyVelocity
local FlyGyro
local FlyConnection

local function tween(obj, time, props)
	TweenService:Create(
		obj,
		TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		props
	):Play()
end

local function new(class, props)
	local obj = Instance.new(class)

	for i, v in pairs(props or {}) do
		obj[i] = v
	end

	return obj
end

local ScreenGui = new("ScreenGui", {
	Name = "NightSystem",
	Parent = PlayerGui,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local Main = new("Frame", {
	Parent = ScreenGui,
	Size = UDim2.fromOffset(1050, 680),
	Position = UDim2.new(.5, -525, .5, -340),
	BackgroundColor3 = Color3.fromRGB(16, 19, 27),
	BackgroundTransparency = .25,
	BorderSizePixel = 0
})

new("UICorner", {
	Parent = Main,
	CornerRadius = UDim.new(0, 18)
})

local MainStroke = new("UIStroke", {
	Parent = Main,
	Color = Color3.fromRGB(120, 90, 255),
	Transparency = .45,
	Thickness = 1
})

local Header = new("Frame", {
	Parent = Main,
	Size = UDim2.new(1, 0, 0, 100),
	BackgroundTransparency = 1
})

local Logo = new("TextLabel", {
	Parent = Header,
	Size = UDim2.fromOffset(55, 55),
	Position = UDim2.fromOffset(25, 22),
	BackgroundTransparency = 1,
	Text = "N",
	TextColor3 = Color3.fromRGB(145, 100, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 46
})

local Title = new("TextLabel", {
	Parent = Header,
	Size = UDim2.fromOffset(300, 35),
	Position = UDim2.fromOffset(85, 20),
	BackgroundTransparency = 1,
	Text = "Night System",
	TextColor3 = Color3.fromRGB(245, 245, 250),
	Font = Enum.Font.GothamBold,
	TextSize = 24,
	TextXAlignment = Enum.TextXAlignment.Left
})

local Version = new("TextLabel", {
	Parent = Header,
	Size = UDim2.fromOffset(200, 25),
	Position = UDim2.fromOffset(87, 53),
	BackgroundTransparency = 1,
	Text = "v1.0.0",
	TextColor3 = Color3.fromRGB(145, 145, 160),
	Font = Enum.Font.Gotham,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left
})

local Close = new("TextButton", {
	Parent = Header,
	Size = UDim2.fromOffset(50, 50),
	Position = UDim2.new(1, -70, 0, 25),
	BackgroundColor3 = Color3.fromRGB(30, 33, 42),
	BackgroundTransparency = .25,
	Text = "×",
	TextColor3 = Color3.fromRGB(235, 235, 240),
	Font = Enum.Font.Gotham,
	TextSize = 30,
	AutoButtonColor = false
})

new("UICorner", {
	Parent = Close,
	CornerRadius = UDim.new(0, 12)
})

local Minimize = new("TextButton", {
	Parent = Header,
	Size = UDim2.fromOffset(50, 50),
	Position = UDim2.new(1, -130, 0, 25),
	BackgroundColor3 = Color3.fromRGB(30, 33, 42),
	BackgroundTransparency = .25,
	Text = "—",
	TextColor3 = Color3.fromRGB(235, 235, 240),
	Font = Enum.Font.Gotham,
	TextSize = 25,
	AutoButtonColor = false
})

new("UICorner", {
	Parent = Minimize,
	CornerRadius = UDim.new(0, 12)
})

local Divider = new("Frame", {
	Parent = Main,
	Position = UDim2.new(0, 0, 0, 99),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = Color3.fromRGB(80, 80, 100),
	BackgroundTransparency = .65,
	BorderSizePixel = 0
})

local Sidebar = new("Frame", {
	Parent = Main,
	Position = UDim2.fromOffset(20, 120),
	Size = UDim2.fromOffset(230, 540),
	BackgroundTransparency = 1
})

local Content = new("Frame", {
	Parent = Main,
	Position = UDim2.fromOffset(270, 120),
	Size = UDim2.new(1, -290, 1, -140),
	BackgroundTransparency = 1
})

local Pages = {}

local function createPage(name)
	local page = new("ScrollingFrame", {
		Parent = Content,
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(130, 90, 255),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false
	})

	local layout = new("UIListLayout", {
		Parent = page,
		Padding = UDim.new(0, 12),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 20
		)
	end)

	Pages[name] = page

	return page
end

local function section(parent, text)

	local holder = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, -20, 0, 35),
		BackgroundTransparency = 1
	})

	local line = new("Frame", {
		Parent = holder,
		Position = UDim2.fromOffset(0, 7),
		Size = UDim2.fromOffset(4, 22),
		BackgroundColor3 = Color3.fromRGB(145, 95, 255),
		BorderSizePixel = 0
	})

	new("UICorner", {
		Parent = line,
		CornerRadius = UDim.new(1, 0)
	})

	new("TextLabel", {
		Parent = holder,
		Position = UDim2.fromOffset(16, 0),
		Size = UDim2.new(1, -16, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Color3.fromRGB(240, 240, 245),
		Font = Enum.Font.GothamSemibold,
		TextSize = 19,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	return holder
end

local function card(parent, height)

	local frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, -20, 0, height),
		BackgroundColor3 = Color3.fromRGB(27, 30, 40),
		BackgroundTransparency = .28,
		BorderSizePixel = 0
	})

	new("UICorner", {
		Parent = frame,
		CornerRadius = UDim.new(0, 12)
	})

	new("UIStroke", {
		Parent = frame,
		Color = Color3.fromRGB(90, 92, 115),
		Transparency = .68,
		Thickness = 1
	})

	return frame
end

local function toggle(parent, title, desc, default, callback)

	local frame = card(parent, 78)

	local titleLabel = new("TextLabel", {
		Parent = frame,
		Position = UDim2.fromOffset(20, 12),
		Size = UDim2.new(1, -100, 0, 25),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Color3.fromRGB(242, 242, 247),
		Font = Enum.Font.GothamSemibold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	new("TextLabel", {
		Parent = frame,
		Position = UDim2.fromOffset(20, 39),
		Size = UDim2.new(1, -100, 0, 25),
		BackgroundTransparency = 1,
		Text = desc or "",
		TextColor3 = Color3.fromRGB(155, 157, 170),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local button = new("TextButton", {
		Parent = frame,
		Size = UDim2.fromOffset(58, 30),
		Position = UDim2.new(1, -78, .5, -15),
		BackgroundColor3 = Color3.fromRGB(48, 51, 62),
		Text = "",
		AutoButtonColor = false
	})

	new("UICorner", {
		Parent = button,
		CornerRadius = UDim.new(1, 0)
	})

	local circle = new("Frame", {
		Parent = button,
		Size = UDim2.fromOffset(22, 22),
		Position = UDim2.fromOffset(4, 4),
		BackgroundColor3 = Color3.fromRGB(220, 220, 225),
		BorderSizePixel = 0
	})

	new("UICorner", {
		Parent = circle,
		CornerRadius = UDim.new(1, 0)
	})

	local state = default or false

	local function update()

		if state then
			tween(button, .2, {
				BackgroundColor3 = Color3.fromRGB(135, 85, 255)
			})

			tween(circle, .2, {
				Position = UDim2.new(1, -26, 0, 4)
			})
		else
			tween(button, .2, {
				BackgroundColor3 = Color3.fromRGB(48, 51, 62)
			})

			tween(circle, .2, {
				Position = UDim2.fromOffset(4, 4)
			})
		end

		if callback then
			callback(state)
		end
	end

	button.MouseButton1Click:Connect(function()
		state = not state
		update()
	end)

	update()

	return frame
end

local function slider(parent, title, min, max, default, callback)

	local frame = card(parent, 100)

	local label = new("TextLabel", {
		Parent = frame,
		Position = UDim2.fromOffset(20, 12),
		Size = UDim2.new(1, -80, 0, 25),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Color3.fromRGB(242, 242, 247),
		Font = Enum.Font.GothamSemibold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local value = new("TextLabel", {
		Parent = frame,
		Position = UDim2.new(1, -75, 0, 12),
		Size = UDim2.fromOffset(55, 25),
		BackgroundTransparency = 1,
		Text = tostring(default),
		TextColor3 = Color3.fromRGB(185, 155, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Right
	})

	local bar = new("Frame", {
		Parent = frame,
		Position = UDim2.fromOffset(20, 62),
		Size = UDim2.new(1, -40, 0, 6),
		BackgroundColor3 = Color3.fromRGB(55, 58, 70),
		BorderSizePixel = 0
	})

	new("UICorner", {
		Parent = bar,
		CornerRadius = UDim.new(1, 0)
	})

	local fill = new("Frame", {
		Parent = bar,
		Size = UDim2.new(
			(default - min) / (max - min),
			0,
			1,
			0
		),
		BackgroundColor3 = Color3.fromRGB(145, 95, 255),
		BorderSizePixel = 0
	})

	new("UICorner", {
		Parent = fill,
		CornerRadius = UDim.new(1, 0)
	})

	local knob = new("Frame", {
		Parent = bar,
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.new(
			(default - min) / (max - min),
			-8,
			.5,
			-8
		),
		BackgroundColor3 = Color3.fromRGB(165, 120, 255),
		BorderSizePixel = 0
	})

	new("UICorner", {
		Parent = knob,
		CornerRadius = UDim.new(1, 0)
	})

	local dragging = false

	local function setValue(x)

		local percent = math.clamp(
			(x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
			0,
			1
		)

		local number = min + (max - min) * percent
		number = math.floor(number + .5)

		value.Text = tostring(number)

		fill.Size = UDim2.new(percent, 0, 1, 0)
		knob.Position = UDim2.new(percent, -8, .5, -8)

		if callback then
			callback(number)
		end
	end

	bar.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			setValue(input.Position.X)
		end

	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			setValue(input.Position.X)
		end

	end)

	return frame
end

local function action(parent, title, desc, callback)

	local frame = card(parent, 70)

	local button = new("TextButton", {
		Parent = frame,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false
	})

	new("TextLabel", {
		Parent = frame,
		Position = UDim2.fromOffset(20, 10),
		Size = UDim2.new(1, -40, 0, 25),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Color3.fromRGB(240, 240, 245),
		Font = Enum.Font.GothamSemibold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	new("TextLabel", {
		Parent = frame,
		Position = UDim2.fromOffset(20, 37),
		Size = UDim2.new(1, -40, 0, 20),
		BackgroundTransparency = 1,
		Text = desc or "",
		TextColor3 = Color3.fromRGB(150, 152, 165),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	button.MouseEnter:Connect(function()
		tween(frame, .15, {
			BackgroundTransparency = .12
		})
	end)

	button.MouseLeave:Connect(function()
		tween(frame, .15, {
			BackgroundTransparency = .28
		})
	end)

	button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	return frame
end

local Movement = createPage("Movement")

section(Movement, "Character")

toggle(
	Movement,
	"Enable Walk Speed",
	"Activate custom walk speed",
	false,
	function(enabled)

		SpeedEnabled = enabled

		if Humanoid then
			Humanoid.WalkSpeed = enabled and SpeedValue or 16
		end

	end
)

slider(
	Movement,
	"Speed Amount",
	16,
	150,
	16,
	function(value)

		SpeedValue = value

		if SpeedEnabled and Humanoid then
			Humanoid.WalkSpeed = value
		end

	end
)

toggle(
	Movement,
	"Enable Jump Power",
	"Activate custom jump power",
	false,
	function(enabled)

		JumpEnabled = enabled

		if Humanoid then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = enabled and JumpValue or 50
		end

	end
)

slider(
	Movement,
	"Jump Power",
	50,
	200,
	50,
	function(value)

		JumpValue = value

		if JumpEnabled and Humanoid then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = value
		end

	end
)

section(Movement, "Extras")

toggle(
	Movement,
	"Noclip",
	"Walk through objects",
	false,
	function(enabled)
		NoclipEnabled = enabled
	end
)

toggle(
	Movement,
	"Infinite Jump",
	"Jump without touching the ground",
	false,
	function(enabled)
		InfiniteJump = enabled
	end
)

section(Movement, "Actions")

action(
	Movement,
	"Reset Character",
	"Respawn your character",
	function()

		if Humanoid then
			Humanoid.Health = 0
		end

	end
)

action(
	Movement,
	"Rejoin Server",
	"Rejoin the current server",
	function()

		TeleportService:Teleport(
			game.PlaceId,
			Player
		)

	end
)

action(
	Movement,
	"Restore Defaults",
	"Reset all settings to default",
	function()

		SpeedEnabled = false
		JumpEnabled = false
		NoclipEnabled = false
		InfiniteJump = false

		SpeedValue = 16
		JumpValue = 50

		if Humanoid then
			Humanoid.WalkSpeed = 16
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = 50
		end

	end
)

local FlyPage = createPage("Fly")

section(FlyPage, "Flight")

toggle(
	FlyPage,
	"Fly",
	"WASD to move, Space up, LeftControl down",
	false,
	function(enabled)

		FlyEnabled = enabled

		if enabled then
			startFly()
		else
			stopFly()
		end

	end
)

slider(
	FlyPage,
	"Fly Speed",
	10,
	200,
	50,
	function(value)
		FlySpeed = value
	end
)

local PlayerPage = createPage("Player")

section(PlayerPage, "Player")

action(
	PlayerPage,
	"Reset Character",
	"Respawn your character",
	function()

		if Humanoid then
			Humanoid.Health = 0
		end

	end
)

local VisualPage = createPage("Visuals")

section(VisualPage, "Visuals")

local TeleportPage = createPage("Teleports")

section(TeleportPage, "Teleports")

local SettingsPage = createPage("Settings")

section(SettingsPage, "Settings")

local navButtons = {}

local function showPage(name)

	for pageName, page in pairs(Pages) do
		page.Visible = pageName == name
	end

	for buttonName, button in pairs(navButtons) do

		if buttonName == name then

			tween(button, .18, {
				BackgroundColor3 = Color3.fromRGB(72, 58, 120),
				BackgroundTransparency = .08
			})

		else

			tween(button, .18, {
				BackgroundColor3 = Color3.fromRGB(25, 28, 37),
				BackgroundTransparency = .35
			})

		end

	end

end

local navNames = {
	"Movement",
	"Fly",
	"Player",
	"Visuals",
	"Teleports",
	"Settings"
}

for i, name in ipairs(navNames) do

	local button = new("TextButton", {
		Parent = Sidebar,
		Size = UDim2.new(1, 0, 0, 58),
		Position = UDim2.fromOffset(0, (i - 1) * 68),
		BackgroundColor3 = Color3.fromRGB(25, 28, 37),
		BackgroundTransparency = .35,
		Text = name,
		TextColor3 = Color3.fromRGB(225, 225, 232),
		Font = Enum.Font.GothamSemibold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false
	})

	new("UICorner", {
		Parent = button,
		CornerRadius = UDim.new(0, 12)
	})

	new("UIPadding", {
		Parent = button,
		PaddingLeft = UDim.new(0, 22)
	})

	new("UIStroke", {
		Parent = button,
		Color = Color3.fromRGB(80, 82, 100),
		Transparency = .8,
		Thickness = 1
	})

	navButtons[name] = button

	button.MouseButton1Click:Connect(function()
		showPage(name)
	end)

	button.MouseEnter:Connect(function()

		if buttonName ~= name then
			tween(button, .15, {
				BackgroundTransparency = .2
			})
		end

	end)

end

local Profile = new("Frame", {
	Parent = Sidebar,
	Position = UDim2.new(0, 0, 1, -70),
	Size = UDim2.new(1, 0, 0, 60),
	BackgroundColor3 = Color3.fromRGB(28, 30, 40),
	BackgroundTransparency = .25,
	BorderSizePixel = 0
})

new("UICorner", {
	Parent = Profile,
	CornerRadius = UDim.new(0, 12)
})

new("UIStroke", {
	Parent = Profile,
	Color = Color3.fromRGB(95, 80, 145),
	Transparency = .65
})

local Avatar = new("ImageLabel", {
	Parent = Profile,
	Position = UDim2.fromOffset(10, 10),
	Size = UDim2.fromOffset(40, 40),
	BackgroundTransparency = 1,
	Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
		.. Player.UserId
		.. "&width=420&height=420&format=png"
})

new("UICorner", {
	Parent = Avatar,
	CornerRadius = UDim.new(1, 0)
})

new("TextLabel", {
	Parent = Profile,
	Position = UDim2.fromOffset(60, 10),
	Size = UDim2.new(1, -70, 0, 22),
	BackgroundTransparency = 1,
	Text = Player.DisplayName,
	TextColor3 = Color3.fromRGB(240, 240, 245),
	Font = Enum.Font.GothamSemibold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left
})

new("TextLabel", {
	Parent = Profile,
	Position = UDim2.fromOffset(60, 32),
	Size = UDim2.new(1, -70, 0, 18),
	BackgroundTransparency = 1,
	Text = "Premium",
	TextColor3 = Color3.fromRGB(155, 105, 255),
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left
})

function startFly()

	if FlyConnection then
		FlyConnection:Disconnect()
	end

	if not Root then
		updateCharacter()
	end

	FlyVelocity = Instance.new("BodyVelocity")
	FlyVelocity.MaxForce = Vector3.new(
		math.huge,
		math.huge,
		math.huge
	)
	FlyVelocity.Velocity = Vector3.zero
	FlyVelocity.Parent = Root

	FlyGyro = Instance.new("BodyGyro")
	FlyGyro.MaxTorque = Vector3.new(
		math.huge,
		math.huge,
		math.huge
	)
	FlyGyro.P = 10000
	FlyGyro.Parent = Root

	FlyConnection = RunService.RenderStepped:Connect(function()

		if not FlyEnabled or not Root then
			return
		end

		local Camera = workspace.CurrentCamera
		local Direction = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			Direction += Camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			Direction -= Camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			Direction -= Camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			Direction += Camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			Direction += Vector3.yAxis
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			Direction -= Vector3.yAxis
		end

		if Direction.Magnitude > 0 then
			Direction = Direction.Unit * FlySpeed
		end

		FlyVelocity.Velocity = Direction
		FlyGyro.CFrame = Camera.CFrame

	end)
end

function stopFly()

	FlyEnabled = false

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

UserInputService.InputBegan:Connect(function(input, processed)

	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.Space
		and InfiniteJump
		and Humanoid then

		Humanoid:ChangeState(
			Enum.HumanoidStateType.Jumping
		)

	end

end)

RunService.Stepped:Connect(function()

	if not Character or not NoclipEnabled then
		return
	end

	for _, part in ipairs(Character:GetDescendants()) do

		if part:IsA("BasePart") then
			part.CanCollide = false
		end

	end

end)

Close.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

local minimized = false

Minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		tween(Main, .25, {
			Size = UDim2.fromOffset(1050, 100)
		})

		Sidebar.Visible = false
		Content.Visible = false
		Divider.Visible = false

	else

		tween(Main, .25, {
			Size = UDim2.fromOffset(1050, 680)
		})

		task.wait(.15)

		Sidebar.Visible = true
		Content.Visible = true
		Divider.Visible = true

	end

end)

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

	end

end)

Header.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
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

showPage("Movement")
