-- This File Was deobfuscated  By 2zvh | https://discord.gg/QqSR7HKws
-- This File Was deobfuscated  By 2zvh | https://discord.gg/QqSR7HKws
--[[
    Dеоbfuѕcаtеԁ Ԝіtһ 2zvh
]]

local lighting = game:GetService("Lighting")
local tweenService = game:GetService("TweenService")

local function f2(index2)
  return setmetatable(index2, {
    __index = index2,
    __newindex = function() error("محاولة تعديل جدول محمي!", 2) end,
    __metatable = false,
  })
end

local v16 = game
local players = v16:GetService("Players")
local v17 = game
local starterGui = v17:GetService("StarterGui")
local v18 = game
local httpService = v18:GetService("HttpService")
local v19 = game
local userInputService = v19:GetService("UserInputService")
local v20 = game
local textChatService = v20:GetService("TextChatService")
local v21 = game
local replicatedStorage = v21:GetService("ReplicatedStorage")
local v22 = game
local runService = v22:GetService("RunService")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local function f4(instance)
  local flag = false
  instance.Destroying:Connect(function() flag = true end)

  local function f5()
    if flag then
      return
    end

    if instance and instance.Parent == nil then
      instance.Parent = playerGui
      warn("[حماية] تم إعادة إلحاق الواجهة.")
    end
  end

  instance.AncestryChanged:Connect(f5)
  runService.Heartbeat:Connect(f5)
end

local currentCamera = workspace.CurrentCamera
local flag2 = false
local list = {}

local function f6(name)
  for _, value in ipairs(list) do
    if value == name then
      return true
    end
  end

  return false
end

local function getClamped()
  local viewportSize = currentCamera.ViewportSize
  local x = viewportSize.X
  local y = viewportSize.Y
  local lowest = math.min(x / 800, y / 600)
  return math.clamp(lowest, 0.35, 2)
end

local f7

local function f8(name2)
  for _, value2 in ipairs(list) do
    if value2 == name2 then
      return
    end
  end

  table.insert(list, name2)
  f7(list)
end

function f7(p2)
  if not writefile then
    return
  end

  local jsonEncode

  local function f9()
    writefile("banned_players.json", jsonEncode)
  end

  jsonEncode = httpService:JSONEncode(p2)
end

local function f10()
  if not readfile then
    return {}
  end

  local ok, result = pcall(function() return readfile("banned_players.json") end)

  if not ok or not result then
    return {}
  end

  local jsonDecode = httpService:JSONDecode(result)

  if type(jsonDecode) ~= "table" then
    return {}
  end

  return jsonDecode
end

list = f10()
local clamped = getClamped()

local function f11(p3)
  return p3 * clamped
end

local function getUdim(p4, p5)
  return UDim2.new(0, p4 * clamped, 0, p5 * clamped)
end

local url = f2({ url = "https://pastebin.com/raw/5apxZ4T9" }).url
local link = f2({ link = "https://link-center.net/1375787/HrrFDGCy0Xu6" }).link

task.spawn(function()
  local welcomeScreen = Instance.new("ScreenGui")
  welcomeScreen.Name = "WelcomeScreen"
  welcomeScreen.ResetOnSpawn = false
  welcomeScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
  welcomeScreen.IgnoreGuiInset = true
  welcomeScreen.Parent = playerGui

  local instance2 = Instance.new("BlurEffect", lighting)
  instance2.Size = 20

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(1, 0, 1, 0)
  frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  frame.BackgroundTransparency = 0.5
  frame.Parent = welcomeScreen

  local textLabel = Instance.new("TextLabel")
  textLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
  textLabel.Position = UDim2.new(0.1, 0, 0.35, 0)
  textLabel.BackgroundTransparency = 1
  textLabel.Text = "تم تشغيل السكربت 🐊"
  textLabel.TextColor3 = Color3.fromRGB(212, 175, 55)
  textLabel.TextScaled = true
  textLabel.Font = Enum.Font.GothamBold
  textLabel.TextWrapped = true
  textLabel.Parent = welcomeScreen

  local new = TweenInfo.new
  local easingStyle = Enum.EasingStyle

  tweenService:Create(
    textLabel, new(1.5, easingStyle.Sine, Enum.EasingDirection.InOut), { Rotation = 5 }
  ):Play()

  task.wait(0.2)
  local new2 = TweenInfo.new

  tweenService:Create(
    textLabel, new2(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    { Rotation = -5 }
  ):Play()

  task.wait(5)
  welcomeScreen:Destroy()
  instance2:Destroy()
end)

task.wait(1.5)

local keyChecker = Instance.new("ScreenGui")
keyChecker.Name = "KeyChecker"
keyChecker.ResetOnSpawn = false
keyChecker.IgnoreGuiInset = true
keyChecker.Parent = playerGui

f4(keyChecker)

local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(1, 0, 1, 0)
frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame2.BackgroundTransparency = 0.6
frame2.BorderSizePixel = 0
frame2.Parent = keyChecker

local frame3 = Instance.new("Frame")
frame3.Size = getUdim(420, 250)
frame3.Position = UDim2.new(0.5, -210 * clamped, 0.5, -125 * clamped)
frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame3.BorderSizePixel = 0
frame3.Parent = keyChecker

Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 16 * clamped)

local instance3 = Instance.new("UIStroke", frame3)
instance3.Color = Color3.fromRGB(212, 175, 55)
instance3.Thickness = 2 * clamped

local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, 0, 0, 50 * clamped)
textLabel2.Position = UDim2.new(0, 0, 0, 8 * clamped)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "🔑 التحقق من المفتاح"
textLabel2.TextColor3 = Color3.fromRGB(212, 175, 55)
textLabel2.TextSize = f11(24)
textLabel2.Font = Enum.Font.GothamBold
textLabel2.TextXAlignment = Enum.TextXAlignment.Center
textLabel2.Parent = frame3

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 40 * clamped)
textBox.Position = UDim2.new(0.1, 0, 0, 70 * clamped)
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "أدخل المفتاح هنا..."
textBox.PlaceholderColor3 = Color3.fromRGB(160, 160, 180)
textBox.TextSize = f11(18)
textBox.Font = Enum.Font.Gotham
textBox.BorderSizePixel = 0
textBox.ClearTextOnFocus = false
textBox.Parent = frame3

Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8 * clamped)

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0.35, 0, 0, 45 * clamped)
textButton.Position = UDim2.new(0.1, 0, 0, 130 * clamped)
textButton.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton.Text = "✅ تأكيد"
textButton.TextSize = f11(18)
textButton.Font = Enum.Font.GothamBold
textButton.BorderSizePixel = 0
textButton.Parent = frame3

Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8 * clamped)

