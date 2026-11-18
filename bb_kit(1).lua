--[[
    BB-Kit — Bomb Battle control + remote inspector
    self-contained UI (no external loadstring)
    1) Remote spy: logs every RemoteEvent/RemoteFunction fire with args
    2) Remote fire panel: replay any remote with custom args
    3) Target system: type a name or cycle < player > arrows
    4) Auto pass bomb to selected player + auto-refire saved remote
    5) Movement: fly / speed / noclip / infinite jump / tap-TP
    6) ESP: players + bomb carrier
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local S = {
    spy=false, autopass=false, autorefire=false, espP=false, espB=false,
    fly=false, speed=false, noclip=false, infjump=false, tptap=false,
}
local CFG = { FlySpeed = 60, WalkSpeed = 50 }
local Target = nil
local SavedAuto = nil -- {name=, raw=, method=}

--=========================================================
-- utils
--=========================================================
local function resolvePlayer(name)
    if not name then return nil end
    name = tostring(name):gsub("^%s*(.-)%s*$", "%1"):lower()
    if name == "" then return nil end
    if name == "me" then return LP end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == name or p.DisplayName:lower() == name then return p end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then return p end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(name, 1, true) or p.DisplayName:lower():find(name, 1, true) then return p end
    end
    return nil
end

local function formatValue(v, depth)
    depth = depth or 0
    local t = typeof(v)
    if t == "string" then return string.format("%q", v) end
    if t == "number" or t == "boolean" then return tostring(v) end
    if t == "Instance" then return v:GetFullName() end
    if t == "Vector3" then return ("Vector3.new(%s, %s, %s)"):format(v.X, v.Y, v.Z) end
    if t == "CFrame" then
        local p = v.Position
        return ("CFrame.new(%s, %s, %s)"):format(p.X, p.Y, p.Z)
    end
    if t == "Color3" then return ("Color3.fromRGB(%d, %d, %d)"):format(v.R*255, v.G*255, v.B*255) end
    if t == "EnumItem" then return tostring(v) end
    if t == "table" and depth < 2 then
        local parts = {}
        for k, val in pairs(v) do
            if #parts >= 8 then parts[#parts+1] = "..." break end
            if type(k) == "number" then
                parts[#parts+1] = formatValue(val, depth + 1)
            else
                parts[#parts+1] = "[" .. tostring(k) .. "]=" .. formatValue(val, depth + 1)
            end
        end
        return "{ " .. table.concat(parts, ", ") .. " }"
    end
    return tostring(v)
end

local function bombInCharacter(char)
    for _, d in ipairs(char:GetChildren()) do
        local n = d.Name:lower()
        if (d:IsA("Tool") or d:IsA("Accessory") or d:IsA("BasePart"))
            and (n:find("bomb") or d.Name:find("قنبلة")) then
            return d
        end
    end
    return nil
end

local function findBombHolder()
    for _, p in ipairs(Players:GetPlayers()) do
        local c = p.Character
        if c and bombInCharacter(c) then return p end
    end
    return nil
end

local function findRemote(name)
    if not name then return nil end
    name = tostring(name):gsub("^%s*(.-)%s*$", "%1")
    for _, inst in ipairs(game:GetDescendants()) do
        if (inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")) and inst.Name == name then
            return inst
        end
    end
    return nil
end

local function parseArgs(str)
    local args = {}
    if not str then return args end
    for token in tostring(str):gmatch("%S+") do
        local plName = token:match("^player:(.+)$")
        local chName = token:match("^char:(.+)$")
        if token == "plr" then
            args[#args+1] = Target
        elseif token == "char" then
            args[#args+1] = Target and Target.Character or nil
        elseif plName then
            args[#args+1] = resolvePlayer(plName)
        elseif chName then
            local p = resolvePlayer(chName)
            args[#args+1] = p and p.Character or nil
        elseif token == "true" then
            args[#args+1] = true
        elseif token == "false" then
            args[#args+1] = false
        elseif token == "nil" then
            -- keep sequence, skip
        else
            local quoted = token:match('^"(.*)"$') or token:match("^'(.*)'$")
            if quoted then
                args[#args+1] = quoted
            else
                local n = tonumber(token)
                args[#args+1] = n ~= nil and n or token
            end
        end
    end
    return args
end

--=========================================================
-- UI
--=========================================================
local gui = Instance.new("ScreenGui")
gui.Name = "BBKit"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

local function corner(r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    return c
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(340, 452)
main.Position = UDim2.new(0.5, -170, 0.4, -180)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
main:AddChild(corner(8))

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
topBar.BorderSizePixel = 0
topBar.Parent = main
topBar:AddChild(corner(8))

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "BB-Kit  |  حرب القنابل"
title.TextColor3 = Color3.fromRGB(255, 120, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.fromOffset(24, 24)
hideBtn.Position = UDim2.new(1, -27, 0, 3)
hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14
hideBtn.Text = "-"
hideBtn.BorderSizePixel = 0
hideBtn.Parent = topBar
hideBtn:AddChild(corner(6))

local tabRow = Instance.new("Frame")
tabRow.Size = UDim2.new(1, -16, 0, 26)
tabRow.Position = UDim2.fromOffset(8, 34)
tabRow.BackgroundTransparency = 1
tabRow.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabRow

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -16, 1, -70)
content.Position = UDim2.fromOffset(8, 64)
content.BackgroundTransparency = 1
content.Parent = main

local ACCENT = Color3.fromRGB(255, 110, 40)

local function mkPage(order)
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ScrollBarThickness = 4
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Visible = false
    f.LayoutOrder = order
    f.Parent = content
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = f
    return f
end

local pages = {}
local tabDefs = { {"Main", 1}, {"Target", 2}, {"Remotes", 3}, {"Move", 4} }
for i, def in ipairs(tabDefs) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.25, -3, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = def[1]
    b.LayoutOrder = i
    b.BorderSizePixel = 0
    b.Parent = tabRow
    b:AddChild(corner(6))
    pages[i] = { btn = b, frame = mkPage(i) }
end

local function showPage(idx)
    for i, p in ipairs(pages) do
        p.frame.Visible = (i == idx)
        p.btn.BackgroundColor3 = (i == idx) and ACCENT or Color3.fromRGB(35, 35, 42)
    end
end
for i, p in ipairs(pages) do
    p.btn.MouseButton1Click:Connect(function() showPage(i) end)
end

local uiOrder = 0
local function mkBtn(parent, text)
    uiOrder = uiOrder + 1
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Text = text
    b.BorderSizePixel = 0
    b.LayoutOrder = uiOrder
    b.Parent = parent
    b:AddChild(corner(6))
    return b
end

local function mkToggle(parent, text, default, cb)
    local b = mkBtn(parent, "")
    local state = default and true or false
    local function paint()
        b.Text = (state and "[ON]  " or "[OFF] ") .. text
        b.BackgroundColor3 = state and Color3.fromRGB(35, 130, 70) or Color3.fromRGB(32, 32, 40)
    end
    b.MouseButton1Click:Connect(function()
        state = not state
        paint()
        cb(state)
    end)
    paint()
    return b
end

local function mkBox(parent, placeholder, text)
    uiOrder = uiOrder + 1
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1, -8, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.PlaceholderText = placeholder
    b.Text = text or ""
    b.ClearTextOnFocus = false
    b.BorderSizePixel = 0
    b.LayoutOrder = uiOrder
    b.Parent = parent
    b:AddChild(corner(6))
    return b
end

local function mkLabel(parent, text, color)
    uiOrder = uiOrder + 1
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, 20)
    l.BackgroundTransparency = 1
    l.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.Text = text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = uiOrder
    l.Parent = parent
    return l
end

--=========================================================
-- log (remotes tab)
--=========================================================
local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -8, 0, 150)
logScroll.BackgroundColor3 = Color3.fromRGB(10, 12, 10)
logScroll.BorderSizePixel = 0
logScroll.ScrollBarThickness = 4
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.LayoutOrder = 2
logScroll.Parent = pages[3].frame
logScroll:AddChild(corner(6))

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 1)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Parent = logScroll

local logLabels = {}
local function pushLog(line)
    local maxw = math.max(80, logScroll.AbsoluteSize.X - 16)
    local sz = TextService:GetTextSize(line, 12, Enum.Font.Code, Vector2.new(maxw, 10000))
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(180, 255, 180)
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.TextWrapped = true
    l.Size = UDim2.new(1, -10, 0, sz.Y + 3)
    l.Text = line
    l.LayoutOrder = #logLabels
    l.Parent = logScroll
    logLabels[#logLabels + 1] = l
    if #logLabels > 180 then
        table.remove(logLabels, 1):Destroy()
        for i, lab in ipairs(logLabels) do lab.LayoutOrder = i - 1 end
    end
    task.defer(function()
        logScroll.CanvasPosition = Vector2.new(0, 999999)
    end)
end

--=========================================================
-- remote spy hooks
--=========================================================
local function logRemote(method, remote, args)
    if not S.spy then return end
    local n = args.n or #args
    local parts = {}
    for i = 1, math.min(n, 12) do
        parts[#parts + 1] = formatValue(args[i], 1)
    end
    if n > 12 then parts[#parts + 1] = "..." end
    pushLog(("[%s] %s:%s(%s)"):format(remote.ClassName, remote:GetFullName(), method, table.concat(parts, ", ")))
end

local spyStatus = "spy: not hooked"
do
    local okNC = false
    if hookmetamethod and getnamecallmethod then
        local ok, oldNC = pcall(function()
            return hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" or method == "InvokeServer" then
                    if typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                        logRemote(method, self, table.pack(...))
                    end
                end
                return oldNC(self, ...)
            end)
        end)
        okNC = ok
    end
    local okFN = false
    if hookfunction then
        local ok1 = pcall(function()
            local tmp = Instance.new("RemoteEvent")
            local oldFire = hookfunction(tmp.FireServer, function(self, ...)
                if typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                    logRemote("FireServer", self, table.pack(...))
                end
                return oldFire(self, ...)
            end)
            tmp:Destroy()
        end)
        local ok2 = pcall(function()
            local tmp = Instance.new("RemoteFunction")
            local oldInv = hookfunction(tmp.InvokeServer, function(self, ...)
                if typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                    logRemote("InvokeServer", self, table.pack(...))
                end
                return oldInv(self, ...)
            end)
            tmp:Destroy()
        end)
        okFN = ok1 or ok2
    end
    if okNC or okFN then
        spyStatus = "spy: hooked"
    else
        spyStatus = "spy: executor has no hookmetamethod/hookfunction"
    end
end

--=========================================================
-- remote firing
--=========================================================
local function doFire(remote, args, method, quiet)
    if not remote then return false end
    if method == "Invoke" then
        local ok, ret = pcall(function() return remote:InvokeServer(unpack(args)) end)
        if not quiet then
            pushLog(ok and ("invoke ok -> " .. formatValue(ret, 1)) or ("invoke ERR: " .. tostring(ret)))
        end
        return ok
    end
    local ok, err = pcall(function() remote:FireServer(unpack(args)) end)
    if not quiet then
        pushLog(ok and ("fired: " .. remote:GetFullName()) or ("fire ERR: " .. tostring(err)))
    end
    return ok
end

--=========================================================
-- MAIN page
--=========================================================
local mainP = pages[1].frame
local bombStatus = mkLabel(mainP, "bomb status: -", Color3.fromRGB(255, 200, 120))
local targetLbl = mkLabel(mainP, "target: -", Color3.fromRGB(140, 220, 255))

mkToggle(mainP, "Auto Pass Bomb (click target)", false, function(v) S.autopass = v end)
mkToggle(mainP, "Auto Refire Saved Remote", false, function(v) S.autorefire = v end)
local savedLbl = mkLabel(mainP, "auto remote: none", Color3.fromRGB(180, 180, 180))

local passNow = mkBtn(mainP, "Pass Bomb NOW (once)")
local tpBtn = mkBtn(mainP, "TP to Target")
local specBtn = mkBtn(mainP, "Spectate Target")

mkToggle(mainP, "ESP Players", false, function(v) S.espP = v end)
mkToggle(mainP, "ESP Bomb Carrier", false, function(v) S.espB = v end)

--=========================================================
-- TARGET page
--=========================================================
local tgtP = pages[2].frame
local nameBox = mkBox(tgtP, "player name (partial ok) / me", "")
local setBtn = mkBtn(tgtP, "Set Target")
mkLabel(tgtP, "or cycle:", Color3.fromRGB(160, 160, 160))

local cycleRow = Instance.new("Frame")
cycleRow.Size = UDim2.new(1, -8, 0, 34)
cycleRow.BackgroundTransparency = 1
cycleRow.LayoutOrder = uiOrder + 1
uiOrder = uiOrder + 1
cycleRow.Parent = tgtP

local prevB = Instance.new("TextButton")
prevB.Size = UDim2.fromOffset(44, 34)
prevB.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
prevB.TextColor3 = Color3.new(1, 1, 1)
prevB.Font = Enum.Font.GothamBold
prevB.TextSize = 20
prevB.Text = "<"
prevB.BorderSizePixel = 0
prevB.Parent = cycleRow
prevB:AddChild(corner(6))

local cycleName = Instance.new("TextLabel")
cycleName.Size = UDim2.new(1, -96, 1, 0)
cycleName.Position = UDim2.fromOffset(48, 0)
cycleName.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
cycleName.TextColor3 = Color3.new(1, 1, 1)
cycleName.Font = Enum.Font.GothamBold
cycleName.TextSize = 13
cycleName.Text = "-"
cycleName.BorderSizePixel = 0
cycleName.Parent = cycleRow
cycleName:AddChild(corner(6))

local nextB = Instance.new("TextButton")
nextB.Size = UDim2.fromOffset(44, 34)
nextB.Position = UDim2.new(1, -44, 0, 0)
nextB.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
nextB.TextColor3 = Color3.new(1, 1, 1)
nextB.Font = Enum.Font.GothamBold
nextB.TextSize = 20
nextB.Text = ">"
nextB.BorderSizePixel = 0
nextB.Parent = cycleRow
nextB:AddChild(corner(6))

--=========================================================
-- REMOTES page
--=========================================================
local remP = pages[3].frame
mkLabel(remP, spyStatus, Color3.fromRGB(255, 200, 120))
local clearB = mkBtn(remP, "Clear Log")
local copyB = mkBtn(remP, "Copy Log to Clipboard")
mkLabel(remP, "remote name:", Color3.fromRGB(160, 160, 160))
local remBox = mkBox(remP, "exact remote name (from log)", "")
mkLabel(remP, 'args: player:NAME char:NAME plr char "text" 123 true', Color3.fromRGB(160, 160, 160))
local argBox = mkBox(remP, 'e.g.  player:TARGETNAME "hello" 5', "")
local fireB = mkBtn(remP, "FireServer")
local invB = mkBtn(remP, "InvokeServer")
local saveAutoB = mkBtn(remP, "Save as Auto-Pass Remote")

--=========================================================
-- MOVE page
--=========================================================
local movP = pages[4].frame
local speedBox = mkBox(movP, "walk speed", tostring(CFG.WalkSpeed))
mkToggle(movP, "Speed", false, function(v) S.speed = v end)
local flyBox = mkBox(movP, "fly speed (E/Q or Space/Ctrl up-down)", tostring(CFG.FlySpeed))
mkToggle(movP, "Fly", false, function(v) setFly(v) end)
mkToggle(movP, "Noclip", false, function(v) S.noclip = v end)
mkToggle(movP, "Infinite Jump", false, function(v) S.infjump = v end)
mkToggle(movP, "Tap / Click TP", false, function(v) S.tptap = v end)
mkLabel(movP, "move the window by dragging the top bar", Color3.fromRGB(140, 140, 140))

--=========================================================
-- movement implementation
--=========================================================
local flyBV, flyBG = nil, nil
local flyUp, flyDown = false, false

local function flyStep()
    if flyBG and flyBG.Parent then flyBG.CFrame = Camera.CFrame end
    if flyBV and flyBV.Parent then
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        local dir = hum and hum.MoveDirection or Vector3.zero
        local v = dir * CFG.FlySpeed
        if flyUp then v = v + Vector3.new(0, CFG.FlySpeed, 0) end
        if flyDown then v = v - Vector3.new(0, CFG.FlySpeed, 0) end
        flyBV.Velocity = v
    end
end

function setFly(on)
    if on == S.fly then return end
    S.fly = on and true or false
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if S.fly then
        if not hrp then S.fly = false return end
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.P = 9e4
        flyBG.CFrame = hrp.CFrame
        flyBG.Parent = hrp
        RunService:BindToRenderStep("bbk_fly", Enum.RenderPriority.Character.Value + 1, flyStep)
    else
        pcall(function() RunService:UnbindFromRenderStep("bbk_fly") end)
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Space then flyUp = true end
    if input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.LeftControl then flyDown = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Space then flyUp = false end
    if input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.LeftControl then flyDown = false end
end)

RunService.Heartbeat:Connect(function(dt)
    if S.speed then
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + hum.MoveDirection.Unit * CFG.WalkSpeed * dt
        end
    end
end)

RunService.Stepped:Connect(function()
    if not S.noclip then return end
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not S.infjump then return end
    local c = LP.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

local function tpTo(pos)
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not S.tptap or gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = LP:GetMouse()
        if m and m.Hit then tpTo(m.Hit.Position) end
    end
end)
UserInputService.TouchTap:Connect(function(pos)
    if not S.tptap then return end
    local ray = Camera:ScreenPointToRay(pos.X, pos.Y)
    local rc = Workspace:Raycast(ray.Origin, ray.Direction * 800)
    if rc then tpTo(rc.Position) end
end)

-- anti afk
LP.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--=========================================================
-- ESP
--=========================================================
local charHL = {}
local bombHL = nil
local function refreshESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local want = S.espP and p.Character or nil
            local h = charHL[p]
            if want then
                if not (h and h.Parent and h.Adornee == want) then
                    if h then h:Destroy() end
                    h = Instance.new("Highlight")
                    h.FillTransparency = 0.65
                    h.FillColor = Color3.fromRGB(255, 70, 60)
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.Adornee = want
                    h.Parent = gui
                    charHL[p] = h
                end
            elseif h then
                h:Destroy()
                charHL[p] = nil
            end
        end
    end
    local holder = S.espB and findBombHolder() or nil
    local bomb = holder and holder.Character and bombInCharacter(holder.Character)
    if bomb then
        local adornee = bomb:IsA("BasePart") and bomb or bomb:FindFirstChildWhichIsA("BasePart") or bomb
        if not (bombHL and bombHL.Parent) then
            bombHL = Instance.new("Highlight")
            bombHL.FillTransparency = 0.4
            bombHL.FillColor = Color3.fromRGB(255, 230, 40)
            bombHL.OutlineColor = Color3.fromRGB(255, 120, 0)
            bombHL.Parent = gui
        end
        bombHL.Adornee = adornee
    elseif bombHL then
        bombHL:Destroy()
        bombHL = nil
    end
end

Players.PlayerRemoving:Connect(function(p)
    if charHL[p] then charHL[p]:Destroy() charHL[p] = nil end
end)

--=========================================================
-- target logic
--=========================================================
local function setTarget(p)
    Target = p
    targetLbl.Text = "target: " .. (p and (p.DisplayName .. " @" .. p.Name) or "-")
    cycleName.Text = p and p.Name or "-"
end

local function cycleTarget(dir)
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then list[#list + 1] = p end
    end
    if #list == 0 then return end
    local idx = 1
    for i, p in ipairs(list) do
        if p == Target then idx = i break end
    end
    idx = ((idx - 1 + dir) % #list) + 1
    setTarget(list[idx])
end

prevB.MouseButton1Click:Connect(function() cycleTarget(-1) end)
nextB.MouseButton1Click:Connect(function() cycleTarget(1) end)
setBtn.MouseButton1Click:Connect(function()
    local p = resolvePlayer(nameBox.Text)
    if p then
        setTarget(p)
    else
        targetLbl.Text = "target: not found: " .. nameBox.Text
    end
end)

--=========================================================
-- bomb pass + status loop
--=========================================================
local VIM = game:GetService("VirtualInputManager")
local function clickAtWorld(pos)
    local sp, onScreen = Camera:WorldToViewportPoint(pos)
    if not onScreen then return false end
    VIM:SendMouseButtonEvent(sp.X, sp.Y, 0, true, game, 1)
    task.wait(0.04)
    VIM:SendMouseButtonEvent(sp.X, sp.Y, 0, false, game, 1)
    return true
end

local function passBombOnce()
    if not (Target and Target.Character) then pushLog("no target set") return end
    local part = Target.Character:FindFirstChild("Head") or Target.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end
    local ok = clickAtWorld(part.Position)
    pushLog(ok and ("pass click -> " .. Target.Name) or "target off-screen, aim camera at them")
end

passNow.MouseButton1Click:Connect(passBombOnce)

tpBtn.MouseButton1Click:Connect(function()
    if not (Target and Target.Character) then return end
    local hrp = Target.Character:FindFirstChild("HumanoidRootPart")
    if hrp then tpTo(hrp.Position) end
end)

local specOn = false
specBtn.MouseButton1Click:Connect(function()
    specOn = not specOn
    if specOn and Target and Target.Character then
        local hum = Target.Character:FindFirstChildOfClass("Humanoid")
        if hum then Camera.CameraSubject = hum end
    else
        specOn = false
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then Camera.CameraSubject = hum end
    end
end)

-- config boxes
speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)
    if n and n > 0 then CFG.WalkSpeed = n end
end)
flyBox.FocusLost:Connect(function()
    local n = tonumber(flyBox.Text)
    if n and n > 0 then CFG.FlySpeed = n end
end)

-- remotes page buttons
clearB.MouseButton1Click:Connect(function()
    for _, l in ipairs(logLabels) do l:Destroy() end
    table.clear(logLabels)
end)
copyB.MouseButton1Click:Connect(function()
    if setclipboard then
        local t = {}
        for _, l in ipairs(logLabels) do t[#t + 1] = l.Text end
        setclipboard(table.concat(t, "\n"))
        pushLog("log copied")
    else
        pushLog("setclipboard not supported here")
    end
end)
fireB.MouseButton1Click:Connect(function()
    local r = findRemote(remBox.Text)
    if not r then pushLog("remote not found: " .. remBox.Text) return end
    doFire(r, parseArgs(argBox.Text), "Fire")
end)
invB.MouseButton1Click:Connect(function()
    local r = findRemote(remBox.Text)
    if not r then pushLog("remote not found: " .. remBox.Text) return end
    doFire(r, parseArgs(argBox.Text), "Invoke")
end)
saveAutoB.MouseButton1Click:Connect(function()
    if remBox.Text == "" then pushLog("type a remote name first") return end
    SavedAuto = { name = remBox.Text, raw = argBox.Text, method = "Fire" }
    savedLbl.Text = "auto remote: " .. SavedAuto.name
    pushLog("auto-pass remote saved: " .. SavedAuto.name .. " | " .. SavedAuto.raw)
end)

-- main loop: status + auto pass + auto refire + esp
task.spawn(function()
    while true do
        task.wait(0.15)
        local holder = findBombHolder()
        bombStatus.Text = "bomb status: " .. (holder and (holder == LP and "YOU" or holder.Name) or "-")
        refreshESP()

        if holder == LP and Target and Target.Character then
            if S.autopass then
                local part = Target.Character:FindFirstChild("Head") or Target.Character:FindFirstChild("HumanoidRootPart")
                if part then clickAtWorld(part.Position) end
            end
            if S.autorefire and SavedAuto then
                local r = findRemote(SavedAuto.name)
                if r then doFire(r, parseArgs(SavedAuto.raw), SavedAuto.method, true) end
            end
        end
    end
end)

-- respawn: restore fly if it was on
LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 5)
    if S.fly then
        S.fly = false
        setFly(true)
    end
    if specOn then
        specOn = false
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then Camera.CameraSubject = hum end
    end
end)

-- hide button
local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    content.Visible = not hidden
    tabRow.Visible = not hidden
    if not hidden then showPage(1) end
    main.Size = hidden and UDim2.fromOffset(340, 30) or UDim2.fromOffset(340, 452)
    hideBtn.Text = hidden and "+" or "-"
end)

-- drag
do
    local dragging = false
    local dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

showPage(1)
pushLog("BB-Kit loaded. open Remotes tab, turn spy ON,")
pushLog("then pass the bomb once normally to catch the remote.")
