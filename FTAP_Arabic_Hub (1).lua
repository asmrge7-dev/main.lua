-- ═══════════════════════════════════════════════════════════════════
--  هاب عربي | ارمي الأشياء والناس | FTAP
--  جمع وتعريب: سكريبت متكامل
-- ═══════════════════════════════════════════════════════════════════

-- ─── الخدمات ──────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst  = game:GetService("ReplicatedFirst")
local Debris           = game:GetService("Debris")
local Teams            = game:GetService("Teams")

-- ─── الريموت إيفنتس ──────────────────────────────────────────────
local grabEventsFolder     = ReplicatedStorage:WaitForChild("GrabEvents", 5)
local setNetworkOwnerEvent = grabEventsFolder and grabEventsFolder:WaitForChild("SetNetworkOwner", 5)
local destroyGrabLineEvent = grabEventsFolder and grabEventsFolder:WaitForChild("DestroyGrabLine", 5)
local createGrabLineEvent  = grabEventsFolder and grabEventsFolder:WaitForChild("CreateGrabLine", 5)

local menuToysFolder = ReplicatedStorage:WaitForChild("MenuToys", 5)
local SpawnToyRF     = menuToysFolder and menuToysFolder:WaitForChild("SpawnToyRemoteFunction", 5)
local DeleteToyRE    = menuToysFolder and menuToysFolder:WaitForChild("DestroyToy", 5)

local playerEventsFolder = ReplicatedStorage:WaitForChild("PlayerEvents", 5)
local StickyPartEvent    = playerEventsFolder and playerEventsFolder:WaitForChild("StickyPartEvent", 5)

local struggleEvent, ragdollRemoteEvent
pcall(function()
    local charEvents = ReplicatedStorage:FindFirstChild("CharacterEvents")
    if charEvents then
        struggleEvent      = charEvents:FindFirstChild("Struggle")
        ragdollRemoteEvent = charEvents:FindFirstChild("RagdollRemote")
    end
end)

-- ─── اللاعب المحلي ───────────────────────────────────────────────
local LocalPlayer         = Players.LocalPlayer
local Character, Humanoid, HumanoidRootPart
local Camera              = Workspace.CurrentCamera
local CharacterParts      = {}
local isHeldValue         = LocalPlayer:WaitForChild("IsHeld", 5)
local SelectedTargetPlayer = nil
local pcDistance          = 0
local IncreaseLineExtend  = 3
local NoclipConnection    = nil
local currentPalletTargetIndex = 1

-- ─── الحالات ─────────────────────────────────────────────────────
local States = {
    InfiniteReach        = false,
    InfiniteReachSpeed   = false,
    CrazyGrab            = false,
    CrazyGrabV2          = false,
    CrazyGrabV3          = false,
    CrazyGrabV4          = false,
    HeavenGrab           = false,
    VoidGrab             = false,
    KillGrab             = false,
    SpinGrab             = false,
    MasslessGrab         = false,
    NoclipGrab           = false,
    SpamGrab             = false,
    ThrowPower           = false,
    PalletFlingAura      = false,
    PalletFlingAll       = false,
    WalkSpeed            = false,
    JumpPower            = false,
    InfiniteJump         = false,
    Noclip               = false,
    AntiGrab             = false,
    AntiExplosion        = false,
    AntiSpamGrab         = false,
    AntiLag              = false,
    AutoAntiLag          = false,
    AntiBurn             = false,
    LagScript            = false,
    FurtherReach         = false,
    FormGrab             = false,
}

local Values = {
    WalkSpeed        = 100,
    JumpPower        = 100,
    FlySpeed         = 50,
    ThrowStrength    = 850,
    ReachSpeed       = 3,
    FormDistance     = 10,
    FormOrientation  = 0,
}

-- ─── إعداد الشخصية ───────────────────────────────────────────────
local function CacheCharacterParts(char)
    CharacterParts = {}
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(CharacterParts, part)
        end
    end
end

local function UpdateCharacter()
    Character        = LocalPlayer.Character
    Humanoid         = Character and Character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if Character then CacheCharacterParts(Character) end
end

UpdateCharacter()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character        = char
    Humanoid         = char:WaitForChild("Humanoid", 5)
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
    CacheCharacterParts(char)
    if Humanoid then
        Humanoid.Died:Connect(function()
            if States.InstantRespawn then
                task.wait(0.1)
                LocalPlayer:LoadCharacter()
            end
        end)
    end
    task.wait(0.1)
    if States.WalkSpeed and Humanoid then
        Humanoid.WalkSpeed = Values.WalkSpeed
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    Character = nil; Humanoid = nil; HumanoidRootPart = nil; CharacterParts = {}
end)

-- ─── دوال مساعدة ─────────────────────────────────────────────────
local function GetPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.DisplayName .. " (" .. p.Name .. ")")
        end
    end
    if #list == 0 then table.insert(list, "لا يوجد لاعبون") end
    return list
end

local function GetPlayerFromDropdown(selected)
    if not selected or selected == "" then return nil end
    local username = string.match(selected, "%((.-)%)")
    return username and Players:FindFirstChild(username) or nil
end

local function ClaimOwnership(part, cf)
    if not part or not part:IsA("BasePart") then return end
    pcall(function()
        if destroyGrabLineEvent then destroyGrabLineEvent:FireServer(part) end
        if setNetworkOwnerEvent then
            setNetworkOwnerEvent:FireServer(part, cf or (HumanoidRootPart and HumanoidRootPart.CFrame))
        end
    end)
end

local function IsValidGrabbedPart(part)
    if not part or not part:IsA("BasePart") or part.Anchored then return false end
    local forbidden = {"baseplate","floor","ground","map","terrain","spawn"}
    local n = part.Name:lower()
    for _, f in ipairs(forbidden) do if n:find(f) then return false end end
    return true
end

local function GetGrabbedPartInfo()
    local gm = Workspace:FindFirstChild("GrabParts")
    if not gm then return nil, nil, nil end
    local pi = gm:FindFirstChild("GrabPart")
    if not pi then return nil, nil, nil end
    local w = pi:FindFirstChild("WeldConstraint")
    if not w or not w.Part1 then return nil, nil, nil end
    local tp = w.Part1
    if not IsValidGrabbedPart(tp) then return nil, nil, nil end
    return tp, tp.Parent, gm
end

local function GetGrabbedPallet()
    local part, model = GetGrabbedPartInfo()
    if not part then return nil end
    local n = part.Name:lower()
    local mn = model and model.Name:lower() or ""
    if n:find("pallet") or mn:find("pallet") then return part end
    return nil
end

local function GetGrabbedCharacter()
    local part, model = GetGrabbedPartInfo()
    if not part or not model then return nil end
    if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
        return model
    end
    return nil
end

