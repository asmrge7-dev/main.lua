-- ╔══════════════════════════════════════╗
-- ║   beka | TROLL HUG TOWER SCRIPT     ║
-- ║  Verified - Delta Compatible         ║
-- ╚══════════════════════════════════════╝

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local TweenService= game:GetService("TweenService")

local LP   = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

-- ─── تنظيف نسخ قديمة ─────────────────────────────────────────────────────────
pcall(function()
    for _, v in pairs(PGui:GetChildren()) do
        if v.Name == "BekaHugTower" then v:Destroy() end
    end
end)

-- ─── حالات ───────────────────────────────────────────────────────────────────
local autoKill   = false
local antiShrink = false
local antiGrab   = false
local killCD     = false
local origScales = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- KILL SELF — 5 طرق بنفس اللحظة (void أول شي لأنه يتجاوز health lock)
-- ═══════════════════════════════════════════════════════════════════════════════
local function killSelf()
    if killCD then return end
    killCD = true

    local char = LP.Character
    if not char then killCD = false return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    -- 1. تحت FallenPartsDestroyHeight مباشرة (الأقوى - يتجاوز health protection)
    pcall(function()
        if hrp then
            local killFloor = workspace.FallenPartsDestroyHeight
            hrp.CFrame = CFrame.new(hrp.Position.X, killFloor - 300, hrp.Position.Z)
        end
    end)
    -- 2. void مطلق
    pcall(function()
        if hrp then hrp.CFrame = CFrame.new(0, -99999, 0) end
    end)
    -- 3. سرعة سالبة ضخمة
    pcall(function()
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, -99999, 0) end
    end)
    -- 4. تدمير كل Motor6D = ragdoll فوري
    pcall(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Motor6D") then pcall(function() v.Part0 = nil end) end
        end
    end)
    -- 5. Humanoid state = Dead
    pcall(function()
        if hum then
            hum.Health = 0
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end)

    task.wait(3)
    killCD = false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LAVA KILL — يرسل الهدف تحت البراكين