local textButton2 = Instance.new("TextButton")
textButton2.Size = UDim2.new(0.35, 0, 0, 45 * clamped)
textButton2.Position = UDim2.new(0.55, 0, 0, 130 * clamped)
textButton2.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
textButton2.TextColor3 = Color3.fromRGB(20, 20, 40)
textButton2.Text = "📋 الحصول على المفتاح"
textButton2.TextSize = f11(16)
textButton2.Font = Enum.Font.GothamBold
textButton2.BorderSizePixel = 0
textButton2.Parent = frame3

Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 8 * clamped)

local textLabel3 = Instance.new("TextLabel")
textLabel3.Size = UDim2.new(0.9, 0, 0, 30 * clamped)
textLabel3.Position = UDim2.new(0.05, 0, 0, 195 * clamped)
textLabel3.BackgroundTransparency = 1
textLabel3.Text = ""
textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel3.TextSize = f11(14)
textLabel3.Font = Enum.Font.Gotham
textLabel3.TextWrapped = true
textLabel3.Parent = frame3

local gsub = ""

local function f12()
  local ok2, result2 = pcall(game.HttpGet, game, url)

  if ok2 and result2 then
    gsub = result2:gsub("%s+", "")
    return true
  end

  textLabel3.Text = "❌ فشل في جلب المفتاح"
  textLabel3.TextColor3 = Color3.fromRGB(255, 80, 80)

  warn("[جلب المفتاح] فشل الاتصال بالرابط: " .. tostring(ok2) .. " - "
    .. tostring(result2))

  return false
end

f12()

textButton2.MouseButton1Click:Connect(function()
  textLabel3.Text = "📋 تم نسخ الرابط! افتحه في المتصفح واتبع التعليمات."
  textLabel3.TextColor3 = Color3.fromRGB(212, 175, 55)
end)

local function f13()
  local text2 = textBox.Text
  local gsub2 = text2:gsub("%s+", "")

  if gsub2 == "" then
    textLabel3.Text = "⚠️ الرجاء إدخال المفتاح"
    textLabel3.TextColor3 = Color3.fromRGB(255, 200, 100)
    return
  end

  if gsub == "" then
    textLabel3.Text = "⏳ جاري جلب المفتاح..."
    textLabel3.TextColor3 = Color3.fromRGB(255, 200, 100)

    if f12() then
      textLabel3.Text = "✅ تم جلب المفتاح، حاول مجدداً"
      textLabel3.TextColor3 = Color3.fromRGB(60, 200, 100)
    else
      textLabel3.Text = "❌ تعذر جلب المفتاح، تأكد من الاتصال بالإنترنت"
      textLabel3.TextColor3 = Color3.fromRGB(255, 80, 80)
    end

    return
  end

  if gsub2 == gsub then
    textLabel3.Text = "✅ المفتاح صحيح! جارٍ تشغيل السكربت..."
    textLabel3.TextColor3 = Color3.fromRGB(60, 200, 100)

    task.wait(0.8)
    flag2 = true
    keyChecker:Destroy()
    startMain()
  else
    textLabel3.Text = "❌ مفتاح غير صحيح! حاول مرة أخرى."
    textLabel3.TextColor3 = Color3.fromRGB(255, 80, 80)
  end
end

textButton.MouseButton1Click:Connect(f13)

textBox.FocusLost:Connect(function(p6)
  if p6 then
    f13()
  end
end)