local function DoSpamGrab(targetRoot)
    if not targetRoot then return end
    pcall(function()
        if setNetworkOwnerEvent then
            setNetworkOwnerEvent:FireServer(targetRoot, HumanoidRootPart and HumanoidRootPart.CFrame)
        end
        if destroyGrabLineEvent then destroyGrabLineEvent:FireServer(targetRoot) end
    end)
end

local function ExecutePalletFling(targetPlayer, palletPart, useNetOwner)
    if not targetPlayer or not targetPlayer.Character then return end
    local tHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not tHRP or not palletPart or not palletPart.Parent then return end
    local t0 = tick()
    while tick() - t0 < 2.5 do
        if not tHRP.Parent or not palletPart.Parent then break end
        local offset = Vector3.new(math.random(-5,5), math.random(-5,5), math.random(-5,5))
        palletPart.CFrame = CFrame.new(tHRP.Position + offset)
            * CFrame.Angles(math.rad(math.random(-360,360)), math.rad(math.random(-360,360)), math.rad(math.random(-360,360)))
        palletPart.AssemblyLinearVelocity  = Vector3.new(math.random(-2000,2000), math.random(-2000,2000), math.random(-2000,2000))
        palletPart.AssemblyAngularVelocity = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
        if useNetOwner then ClaimOwnership(palletPart, palletPart.CFrame) end
        RunService.Heartbeat:Wait()
    end
end

-- ─── الـ Noclip ───────────────────────────────────────────────────
local function StartNoclip()
    if NoclipConnection then return end
    NoclipConnection = RunService.Stepped:Connect(function()
        if not States.Noclip then return end
        for _, p in ipairs(CharacterParts) do
            if p and p.Parent then p.CanCollide = false end
        end
    end)
end

local function StopNoclip()
    if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end
    for _, p in ipairs(CharacterParts) do
        if p and p.Parent then p.CanCollide = true end
    end
end

-- ─── Form Grab (من سكريبت Bloody) ────────────────────────────────
local formEnabled   = false
local formDistance  = 10
local formOrientation = 0
local currentPreset = "الوقوف"
local activeForm    = nil
local ragdollMonitor = nil

local formPresets = {
    ["الوقوف"] = {
        Torso = {pos = Vector3.new(0,0,0),   rot = CFrame.Angles(0,0,0)},
        Head  = {pos = Vector3.new(0,1.5,0), rot = CFrame.Angles(0,0,0)},
        RightArm = {pos = Vector3.new(1.5,0,0), rot = CFrame.Angles(0,0,0)},
        LeftArm  = {pos = Vector3.new(-1.5,0,0), rot = CFrame.Angles(0,0,0)},
        RightLeg = {pos = Vector3.new(0.5,-2,0), rot = CFrame.Angles(0,0,0)},
        LeftLeg  = {pos = Vector3.new(-0.5,-2,0), rot = CFrame.Angles(0,0,0)},
    },
    ["شكل T"] = {
        Torso = {pos = Vector3.new(0,0,0),   rot = CFrame.Angles(0,0,0)},
        Head  = {pos = Vector3.new(0,1.5,0), rot = CFrame.Angles(0,0,0)},
        RightArm = {pos = Vector3.new(2.5,0.5,0), rot = CFrame.Angles(0,0,math.rad(-90))},
        LeftArm  = {pos = Vector3.new(-2.5,0.5,0), rot = CFrame.Angles(0,0,math.rad(90))},
        RightLeg = {pos = Vector3.new(0.5,-2,0), rot = CFrame.Angles(0,0,0)},
        LeftLeg  = {pos = Vector3.new(-0.5,-2,0), rot = CFrame.Angles(0,0,0)},
    },
    ["شكل الكرة"] = {
        Torso = {pos = Vector3.new(0,0,0),   rot = CFrame.Angles(0,0,0)},
        Head  = {pos = Vector3.new(0,0.5,0), rot = CFrame.Angles(0,0,0)},
        RightArm = {pos = Vector3.new(0.5,-1,0), rot = CFrame.Angles(math.rad(90),0,0)},
        LeftArm  = {pos = Vector3.new(-0.5,-1,0), rot = CFrame.Angles(math.rad(90),0,0)},
        RightLeg = {pos = Vector3.new(0.5,-0.5,1), rot = CFrame.Angles(math.rad(90),0,0)},
        LeftLeg  = {pos = Vector3.new(-0.5,-0.5,1), rot = CFrame.Angles(math.rad(90),0,0)},
    },
    ["شكل L"] = {
        Torso = {pos = Vector3.new(0,0,0),   rot = CFrame.Angles(0,0,math.rad(90))},
        Head  = {pos = Vector3.new(1.5,0,0), rot = CFrame.Angles(0,0,0)},
        RightArm = {pos = Vector3.new(0.5,-1.5,0), rot = CFrame.Angles(0,0,0)},
        LeftArm  = {pos = Vector3.new(-0.5,-1.5,0), rot = CFrame.Angles(0,0,0)},
        RightLeg = {pos = Vector3.new(2,-2,0), rot = CFrame.Angles(0,0,0)},
        LeftLeg  = {pos = Vector3.new(2.5,-2,0), rot = CFrame.Angles(0,0,0)},
    },
    ["مقلوب"] = {
        Torso = {pos = Vector3.new(0,0,0),   rot = CFrame.Angles(math.rad(180),0,0)},
        Head  = {pos = Vector3.new(0,-1.5,0), rot = CFrame.Angles(math.rad(180),0,0)},
        RightArm = {pos = Vector3.new(1.5,0,0), rot = CFrame.Angles(math.rad(180),0,0)},
        LeftArm  = {pos = Vector3.new(-1.5,0,0), rot = CFrame.Angles(math.rad(180),0,0)},
        RightLeg = {pos = Vector3.new(0.5,2,0), rot = CFrame.Angles(math.rad(180),0,0)},
        LeftLeg  = {pos = Vector3.new(-0.5,2,0), rot = CFrame.Angles(math.rad(180),0,0)},
    },
}

local function GetCharacterParts(char)
    if not char then return nil end
    local parts = {limbs = {}}
    parts.torso  = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    parts.head   = char:FindFirstChild("Head")
    parts.hrp    = char:FindFirstChild("HumanoidRootPart")
    local limbNames = {"RightUpperArm","LeftUpperArm","RightUpperLeg","LeftUpperLeg",
                       "RightArm","LeftArm","RightLeg","LeftLeg"}
    for _, lname in ipairs(limbNames) do
        local lpart = char:FindFirstChild(lname)
        if lpart then
            table.insert(parts.limbs, {part = lpart, name = lname})
        end
    end
    if not parts.torso then return nil end
    return parts
end

local function ApplyNoclipToForm(parts)
    if not parts then return end
    local function noclip(p)
        if p and p.Parent then p.CanCollide = false end
    end
    noclip(parts.torso); noclip(parts.head); noclip(parts.hrp)
    for _, limb in ipairs(parts.limbs) do noclip(limb.part) end