-- ═══════════════════════════════════════════════════════════════════════════════
local function lavaKill(plr)
    if not plr or not plr.Character then return end
    local char = plr.Character
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChild("Humanoid")

    pcall(function()
        if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -99999, hrp.Position.Z) end
    end)
    pcall(function()
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, -99999, 0) end
    end)
    pcall(function()
        if hum then hum.Health = 0 end
    end)
    pcall(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Motor6D") then pcall(function() v.Part0 = nil end) end
        end
    end)
    pcall(function()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PULL TO ME
-- ═══════════════════════════════════════════════════════════════════════════════
local function pullToMe(plr)
    local myChar = LP.Character
    if not myChar or not plr or not plr.Character then return end
    local myHRP    = myChar:FindFirstChild("HumanoidRootPart")
    local theirHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not theirHRP then return end
    pcall(function()
        theirHRP.CFrame = myHRP.CFrame * CFrame.new(2, 0, 0)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIND PLAYER (partial name match)
-- ═══════════════════════════════════════════════════════════════════════════════
local function findPlayer(name)
    -- FIX: empty box لا يرجع أول لاعب
    if not name or name == "" then return nil end
    name = name:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Name:lower():find(name, 1, true) then
            return p
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ANTI-SHRINK
-- ═══════════════════════════════════════════════════════════════════════════════
local SCALE_NAMES = {
    "BodyWidthScale","BodyHeightScale","BodyDepthScale",
    "HeadScale","BodyProportionScale"
}

local function saveScales()
    origScales = {}
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    for _, sn in pairs(SCALE_NAMES) do
        local sv = hum:FindFirstChild(sn)
        if sv then origScales[sn] = sv.Value end
    end
end

local function resetScales()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    for sn, val in pairs(origScales) do
        local sv = hum:FindFirstChild(sn)
        if sv and sv.Value < val - 0.02 then
            pcall(function() sv.Value = val end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- GRAB DETECTION — 3 طرق
-- ═══════════════════════════════════════════════════════════════════════════════
local function isGrabbed()
    local char = LP.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- طريقة 1: Weld خارجي على شخصيتي
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("WeldConstraint") or (v:IsA("Weld") and v.Name ~= "RootJoint") then
            local ok, p0, p1 = pcall(function()
                return v.Part0, v.Part1
            end)
            if ok and p0 and p1 then
                local ok2, mine0 = pcall(function() return p0:IsDescendantOf(char) end)
                local ok3, mine1 = pcall(function() return p1:IsDescendantOf(char) end)
                if not ok2 then mine0 = false end
                if not ok3 then mine1 = false end
                if mine0 ~= mine1 then return true end
            end
        end
    end

    -- طريقة 2: لاعب ملاصق جداً (< 2.5 ستد)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if tHRP and (tHRP.Position - hrp.Position).Magnitude < 2.5 then
                return true
            end
        end
    end

    -- طريقة 3: Humanoid.Sit (بعض الألعاب تعمل grab عن طريق sit)
    local hum = char:FindFirstChild("Humanoid")
    if hum and hum.Sit then return true end

    return false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ANTI-GRAB — يدمر أي Weld جديد يجي على شخصيتك
-- ═══════════════════════════════════════════════════════════════════════════════
local function setupAntiGrab(char)
    if not char then return end
    char.DescendantAdded:Connect(function(d)
        if not antiGrab then return end
        -- FIX: pcall كامل لأن d ممكن يتدمر قبل ما نوصله
        task.wait(0.02)
        pcall(function()
            if not d.Parent then return end
            if d:IsA("WeldConstraint") or (d:IsA("Weld") and d.Name ~= "RootJoint") then
                local p0, p1 = d.Part0, d.Part1
                if p0 and p1 then
                    local mine0 = pcall(function() return p0:IsDescendantOf(char) end)
                    local mine1 = pcall(function() return p1:IsDescendantOf(char) end)
                    -- إذا واحد منهم خارج شخصيتي → دمر الوِلد
                    d:Destroy()
                end
            end
        end)
    end)
end

-- إعداد عند الـ spawn
LP.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    saveScales()
    setupAntiGrab(char)
end)
if LP.Character then
    saveScales()
    setupAntiGrab(LP.Character)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui")
sg.Name           = "BekaHugTower"
sg.ResetOnSpawn   = false
sg.DisplayOrder   = 9999
sg.IgnoreGuiInset = true
sg.Parent         = PGui

local main = Instance.new("Frame")
main.Name                   = "Main"
main.Size                   = UDim2.new(0, 230, 0, 320)
main.Position               = UDim2.new(0, 15, 0.15, 0)
main.BackgroundColor3       = Color3.fromRGB(10, 10, 10)
main.BackgroundTransparency = 0
main.BorderSizePixel        = 0
main.Active                 = true
main.Parent                 = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mStroke = Instance.new("UIStroke", main)
mStroke.Color     = Color3.fromRGB(200, 0, 0)
mStroke.Thickness = 2

-- Title bar
local tbar = Instance.new("Frame")
tbar.Size             = UDim2.new(1, 0, 0, 32)
tbar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
tbar.BorderSizePixel  = 0
tbar.Parent           = main
Instance.new("UICorner", tbar).CornerRadius = UDim.new(0, 12)
local tbfix = Instance.new("Frame")
tbfix.Size             = UDim2.new(1, 0, 0, 14)
tbfix.Position         = UDim2.new(0, 0, 1, -14)
tbfix.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
tbfix.BorderSizePixel  = 0
tbfix.Parent           = tbar

local tlbl = Instance.new("TextLabel")
tlbl.Size                   = UDim2.new(1, -35, 1, 0)
tlbl.Position               = UDim2.new(0, 10, 0, 0)
tlbl.BackgroundTransparency = 1
tlbl.Text                   = "🌋 beka | Hug Tower"
tlbl.TextColor3             = Color3.new(1,1,1)
tlbl.Font                   = Enum.Font.GothamBold
tlbl.TextSize               = 13
tlbl.TextXAlignment         = Enum.TextXAlignment.Left
tlbl.Parent                 = tbar

local closeB = Instance.new("TextButton")
closeB.Size             = UDim2.new(0, 22, 0, 22)
closeB.Position         = UDim2.new(1, -26, 0, 5)
closeB.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeB.TextColor3       = Color3.new(1,1,1)
closeB.Font             = Enum.Font.GothamBold
closeB.TextSize         = 14
closeB.Text             = "×"
closeB.BorderSizePixel  = 0
closeB.Parent           = tbar
Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, 6)
closeB.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Drag
local drag, dragInp, dragSt, dragPos
tbar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragSt  = i.Position
        dragPos = main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then drag = false end
        end)
    end
end)
tbar.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or
       i.UserInputType == Enum.UserInputType.Touch then dragInp = i end
end)
UIS.InputChanged:Connect(function(i)
    if i == dragInp and drag then
        local d = i.Position - dragSt
        main.Position = UDim2.new(
            dragPos.X.Scale, dragPos.X.Offset + d.X,
            dragPos.Y.Scale, dragPos.Y.Offset + d.Y
        )
    end
end)

-- Status bar
local statusLbl = Instance.new("TextLabel")
statusLbl.Size                   = UDim2.new(1, -20, 0, 18)
statusLbl.Position               = UDim2.new(0, 10, 0, 36)
statusLbl.BackgroundTransparency = 1
statusLbl.Text                   = "⚪ جاهز"
statusLbl.TextColor3             = Color3.fromRGB(130, 130, 130)
statusLbl.Font                   = Enum.Font.Gotham
statusLbl.TextSize               = 11
statusLbl.TextXAlignment         = Enum.TextXAlignment.Center
statusLbl.Parent                 = main

local function setStatus(txt, color)
    statusLbl.Text       = txt
    statusLbl.TextColor3 = color or Color3.fromRGB(130, 130, 130)
end