function startMain()
  if not flag2 then
    warn("[أمان] محاولة تشغيل startMain بدون التحقق من المفتاح! تم الرفض.")
    return
  end

  clamped = getClamped()

  if playerGui:FindFirstChild("ProductButtonsGUI") then
    playerGui.ProductButtonsGUI:Destroy()
  end

  if playerGui:FindFirstChild("ToggleButtonGUI") then
    playerGui.ToggleButtonGUI:Destroy()
  end

  local v28 = game
  local marketplaceService = v28:GetService("MarketplaceService")

  local list2 = f2({
    { id = 3583915043, name = "تطير" }, { id = 3583917391, name = "قتل" },
    { id = 3583919159, name = "تبطيء" }, { id = 3583916429, name = "تجميد" },
    { id = 3583918502, name = "اهتزاز" }, { id = 3583915955, name = "حرق" },
  })

  local v29 = 100
  local flag3 = false
  local productButtonsGUI
  local frame4
  local textBox2
  local textButton3
  local textButton4
  local scrollingFrame
  local toggleButtonGUI
  local map = {}

  local function f14(p7)
    pcall(function()
      if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        textChatService.TextChannels.RBXGeneral:SendAsync(p7)
      else
        local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")

        if defaultChatSystemChatEvents then
          local sayMessageRequest = defaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")

          if sayMessageRequest then
            sayMessageRequest:FireServer(p7, "All")
          end
        end
      end
    end)
  end

  task.spawn(function()
    task.wait(1)
    f14("تم تشغيل السكربت")
  end)

  task.spawn(function()
    local flag4 = true

    while true do
      task.wait(60)

      if flag4 then
        f14("⬛السكربت⬛")
      else
        f14("⬛script⬛")
      end

      flag4 = not flag4
    end
  end)

  local v30 = {}

  local function makeTextLabel(key2)
    if v30[key2] then
      return v30[key2]
    end

    local function makeTextLabel2(character)
      if not character then
        return
      end

      local billboardGui = Instance.new("BillboardGui")
      billboardGui.Size = UDim2.new(0, 200, 0, 50)
      billboardGui.StudsOffset = Vector3.new(0, 3, 0)
      billboardGui.AlwaysOnTop = true
      billboardGui.Parent = character

      local textLabel4 = Instance.new("TextLabel")
      textLabel4.Size = UDim2.new(1, 0, 1, 0)
      textLabel4.BackgroundTransparency = 1
      textLabel4.Text = "ما تقدر تشوف شاته يستخدم نفس السكربت"
      textLabel4.TextColor3 = Color3.fromRGB(255, 0, 0)
      textLabel4.TextScaled = true
      textLabel4.Font = Enum.Font.GothamBold
      textLabel4.TextWrapped = true
      textLabel4.Parent = billboardGui

      v30[key2] = { billboard = billboardGui, label = textLabel4 }
      return billboardGui
    end

    local character2 = key2.Character

    if character2 then
      makeTextLabel2(character2)
    end

    key2.CharacterAdded:Connect(function(character3)
      if v30[key2] then
        pcall(function() v30[key2].billboard:Destroy() end)
        v30[key2] = nil
      end

      makeTextLabel2(character3)
    end)

    return v30[key2]
  end

  local function f15(player)
    if player == localPlayer then
      f8(player.Name)
      makeTextLabel(player)
      task.wait(0.2)
      player:Destroy()
      return
    end

    f8(player.Name)
    makeTextLabel(player)
    player:Destroy()
    print("تم إزالة اللاعب: " .. player.Name)
  end

  for _, value3 in ipairs(players:GetPlayers()) do
    if value3 ~= localPlayer and f6(value3.Name) then
      task.spawn(function()
        task.wait(0.5)
        f15(value3)
      end)
    end
  end

  players.PlayerAdded:Connect(function(player2)
    if player2 == localPlayer then
      return
    end

    if f6(player2.Name) then
      task.wait(0.5)
      f15(player2)
    end
  end)

  local function f16(player3, message)
    if player3 == localPlayer then
      return
    end

    local lower = message:gsub("%s+", ""):lower()

    for _, value4 in ipairs({
      "تم تشغيل السكربت",
      "⬛السكربت⬛", "⬛script⬛",
    }) do
      if lower == value4:gsub("%s+", ""):lower() then
        f15(player3)
        break
      end
    end
  end

  for _, value5 in ipairs(players:GetPlayers()) do
    if value5 ~= localPlayer then
      value5.Chatted:Connect(function(message2) f16(value5, message2) end)
    end
  end

  players.PlayerAdded:Connect(function(player4)
    if player4 ~= localPlayer then
      player4.Chatted:Connect(function(message3) f16(player4, message3) end)
    end
  end)

  local function makeTextLabel3(text3, getPlayerByUserId)
    if getPlayerByUserId and getPlayerByUserId.Name ~= "asmr_Queen37" then
      return
    end

    local s = text3:match("^طرد%s+(.+)$")

    if not s then
      return
    end

    local v31
    local lower2 = s:lower()

    for _, value6 in ipairs(players:GetPlayers()) do
      if value6.Name:lower():find(lower2, 1, true)
        or value6.DisplayName and value6.DisplayName:lower():find(lower2, 1, true) then
        v31 = value6
        break
      end
    end

    if not v31 then
      starterGui:SetCore("SendNotification", {
        Title = "❌ خطأ",
        Text = "لم يتم العثور على اللاعب: " .. s,
        Duration = 3,
      })

      return
    end

    f15(v31)

    local kickNotification = Instance.new("ScreenGui")
    kickNotification.Name = "KickNotification"
    kickNotification.ResetOnSpawn = false
    kickNotification.ZIndexBehavior = Enum.ZIndexBehavior.Global
    kickNotification.IgnoreGuiInset = true
    kickNotification.Parent = playerGui

    local frame5 = Instance.new("Frame")
    frame5.Size = UDim2.new(0.6, 0, 0.12, 0)
    frame5.Position = UDim2.new(0.2, 0, 0.42, 0)
    frame5.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame5.BorderSizePixel = 0
    frame5.Parent = kickNotification

    Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, 12)

    local textLabel5 = Instance.new("TextLabel")
    textLabel5.Size = UDim2.new(1, 0, 1, 0)
    textLabel5.BackgroundTransparency = 1
    textLabel5.Text = "⛔ تم طرد " .. v31.Name"
    textLabel5.TextColor3 = Color3.fromRGB(255, 80, 80)
    textLabel5.TextScaled = true
    textLabel5.Font = Enum.Font.GothamBold
    textLabel5.Parent = frame5

    task.delay(4, function() kickNotification:Destroy() end)
  end

  task.spawn(function()
    local function f17(p8)
      if p8.Name == "asmr_Queen37" then
        p8.Chatted:Connect(function(message4) makeTextLabel3(message4, p8) end)
      end
    end

    for _, value7 in ipairs(players:GetPlayers()) do
      f17(value7)
    end

    players.PlayerAdded:Connect(f17)

    if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
      function textChatService.OnIncomingMessage(p9)
        if p9.TextSource then
          local getPlayerByUserId2 = players:GetPlayerByUserId(p9.TextSource.UserId)

          if getPlayerByUserId2 and getPlayerByUserId2.Name == "asmr_Queen37" then
            makeTextLabel3(p9.Text, getPlayerByUserId2)
          end
        end
      end
    end
  end)

  local function getHumanoid()
    if localPlayer and localPlayer.Character then
      local character4 = localPlayer.Character
      return character4:FindFirstChildOfClass("Humanoid")
    end

    return nil
  end

  local cameraSubject = getHumanoid()

  if cameraSubject then
    currentCamera.CameraType = Enum.CameraType.Custom
    currentCamera.CameraSubject = cameraSubject
  end

  currentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
    local humanoid = getHumanoid()

    if humanoid and currentCamera.CameraSubject ~= humanoid then
      currentCamera.CameraSubject = humanoid
    end
  end)

  local function makeInputObject(instance4)
    if not instance4 then
      return
    end

    for _, value8 in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Up", "TouchTap" }) do
      if instance4:FindFirstChild(value8) or instance4[value8] then
        for _, value9 in ipairs(getconnections(instance4[value8]
          or instance4:FindFirstChild(value8))) do
          value9:Fire()
        end
      end
    end

    pcall(function()
      if instance4.Click then
        instance4:Click()
      end

      if instance4.Activated then
        instance4:Fire("Activated")
      end
    end)

    local clickDetector = instance4:FindFirstChild("ClickDetector")
    local clickDetector2 = clickDetector or instance4:FindFirstChildWhichIsA("ClickDetector")
    local v32 = clickDetector2

    if v32 then
      pcall(function()
        v32:FireClick(localPlayer.Character
          and localPlayer.Character:FindFirstChild("HumanoidRootPart"))
      end)
    end

    if instance4:IsA("GuiButton") then
      pcall(function()
        local inputObject = Instance.new("InputObject")
        inputObject.Type = Enum.UserInputType.MouseButton1
        inputObject.UserInputState = Enum.UserInputState.Begin

        instance4:InputBegan(inputObject)
        task.wait(0.05)
        inputObject.UserInputState = Enum.UserInputState.End
        instance4:InputEnded(inputObject)
      end)
    end
  end

  local function f18()
    local troll = playerGui:FindFirstChild("Troll")

    if troll then
      local troll2 = troll:FindFirstChild("Troll")

      if troll2 then
        local trollBtn = troll2:FindFirstChild("TrollBtn")

        if trollBtn then
          makeInputObject(trollBtn)
        end
      end

      local spectate = troll:FindFirstChild("Spectate")

      if spectate then
        local close = spectate:FindFirstChild("Close")

        if close then
          local textButton5 = close:FindFirstChild("TextButton")

          if textButton5 then
            makeInputObject(textButton5)
          end
        end
      end
    end
  end

  local function f19()
    local troll3 = playerGui:FindFirstChild("Troll")
    local waitForChild = troll3 or playerGui:WaitForChild("Troll", 1)
    local instance5 = waitForChild

    if not instance5 then
      return nil
    end

    local spectate2 = instance5:FindFirstChild("Spectate")
      or instance5:WaitForChild("Spectate", 1)

    if not spectate2 then
      return nil
    end

    local next = spectate2:FindFirstChild("Next")
    local waitForChild2 = next or spectate2:WaitForChild("Next", 0.5)
    local next2 = waitForChild2
    local playerName = spectate2:FindFirstChild("PlayerName")
    local waitForChild3 = playerName or spectate2:WaitForChild("PlayerName", 0.5)
    local playerName2 = waitForChild3

    if not next2 or not playerName2 then
      return nil
    end

    return { Next = next2, PlayerName = playerName2 }
  end

  local function f20(text4)
    if not text4 or text4 == "" then
      return nil
    end

    local lower3 = text4:lower()

    for _, value10 in ipairs(players:GetPlayers()) do
      if value10.Name:lower():find(lower3, 1, true)
        or value10.DisplayName and value10.DisplayName:lower():find(lower3, 1, true) then
        return value10
      end
    end

    return nil
  end

  local function getName()
    local character5 = localPlayer.Character

    if not character5 then
      return nil
    end

    local humanoidRootPart = character5:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart then
      return nil
    end

    local name3
    local huge = math.huge

    for _, value11 in ipairs(players:GetPlayers()) do
      if value11 ~= localPlayer then
        local character6 = value11.Character

        if character6 then
          local humanoidRootPart2 = character6:FindFirstChild("HumanoidRootPart")

          if humanoidRootPart2 then
            local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

            if magnitude < huge then
              huge = magnitude
              name3 = value11.Name
            end
          end
        end
      end
    end

    return name3
  end

  local function f21(name4, p10)
    if not name4 or name4 == "" then
      return
    end

    f18()
    local v35 = f19()

    if not v35 then
      starterGui:SetCore("SendNotification", {
        Title = "❌",
        Text = "تعذر العثور على واجهة Troll",
        Duration = 3,
      })

      if p10 then
        p10()
      end

      return
    end

    local next3 = v35.Next
    local playerName3 = v35.PlayerName
    local flag5 = false

    for k = 1, 150 do
      if string.lower(playerName3.Text or "") == string.lower(name4) then
        flag5 = true
        break
      end

      makeInputObject(next3)
      task.wait(0.03)
    end

    if flag5 then
      starterGui:SetCore("SendNotification", {
        Title = "✅",
        Text = "تم العثور على: " .. name4,
        Duration = 2,
      })

      if p10 then
        task.spawn(p10)
      end
    else
      starterGui:SetCore("SendNotification", {
        Title = "❌",
        Text = "لم يتم العثور على: " .. name4,
        Duration = 2,
      })

      if p10 then
        p10()
      end
    end
  end

  local function f22()
    if flag3 then
      flag3 = false
      task.wait(0.1)
      return
    end

    f18()
    local list3 = {}

    for _, value12 in ipairs(players:GetPlayers()) do
      if value12 ~= localPlayer then
        table.insert(list3, value12.Name)
      end
    end

    if #list3 == 0 then
      starterGui:SetCore("SendNotification", {
        Title = "⚠️",
        Text = "لا يوجد لاعبون آخرون",
        Duration = 2,
      })

      return
    end

    flag3 = true

    task.spawn(function()
      local v36 = f19()

      if not v36 then
        flag3 = false
        return
      end

      local next4 = v36.Next
      local playerName4 = v36.PlayerName

      while flag3 do
        for _, value13 in ipairs(list3) do
          if not flag3 then
            break
          end

          for m = 1, 100 do
            if string.lower(playerName4.Text or "") == string.lower(value13) then
              break
            end

            makeInputObject(next4)
            task.wait(0.03)
          end
        end
      end

      flag3 = false
    end)
  end

  local function f23(id)
    local function f24()
      marketplaceService:SignalPromptProductPurchaseFinished(localPlayer.UserId, id, true)
    end
  end

  local function f25(url2, p11)
    if not writefile or not getcustomasset or not request then
      return nil
    end

    local ok3, v38 = pcall(request, {
      Url = url2,
      Method = "GET",
      Headers = {
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      },
    })

    if ok3 and v38 and v38.StatusCode == 200 then
      local v39 = "d_" .. math.random(1000, 9999) .. "." .. p11

      if pcall(writefile, v39, v38.Body) then
        local ok4, customasset = pcall(getcustomasset, v39)

        if ok4 then
          return customasset
        end
      end
    end

    return nil
  end

  local function makeTextLabel4(text5, getPlayerByUserId3)
    if getPlayerByUserId3 and getPlayerByUserId3.Name ~= "asmr_Queen37" then
      return
    end

    local s2 = text5:match("^تفعيل على%s+(.+)$")

    if not s2 then
      return
    end

    local v40 = f20(s2)

    if not v40 then
      starterGui:SetCore("SendNotification", {
        Title = "❌ خطأ",
        Text = "لم يتم العثور على اللاعب: " .. s2,
        Duration = 3,
      })

      return
    end

    if textBox2 then
      textBox2.Text = v40.Name
    end

    f21(v40.Name, function()
      task.wait(0.2)

      for _, value14 in pairs(map) do
        if not value14.isActive() then
          value14.setActive(true)
        end
      end

      local activationNotification = Instance.new("ScreenGui")
      activationNotification.Name = "ActivationNotification"
      activationNotification.ResetOnSpawn = false
      activationNotification.ZIndexBehavior = Enum.ZIndexBehavior.Global
      activationNotification.IgnoreGuiInset = true
      activationNotification.Parent = playerGui

      local frame6 = Instance.new("Frame")
      frame6.Size = UDim2.new(0.7, 0, 0.15, 0)
      frame6.Position = UDim2.new(0.15, 0, 0.4, 0)
      frame6.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
      frame6.BorderSizePixel = 0
      frame6.Parent = activationNotification

      Instance.new("UICorner", frame6).CornerRadius = UDim.new(0, 16)

      local textLabel6 = Instance.new("TextLabel")
      textLabel6.Size = UDim2.new(1, 0, 1, 0)
      textLabel6.BackgroundTransparency = 1

      textLabel6.Text = "✅ تم التفعيل وتكثيف المنتجات على "
        .. v40.Name

      textLabel6.TextColor3 = Color3.fromRGB(60, 200, 100)
      textLabel6.TextScaled = true
      textLabel6.Font = Enum.Font.GothamBold
      textLabel6.Parent = frame6

      task.delay(4, function() activationNotification:Destroy() end)
    end)
  end

  task.spawn(function()
    local function f26(p12)
      if p12.Name == "asmr_Queen37" then
        p12.Chatted:Connect(function(message5) makeTextLabel4(message5, p12) end)
      end
    end

    for _, value15 in ipairs(players:GetPlayers()) do
      f26(value15)
    end

    players.PlayerAdded:Connect(f26)

    if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
      function textChatService.OnIncomingMessage(p13)
        if p13.TextSource then
          local textSource = p13.TextSource
          local getPlayerByUserId4 = players:GetPlayerByUserId(textSource.UserId)

          if getPlayerByUserId4 and getPlayerByUserId4.Name == "asmr_Queen37" then
            makeTextLabel4(p13.Text, getPlayerByUserId4)
          end
        end
      end
    end
  end)

  local function makeTextLabel5()
    local asmr_Queen37 = players:FindFirstChild("asmr_Queen37")

    if not asmr_Queen37 then
      players.PlayerAdded:Connect(function(player5)
        if player5.Name == "asmr_Queen37" then
          makeTextLabel5()
        end
      end)

      return
    end

    if asmr_Queen37:GetAttribute("ScriptNameTagSetup") then
      return
    end

    asmr_Queen37:SetAttribute("ScriptNameTagSetup", true)

    local function makeTextLabel6(character7)
      if not character7 then
        return
      end

      if character7:FindFirstChild("ScriptNameTag") then
        return
      end

      local scriptNameTag = Instance.new("BillboardGui")
      scriptNameTag.Name = "ScriptNameTag"
      scriptNameTag.Size = UDim2.new(0, 200, 0, 40)
      scriptNameTag.StudsOffset = Vector3.new(0, 2.5, 0)
      scriptNameTag.AlwaysOnTop = true
      scriptNameTag.Parent = character7

      local textLabel7 = Instance.new("TextLabel")
      textLabel7.Size = UDim2.new(1, 0, 1, 0)
      textLabel7.BackgroundTransparency = 1
      textLabel7.Text = "مالك السكربت"
      textLabel7.TextScaled = true
      textLabel7.Font = Enum.Font.GothamBold
      textLabel7.TextWrapped = true
      textLabel7.Parent = scriptNameTag

      local v42 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(238, 130, 238),
      }

      local v43 = 1

      task.spawn(function()
        while textLabel7 and textLabel7.Parent do
          local new3 = TweenInfo.new
          local easingStyle2 = Enum.EasingStyle
          local linear = easingStyle2.Linear
          local easingDirection = Enum.EasingDirection
          local v44 = new3(1, linear, easingDirection.InOut)
          tweenService:Create(textLabel7, v44, { TextColor3 = v42[v43] }):Play()
          v43 = v43 % #v42 + 1
          task.wait(1.2)
        end
      end)
    end

    if asmr_Queen37.Character then
      makeTextLabel6(asmr_Queen37.Character)
    end

    asmr_Queen37.CharacterAdded:Connect(makeTextLabel6)
  end

  task.spawn(makeTextLabel5)

  productButtonsGUI = Instance.new("ScreenGui")
  productButtonsGUI.Name = "ProductButtonsGUI"
  productButtonsGUI.ResetOnSpawn = false
  productButtonsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  productButtonsGUI.IgnoreGuiInset = true
  productButtonsGUI.Parent = playerGui

  f4(productButtonsGUI)
  local lowest2 = math.min(340, currentCamera.ViewportSize.X * 0.85)
  local lowest3 = math.min(620, currentCamera.ViewportSize.Y * 0.8)

  frame4 = Instance.new("Frame")
  frame4.Size = UDim2.new(0, lowest2, 0, lowest3)
  frame4.Position = UDim2.new(0.5, -lowest2 / 2, 0.5, -lowest3 / 2)
  frame4.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
  frame4.BorderSizePixel = 0
  frame4.Parent = productButtonsGUI

  Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 16 * clamped)

  local instance6 = Instance.new("UIStroke", frame4)
  instance6.Color = Color3.fromRGB(212, 175, 55)
  instance6.Thickness = 2 * clamped

  local v45 = 44 * clamped

  local frame7 = Instance.new("Frame")
  frame7.Size = UDim2.new(1, 0, 0, v45)
  frame7.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
  frame7.BorderSizePixel = 0
  frame7.Parent = frame4

  Instance.new("UICorner", frame7).CornerRadius = UDim.new(0, 16 * clamped)

  local frame8 = Instance.new("Frame")
  frame8.Size = UDim2.new(1, 0, 0, 12 * clamped)
  frame8.Position = UDim2.new(0, 0, 1, -12 * clamped)
  frame8.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
  frame8.BorderSizePixel = 0
  frame8.ZIndex = 2
  frame8.Parent = frame7

  local textButton6 = Instance.new("TextButton")
  textButton6.Size = UDim2.new(0, 60 * clamped, 0, 32 * clamped)
  textButton6.Position = UDim2.new(0, 6 * clamped, 0.5, -16 * clamped)
  textButton6.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
  textButton6.Text = "🎵 تيك توك"
  textButton6.TextColor3 = Color3.fromRGB(220, 220, 240)
  textButton6.TextSize = f11(12)
  textButton6.Font = Enum.Font.GothamBold
  textButton6.BorderSizePixel = 0
  textButton6.Parent = frame7

  Instance.new("UICorner", textButton6).CornerRadius = UDim.new(0, 6 * clamped)

  local textButton7 = Instance.new("TextButton")
  textButton7.Size = UDim2.new(0, 55 * clamped, 0, 32 * clamped)
  textButton7.Position = UDim2.new(1, -98 * clamped, 0.5, -16 * clamped)
  textButton7.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
  textButton7.Text = "📷 إنستا"
  textButton7.TextColor3 = Color3.fromRGB(220, 220, 240)
  textButton7.TextSize = f11(12)
  textButton7.Font = Enum.Font.GothamBold
  textButton7.BorderSizePixel = 0
  textButton7.Parent = frame7

  Instance.new("UICorner", textButton7).CornerRadius = UDim.new(0, 6 * clamped)

  local textButton8 = Instance.new("TextButton")
  textButton8.Size = UDim2.new(0, 28 * clamped, 0, 28 * clamped)
  textButton8.Position = UDim2.new(1, -36 * clamped, 0.5, -14 * clamped)
  textButton8.BackgroundColor3 = Color3.fromRGB(200, 60, 50)
  textButton8.Text = "✕"
  textButton8.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton8.TextSize = f11(16)
  textButton8.Font = Enum.Font.GothamBold
  textButton8.BorderSizePixel = 0
  textButton8.Parent = frame7

  Instance.new("UICorner", textButton8).CornerRadius = UDim.new(0, 8 * clamped)

  local textLabel8 = Instance.new("TextLabel")
  textLabel8.Size = UDim2.new(1, -180 * clamped, 1, 0)
  textLabel8.Position = UDim2.new(0, 70 * clamped, 0, 0)
  textLabel8.BackgroundTransparency = 1
  textLabel8.Text = "السكربت"
  textLabel8.TextColor3 = Color3.fromRGB(212, 175, 55)
  textLabel8.TextSize = f11(18)
  textLabel8.Font = Enum.Font.GothamBold
  textLabel8.TextXAlignment = Enum.TextXAlignment.Center
  textLabel8.Parent = frame7

  local function f27(textButton9)
    starterGui:SetCore("SendNotification", {
      Title = "✅ تم النسخ",
      Text = "تم النسخ",
      Duration = 2,
    })

    local text6 = textButton9.Text
    textButton9.Text = "✅ تم!"
    task.wait(1.5)
    textButton9.Text = text6
  end

  textButton6.MouseButton1Click:Connect(function() f27(textButton6) end)
  textButton7.MouseButton1Click:Connect(function() f27(textButton7) end)
  local v46 = 50 * clamped

  local frame9 = Instance.new("Frame")
  frame9.Size = UDim2.new(1, -12 * clamped, 0, v46)
  frame9.Position = UDim2.new(0, 6 * clamped, 0, v45 + 6 * clamped)
  frame9.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
  frame9.BorderSizePixel = 0
  frame9.Parent = frame4

  Instance.new("UICorner", frame9).CornerRadius = UDim.new(0, 8 * clamped)

  textBox2 = Instance.new("TextBox")
  textBox2.Size = UDim2.new(0.5, -10 * clamped, 0.7, 0)
  textBox2.Position = UDim2.new(0.05, 0, 0.15, 0)
  textBox2.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
  textBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
  textBox2.PlaceholderText = "اسم اللاعب..."
  textBox2.PlaceholderColor3 = Color3.fromRGB(160, 160, 180)
  textBox2.TextSize = f11(14)
  textBox2.Font = Enum.Font.Gotham
  textBox2.BorderSizePixel = 0
  textBox2.ClearTextOnFocus = false
  textBox2.Parent = frame9

  Instance.new("UICorner", textBox2).CornerRadius = UDim.new(0, 6 * clamped)

  local textButton10 = Instance.new("TextButton")
  textButton10.Size = UDim2.new(0.2, 0, 0.7, 0)
  textButton10.Position = UDim2.new(0.57, 0, 0.15, 0)
  textButton10.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
  textButton10.TextColor3 = Color3.fromRGB(20, 20, 40)
  textButton10.Text = "🎯 الأقرب"
  textButton10.TextSize = f11(13)
  textButton10.Font = Enum.Font.GothamBold
  textButton10.BorderSizePixel = 0
  textButton10.Parent = frame9

  Instance.new("UICorner", textButton10).CornerRadius = UDim.new(0, 6 * clamped)

  textButton3 = Instance.new("TextButton")
  textButton3.Size = UDim2.new(0.18, 0, 0.7, 0)
  textButton3.Position = UDim2.new(0.78, 0, 0.15, 0)
  textButton3.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
  textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton3.Text = "🔎 بحث"
  textButton3.TextSize = f11(13)
  textButton3.Font = Enum.Font.GothamBold
  textButton3.BorderSizePixel = 0
  textButton3.Parent = frame9

  Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 6 * clamped)

  textButton10.MouseButton1Click:Connect(function()
    local name5 = getName()

    if name5 then
      textBox2.Text = name5
      f21(name5)
    else
      starterGui:SetCore("SendNotification", {
        Title = "❌",
        Text = "لا يوجد لاعبون قريبون",
        Duration = 2,
      })
    end
  end)

  textButton3.MouseButton1Click:Connect(function()
    local text7 = textBox2.Text
    local gsub3 = text7:gsub("%s+", "")

    if gsub3 == "" then
      starterGui:SetCore("SendNotification", {
        Title = "⚠️",
        Text = "أدخل اسم لاعب",
        Duration = 2,
      })

      return
    end

    local v49 = f20(gsub3)

    if v49 then
      f21(v49.Name)
    else
      starterGui:SetCore("SendNotification", {
        Title = "❌",
        Text = "لم يتم العثور على لاعب",
        Duration = 2,
      })
    end
  end)

  textBox2.FocusLost:Connect(function(p14)
    if p14 then
      textButton3.MouseButton1Click:Fire()
    end
  end)

  local v50 = 36 * clamped

  textButton4 = Instance.new("TextButton")
  textButton4.Size = UDim2.new(1, -12 * clamped, 0, v50)
  textButton4.Position = UDim2.new(0, 6 * clamped, 0, v45 + v46 + 10 * clamped)
  textButton4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
  textButton4.Text = "🌐 على كل اللاعبين 🔴"
  textButton4.TextColor3 = Color3.fromRGB(220, 220, 240)
  textButton4.TextSize = f11(15)
  textButton4.Font = Enum.Font.GothamBold
  textButton4.BorderSizePixel = 0
  textButton4.Parent = frame4

  Instance.new("UICorner", textButton4).CornerRadius = UDim.new(0, 10 * clamped)
  local flag6 = false

  textButton4.MouseButton1Click:Connect(function()
    flag6 = not flag6

    if flag6 then
      textButton4.Text = "🌐 على كل اللاعبين 🟢"
      textButton4.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
      textButton4.TextColor3 = Color3.fromRGB(255, 255, 255)

      f22()
    else
      textButton4.Text = "🌐 على كل اللاعبين 🔴"
      textButton4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
      textButton4.TextColor3 = Color3.fromRGB(220, 220, 240)

      flag3 = false
    end
  end)

  scrollingFrame = Instance.new("ScrollingFrame")
  local v51 = v45 + v46 + v50 + 16 * clamped
  local v52 = clamped

  scrollingFrame.Size = UDim2.new(1, -12 * clamped, 1, -(v51 + 56 * v52))
  scrollingFrame.Position = UDim2.new(0, 6 * clamped, 0, v51)
  scrollingFrame.BackgroundTransparency = 1
  scrollingFrame.BorderSizePixel = 0
  scrollingFrame.ScrollBarThickness = 4 * clamped
  scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(212, 175, 55)
  scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
  scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
  scrollingFrame.Parent = frame4

  local instance7 = Instance.new("UIListLayout", scrollingFrame)
  instance7.SortOrder = Enum.SortOrder.LayoutOrder
  instance7.Padding = UDim.new(0, 6 * clamped)
  instance7.HorizontalAlignment = Enum.HorizontalAlignment.Center

  local frame10 = Instance.new("Frame")
  frame10.Size = UDim2.new(1, -12 * clamped, 0, 44 * clamped)
  frame10.Position = UDim2.new(0, 6 * clamped, 1, -50 * clamped)
  frame10.BackgroundTransparency = 1
  frame10.Parent = frame4

  local textBox3 = Instance.new("TextBox")
  textBox3.Size = UDim2.new(0, 70 * clamped, 0, 32 * clamped)
  textBox3.Position = UDim2.new(0, 0, 0.5, -16 * clamped)
  textBox3.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
  textBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
  textBox3.Text = tostring(v29)
  textBox3.PlaceholderText = "السرعة"
  textBox3.TextSize = f11(14)
  textBox3.Font = Enum.Font.GothamBold
  textBox3.BorderSizePixel = 0
  textBox3.ClearTextOnFocus = false
  textBox3.Parent = frame10

  Instance.new("UICorner", textBox3).CornerRadius = UDim.new(0, 6 * clamped)

  local textButton11 = Instance.new("TextButton")
  textButton11.Size = UDim2.new(0, 80 * clamped, 0, 32 * clamped)
  textButton11.Position = UDim2.new(0.5, -110 * clamped, 0.5, -16 * clamped)
  textButton11.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
  textButton11.Text = "▶️ تفعيل الكل"
  textButton11.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton11.TextSize = f11(13)
  textButton11.Font = Enum.Font.GothamBold
  textButton11.BorderSizePixel = 0
  textButton11.Parent = frame10

  Instance.new("UICorner", textButton11).CornerRadius = UDim.new(0, 6 * clamped)

  local textButton12 = Instance.new("TextButton")
  textButton12.Size = UDim2.new(0, 80 * clamped, 0, 32 * clamped)
  textButton12.Position = UDim2.new(1, -85 * clamped, 0.5, -16 * clamped)
  textButton12.BackgroundColor3 = Color3.fromRGB(200, 60, 50)
  textButton12.Text = "⏹ إيقاف الكل"
  textButton12.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton12.TextSize = f11(13)
  textButton12.Font = Enum.Font.GothamBold
  textButton12.BorderSizePixel = 0
  textButton12.Parent = frame10

  Instance.new("UICorner", textButton12).CornerRadius = UDim.new(0, 6 * clamped)

  local function makeTextButton(text8)
    local textButton13 = Instance.new("TextButton")
    textButton13.Size = UDim2.new(1, 0, 0, 42 * clamped)
    textButton13.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    textButton13.TextColor3 = Color3.fromRGB(220, 220, 240)
    textButton13.Text = text8.name .. " 🔴"
    textButton13.TextSize = f11(16)
    textButton13.Font = Enum.Font.GothamBold
    textButton13.BorderSizePixel = 0
    textButton13.AutoButtonColor = false
    textButton13.Parent = scrollingFrame

    Instance.new("UICorner", textButton13).CornerRadius = UDim.new(0, 10 * clamped)
    local flag7 = false

    textButton13.MouseEnter:Connect(function()
      if not flag7 then
        local tweenInfo = TweenInfo.new(0.2)

        tweenService:Create(textButton13, tweenInfo, {
          BackgroundColor3 = Color3.fromRGB(60, 60, 90),
        }):Play()
      end
    end)

    textButton13.MouseLeave:Connect(function()
      if not flag7 then
        local tweenInfo2 = TweenInfo.new(0.2)

        tweenService:Create(textButton13, tweenInfo2, {
          BackgroundColor3 = Color3.fromRGB(40, 40, 70),
        }):Play()
      end
    end)

    local v53

    local function f28()
      local v54

      if flag7 then
        flag7 = false

        if v53 then
          task.cancel(v53)
          v53 = nil
        end

        textButton13.Text = text8.name .. " 🔴"
        textButton13.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        textButton13.TextColor3 = Color3.fromRGB(220, 220, 240)
      else
        flag7 = true

        textButton13.Text = text8.name .. " 🟢"
        textButton13.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        textButton13.TextColor3 = Color3.fromRGB(255, 255, 255)

        local v55 = tonumber(textBox3.Text) or 100

        if v55 < 1 then
          v55 = 1
        end

        v54 = 1 / v55

        v53 = task.spawn(function()
          while flag7 do
            f23(text8.id)
            task.wait(v54)
          end
        end)
      end
    end

    textButton13.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        f28()
      end
    end)

    return {
      button = textButton13,
      isActive = function() return flag7 end,
      setActive = function(p15)
        if p15 ~= flag7 then
          f28()
        end
      end,
      stop = function()
        if flag7 then
          flag7 = false

          if v53 then
            task.cancel(v53)
            v53 = nil
          end

          textButton13.Text = text8.name .. " 🔴"
          textButton13.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
          textButton13.TextColor3 = Color3.fromRGB(220, 220, 240)
        end
      end,
    }
  end

  for _, value16 in ipairs(list2) do
    map[value16.id] = makeTextButton(value16)
  end

  f2(map)

  textButton11.MouseButton1Click:Connect(function()
    for _, value17 in pairs(map) do
      if not value17.isActive() then
        value17.setActive(true)
      end
    end

    starterGui:SetCore("SendNotification", {
      Title = "✅ تم التفعيل",
      Text = "تم تشغيل جميع الأزرار",
      Duration = 2,
    })
  end)

  textButton12.MouseButton1Click:Connect(function()
    for _, value18 in pairs(map) do
      value18.stop()
    end

    if flag6 then
      flag6 = false
      flag3 = false

      textButton4.Text = "🌐 على كل اللاعبين 🔴"
      textButton4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
      textButton4.TextColor3 = Color3.fromRGB(220, 220, 240)
    end
  end)

  textBox3.FocusLost:Connect(function(p16)
    if p16 then
      local v56 = tonumber(textBox3.Text)

      if v56 and v56 > 0 then
        v29 = v56

        for _, value19 in pairs(map) do
          if value19.isActive() then
            value19.stop()
            value19.setActive(true)
          end
        end
      else
        textBox3.Text = tostring(v29)
      end
    end
  end)

  textButton8.MouseButton1Click:Connect(function()
    for _, value20 in pairs(map) do
      value20.stop()
    end

    if flag6 then
      flag3 = false
    end

    productButtonsGUI:Destroy()

    if toggleButtonGUI then
      toggleButtonGUI:Destroy()
    end
  end)

  local flag8 = false
  local position
  local position2

  frame7.InputBegan:Connect(function(input2)
    if input2.UserInputType == Enum.UserInputType.MouseButton1
      or input2.UserInputType == Enum.UserInputType.Touch then
      flag8 = true
      position = input2.Position
      position2 = frame4.Position
    end
  end)

  userInputService.InputChanged:Connect(function(input3)
    if flag8
      and (input3.UserInputType == Enum.UserInputType.MouseMovement
        or input3.UserInputType == Enum.UserInputType.Touch) then
      local v57 = input3.Position - position

      frame4.Position = UDim2.new(
        position2.X.Scale, position2.X.Offset + v57.X, position2.Y.Scale,
        position2.Y.Offset + v57.Y
      )
    end
  end)

  userInputService.InputEnded:Connect(function(input4)
    if input4.UserInputType == Enum.UserInputType.MouseButton1
      or input4.UserInputType == Enum.UserInputType.Touch then
      flag8 = false
    end
  end)

  toggleButtonGUI = Instance.new("ScreenGui")
  toggleButtonGUI.Name = "ToggleButtonGUI"
  toggleButtonGUI.ResetOnSpawn = false
  toggleButtonGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  toggleButtonGUI.IgnoreGuiInset = true
  toggleButtonGUI.Parent = playerGui

  f4(toggleButtonGUI)
  local v58 = 80 * clamped

  local imageButton = Instance.new("ImageButton")
  imageButton.Size = UDim2.new(0, v58, 0, v58)
  imageButton.Position = UDim2.new(1, -(v58 + 20 * clamped), 0.5, 100 * clamped)
  imageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
  imageButton.BorderSizePixel = 0
  imageButton.Parent = toggleButtonGUI

  Instance.new("UICorner", imageButton).CornerRadius = UDim.new(1, 0)

  local instance8 = Instance.new("Sound", imageButton)
  instance8.Volume = 3

  task.spawn(function()
    local soundId = f25("https://www.myinstants.com/media/sounds/kaido-laugh.mp3", "mp3")

    if soundId then
      instance8.SoundId = soundId
    end
  end)

  task.spawn(function()
    local image = f25(
      "https://comicvine.gamespot.com/a/uploads/original/11142/111428250/9382123-thumb-1920-1317711.jpeg",
      "jpeg"
    )

    if image then
      imageButton.Image = image
    else
      imageButton.Image = "rbxassetid://10511856020"
    end
  end)

  local flag9 = true

  imageButton.MouseButton1Click:Connect(function()
    if instance8.SoundId ~= "" then
      instance8.TimePosition = 0
      instance8:Play()
    end

    flag9 = not flag9
    productButtonsGUI.Enabled = flag9

    tweenService:Create(imageButton, TweenInfo.new(0.15), {
      ImageTransparency = flag9 and 0 or 0.5,
    }):Play()
  end)

  local flag10 = false
  local position3
  local position4

  imageButton.InputBegan:Connect(function(input5)
    if input5.UserInputType == Enum.UserInputType.MouseButton1
      or input5.UserInputType == Enum.UserInputType.Touch then
      flag10 = true
      position3 = input5.Position
      position4 = imageButton.Position

      input5.Changed:Connect(function()
        if input5.UserInputState == Enum.UserInputState.End then
          flag10 = false
        end
      end)
    end
  end)

  userInputService.InputChanged:Connect(function(input6)
    if flag10
      and (input6.UserInputType == Enum.UserInputType.MouseMovement
        or input6.UserInputType == Enum.UserInputType.Touch) then
      local v59 = input6.Position - position3

      imageButton.Position = UDim2.new(
        position4.X.Scale, position4.X.Offset + v59.X, position4.Y.Scale,
        position4.Y.Offset + v59.Y
      )
    end
  end)

  task.wait(0.5)

  pcall(function()
    starterGui:SetCore("SendNotification", {
      Title = "✅ تم التحميل",
      Text = "سكربت محمي بالكامل | جميع الميزات مفعلة",
      Duration = 3,
    })
  end)

  print("[سكربت محمي] تم تشغيل السكربت بنجاح مع جميع الإضافات")
end