end

local function RestoreCollisions(parts)
    if not parts then return end
    local function recol(p)
        if p and p.Parent then p.CanCollide = true end
    end
    recol(parts.torso); recol(parts.head); recol(parts.hrp)
    for _, limb in ipairs(parts.limbs) do recol(limb.part) end
end

local function ApplyFormToTarget(parts, player)
    if not parts or not player.Character then return end
    local torso = player.Character:FindFirstChild("UpperTorso")
        or player.Character:FindFirstChild("Torso")
    if not torso or not parts.torso or not parts.torso.Parent then return end
    local unitDir = Vector3.new(torso.CFrame.LookVector.X, 0, torso.CFrame.LookVector.Z).Unit
    local basePos = Vector3.new(torso.Position.X, torso.Position.Y, torso.Position.Z)
        + unitDir * formDistance
    local baseCF  = CFrame.new(basePos, basePos + unitDir) * CFrame.Angles(0, math.rad(formOrientation), 0)
    local preset  = formPresets[currentPreset]
    if not preset then return end
    ApplyNoclipToForm(parts)
    local function applyPart(p, presetData)
        if p and p.Parent and presetData then
            p.AssemblyLinearVelocity  = Vector3.zero
            p.AssemblyAngularVelocity = Vector3.zero
            p.Anchored = false
            p.CFrame = baseCF * CFrame.new(presetData.pos) * presetData.rot
        end
    end
    applyPart(parts.torso, preset.Torso)
    applyPart(parts.head,  preset.Head)
    local limbMap = {}
    for _, l in ipairs(parts.limbs) do limbMap[l.name] = l.part end
    for pname, pdata in pairs(preset) do
        if pname ~= "Torso" and pname ~= "Head" then
            applyPart(limbMap[pname], pdata)
        end
    end
end

local function StopCurrentForm()
    if activeForm then
        RestoreCollisions(activeForm.parts)
        if activeForm.connection then activeForm.connection:Disconnect() end
    end
    activeForm = nil
end

local function SetupForm(char)
    if not formEnabled then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.wait(0.3)
    local parts = GetCharacterParts(char)
    if not parts then return end
    activeForm = {char = char, parts = parts, connection = nil}
    activeForm.connection = RunService.Heartbeat:Connect(function()
        if not formEnabled then return end
        ApplyFormToTarget(parts, LocalPlayer)
    end)
end

coroutine.wrap(function()
    while task.wait(0.15) do
        if formEnabled then
            pcall(function()
                local grabbed = GetGrabbedCharacter()
                if grabbed and not activeForm then SetupForm(grabbed) end
                if activeForm and (not activeForm.char or not activeForm.char.Parent) then
                    StopCurrentForm()
                end
            end)
        end
    end
end)()

LocalPlayer.CharacterAdded:Connect(function()
    if activeForm and activeForm.connection then
        activeForm.connection:Disconnect()
    end
    activeForm = nil
end)

-- ─── Anti-Explosion Setup ─────────────────────────────────────────
local antiExplosionConn = nil
local function setupAntiExplosion(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not hrp then return end
    if antiExplosionConn then antiExplosionConn:Disconnect() end
    antiExplosionConn = Workspace.ChildAdded:Connect(function(model)
        if not States.AntiExplosion then return end
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChild("Humanoid")
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not h or not r or h.Health <= 0 then return end
        if model:IsA("BasePart") and (model.Position - r.Position).Magnitude <= 20 then
            r.Anchored = true
            task.wait()
            h:ChangeState(Enum.HumanoidStateType.Running)
            r.Anchored = false
            h.AutoRotate = true
        end
    end)
end

if LocalPlayer.Character then setupAntiExplosion(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupAntiExplosion)

-- ─── Anti-Burn ────────────────────────────────────────────────────
local antiFireConn, antiFireOrigCF = nil, nil

-- ─── Auto Anti-Lag ───────────────────────────────────────────────
task.spawn(function()
    while true do
        task.wait(1)
        if States.AutoAntiLag and not States.AntiLag then
            local fps = 1 / RunService.RenderStepped:Wait()
            if fps < 5 then
                States.AntiLag = true
                pcall(function()
                    local ps = LocalPlayer:WaitForChild('PlayerScripts')
                    local s  = ps:WaitForChild('CharacterAndBeamMove')
                    s.Disabled = true
                end)
            end
        end
    end
end)

-- ─── InfiniteReach (PC) ───────────────────────────────────────────
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel and States.InfiniteReach then
        if pcDistance < 11 then pcDistance = 11 end
        if input.Position.Z <= 0 then
            pcDistance = math.max(11, pcDistance - IncreaseLineExtend)
        else
            pcDistance = pcDistance + IncreaseLineExtend
        end
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if child.Name == "GrabParts" and child:IsA("Model") and States.InfiniteReach
        and UserInputService.MouseEnabled and not UserInputService.TouchEnabled then
        child:WaitForChild("GrabPart", 5)
        child:WaitForChild("DragPart", 5)
        local dp = child:FindFirstChild("DragPart")
        if dp then
            local dp1 = dp:Clone()
            dp1.Name = "DragPart1"
            dp1.AlignPosition.Attachment1 = dp1.DragAttach
            dp1.Parent = child
            pcDistance = (dp1.Position - Camera.CFrame.Position).Magnitude
            dp1.AlignOrientation.Enabled = false
            dp.AlignPosition.Enabled = false
            task.spawn(function()
                while child.Parent do
                    dp1.Position = Camera.CFrame.Position + Camera.CFrame.LookVector * pcDistance
                    RunService.RenderStepped:Wait()
                end
                pcDistance = 0
            end)
        end
    end
end)

-- ─── Throw Power ─────────────────────────────────────────────────
Workspace.ChildAdded:Connect(function(model)
    if model.Name == "GrabParts" then
        local pi = model:FindFirstChild("GrabPart")
        if not pi then return end
        local w = pi:FindFirstChild("WeldConstraint")
        if not w or not w.Part1 then return end
        local part = w.Part1
        if not IsValidGrabbedPart(part) then return end
        local vel = Instance.new("BodyVelocity")
        vel.Parent = part
        model:GetPropertyChangedSignal("Parent"):Connect(function()
            if not model.Parent then
                if States.ThrowPower then
                    vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    vel.Velocity  = Camera.CFrame.LookVector * Values.ThrowStrength
                else
                    vel.MaxForce = Vector3.zero
                end
                Debris:AddItem(vel, 1)
            end
        end)
    end
end)

-- ─── Infinite Jump ───────────────────────────────────────────────
UserInputService.JumpRequest:Connect(function()
    if States.InfiniteJump then
        local hum = Character and Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ─── RenderStepped (Speed/Jump) ───────────────────────────────────
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    if States.WalkSpeed and hum.MoveDirection.Magnitude > 0 then
        local spd = (Values.WalkSpeed / 100) * 80
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (spd * dt))
    end
    if States.JumpPower then
        hum.UseJumpPower = true
        hum.JumpPower    = Values.JumpPower
    end