-- ─── Toggle builder ──────────────────────────────────────────────────────────
local function makeToggle(yOff, labelTxt, callback)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, -20, 0, 34)
    f.Position         = UDim2.new(0, 10, 0, yOff)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    f.BorderSizePixel  = 0
    f.Parent           = main
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(0.72, 0, 1, 0)
    lbl.Position               = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = labelTxt
    lbl.TextColor3             = Color3.fromRGB(220, 220, 220)
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 12
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Parent                 = f

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 52, 0, 22)
    btn.Position         = UDim2.new(1, -60, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3       = Color3.new(1,1,1)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 11
    btn.Text             = "OFF"
    btn.BorderSizePixel  = 0
    btn.Parent           = f
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text             = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(70, 70, 70)
        callback(state)
    end)
end

-- ─── Action button builder ───────────────────────────────────────────────────
local function makeBtn(yOff, txt, color, callback)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(1, -20, 0, 32)
    b.Position         = UDim2.new(0, 10, 0, yOff)
    b.BackgroundColor3 = color
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 13
    b.Text             = txt
    b.BorderSizePixel  = 0
    b.Parent           = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    local origColor = color
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(
                math.min(origColor.R*1.4,1),
                math.min(origColor.G*1.4,1),
                math.min(origColor.B*1.4,1))
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = origColor}):Play()
    end)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- ─── Toggles ─────────────────────────────────────────────────────────────────
makeToggle(60, "💀 موت عند الامساك", function(s)
    autoKill = s
    setStatus(s and "⚡ مراقبة الامساك..." or "⚪ جاهز",
              s and Color3.fromRGB(255, 80, 80) or nil)
end)

makeToggle(100, "🔒 مانع الكمش", function(s)
    antiShrink = s
    if s then saveScales() end
    setStatus(s and "🔒 مانع الكمش شغال" or "⚪ جاهز",
              s and Color3.fromRGB(100, 200, 255) or nil)
end)

makeToggle(140, "🛡️ مانع الامساك", function(s)
    antiGrab = s
    setStatus(s and "🛡️ مانع الامساك شغال" or "⚪ جاهز",
              s and Color3.fromRGB(255, 200, 0) or nil)
end)

-- ─── Player name input ───────────────────────────────────────────────────────
local inputLbl = Instance.new("TextLabel")
inputLbl.Size                   = UDim2.new(1, -20, 0, 15)
inputLbl.Position               = UDim2.new(0, 10, 0, 183)
inputLbl.BackgroundTransparency = 1
inputLbl.Text                   = "اسم اللاعب:"
inputLbl.TextColor3             = Color3.fromRGB(170, 170, 170)
inputLbl.Font                   = Enum.Font.GothamBold
inputLbl.TextSize               = 11
inputLbl.TextXAlignment         = Enum.TextXAlignment.Left
inputLbl.Parent                 = main

local nameBox = Instance.new("TextBox")
nameBox.Size               = UDim2.new(1, -20, 0, 28)
nameBox.Position           = UDim2.new(0, 10, 0, 200)
nameBox.BackgroundColor3   = Color3.fromRGB(25, 25, 25)
nameBox.TextColor3         = Color3.new(1,1,1)
nameBox.Font               = Enum.Font.Gotham
nameBox.TextSize           = 12
nameBox.PlaceholderText    = "اكتب اسم اللاعب..."
nameBox.PlaceholderColor3  = Color3.fromRGB(70, 70, 70)
nameBox.Text               = ""
nameBox.BorderSizePixel    = 0
nameBox.ClearTextOnFocus   = false
nameBox.Parent             = main
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 7)
local nbS = Instance.new("UIStroke", nameBox)
nbS.Color = Color3.fromRGB(55, 55, 55); nbS.Thickness = 1

-- ─── Action buttons ──────────────────────────────────────────────────────────
makeBtn(237, "📍 جيبه عندي", Color3.fromRGB(0, 100, 200), function()
    local plr = findPlayer(nameBox.Text)
    if plr then
        pullToMe(plr)
        setStatus("✅ جاب " .. plr.Name, Color3.fromRGB(100, 255, 100))
    else
        setStatus("❌ ما لقيت اللاعب", Color3.fromRGB(255, 80, 80))
    end
end)

makeBtn(277, "🌋 براكين - اقتله", Color3.fromRGB(200, 60, 0), function()
    local plr = findPlayer(nameBox.Text)
    if plr then
        lavaKill(plr)
        setStatus("🌋 " .. plr.Name .. " ← تم", Color3.fromRGB(255, 120, 0))
    else
        setStatus("❌ ما لقيت اللاعب", Color3.fromRGB(255, 80, 80))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MAIN HEARTBEAT LOOP
-- ═══════════════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    -- موت عند الامساك
    if autoKill and not killCD then
        if isGrabbed() then
            setStatus("⚡ تم الكشف! نموت...", Color3.fromRGB(255, 50, 50))
            task.spawn(killSelf)
        end
    end

    -- مانع الكمش
    if antiShrink then
        pcall(resetScales)
    end
end)

print("[beka] Hug Tower loaded ✓  — anti-grab / anti-shrink / lava kill / pull / auto-die")
