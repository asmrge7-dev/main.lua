-- BEKA build | edited from the supplied source

local function f1(p1)
  local v1 = p1

  return setmetatable(p1, {
    __index = p1,
    __newindex = function()
      error("محاولة تعديل جدول محميء", 2)
      return
    end,
    __metatable = false,
  })
end

do
end

local players = (game:GetService("Players"))

do
end

local starterGui = (game:GetService("StarterGui"))

do
end

local httpService = (game:GetService("HttpService"))

do
end

local userInputService = (game:GetService("UserInputService"))

do
end

local tweenService = (game:GetService("TweenService"))

do
end

local textChatService = (game:GetService("TextChatService"))
local v2 = game
local v3, v4, v5, v6
v2:GetService("ReplicatedStorage")

do
end

local runService = (game:GetService("RunService"))
local localPlayer = players.LocalPlayer
local v7 = localPlayer
local playerGui = (localPlayer:WaitForChild("PlayerGui"))

local function f2(p2)
  local v8 = p2
  local v9 = false
  local destroying = p2.Destroying
  local v10, v11

  destroying:Connect(function()
    v9 = true
    return
  end)

  local function f3()
    local v12

    if v9 then
      return
    else
      local v13
      v13 = p2

      do
      end

      if p2 and p2.Parent == nil then
        p2.Parent = playerGui
        warn("[حماية] تم إعادة إلحاق الواجهةخ")
      end

      return
    end
  end

  do
  end

  p2.AncestryChanged:Connect(f3)

  do
  end

  runService.Heartbeat:Connect(f3)
  return
end

local currentCamera = workspace.CurrentCamera
local v14 = false
local v15

local function f4(p3)
  local v16 = p3

  for index, value in ipairs(v15) do
    if value == p3 then
      return true
    end
  end

  return false
end

local function f5()
  local viewportSize = currentCamera.ViewportSize
  local v17 = math.min(viewportSize.X / 800, viewportSize.Y / 600)
  return math.clamp(v17, 0.35, 2)
end

v15 = {}
local f6

local function f7(p4)
  local v18 = p4

  for index2, value2 in ipairs(v15) do
    if value2 == p4 then
      return
    end
  end

  table.insert(v15, p4)
  f6(v15)
  return
end

function f6(p5)
  local v19 = p5

  if not writefile then
    return
  else
    local v20
    v20 = httpService

    httpService:JSONEncode(p5)
    return
  end
end

local function f8()
  local v21, v22

  if not readfile then
    return {}
  else
    local v23
    v23 = { pcall(function() return readfile("banned_players.json") end) }

    local v24
    v24 = v23[2]

    do
    end

    do
    end

    if not v23[1] or not v24 then
      return {}
    else
      local v25
      v25 = httpService

      local jsonDecode
      jsonDecode = httpService:JSONDecode(v24)

      if (type(jsonDecode)) ~= "table" then
        return {}
      else
        return jsonDecode
      end
    end
  end
end

local v26 = f7
local v27 = f4
v15 = (f8())
local v28 = f5
local v29 = (f5())

local function f9(p6)
  return p6 * v29
end

local function f10(p7, p8)
  return UDim2.new(0, p7 * v29, 0, p8 * v29)
end

local v30 = f1
local v31 = f2
-- Old remote key URL removed.

do
end

task.spawn(function()
  local welcomeScreen = Instance.new("ScreenGui")
  local v32, v33

  welcomeScreen.Name = "WelcomeScreen"
  welcomeScreen.ResetOnSpawn = false
  welcomeScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
  welcomeScreen.IgnoreGuiInset = true
  welcomeScreen.Parent = playerGui

  local instance = Instance.new("BlurEffect", game.Lighting)
  instance.Size = 20

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(1, 0, 1, 0)
  frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  frame.BackgroundTransparency = 0.5
  frame.Parent = welcomeScreen

  local textLabel = Instance.new("TextLabel")
  textLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
  textLabel.Position = UDim2.new(0.1, 0, 0.35, 0)
  textLabel.BackgroundTransparency = 1
  textLabel.Text = "تم تشغيل سكربت BEKA"
  textLabel.TextColor3 = Color3.fromRGB(212, 175, 55)
  textLabel.TextScaled = true
  textLabel.Font = Enum.Font.GothamBold
  textLabel.TextWrapped = true
  textLabel.Parent = welcomeScreen

  local v34 = tweenService

  do
  end

  ;(tweenService:Create(
    textLabel, (TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)),
    { Rotation = 5 }
  )):Play()

  task.wait(0.2)
  local v35 = tweenService

  do
  end

  ;(tweenService:Create(
    textLabel, (TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)),
    { Rotation = -5 }
  )):Play()

  task.wait(5)
  welcomeScreen:Destroy()
  instance:Destroy()
  return
end)

task.wait(1.5)

-- Key gate removed for the BEKA build.
v14 = true