end)

-- ─── Anti-Grab ────────────────────────────────────────────────────
if isHeldValue then
    isHeldValue.Changed:Connect(function(isHeld)
        if isHeld and States.AntiGrab then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp  = char:WaitForChild("HumanoidRootPart")
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local lastFire = 0
            local conn
            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(400000,400000,400000)
            bg.CFrame    = hrp.CFrame
            bg.Parent    = hrp
            conn = RunService.RenderStepped:Connect(function(dt)
                if isHeldValue.Value and States.AntiGrab then
                    local now = tick()
                    if now - lastFire >= 0.1 then
                        lastFire = now
                        if struggleEvent then struggleEvent:FireServer(LocalPlayer) end
                        if ragdollRemoteEvent then ragdollRemoteEvent:FireServer(hrp, 0) end
                    end
                    if Camera then
                        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
                    end
                    if hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (16 * dt))
                    end
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.Anchored = true
                            p.AssemblyLinearVelocity  = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                else
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.Anchored = false end
                    end
                    if bg then bg:Destroy() end
                    if conn then conn:Disconnect() end
                end
            end)
        end
    end)
end

-- ─── Heartbeat (Grab Mods) ────────────────────────────────────────
RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local tp, _, gm = GetGrabbedPartInfo()
        if not tp then return end
        if States.CrazyGrab then
            local off = Vector3.new(math.random(-30,30), math.random(10,30), math.random(-30,30))
            local newPos = tp.Position + off
            local minH   = (Workspace.FallenPartsDestroyHeight or -500) + 50
            if newPos.Y < minH then newPos = Vector3.new(newPos.X, minH+20, newPos.Z) end
            tp.CFrame = CFrame.new(newPos) * CFrame.Angles(math.rad(math.random(-180,180)), math.rad(math.random(-180,180)), math.rad(math.random(-180,180)))
        end
        if States.CrazyGrabV2 then
            local hrp = HumanoidRootPart
            if hrp then
                local a = tick() * 500; local r = 30
                local c = hrp.Position + Vector3.new(0,5,0)
                tp.CFrame = CFrame.new(c + Vector3.new(math.cos(a)*r, 0, math.sin(a)*r)) * CFrame.Angles(0,a,0)
                tp.AssemblyLinearVelocity = Vector3.new(500,500,500)
            end
        end
        if States.CrazyGrabV3 then
            local hrp = HumanoidRootPart
            if hrp then
                local a = tick() * 700; local r = 1000
                local c = hrp.Position + Vector3.new(0,10,0)
                tp.CFrame = CFrame.new(c + Vector3.new(math.cos(a)*r, 0, math.sin(a)*r)) * CFrame.Angles(0,a,0)
                tp.AssemblyLinearVelocity = Vector3.new(700,700,700)
            end
        end
        if States.CrazyGrabV4 then
            local hrp = HumanoidRootPart
            if hrp then
                local t = tick() * 1000; local r = 100
                local oY = (math.sin(t)*0.5+0.5)*100
                tp.CFrame = CFrame.new(hrp.Position + Vector3.new(math.cos(t)*r, oY, math.sin(t)*r)) * CFrame.Angles(0,t,0)
                tp.AssemblyLinearVelocity = Vector3.new(1000,1000,1000)
            end
        end
        if States.HeavenGrab then
            local spd = 350
            tp.CFrame = CFrame.new(tp.Position + Vector3.new(0,spd*dt,0)) * tp.CFrame.Rotation
            tp.AssemblyLinearVelocity = Vector3.new(0,spd,0)
        end
        if States.VoidGrab then
            local spd = 350
            tp.CFrame = CFrame.new(tp.Position - Vector3.new(0,spd*dt,0)) * tp.CFrame.Rotation
            tp.AssemblyLinearVelocity = Vector3.new(0,-spd,0)
            tp.CanCollide = false
        end
        if States.KillGrab then
            local model = tp.Parent
            if model then
                local h = model:FindFirstChildOfClass("Humanoid")
                if h then h.Health = 0 end
            end
        end
        if States.SpinGrab then
            tp.CFrame = tp.CFrame * CFrame.Angles(0, math.rad(1800*dt), 0)
            tp.AssemblyAngularVelocity = Vector3.new(0,100,0)
        end
        if States.MasslessGrab then
            local model = tp.Parent
            if model and model:IsA("Model") then
                for _, d in ipairs(model:GetDescendants()) do
                    if d:IsA("BasePart") then d.Massless = true end
                end
            else
                tp.Massless = true
            end
        end
        if States.NoclipGrab then
            local model = tp.Parent
            if model and model:IsA("Model") then
                for _, d in ipairs(model:GetDescendants()) do
                    if d:IsA("BasePart") then d.CanCollide = false end
                end
            else
                tp.CanCollide = false
            end
        end
        if States.SpamGrab then
            for _, evName in ipairs({"DestroyGrab","ReleaseGrab","UnGrab"}) do
                local ev = ReplicatedStorage:FindFirstChild(evName, true)
                if ev and ev:IsA("RemoteEvent") then ev:FireServer(gm) end
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════
--  تحميل Rayfield
-- ═══════════════════════════════════════════════════════════════════
local SimpleGUI = loadstring(game:HttpGet(
    'https://gist.github.com/UnknownDeveloper-sqd/9b086248f695cdb508f70c7bfe3f6149/raw/2dc4a7e30da7e0166281bbf80e25cbcb8fae7757/Script'
))()

local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/UnknownDeveloper-sqd/UnknownSquad-RayField-Lib/refs/heads/main/Rayfield/CustomRayfield.luau"
))()

-- ═══════════════════════════════════════════════════════════════════
--  إنشاء النافذة
-- ═══════════════════════════════════════════════════════════════════
local Window = Rayfield:CreateWindow({
    Name            = "🏆 هاب FTAP العربي",
    LoadingTitle    = "جاري التحميل...",
    LoadingSubtitle = "ارمي الأشياء والناس | النسخة العربية",
    Theme           = "Amethyst",
    Width           = 620,
    Height          = 520,
    Font            = "Code",
    ConfigurationSaving = {Enabled = false},
    KeySystem       = false
})

-- ═══════════════════════════════════════════════════════════════════
--  التبويبات
-- ═══════════════════════════════════════════════════════════════════
local GrabTab    = Window:CreateTab("🤜 الإمساك",    4483362458)
local AuraTab    = Window:CreateTab("🌀 الأورا",     4483362458)
local TargetTab  = Window:CreateTab("🎯 الهدف",     4483362458)
local PlayerTab  = Window:CreateTab("🏃 اللاعب",    4483362458)
local AntiTab    = Window:CreateTab("🛡️ الحماية",   4483362458)
local LagTab     = Window:CreateTab("⚡ الأدوات",    4483362458)
local FormTab    = Window:CreateTab("🧩 الشكل",     4483362458)
local BarrierTab = Window:CreateTab("🔓 الحواجز",   4483362458)

-- ═══════════════════════════════════════════════════════════════════
--  🤜 تبويب الإمساك
-- ═══════════════════════════════════════════════════════════════════
GrabTab:CreateToggle({
    Name = "مسافة لا نهائية (بيتا)",
    CurrentValue = false,
    Flag = "InfiniteReach",
    Callback = function(v)
        States.InfiniteReach = v
        if not v then pcDistance = 0 end
    end
})

GrabTab:CreateSlider({
    Name = "سرعة المسافة",
    Range = {3, 25}, Increment = 1, Suffix = " سرعة",
    CurrentValue = 3, Flag = "ReachSpeedSlider",
    Callback = function(v) IncreaseLineExtend = v end
})

GrabTab:CreateToggle({
    Name = "تفعيل سرعة المسافة",
    CurrentValue = false, Flag = "ReachSpeedToggle",
    Callback = function(v) States.InfiniteReachSpeed = v end
})

GrabTab:CreateButton({
    Name = "مسافة أبعد (دائمة)",
    Callback = function()
        if States.FurtherReach then
            Rayfield:Notify({Title = "مسافة أبعد", Content = "مفعّلة بالفعل!", Duration = 3})
            return
        end
        States.FurtherReach = true
        local lv = Instance.new("BoolValue")
        lv.Name = "FartherReach"; lv.Value = true; lv.Parent = LocalPlayer
        local notif = ReplicatedStorage.GamepassEvents:FindFirstChild("FurtherReachBoughtNotifier")
        local activ = ReplicatedStorage.MenuToys:FindFirstChild("LimitedTimeToyEvent")
        if notif then notif.Parent = ReplicatedFirst end
        if activ then
            activ.Parent = ReplicatedStorage.GamepassEvents
            activ.Name   = "FurtherReachBoughtNotifier"
        end
        pcall(function()
            LocalPlayer.Character.GrabbingScript.Enabled = false
            LocalPlayer.Character.GrabbingScript.Enabled = true
        end)
        task.delay(0.1, function()
            if activ then activ:FireServer() end
        end)
        Rayfield:Notify({Title = "مسافة أبعد", Content = "تم التفعيل بنجاح!", Duration = 3})
    end
})

GrabTab:CreateToggle({
    Name = "جراب مجنون 🌪️",
    CurrentValue = false, Flag = "CrazyGrab",
    Callback = function(v) States.CrazyGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب مجنون V2 🔄",
    CurrentValue = false, Flag = "CrazyGrabV2",
    Callback = function(v) States.CrazyGrabV2 = v end
})

GrabTab:CreateToggle({
    Name = "جراب مجنون V3 💥",
    CurrentValue = false, Flag = "CrazyGrabV3",
    Callback = function(v) States.CrazyGrabV3 = v end
})

GrabTab:CreateToggle({
    Name = "جراب مجنون V4 ⚡",
    CurrentValue = false, Flag = "CrazyGrabV4",
    Callback = function(v) States.CrazyGrabV4 = v end
})

GrabTab:CreateToggle({
    Name = "جراب السماء ⬆️ (يرمي فوق)",
    CurrentValue = false, Flag = "HeavenGrab",
    Callback = function(v) States.HeavenGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب الفراغ ⬇️ (يرمي تحت)",
    CurrentValue = false, Flag = "VoidGrab",
    Callback = function(v) States.VoidGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب القتل 💀",
    CurrentValue = false, Flag = "KillGrab",
    Callback = function(v) States.KillGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب الدوران 🌀",
    CurrentValue = false, Flag = "SpinGrab",
    Callback = function(v) States.SpinGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب بدون وزن 🪶",
    CurrentValue = false, Flag = "MasslessGrab",
    Callback = function(v) States.MasslessGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب المرور 👻 (عبر الجدران)",
    CurrentValue = false, Flag = "NoclipGrab",
    Callback = function(v) States.NoclipGrab = v end
})

GrabTab:CreateToggle({
    Name = "جراب المضايقة 🔁",
    CurrentValue = false, Flag = "SpamGrab",
    Callback = function(v) States.SpamGrab = v end
})

GrabTab:CreateSlider({
    Name = "قوة الرمي 💪",
    Range = {0, 50000}, Increment = 100, Suffix = " قوة",
    CurrentValue = 850, Flag = "ThrowStrength",
    Callback = function(v) Values.ThrowStrength = v end
})

GrabTab:CreateToggle({
    Name = "تفعيل قوة الرمي",
    CurrentValue = false, Flag = "ThrowPowerToggle",
    Callback = function(v) States.ThrowPower = v end
})