function startMain()
  local v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57,
    v58, v59, v60, v61, v62, v63, v64, v65, productButtonsGUI, frame4, textBox2, textButton3,
    textButton4, scrollingFrame, toggleButtonGUI, v66, v67, f13, f14, f15, f16, f17, f18, f19,
    f20, f21, f22, f23, f24, f25, f26, f27, f28, textButton5, textButton6, f29, v68, textBox3,
    v69, position, position2, imageButton, instance3, v70, v71, position3, position4

  if not v14 then
    warn("[أمان] محاولة تشغيل st١rtٍ١٩n بدون التحقق EF المفتاحء تم الرفضخ")
    return
  else
    v29 = (f5())

    local v72
    v72 = playerGui

    if (playerGui:FindFirstChild("ProductButtonsGUI")) then
      do
      end

      playerGui.ProductButtonsGUI:Destroy()
    end

    local v73
    v73 = playerGui

    if (playerGui:FindFirstChild("ToggleButtonGUI")) then
      do
      end

      playerGui.ToggleButtonGUI:Destroy()
    end

    do
    end

    game:GetService("MarketplaceService")

    local v74

    v74 = f1({
      { id = 3583915043, name = "تطير" }, { id = 3583917391, name = "B*D" },
      { id = 3583919159, name = "تبطيء" }, { id = 3583916429, name = "تجميد" },
      { id = 3583918502, name = "اهتزاز" }, { id = 3583915955, name = "حرق" },
    })

    v64 = 100
    v65 = false
    productButtonsGUI = nil
    frame4 = nil
    textBox2 = nil
    textButton3 = nil
    textButton4 = nil
    scrollingFrame = nil
    toggleButtonGUI = nil
    v66 = {}

    task.spawn(function()
      task.wait(1)
      return
    end)

    task.spawn(function()
      while true do
        task.wait(60)
      end
    end)

    v67 = {}

    function f13(p10)
      local v75 = p10
      local v76, f30

      if v67[p10] then
        return v67[p10]
      else
        function f30(p11)
          local v77 = p11

          if not p11 then
            return
          else
            local billboardGui
            billboardGui = Instance.new("BillboardGui")
            billboardGui.Size = UDim2.new(0, 200, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = p11

            local textLabel4
            textLabel4 = Instance.new("TextLabel")
            textLabel4.Size = UDim2.new(1, 0, 1, 0)
            textLabel4.BackgroundTransparency = 1
            textLabel4.Text = "ما تقدر تشوف شاته يستخدم نفس السكربت"
            textLabel4.TextColor3 = Color3.fromRGB(255, 0, 0)
            textLabel4.TextScaled = true
            textLabel4.Font = Enum.Font.GothamBold
            textLabel4.TextWrapped = true
            textLabel4.Parent = billboardGui

            v67[p10] = { billboard = billboardGui, label = textLabel4 }
            return billboardGui
          end
        end

        local character
        character = p10.Character

        if character then
          f30(character)
        end

        do
        end

        p10.CharacterAdded:Connect(function(character2)
          local v78 = character2

          if v67[p10] then
            pcall(function()
              do
              end

              v67[p10].billboard:Destroy()
              return
            end)

            v67[p10] = nil
          end

          f30(character2)
          return
        end)

        return v67[p10]
      end
    end

    function f14(p12)
      local v79 = p12

      if p12 == localPlayer then
        f7(p12.Name)
        f13(p12)
        task.wait(0.2)
        p12:Destroy()
        return
      else
        f7(p12.Name)
        f13(p12)
        p12:Destroy()
        print("تم إزالة اللاعبغ " .. p12.Name)
        return
      end
    end

    do
    end

    local v80
    v80 = players

    for index3, value3 in ipairs(players:GetPlayers()) do
      local v81 = value3

      local v82
      v82 = v81 ~= localPlayer

      local v83
      v83 = v82

      do
      end

      if v82 and f4(v81.Name) then
        task.spawn(function()
          task.wait(0.5)
          f14(v81)
          return
        end)
      end
    end

    do
    end

    players.PlayerAdded:Connect(function(player)
      local v84 = player

      if player == localPlayer then
        return
      else
        if (f4(player.Name)) then
          task.wait(0.5)
          f14(player)
        end

        return
      end
    end)

    function f15(p13, p14)
      local v85 = p14
      local v86 = p13
      local v87, v88

      if p13 == localPlayer then
        return
      else
        do
        end

        local lower
        lower = (p14:gsub("إsث", "")):lower()

        for index4, value4 in ipairs({}) do
          do
          end

          if lower == ((value4:gsub("إsث", "")):lower()) then
            f14(p13)
            break
          end
        end

        return
      end
    end

    local v89
    v89 = players

    for index5, value5 in ipairs(players:GetPlayers()) do
      local v90 = value5

      if v90 ~= localPlayer then
        do
        end

        v90.Chatted:Connect(function(message)
          f15(v90, message)
          return
        end)
      end
    end

    do
    end

    players.PlayerAdded:Connect(function(player2)
      local v91 = player2
      local v92

      if player2 ~= localPlayer then
        do
        end

        player2.Chatted:Connect(function(message2)
          f15(player2, message2)
          return
        end)
      end

      return
    end)

    function f16(p15, p16)
      local v93 = p15
      local v94 = p16
      local v95 = p16
      local v96, v97, v98, v99

      do
      end

      local kickNotification

      if p16 and p16.Name ~= "asmr_3134" then
        return
      else
        local s
        s = p15:match("^طرد%s+(.+)$")

        if not s then
          return
        else
          local v100
          v100 = nil

          local lower2
          lower2 = s:lower()

          local v101
          v101 = players

          for index6, value6 in ipairs(players:GetPlayers()) do
            do
            end

            do
            end

            local find
            find = (value6.Name:lower()):find(lower2, 1, true)

            local v102
            v102 = find

            if not find then
              local displayName
              displayName = value6.DisplayName

              local find2
              find2 = displayName

              if displayName then
                do
                end

                do
                end

                find2 = (value6.DisplayName:lower()):find(lower2, 1, true)
              end

              v102 = find2
            end

            if v102 then
              v100 = value6
              break
            end
          end

          if not v100 then
            local v103
            v103 = starterGui

            starterGui:SetCore("SendNotification", {
              Title = "L خطأ",
              Text = "DE يتم العثور على اللاعبغ " .. s,
              Duration = 3,
            })

            return
          else
            f14(v100)

            kickNotification = (Instance.new("ScreenGui"))
            kickNotification.Name = "KickNotification"
            kickNotification.ResetOnSpawn = false
            kickNotification.ZIndexBehavior = Enum.ZIndexBehavior.Global
            kickNotification.IgnoreGuiInset = true
            kickNotification.Parent = playerGui

            local frame5
            frame5 = Instance.new("Frame")
            frame5.Size = UDim2.new(0.6, 0, 0.12, 0)
            frame5.Position = UDim2.new(0.2, 0, 0.42, 0)
            frame5.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            frame5.BorderSizePixel = 0
            frame5.Parent = kickNotification

            ;(Instance.new("UICorner", frame5)).CornerRadius = UDim.new(0, 12)

            local textLabel5
            textLabel5 = Instance.new("TextLabel")
            textLabel5.Size = UDim2.new(1, 0, 1, 0)
            textLabel5.BackgroundTransparency = 1
            textLabel5.Text = "� تم طرد " .. v100.Name .. " EF بواسطة BEKA"
            textLabel5.TextColor3 = Color3.fromRGB(255, 80, 80)
            textLabel5.TextScaled = true
            textLabel5.Font = Enum.Font.GothamBold
            textLabel5.Parent = frame5

            task.delay(4, function()
              local v104 = kickNotification
              kickNotification:Destroy()
              return
            end)

            return
          end
        end
      end
    end

    do
    end

    task.spawn(function()
      local function f31(p17)
        local v105 = p17
        local v106

        if p17.Name == "asmr_3134" then
          do
          end

          p17.Chatted:Connect(function(message3)
            f16(message3, p17)
            return
          end)
        end

        return
      end

      local v107 = players
      local v108

      for index7, value7 in ipairs(players:GetPlayers()) do
        f31(value7)
      end

      do
      end

      players.PlayerAdded:Connect(f31)

      if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        function textChatService.OnIncomingMessage(p18)
          local v109 = p18
          local v110

          if p18.TextSource then
            local v111
            v111 = players

            local getPlayerByUserId
            getPlayerByUserId = players:GetPlayerByUserId(p18.TextSource.UserId)

            do
            end

            if getPlayerByUserId and getPlayerByUserId.Name == "asmr_3134" then
              f16(p18.Text, getPlayerByUserId)
            end
          end

          return
        end
      end

      return
    end)

    function f17()
      local v112 = localPlayer
      local v113 = localPlayer
      local v114

      do
      end

      if localPlayer and localPlayer.Character then
        do
        end

        return localPlayer.Character:FindFirstChildOfClass("Humanoid")
      else
        return nil
      end
    end

    local v115
    v115 = f17()

    if v115 then
      currentCamera.CameraType = Enum.CameraType.Custom
      currentCamera.CameraSubject = v115
    end

    local v116
    v116 = currentCamera

    do
    end

    ;(currentCamera:GetPropertyChangedSignal("CameraSubject")):Connect(function()
      local v117 = f17()
      local v118 = v117

      do
      end

      if v117 and currentCamera.CameraSubject ~= v117 then
        currentCamera.CameraSubject = v117
      end

      return
    end)

    function f18(p19)
      local v119 = p19
      local v120, v121, v122

      if not p19 then
        return
      else
        for index8, value8 in ipairs({
          "Activated", "MouseButton1Click", "MouseButton1Up", "TouchTap",
        }) do
          local v123
          v123 = p19

          do
          end

          do
          end

          if (p19:FindFirstChild(value8)) or p19[value8] then
            local v124
            v124 = ipairs

            local v125
            v125 = getconnections

            local v126
            v126 = p19[value8]

            local findFirstChild
            findFirstChild = v126

            if not v126 then
              local v127
              v127 = p19
              findFirstChild = p19:FindFirstChild(value8)
            end

            for v128, v129 in v124(v125(findFirstChild)) do
              v129:Fire()
            end
          end
        end

        pcall(function()
          if p19.Click then
            local v130
            v130 = p19
            p19:Click()
          end

          if p19.Activated then
            local v131
            v131 = p19
            p19:Fire("Activated")
          end

          return
        end)

        local v132
        v132 = p19

        local clickDetector
        clickDetector = p19:FindFirstChild("ClickDetector")

        local clickDetector2
        clickDetector2 = clickDetector

        if not clickDetector then
          local v133
          v133 = p19
          clickDetector2 = p19:FindFirstChildWhichIsA("ClickDetector")
        end

        v122 = clickDetector2

        if v122 then
          pcall(function()
            local v134 = v122
            local character3 = localPlayer.Character
            local humanoidRootPart = character3
            local v135

            if character3 then
              do
              end

              humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            end

            local v136 = v122
            v122:FireClick(humanoidRootPart)
            return
          end)
        end

        local v137
        v137 = p19

        if (p19:IsA("GuiButton")) then
          pcall(function()
            local inputObject = Instance.new("InputObject")
            inputObject.Type = Enum.UserInputType.MouseButton1
            inputObject.UserInputState = Enum.UserInputState.Begin

            local v138 = p19
            p19:InputBegan(inputObject)
            task.wait(0.05)
            inputObject.UserInputState = Enum.UserInputState.End
            local v139 = p19
            p19:InputEnded(inputObject)
            return
          end)
        end

        return
      end
    end

    function f19()
      local v140 = playerGui
      local troll = playerGui:FindFirstChild("Troll")

      if troll then
        local troll2
        troll2 = troll:FindFirstChild("Troll")

        if troll2 then
          local trollBtn
          trollBtn = troll2:FindFirstChild("TrollBtn")

          if trollBtn then
            f18(trollBtn)
          end
        end

        local spectate
        spectate = troll:FindFirstChild("Spectate")

        if spectate then
          local close
          close = spectate:FindFirstChild("Close")

          if close then
            local textButton7
            textButton7 = close:FindFirstChild("TextButton")

            if textButton7 then
              f18(textButton7)
            end
          end
        end
      end

      return
    end

    function f20()
      local v141 = playerGui
      local troll3 = playerGui:FindFirstChild("Troll")
      local waitForChild = troll3
      local v142, v143

      if not troll3 then
        local v144
        v144 = playerGui
        waitForChild = playerGui:WaitForChild("Troll", 1)
      end

      local v145 = waitForChild

      if not v145 then
        return nil
      else
        local spectate2
        spectate2 = v145:FindFirstChild("Spectate")

        local v146
        v146 = spectate2

        do
        end

        local waitForChild2
        waitForChild2 = spectate2 or v145:WaitForChild("Spectate", 1)

        if not waitForChild2 then
          return nil
        else
          local next
          next = waitForChild2:FindFirstChild("Next")

          local v147
          v147 = next

          do
          end

          local waitForChild3
          waitForChild3 = next or waitForChild2:WaitForChild("Next", 0.5)

          local playerName
          playerName = waitForChild2:FindFirstChild("PlayerName")

          local v148
          v148 = playerName

          do
          end

          local waitForChild4
          waitForChild4 = playerName or waitForChild2:WaitForChild("PlayerName", 0.5)

          do
          end

          do
          end

          if not waitForChild3 or not waitForChild4 then
            return nil
          else
            return { Next = waitForChild3, PlayerName = waitForChild4 }
          end
        end
      end
    end

    function f21(p20)
      local v149 = p20
      local v150 = not p20
      local v151 = v150
      local v152, v153, v154, v155

      do
      end

      if v150 or p20 == "" then
        return nil
      else
        local lower3
        lower3 = p20:lower()

        local v156
        v156 = players

        for index9, value9 in ipairs(players:GetPlayers()) do
          do
          end

          do
          end

          local find3
          find3 = (value9.Name:lower()):find(lower3, 1, true)

          local v157
          v157 = find3

          if not find3 then
            local displayName2
            displayName2 = value9.DisplayName

            local find4
            find4 = displayName2

            if displayName2 then
              do
              end

              do
              end

              find4 = (value9.DisplayName:lower()):find(lower3, 1, true)
            end

            v157 = find4
          end

          if v157 then
            return value9
          end
        end

        return nil
      end
    end

    function f22()
      local character4 = localPlayer.Character

      if not character4 then
        return nil
      else
        local humanoidRootPart2
        humanoidRootPart2 = character4:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart2 then
          return nil
        else
          local name
          name = nil

          local huge
          huge = math.huge

          local v158
          v158 = players

          for index10, value10 in ipairs(players:GetPlayers()) do
            if value10 ~= localPlayer then
              local character5
              character5 = value10.Character

              if character5 then
                local humanoidRootPart3
                humanoidRootPart3 = character5:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart3 then
                  local magnitude
                  magnitude = (humanoidRootPart2.Position - humanoidRootPart3.Position).Magnitude

                  if magnitude < huge then
                    huge = magnitude
                    name = value10.Name
                  end
                end
              end
            end
          end

          return name
        end
      end
    end

    function f23(p21, p22)
      local v159 = p22
      local v160 = p21
      local v161 = not p21
      local v162 = v161
      local v163, v164, v165

      do
      end

      if v161 or p21 == "" then
        return
      else
        f19()

        local v166
        v166 = f20()

        if not v166 then
          local v167
          v167 = starterGui

          starterGui:SetCore("SendNotification", {
            Title = "L",
            Text = "تعذر العثور على واجهة Troll",
            Duration = 3,
          })

          if p22 then
            p22()
          end

          return
        else
          local next2
          next2 = v166.Next

          local playerName2
          playerName2 = v166.PlayerName

          local v168
          v168 = false

          local v169
          v169 = 0

          while true do
            v169 = 1 + v169

            if not (v169 <= 150) then
              break
            end

            local lower4
            lower4 = string.lower

            do
            end

            do
            end

            do
            end

            if (lower4(playerName2.Text or "")) == (string.lower(p21)) then
              v168 = true
              break
            else
              f18(next2)
              task.wait(0.03)
            end
          end

          if v168 then
            local v170
            v170 = starterGui

            starterGui:SetCore("SendNotification", {
              Title = "",
              Text = "تم العثور علىغ " .. p21,
              Duration = 2,
            })

            if p22 then
              task.spawn(p22)
            end
          else
            local v171
            v171 = starterGui

            starterGui:SetCore("SendNotification", {
              Title = "L",
              Text = "DE يتم العثور علىغ " .. p21,
              Duration = 2,
            })

            if p22 then
              p22()
            end
          end

          return
        end
      end
    end

    function f24()
      local v172

      if v65 then
        v65 = false
        task.wait(0.1)
        return
      else
        f19()
        v172 = {}

        local v173
        v173 = players

        for index11, value11 in ipairs(players:GetPlayers()) do
          if value11 ~= localPlayer then
            table.insert(v172, value11.Name)
          end
        end

        if #v172 == 0 then
          local v174
          v174 = starterGui

          starterGui:SetCore("SendNotification", {
            Title = "�",
            Text = "لا يوجد لاعبون",
            Duration = 2,
          })

          return
        else
          v65 = true

          task.spawn(function()
            local v175 = f20()
            local v176, v177, v178

            if not v175 then
              v65 = false
              return
            else
              local next3
              next3 = v175.Next

              local playerName3
              playerName3 = v175.PlayerName

              while v65 do
                for index12, value12 in ipairs(v172) do
                  if not v65 then
                    break
                  else
                    local v179
                    v179 = 0

                    while true do
                      v179 = 1 + v179

                      if not (100 >= v179) then
                        break
                      end

                      local lower5
                      lower5 = string.lower

                      do
                      end

                      do
                      end

                      do
                      end

                      if (lower5(playerName3.Text or "")) == (string.lower(value12)) then
                        break
                      else
                        f18(next3)
                        task.wait(0.03)
                      end
                    end
                  end
                end
              end

              v65 = false
              return
            end
          end)

          return
        end
      end
    end

    function f25(p23)
      return
    end

    -- Delta-friendly asset fallback. No remote key or downloaded code is used.
    function f26(assetUrl, extension)
      return nil
    end

    -- Secondary administrator command: type "!activate playername" as asmr_3134.
    local function f27(message, sender)
      if sender and sender.Name ~= "asmr_3134" then
        return
      end

      local targetName = tostring(message or ""):match("^!activate%s+(.+)$")
      if not targetName then
        return
      end

      local target = f21(targetName)
      if not target then
        pcall(function()
          starterGui:SetCore("SendNotification", {
            Title = "BEKA",
            Text = "ما لكيت اللاعب: " .. targetName,
            Duration = 3,
          })
        end)
        return
      end

      if textBox2 then
        textBox2.Text = target.Name
      end

      f23(target.Name, function()
        for _, action in pairs(v66) do
          if not action.isActive() then
            action.setActive(true)
          end
        end
      end)
    end

    local function connectBekaAdmin(player)
      if player.Name == "asmr_3134" then
        player.Chatted:Connect(function(message)
          f27(message, player)
        end)
      end
    end

    for _, player in ipairs(players:GetPlayers()) do
      connectBekaAdmin(player)
    end
    players.PlayerAdded:Connect(connectBekaAdmin)

    -- Main BEKA interface.
    productButtonsGUI = Instance.new("ScreenGui")
    productButtonsGUI.Name = "ProductButtonsGUI"
    productButtonsGUI.ResetOnSpawn = false
    productButtonsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    productButtonsGUI.IgnoreGuiInset = true
    productButtonsGUI.Parent = playerGui
    f2(productButtonsGUI)

    local v216 = math.min(340, currentCamera.ViewportSize.X * 0.85)
    local v217 = math.min(620, currentCamera.ViewportSize.Y * 0.8)
    local v218 = 50 * v29
    local v221 = 50 * v29
    local v228 = 36 * v29

    frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(0, v216, 0, v217)
    frame4.Position = UDim2.new(0.5, -v216 / 2, 0.5, -v217 / 2)
    frame4.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame4.BorderSizePixel = 0
    frame4.Parent = productButtonsGUI
    Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 16 * v29)

    local instance4 = Instance.new("UIStroke", frame4)
    instance4.Color = Color3.fromRGB(212, 175, 55)
    instance4.Thickness = 2 * v29

    local frame6 = Instance.new("Frame")
    frame6.Size = UDim2.new(1, 0, 0, v218)
    frame6.Position = UDim2.new(0, 0, 0, 0)
    frame6.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    frame6.BorderSizePixel = 0
    frame6.Parent = frame4
    Instance.new("UICorner", frame6).CornerRadius = UDim.new(0, 12 * v29)

    local frame7 = Instance.new("Frame")
    frame7.Size = UDim2.new(1, 0, 0, 42 * v29)
    frame7.Position = UDim2.new(0, 0, 0, 0)
    frame7.BackgroundTransparency = 1
    frame7.BorderSizePixel = 0
    frame7.Parent = frame6

    textButton5 = Instance.new("TextButton")
    textButton5.Size = UDim2.new(0, 60 * v29, 0, 32 * v29)
    textButton5.Position = UDim2.new(0, 6 * v29, 0.5, -16 * v29)
    textButton5.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    textButton5.Text = "BEKA"
    textButton5.TextColor3 = Color3.fromRGB(220, 220, 240)
    textButton5.TextSize = f9(12)
    textButton5.Font = Enum.Font.GothamBold
    textButton5.BorderSizePixel = 0
    textButton5.Parent = frame7
    Instance.new("UICorner", textButton5).CornerRadius = UDim.new(0, 6 * v29)

    textButton6 = Instance.new("TextButton")
    textButton6.Size = UDim2.new(0, 55 * v29, 0, 32 * v29)
    textButton6.Position = UDim2.new(1, -98 * v29, 0.5, -16 * v29)
    textButton6.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    textButton6.Text = "إخفاء"
    textButton6.TextColor3 = Color3.fromRGB(220, 220, 240)
    textButton6.TextSize = f9(12)
    textButton6.Font = Enum.Font.GothamBold
    textButton6.BorderSizePixel = 0
    textButton6.Parent = frame7
    Instance.new("UICorner", textButton6).CornerRadius = UDim.new(0, 6 * v29)

    local textButton8 = Instance.new("TextButton")
    textButton8.Size = UDim2.new(0, 28 * v29, 0, 28 * v29)
    textButton8.Position = UDim2.new(1, -36 * v29, 0.5, -14 * v29)
    textButton8.BackgroundColor3 = Color3.fromRGB(200, 60, 50)
    textButton8.Text = "×"
    textButton8.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton8.TextSize = f9(16)
    textButton8.Font = Enum.Font.GothamBold
    textButton8.BorderSizePixel = 0
    textButton8.Parent = frame7
    Instance.new("UICorner", textButton8).CornerRadius = UDim.new(0, 8 * v29)

    local textLabel8 = Instance.new("TextLabel")
    textLabel8.Size = UDim2.new(1, -150 * v29, 1, 0)
    textLabel8.Position = UDim2.new(0, 72 * v29, 0, 0)
    textLabel8.BackgroundTransparency = 1
    textLabel8.Text = "BEKA HUB"
    textLabel8.TextColor3 = Color3.fromRGB(212, 175, 55)
    textLabel8.TextSize = f9(18)
    textLabel8.Font = Enum.Font.GothamBold
    textLabel8.TextXAlignment = Enum.TextXAlignment.Center
    textLabel8.Parent = frame7

    textButton5.MouseButton1Click:Connect(function()
      pcall(function()
        starterGui:SetCore("SendNotification", {
          Title = "BEKA",
          Text = "BEKA HUB شغّال",
          Duration = 2,
        })
      end)
    end)
    textButton6.MouseButton1Click:Connect(function()
      productButtonsGUI.Enabled = false
    end)

    local frame9 = Instance.new("Frame")
    frame9.Size = UDim2.new(1, -12 * v29, 0, v221)
    frame9.Position = UDim2.new(0, 6 * v29, 0, v218)
    frame9.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    frame9.BorderSizePixel = 0
    frame9.Parent = frame4
    Instance.new("UICorner", frame9).CornerRadius = UDim.new(0, 8 * v29)

    textBox2 = Instance.new("TextBox")
    textBox2.Size = UDim2.new(0.53, 0, 0.7, 0)
    textBox2.Position = UDim2.new(0.03, 0, 0.15, 0)
    textBox2.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    textBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox2.PlaceholderText = "اسم اللاعب"
    textBox2.PlaceholderColor3 = Color3.fromRGB(160, 160, 180)
    textBox2.TextSize = f9(14)
    textBox2.Font = Enum.Font.Gotham
    textBox2.BorderSizePixel = 0
    textBox2.ClearTextOnFocus = false
    textBox2.Parent = frame9
    Instance.new("UICorner", textBox2).CornerRadius = UDim.new(0, 6 * v29)

    local textButton9 = Instance.new("TextButton")
    textButton9.Size = UDim2.new(0.2, 0, 0.7, 0)
    textButton9.Position = UDim2.new(0.57, 0, 0.15, 0)
    textButton9.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
    textButton9.TextColor3 = Color3.fromRGB(20, 20, 40)
    textButton9.Text = "الأقرب"
    textButton9.TextSize = f9(13)
    textButton9.Font = Enum.Font.GothamBold
    textButton9.BorderSizePixel = 0
    textButton9.Parent = frame9
    Instance.new("UICorner", textButton9).CornerRadius = UDim.new(0, 6 * v29)

    textButton3 = Instance.new("TextButton")
    textButton3.Size = UDim2.new(0.18, 0, 0.7, 0)
    textButton3.Position = UDim2.new(0.78, 0, 0.15, 0)
    textButton3.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
    textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton3.Text = "بحث"
    textButton3.TextSize = f9(13)
    textButton3.Font = Enum.Font.GothamBold
    textButton3.BorderSizePixel = 0
    textButton3.Parent = frame9
    Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 6 * v29)

    textButton9.MouseButton1Click:Connect(function()
      local nearest = f22()
      if nearest then
        textBox2.Text = nearest
        f23(nearest)
      else
        pcall(function()
          starterGui:SetCore("SendNotification", {
            Title = "BEKA",
            Text = "ماكو لاعب قريب",
            Duration = 2,
          })
        end)
      end
    end)

    local function selectEnteredPlayer()
      local query = textBox2.Text:gsub("%s+", "")
      if query == "" then
        return
      end
      local target = f21(query)
      if target then
        textBox2.Text = target.Name
        f23(target.Name)
      else
        pcall(function()
          starterGui:SetCore("SendNotification", {
            Title = "BEKA",
            Text = "ما لكيت اللاعب: " .. query,
            Duration = 2,
          })
        end)
      end
    end
    textButton3.MouseButton1Click:Connect(selectEnteredPlayer)
    textBox2.FocusLost:Connect(function(enterPressed)
      if enterPressed then selectEnteredPlayer() end
    end)

    textButton4 = Instance.new("TextButton")
    textButton4.Size = UDim2.new(1, -12 * v29, 0, v228)
    textButton4.Position = UDim2.new(0, 6 * v29, 0, v218 + v221 + 10 * v29)
    textButton4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    textButton4.Text = "تحديد كل اللاعبين: متوقف"
    textButton4.TextColor3 = Color3.fromRGB(220, 220, 240)
    textButton4.TextSize = f9(15)
    textButton4.Font = Enum.Font.GothamBold
    textButton4.BorderSizePixel = 0
    textButton4.Parent = frame4
    Instance.new("UICorner", textButton4).CornerRadius = UDim.new(0, 10 * v29)
    v68 = false
    textButton4.MouseButton1Click:Connect(function()
      v68 = not v68
      if v68 then
        textButton4.Text = "تحديد كل اللاعبين: يعمل"
        textButton4.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        textButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
        f24()
      else
        textButton4.Text = "تحديد كل اللاعبين: متوقف"
        textButton4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        textButton4.TextColor3 = Color3.fromRGB(220, 220, 240)
        v65 = false
      end
    end)

    scrollingFrame = Instance.new("ScrollingFrame")
    local scrollTop = v218 + v221 + v228 + 16 * v29
    scrollingFrame.Size = UDim2.new(1, -12 * v29, 1, -(scrollTop + 56 * v29))
    scrollingFrame.Position = UDim2.new(0, 6 * v29, 0, scrollTop)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4 * v29
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(212, 175, 55)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = frame4

    local instance5 = Instance.new("UIListLayout", scrollingFrame)
    instance5.SortOrder = Enum.SortOrder.LayoutOrder
    instance5.Padding = UDim.new(0, 6 * v29)
    instance5.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local frame10 = Instance.new("Frame")
    frame10.Size = UDim2.new(1, -12 * v29, 0, 40 * v29)
    frame10.Position = UDim2.new(0, 6 * v29, 1, -46 * v29)
    frame10.BackgroundTransparency = 1
    frame10.BorderSizePixel = 0
    frame10.Parent = frame4

    textBox3 = Instance.new("TextBox")
    textBox3.Size = UDim2.new(0, 70 * v29, 0, 32 * v29)
    textBox3.Position = UDim2.new(0, 0, 0.5, -16 * v29)
    textBox3.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    textBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox3.Text = tostring(v64)
    textBox3.PlaceholderText = "السرعة"
    textBox3.TextSize = f9(14)
    textBox3.Font = Enum.Font.GothamBold
    textBox3.BorderSizePixel = 0
    textBox3.ClearTextOnFocus = false
    textBox3.Parent = frame10
    Instance.new("UICorner", textBox3).CornerRadius = UDim.new(0, 6 * v29)

    local textButton10 = Instance.new("TextButton")
    textButton10.Size = UDim2.new(0, 80 * v29, 0, 32 * v29)
    textButton10.Position = UDim2.new(0.5, -110 * v29, 0.5, -16 * v29)
    textButton10.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
    textButton10.Text = "تشغيل الكل"
    textButton10.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton10.TextSize = f9(13)
    textButton10.Font = Enum.Font.GothamBold
    textButton10.BorderSizePixel = 0
    textButton10.Parent = frame10
    Instance.new("UICorner", textButton10).CornerRadius = UDim.new(0, 6 * v29)

    local textButton11 = Instance.new("TextButton")
    textButton11.Size = UDim2.new(0, 80 * v29, 0, 32 * v29)
    textButton11.Position = UDim2.new(1, -85 * v29, 0.5, -16 * v29)
    textButton11.BackgroundColor3 = Color3.fromRGB(200, 60, 50)
    textButton11.Text = "إيقاف الكل"
    textButton11.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton11.TextSize = f9(13)
    textButton11.Font = Enum.Font.GothamBold
    textButton11.BorderSizePixel = 0
    textButton11.Parent = frame10
    Instance.new("UICorner", textButton11).CornerRadius = UDim.new(0, 6 * v29)

    local function f34(p33)
      local v230 = p33
      local textButton12 = (Instance.new("TextButton"))
      local v231, v232, v233

      textButton12.Size = UDim2.new(1, 0, 0, 42 * v29)
      textButton12.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
      textButton12.TextColor3 = Color3.fromRGB(220, 220, 240)
      textButton12.Text = p33.name .. " =4"
      textButton12.TextSize = f9(16)
      textButton12.Font = Enum.Font.GothamBold
      textButton12.BorderSizePixel = 0
      textButton12.AutoButtonColor = false
      textButton12.Parent = scrollingFrame

      ;(Instance.new("UICorner", textButton12)).CornerRadius = UDim.new(0, 10 * v29)
      local v234 = false

      do
      end

      textButton12.MouseEnter:Connect(function()
        local v235

        if not v234 then
          local v236
          v236 = tweenService

          do
          end

          ;(tweenService:Create(textButton12, (TweenInfo.new(0.2)), {
            BackgroundColor3 = (Color3.fromRGB(60, 60, 90)),
          })):Play()
        end

        return
      end)

      do
      end

      textButton12.MouseLeave:Connect(function()
        local v237

        if not v234 then
          local v238
          v238 = tweenService

          do
          end

          ;(tweenService:Create(textButton12, (TweenInfo.new(0.2)), {
            BackgroundColor3 = (Color3.fromRGB(40, 40, 70)),
          })):Play()
        end

        return
      end)

      local v239

      local function f35()
        local v240

        if v234 then
          v234 = false

          if v239 then
            task.cancel(v239)
            v239 = nil
          end

          textButton12.Text = p33.name .. " =4"
          textButton12.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
          textButton12.TextColor3 = Color3.fromRGB(220, 220, 240)
        else
          v234 = true

          textButton12.Text = p33.name .. " =�"
          textButton12.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
          textButton12.TextColor3 = Color3.fromRGB(255, 255, 255)

          local v241
          v241 = (tonumber(textBox3.Text)) or 100

          if v241 < 1 then
            v241 = 1
          end

          v240 = 1 / v241

          v239 = (task.spawn(function()
            while v234 do
              f25(p33.id)
              task.wait(v240)
            end

            return
          end))
        end

        return
      end

      do
      end

      textButton12.InputBegan:Connect(function(input)
        local v242 = input
        local v243 = input.UserInputType == Enum.UserInputType.MouseButton1
        local v244 = v243

        do
        end

        if v243 or input.UserInputType == Enum.UserInputType.Touch then
          f35()
        end

        return
      end)

      return {
        button = textButton12,
        isActive = function() return v234 end,
        setActive = function(p34)
          if p34 ~= v234 then
            f35()
          end

          return
        end,
        stop = function()
          if v234 then
            v234 = false

            if v239 then
              task.cancel(v239)
              v239 = nil
            end

            textButton12.Text = p33.name .. " =4"
            textButton12.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            textButton12.TextColor3 = Color3.fromRGB(220, 220, 240)
          end

          return
        end,
      }
    end

    for index14, value15 in ipairs(v74) do
      v66[value15.id] = f34(value15)
    end

    f1(v66)

    do
    end

    textButton10.MouseButton1Click:Connect(function()
      for key2, value16 in pairs(v66) do
        if not (value16.isActive()) then
          value16.setActive(true)
        end
      end

      local v245 = starterGui

      starterGui:SetCore("SendNotification", {
        Title = " *E 'D*A9JD",
        Text = "*E *4:JD ,EJ9 'D#21'1",
        Duration = 2,
      })

      return
    end)

    do
    end

    textButton11.MouseButton1Click:Connect(function()
      for key3, value17 in pairs(v66) do
        value17.stop()
      end

      if v68 then
        v68 = false
        v65 = false

        textButton4.Text = "< 9DI CD 'DD'9(JF =4"
        textButton4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        textButton4.TextColor3 = Color3.fromRGB(220, 220, 240)
      end

      return
    end)

    do
    end

    textBox3.FocusLost:Connect(function(p35)
      local v246

      if p35 then
        local v247
        v247 = tonumber(textBox3.Text)

        do
        end

        if v247 and v247 > 0 then
          v64 = v247

          for key4, value18 in pairs(v66) do
            if (value18.isActive()) then
              value18.stop()
              value18.setActive(true)
            end
          end
        else
          textBox3.Text = tostring(v64)
        end
      end

      return
    end)

    do
    end

    textButton8.MouseButton1Click:Connect(function()
      local v248, v249

      for key5, value19 in pairs(v66) do
        value19.stop()
      end

      if v68 then
        v65 = false
      end

      do
      end

      productButtonsGUI:Destroy()

      if toggleButtonGUI then
        do
        end

        toggleButtonGUI:Destroy()
      end

      return
    end)

    v69 = false
    position = nil
    position2 = nil

    do
    end

    frame7.InputBegan:Connect(function(input2)
      local v250 = input2
      local v251 = input2.UserInputType == Enum.UserInputType.MouseButton1
      local v252 = v251

      do
      end

      if v251 or input2.UserInputType == Enum.UserInputType.Touch then
        v69 = true
        position = input2.Position
        position2 = frame4.Position
      end

      return
    end)

    do
    end

    userInputService.InputChanged:Connect(function(input3)
      local v253 = v69
      local v254 = input3
      local v255 = v253
      local v256, v257

      if v253 then
        do
        end

        do
        end

        v255 = input3.UserInputType == Enum.UserInputType.MouseMovement
          or input3.UserInputType == Enum.UserInputType.Touch
      end

      if v255 then
        local v258
        v258 = input3.Position - position

        frame4.Position = UDim2.new(
          position2.X.Scale, position2.X.Offset + v258.X, position2.Y.Scale,
          position2.Y.Offset + v258.Y
        )
      end

      return
    end)

    do
    end

    userInputService.InputEnded:Connect(function(input4)
      local v259 = input4
      local v260 = input4.UserInputType == Enum.UserInputType.MouseButton1
      local v261 = v260

      do
      end

      if v260 or input4.UserInputType == Enum.UserInputType.Touch then
        v69 = false
      end

      return
    end)

    toggleButtonGUI = (Instance.new("ScreenGui"))
    toggleButtonGUI.Name = "ToggleButtonGUI"
    toggleButtonGUI.ResetOnSpawn = false
    toggleButtonGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    toggleButtonGUI.IgnoreGuiInset = true
    toggleButtonGUI.Parent = playerGui

    f2(toggleButtonGUI)

    local v262
    v262 = 80 * v29

    imageButton = (Instance.new("ImageButton"))
    imageButton.Size = UDim2.new(0, v262, 0, v262)
    imageButton.Position = UDim2.new(1, -(v262 + 20 * v29), 0.5, 100 * v29)
    imageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    imageButton.BorderSizePixel = 0
    imageButton.Parent = toggleButtonGUI

    ;(Instance.new("UICorner", imageButton)).CornerRadius = UDim.new(1, 0)

    instance3 = (Instance.new("Sound", imageButton))
    instance3.Volume = 3

    task.spawn(function()
      local v263 = f26("https://www.myinstants.com/media/sounds/kaido-laugh.mp3", "mp3")

      if v263 then
        instance3.SoundId = v263
      end

      return
    end)

    imageButton.Image = "rbxassetid://10511856020"

    v70 = true

    do
    end

    imageButton.MouseButton1Click:Connect(function()
      local v265

      if instance3.SoundId ~= "" then
        instance3.TimePosition = 0

        local v266
        v266 = instance3

        instance3:Play()
      end

      v70 = not v70
      productButtonsGUI.Enabled = v70
      local v267 = tweenService

      do
      end

      ;(tweenService:Create(imageButton, (TweenInfo.new(0.15)), {
        ImageTransparency = v70 and 0 or 0.5,
      })):Play()

      return
    end)

    v71 = false
    position3 = nil
    position4 = nil

    do
    end

    imageButton.InputBegan:Connect(function(input5)
      local v268 = input5
      local v269 = input5.UserInputType == Enum.UserInputType.MouseButton1
      local v270 = v269
      local v271

      do
      end

      if v269 or input5.UserInputType == Enum.UserInputType.Touch then
        v71 = true
        position3 = input5.Position
        position4 = imageButton.Position

        do
        end

        input5.Changed:Connect(function()
          if input5.UserInputState == Enum.UserInputState.End then
            v71 = false
          end

          return
        end)
      end

      return
    end)

    do
    end

    userInputService.InputChanged:Connect(function(input6)
      local v272 = input6
      local v273 = v71
      local v274 = v273
      local v275, v276

      if v273 then
        do
        end

        do
        end

        v274 = input6.UserInputType == Enum.UserInputType.MouseMovement
          or input6.UserInputType == Enum.UserInputType.Touch
      end

      if v274 then
        local v277
        v277 = input6.Position - position3

        imageButton.Position = UDim2.new(
          position4.X.Scale, position4.X.Offset + v277.X, position4.Y.Scale,
          position4.Y.Offset + v277.Y
        )
      end

      return
    end)

    task.wait(0.5)

    pcall(function()
      local v278 = starterGui

      starterGui:SetCore("SendNotification", {
        Title = " *E 'D*-EJD",
        Text = "3C1(* E-EJ ('DC'ED | ,EJ9 'DEJ2'* EA9D)",
        Duration = 3,
      })

      return
    end)

    print("BEKA HUB loaded")
    return
  end
end

-- Start BEKA menu without the old key gate.
startMain()

return