-- ═══════════════════════════════════════════════════════════════════
--  🌀 تبويب الأورا
-- ═══════════════════════════════════════════════════════════════════
AuraTab:CreateToggle({
    Name = "أورا رمي الباليتس 🌀 (امسك باليتا أولاً)",
    CurrentValue = false, Flag = "PalletFlingAura",
    Callback = function(v)
        States.PalletFlingAura = v
        if v then
            Rayfield:Notify({Title = "أورا الباليتس", Content = "امسك أي باليتا والأورا تشتغل!", Duration = 5})
            task.spawn(function()
                local palletPart = nil
                while States.PalletFlingAura do
                    if not palletPart or not palletPart.Parent then
                        palletPart = GetGrabbedPallet()
                    end
                    if palletPart and palletPart.Parent then
                        palletPart.CanCollide = false
                        palletPart.Transparency = 1
                        local model = palletPart.Parent
                        if model and model:IsA("Model") then
                            for _, d in ipairs(model:GetDescendants()) do
                                if d:IsA("BasePart") then
                                    d.CanCollide = false; d.Transparency = 1
                                end
                            end
                        end
                        ClaimOwnership(palletPart, palletPart.CFrame)
                        local hrp = HumanoidRootPart
                        if hrp then
                            palletPart.CFrame = hrp.CFrame
                            palletPart.AssemblyLinearVelocity  = Vector3.new(0,100,0)
                            palletPart.AssemblyAngularVelocity = Vector3.new(500,500,500)
                        end
                        for _, evName in ipairs({"DestroyGrab","ReleaseGrab","UnGrab"}) do
                            local ev = ReplicatedStorage:FindFirstChild(evName, true)
                            if ev and ev:IsA("RemoteEvent") then
                                local gm = Workspace:FindFirstChild("GrabParts")
                                if gm then ev:FireServer(gm) end
                            end
                        end
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════
--  🎯 تبويب الهدف
-- ═══════════════════════════════════════════════════════════════════
local TargetDropdown = TargetTab:CreateDropdown({
    Name = "اختر اللاعب المستهدف",
    Options = GetPlayerList(),
    CurrentOption = {},
    Flag = "TargetDropdown",
    Callback = function(opt)
        local sel = typeof(opt) == "table" and opt[1] or opt
        SelectedTargetPlayer = GetPlayerFromDropdown(sel)
    end
})

TargetTab:CreateButton({
    Name = "🔄 تحديث القائمة",
    Callback = function()
        TargetDropdown:Refresh(GetPlayerList())
        Rayfield:Notify({Title = "الهدف", Content = "تم تحديث قائمة اللاعبين!", Duration = 2})
    end
})

TargetTab:CreateButton({
    Name = "📍 جلب الهدف",
    Callback = function()
        if not SelectedTargetPlayer or not SelectedTargetPlayer.Character then
            Rayfield:Notify({Title = "خطأ", Content = "اختر لاعباً أولاً!", Duration = 3})
            return
        end
        task.spawn(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local savedCF   = myRoot.CFrame
            local targetChar = SelectedTargetPlayer.Character
            if not targetChar then return end
            local tHead  = targetChar:FindFirstChild("Head")
            local tHRP   = targetChar:FindFirstChild("HumanoidRootPart")
            if not tHead or not tHRP then return end
            local startPos = tHead.Position
            for _ = 1, 50 do
                if not tHead.Parent or not myChar.Parent then break end
                local pOwner = tHead:FindFirstChild("PartOwner")
                if pOwner and pOwner.Value == LocalPlayer.Name then break end
                local myHum = myChar:FindFirstChildOfClass("Humanoid")
                if myHum and myHum.Health > 0 then
                    local dist = (tHead.Position - myRoot.Position).Magnitude
                    if dist > 25 then
                        myRoot.CFrame = tHead.CFrame + (tHead.Position - startPos) * 10
                    else
                        myRoot.CFrame = tHead.CFrame
                    end
                    pcall(function() setNetworkOwnerEvent:FireServer(tHead, tHead.CFrame) end)
                end
                task.wait(0.03)
            end
            tHRP.CFrame = savedCF + savedCF.LookVector * 3 + Vector3.new(0,5,0)
            myRoot.CFrame = savedCF
            Rayfield:Notify({Title = "الهدف", Content = "تم جلب " .. SelectedTargetPlayer.Name, Duration = 3})
        end)
    end
})

TargetTab:CreateButton({
    Name = "💀 قتل الهدف",
    Callback = function()
        if not SelectedTargetPlayer or not SelectedTargetPlayer.Character then
            Rayfield:Notify({Title = "خطأ", Content = "اختر لاعباً أولاً!", Duration = 3})
            return
        end
        task.spawn(function()
            local myChar  = LocalPlayer.Character
            local myRoot  = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local savedCF  = myRoot.CFrame
            local tChar    = SelectedTargetPlayer.Character
            local tHead    = tChar and tChar:FindFirstChild("Head")
            local tHRP     = tChar and tChar:FindFirstChild("HumanoidRootPart")
            if not tHead or not tHRP then return end
            local startPos = tHead.Position
            for _ = 1, 50 do
                if not tHead.Parent or not myChar.Parent then break end
                local pOwner = tHead:FindFirstChild("PartOwner")
                if pOwner and pOwner.Value == LocalPlayer.Name then break end
                local myHum = myChar:FindFirstChildOfClass("Humanoid")
                if myHum and myHum.Health > 0 then
                    local dist = (tHead.Position - myRoot.Position).Magnitude
                    if dist > 25 then
                        myRoot.CFrame = tHead.CFrame + (tHead.Position - startPos) * 10
                    else
                        myRoot.CFrame = tHead.CFrame
                    end
                    pcall(function() setNetworkOwnerEvent:FireServer(tHead, tHead.CFrame) end)
                end
                task.wait(0.03)
            end
            tHRP.CFrame = CFrame.new(tHRP.Position.X, -9999, tHRP.Position.Z)
            myRoot.CFrame = savedCF
            Rayfield:Notify({Title = "قتل", Content = "تم إرسال " .. SelectedTargetPlayer.Name .. " إلى الفراغ!", Duration = 3})
        end)
    end
})

local isFreezeActive = false
local freezeConn     = nil

TargetTab:CreateToggle({
    Name = "🧊 تجميد الهدف",
    CurrentValue = false, Flag = "FreezeTarget",
    Callback = function(v)
        isFreezeActive = v
        if v then
            if freezeConn then freezeConn:Disconnect() end
            freezeConn = RunService.Heartbeat:Connect(function()
                if not isFreezeActive or not SelectedTargetPlayer or not SelectedTargetPlayer.Character then return end
                local myHRP = HumanoidRootPart
                local tHRP  = SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP or not tHRP then return end
                myHRP.CFrame = tHRP.CFrame * CFrame.new(0,-5,0)
                DoSpamGrab(tHRP)
            end)
        else
            if freezeConn then freezeConn:Disconnect(); freezeConn = nil end
        end
    end
})

TargetTab:CreateButton({
    Name = "🏓 رمي بالباليتا",
    Callback = function()
        if not SelectedTargetPlayer or not SelectedTargetPlayer.Character then
            Rayfield:Notify({Title = "خطأ", Content = "اختر لاعباً أولاً!", Duration = 3})
            return
        end
        Rayfield:Notify({Title = "رمي الباليتا", Content = "امسك أي باليتا خلال 5 ثواني!", Duration = 5})
        task.spawn(function()
            local palletPart = nil
            local t0 = tick()
            while tick() - t0 < 5 do
                local p = GetGrabbedPallet()
                if p then palletPart = p; break end
                task.wait(0.1)
            end
            if not palletPart then
                Rayfield:Notify({Title = "رمي الباليتا", Content = "انتهى الوقت! لم تمسك باليتا.", Duration = 3})
                return
            end
            ExecutePalletFling(SelectedTargetPlayer, palletPart, false)
            Rayfield:Notify({Title = "رمي الباليتا", Content = "تم الرمي!", Duration = 2})
        end)
    end
})

TargetTab:CreateToggle({
    Name = "🏓 رمي الكل بالباليتا",
    CurrentValue = false, Flag = "PalletFlingAll",
    Callback = function(v)
        States.PalletFlingAll = v
        if v then
            Rayfield:Notify({Title = "رمي الكل", Content = "امسك باليتا لترمي جميع اللاعبين!", Duration = 4})
            task.spawn(function()
                local lastPallet = nil
                while States.PalletFlingAll do
                    local pallet = GetGrabbedPallet()
                    if pallet and pallet ~= lastPallet then
                        lastPallet = pallet
                        local plist = {}
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer then table.insert(plist, p) end
                        end
                        if currentPalletTargetIndex > #plist then currentPalletTargetIndex = 1 end
                        local target = plist[currentPalletTargetIndex]
                        if target then
                            currentPalletTargetIndex += 1
                            Rayfield:Notify({Title = "رمي الكل", Content = "يرمي " .. target.Name, Duration = 2})
                            task.spawn(function()
                                ExecutePalletFling(target, pallet, true)
                            end)
                        end
                    elseif not pallet then
                        lastPallet = nil
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════
--  🏃 تبويب اللاعب
-- ═══════════════════════════════════════════════════════════════════
PlayerTab:CreateSlider({
    Name = "سرعة الركض 🏃",
    Range = {20, 500}, Increment = 5, Suffix = " سرعة",
    CurrentValue = 100, Flag = "WalkSpeedSlider",
    Callback = function(v) Values.WalkSpeed = v end
})

PlayerTab:CreateToggle({
    Name = "تفعيل سرعة الركض",
    CurrentValue = false, Flag = "WalkSpeedToggle",
    Callback = function(v)
        States.WalkSpeed = v
        local hum = Character and Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v and Values.WalkSpeed or 16 end
    end
})

PlayerTab:CreateSlider({
    Name = "قوة القفز 🦘",
    Range = {50, 300}, Increment = 5, Suffix = " قوة",
    CurrentValue = 100, Flag = "JumpPowerSlider",
    Callback = function(v) Values.JumpPower = v end
})

PlayerTab:CreateToggle({
    Name = "تفعيل قوة القفز",
    CurrentValue = false, Flag = "JumpPowerToggle",
    Callback = function(v)
        States.JumpPower = v
        local hum = Character and Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then hum.UseJumpPower = true; hum.JumpPower = Values.JumpPower
            else hum.JumpPower = 50; hum.UseJumpPower = false end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "قفز لا نهائي 🌤️",
    CurrentValue = false, Flag = "InfiniteJump",
    Callback = function(v) States.InfiniteJump = v end
})

PlayerTab:CreateToggle({
    Name = "المرور عبر الجدران 👻",
    CurrentValue = false, Flag = "NoclipToggle",
    Callback = function(v)
        States.Noclip = v
        if v then StartNoclip() else StopNoclip() end
    end
})

-- ═══════════════════════════════════════════════════════════════════
--  🛡️ تبويب الحماية
-- ═══════════════════════════════════════════════════════════════════
AntiTab:CreateToggle({
    Name = "ضد الإمساك 🛡️",
    CurrentValue = false, Flag = "AntiGrab",
    Callback = function(v) States.AntiGrab = v end
})

AntiTab:CreateToggle({
    Name = "ضد الانفجار 💥🛡️",
    CurrentValue = false, Flag = "AntiExplosion",
    Callback = function(v) States.AntiExplosion = v end
})

AntiTab:CreateToggle({
    Name = "ضد مضايقة الجراب 🔁🛡️ (بيتا)",
    CurrentValue = false, Flag = "AntiSpamGrab",
    Callback = function(v) States.AntiSpamGrab = v end
})

AntiTab:CreateToggle({
    Name = "ضد التأخير ⚡🛡️",
    CurrentValue = false, Flag = "AntiLag",
    Callback = function(v)
        States.AntiLag = v
        pcall(function()
            local ps = LocalPlayer:WaitForChild('PlayerScripts')
            local s  = ps:WaitForChild('CharacterAndBeamMove')
            s.Disabled = v
        end)
    end
})

AntiTab:CreateToggle({
    Name = "ضد التأخير التلقائي ⚡🤖",
    CurrentValue = false, Flag = "AutoAntiLag",
    Callback = function(v) States.AutoAntiLag = v end
})

AntiTab:CreateToggle({
    Name = "ضد الحرق 🔥🛡️",
    CurrentValue = false, Flag = "AntiBurn",
    Callback = function(v)
        States.AntiBurn = v
        if v then
            local extPart = Workspace:FindFirstChild("Map")
                and Workspace.Map:FindFirstChild("Hole")
                and Workspace.Map.Hole:FindFirstChild("PoisonBigHole")
                and Workspace.Map.Hole.PoisonBigHole:FindFirstChild("ExtinguishPart")
            if extPart then
                antiFireOrigCF = extPart.CFrame
                local lastUpdate = 0
                antiFireConn = RunService.Heartbeat:Connect(function()
                    if not States.AntiBurn then return end
                    local now = tick()
                    if now - lastUpdate < 0.05 then return end
                    lastUpdate = now
                    local root = HumanoidRootPart
                    if not root then return end
                    if root:FindFirstChild("FireLight") or root:FindFirstChild("FireParticleEmitter") then
                        extPart.CFrame = root.CFrame
                    elseif antiFireOrigCF then
                        extPart.CFrame = antiFireOrigCF
                    end
                end)
            end
        else
            if antiFireConn then antiFireConn:Disconnect(); antiFireConn = nil end
            if antiFireOrigCF then
                local extPart = Workspace:FindFirstChild("Map")
                    and Workspace.Map:FindFirstChild("Hole")
                    and Workspace.Map.Hole:FindFirstChild("PoisonBigHole")
                    and Workspace.Map.Hole.PoisonBigHole:FindFirstChild("ExtinguishPart")
                if extPart then extPart.CFrame = antiFireOrigCF end
            end
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════
--  ⚡ تبويب الأدوات
-- ═══════════════════════════════════════════════════════════════════
LagTab:CreateToggle({
    Name = "سكريبت التأخير 🌐 (VPN)",
    CurrentValue = false, Flag = "LagScript",
    Callback = function(v)
        States.LagScript = v
        if v then
            task.spawn(function()
                while States.LagScript do
                    local t0 = tick()
                    while States.LagScript and (tick()-t0 < 2) do
                        for _ = 1, 50 do
                            if not States.LagScript then break end
                            local angle = math.random() * math.pi * 2
                            local offset = Vector3.new(math.cos(angle)*10, 0, math.sin(angle)*10)
                            local pos = (HumanoidRootPart and HumanoidRootPart.Position + offset) or Vector3.zero
                            pcall(function()
                                if createGrabLineEvent then
                                    createGrabLineEvent:FireServer(
                                        Workspace.Terrain,
                                        CFrame.new(pos) * CFrame.Angles(
                                            math.rad(math.random(0,360)),
                                            math.rad(math.random(0,360)),
                                            math.rad(math.random(0,360))
                                        )
                                    )
                                end
                            end)
                        end
                        RunService.Heartbeat:Wait()
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

LagTab:CreateButton({
    Name = "💥 إغلاق السيرفر (يستغرق وقتاً)",
    Callback = function()
        Rayfield:Notify({Title = "إغلاق السيرفر", Content = "جاري إغلاق السيرفر...", Duration = 5})
        local DataEvents         = ReplicatedStorage:FindFirstChild("DataEvents")
        local UpdateTexturesChoice = DataEvents and DataEvents:FindFirstChild("UpdateTexturesChoice")
        local DataRemoteEvent    = DataEvents and DataEvents:FindFirstChild("DataRemoteEvent")
        local BigPayload         = string.rep("A", 5_000_000)

        local function flingEverything()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored then
                    pcall(function()
                        obj:SetNetworkOwner(LocalPlayer)
                        obj.AssemblyLinearVelocity  = Vector3.new(math.random(-1e6,1e6), math.random(-1e6,1e6), math.random(-1e6,1e6))
                        obj.AssemblyAngularVelocity = Vector3.new(math.random(-1e5,1e5), math.random(-1e5,1e5), math.random(-1e5,1e5))
                    end)
                end
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                local c = plr.Character
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            hrp:SetNetworkOwner(LocalPlayer)
                            hrp.AssemblyLinearVelocity = Vector3.new(math.random(-2e6,2e6), math.random(-2e6,2e6), math.random(-2e6,2e6))
                        end)
                    end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum then
                        pcall(function()
                            hum:ChangeState(Enum.HumanoidStateType.Freefall)
                            hum.PlatformStand = true
                        end)
                    end
                end
            end
        end

        local crashing = false
        if crashing then return end
        crashing = true
        local flingConn = RunService.Heartbeat:Connect(flingEverything)
        task.spawn(function()
            if UpdateTexturesChoice then
                for _ = 1, 3 do
                    pcall(function() UpdateTexturesChoice:FireServer(BigPayload) end)
                end
            end
            if DataRemoteEvent then
                for _ = 1, 1_000_000 do
                    pcall(function() DataRemoteEvent:FireServer() end)
                end
            end
        end)
        task.delay(30, function()
            flingConn:Disconnect()
            crashing = false
        end)
    end
})

-- ═══════════════════════════════════════════════════════════════════
--  🧩 تبويب الشكل (Form Grab - من Bloody V2)
-- ═══════════════════════════════════════════════════════════════════
FormTab:CreateParagraph({
    Title = "📌 ملاحظة",
    Content = "امسك لاعباً ثم فعّل الشكل. يعمل على اللاعبين والـ NPC. لا تفعّله داخل المنزل."
})

FormTab:CreateToggle({
    Name = "🧩 تفعيل شكل الإمساك",
    CurrentValue = false, Flag = "FormGrabToggle",
    Callback = function(v)
        formEnabled = v
        if not v then StopCurrentForm() end
    end
})

FormTab:CreateSlider({
    Name = "المسافة 📏 (ستود)",
    Range = {0, 20}, Increment = 1,
    CurrentValue = 10, Flag = "FormDistance",
    Callback = function(v) formDistance = v end
})

FormTab:CreateSlider({
    Name = "الاتجاه 🧭 (درجة)",
    Range = {0, 360}, Increment = 5,
    CurrentValue = 0, Flag = "FormOrientation",
    Callback = function(v) formOrientation = v end
})

FormTab:CreateDropdown({
    Name = "الشكل 🎭",
    Options = {"الوقوف", "شكل T", "شكل الكرة", "شكل L", "مقلوب"},
    CurrentOption = {"الوقوف"},
    Flag = "FormPreset",
    Callback = function(v) currentPreset = typeof(v)=="table" and v[1] or v end
})

FormTab:CreateButton({
    Name = "⛔ إيقاف الشكل",
    Callback = function()
        StopCurrentForm()
        Rayfield:Notify({Title = "الشكل", Content = "تم إيقاف الشكل.", Duration = 2})
    end
})

-- ═══════════════════════════════════════════════════════════════════
--  🔓 تبويب الحواجز
-- ═══════════════════════════════════════════════════════════════════
BarrierTab:CreateParagraph({
    Title = "📌 ملاحظة",
    Content = "يكسر حواجز المنطقة. يستغرق بضع ثوانٍ. كن صبوراً."
})

BarrierTab:CreateButton({
    Name = "🔓 كسر الحواجز",
    Callback = function()
        local player = LocalPlayer
        local pName  = player.Name
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "خطأ", Content = "الشخصية غير موجودة!", Duration = 3})
            return
        end
        local origPos = player.Character.HumanoidRootPart.CFrame
        pcall(function()
            SpawnToyRF:InvokeServer("InstrumentWoodwindOcarina",
                CFrame.new(184.148834,-5.54824972,498.136749,0.829037189,-0.214714944,0.516328275,0,0.923344612,0.383972496,-0.559193552,-0.318327487,0.765486956),
                Vector3.new(0,34,0)
            )
        end)
        task.wait(0.3)
        local toyFolder = Workspace:FindFirstChild(pName .. "SpawnedInToys")
        local ocarina   = toyFolder and toyFolder:FindFirstChild("InstrumentWoodwindOcarina")
        local holdPart  = ocarina and ocarina:FindFirstChild("HoldPart")
        if holdPart then
            holdPart.HoldItemRemoteFunction:InvokeServer(ocarina, Workspace[pName])
            task.wait(0.3)
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(304.06, 25.77, 488.54)
            end
            task.wait(0.15)
            if ocarina and ocarina.Parent then
                pcall(function() DeleteToyRE:FireServer(ocarina) end)
            end
            task.wait(0.15)
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = origPos
            end
            for _, v in ipairs(Workspace.Plots:GetChildren()) do
                local barrier = v:FindFirstChild("Barrier")
                if barrier then
                    for _, p in ipairs(barrier:GetChildren()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
            task.wait(0.5)
            pcall(function()
                SpawnToyRF:InvokeServer("Campfire", player.Character.HumanoidRootPart.CFrame, Vector3.zero)
            end)
            task.wait(0.2)
            local campfire  = toyFolder and toyFolder:FindFirstChild("Campfire")
            local soundPart = campfire and campfire:FindFirstChild("SoundPart")
            if soundPart then
                ClaimOwnership(soundPart, player.Character.HumanoidRootPart.CFrame)
                soundPart.CFrame = CFrame.new(304, 25, 488)
                task.wait(2)
                if campfire and campfire.Parent then
                    pcall(function() DeleteToyRE:FireServer(campfire) end)
                end
                Rayfield:Notify({Title = "كسر الحواجز", Content = "تم كسر الحواجز بنجاح! ✅", Duration = 5})
            end
        else
            Rayfield:Notify({Title = "خطأ", Content = "فشل في كسر الحواجز.", Duration = 3})
        end
    end
})

-- ─── تحديث قائمة اللاعبين ─────────────────────────────────────────
Players.PlayerAdded:Connect(function()
    TargetDropdown:Refresh(GetPlayerList())
end)

Players.PlayerRemoving:Connect(function()
    TargetDropdown:Refresh(GetPlayerList())
end)

-- ─── إشعار التحميل ───────────────────────────────────────────────
Rayfield:Notify({
    Title    = "🏆 هاب FTAP العربي",
    Content  = "تم التحميل بنجاح! استمتع بالسكريبت 🎮",
    Duration = 5,
    Image    = 4483362458
})

-- ═══════════════════════════════════════════════════════════════════
