-- KiyoXridz Hub - Compact UI Layout
-- Layout: Main GUI centered, open button left, two vertical floating actions right.
-- Player controls stay inside the Player tab. Auto Steal is not included.
-- Note: Drop Brainrot is a UI hook placeholder; connect only to an authorized game API.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("KiyoXridz_Compact")
if old then old:Destroy() end

local NORMAL_SPEED, CARRY_SPEED, LAGGER_SPEED = 60, 30, 15
local speedMode = "Normal"
local guiLocked = false
local playerHighlightEnabled = false
local highlights = {}

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function applySpeed()
    local hum = getHumanoid()
    if not hum then return end
    local value = NORMAL_SPEED
    if speedMode == "Carry" then value = CARRY_SPEED end
    if speedMode == "Lagger" then value = LAGGER_SPEED end
    pcall(function() hum.WalkSpeed = value end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5)
    task.wait(0.25)
    applySpeed()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "KiyoXridz_Compact"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 7)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(0, 210, 220)
    s.Thickness = 1
    s.Transparency = transparency or 0.2
    s.Parent = obj
    return s
end

local function makeButton(parent, text, position, size)
    local b = Instance.new("TextButton")
    b.Position = position
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(29, 40, 54)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamSemibold
    b.Text = text
    b.TextColor3 = Color3.fromRGB(225, 242, 247)
    b.TextSize = 11
    b.AutoButtonColor = true
    b.Parent = parent
    corner(b, 6)
    return b
end

-- Main panel centered by default.
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Size = UDim2.fromOffset(340, 300)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(13, 17, 25)
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 10)
stroke(main)

local top = Instance.new("Frame")
top.Name = "Header"
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(20, 28, 39)
top.BorderSizePixel = 0
top.Parent = main
corner(top, 10)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -132, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "KIYOXRIDZ  /  HUB"
title.TextColor3 = Color3.fromRGB(225, 250, 255)
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local lockBtn = makeButton(top, "UNLOCKED", UDim2.new(1, -112, 0, 7), UDim2.fromOffset(72, 26))
lockBtn.Name = "LockButton"
lockBtn.TextSize = 9
lockBtn.BackgroundColor3 = Color3.fromRGB(31, 48, 60)
local close = makeButton(top, "×", UDim2.new(1, -34, 0, 7), UDim2.fromOffset(27, 26))
close.BackgroundColor3 = Color3.fromRGB(125, 40, 55)
close.TextSize = 17
close.MouseButton1Click:Connect(function() main.Visible = false end)

-- Dragging is disabled while locked.
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if guiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and not guiLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

lockBtn.MouseButton1Click:Connect(function()
    guiLocked = not guiLocked
    lockBtn.Text = guiLocked and "LOCKED" or "UNLOCKED"
    lockBtn.BackgroundColor3 = guiLocked and Color3.fromRGB(0, 105, 115) or Color3.fromRGB(31, 48, 60)
end)

local tabs = Instance.new("Frame")
tabs.Position = UDim2.fromOffset(10, 49)
tabs.Size = UDim2.new(1, -20, 0, 30)
tabs.BackgroundTransparency = 1
tabs.Parent = main
local mainTab = makeButton(tabs, "MAIN", UDim2.fromOffset(0, 0), UDim2.new(0.5, -4, 1, 0))
local playerTab = makeButton(tabs, "PLAYER", UDim2.new(0.5, 4, 0, 0), UDim2.new(0.5, -4, 1, 0))

local pages = Instance.new("Frame")
pages.Position = UDim2.fromOffset(10, 86)
pages.Size = UDim2.new(1, -20, 1, -96)
pages.BackgroundTransparency = 1
pages.Parent = main
local mainPage = Instance.new("Frame")
mainPage.Size = UDim2.fromScale(1, 1)
mainPage.BackgroundTransparency = 1
mainPage.Parent = pages
local playerPage = Instance.new("Frame")
playerPage.Size = UDim2.fromScale(1, 1)
playerPage.BackgroundTransparency = 1
playerPage.Visible = false
playerPage.Parent = pages

local function setTab(which)
    mainPage.Visible = which == "Main"
    playerPage.Visible = which == "Player"
    mainTab.BackgroundColor3 = which == "Main" and Color3.fromRGB(0, 105, 115) or Color3.fromRGB(29, 40, 54)
    playerTab.BackgroundColor3 = which == "Player" and Color3.fromRGB(0, 105, 115) or Color3.fromRGB(29, 40, 54)
end
mainTab.MouseButton1Click:Connect(function() setTab("Main") end)
playerTab.MouseButton1Click:Connect(function() setTab("Player") end)

local function sectionLabel(parent, text, y)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(2, y)
    l.Size = UDim2.new(1, -4, 0, 18)
    l.Font = Enum.Font.GothamBold
    l.Text = text
    l.TextColor3 = Color3.fromRGB(0, 210, 220)
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

sectionLabel(mainPage, "MOVEMENT MODE", 0)
local speedStatus = Instance.new("TextLabel")
speedStatus.BackgroundTransparency = 1
speedStatus.Position = UDim2.fromOffset(2, 19)
speedStatus.Size = UDim2.new(1, -4, 0, 18)
speedStatus.Font = Enum.Font.Gotham
speedStatus.Text = "Active mode: Normal"
speedStatus.TextColor3 = Color3.fromRGB(205, 220, 230)
speedStatus.TextSize = 10
speedStatus.TextXAlignment = Enum.TextXAlignment.Left
speedStatus.Parent = mainPage

local function speedModeButton(label, mode, x)
    local b = makeButton(mainPage, label, UDim2.fromOffset(x, 42), UDim2.new(1/3, -5, 0, 30))
    b.MouseButton1Click:Connect(function()
        speedMode = mode
        speedStatus.Text = "Active mode: " .. mode
        applySpeed()
    end)
end
speedModeButton("NORMAL", "Normal", 0)
speedModeButton("CARRY", "Carry", 108)
speedModeButton("LAGGER", "Lagger", 216)

sectionLabel(mainPage, "SPEED VALUES  /  ENTER NUMBER", 82)
local function makeValueBox(parent, labelText, defaultValue, y, callback)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(2, y)
    label.Size = UDim2.fromOffset(118, 25)
    label.Font = Enum.Font.Gotham
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(205, 220, 230)
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local box = Instance.new("TextBox")
    box.Position = UDim2.fromOffset(122, y)
    box.Size = UDim2.fromOffset(82, 24)
    box.BackgroundColor3 = Color3.fromRGB(25, 34, 47)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.Gotham
    box.Text = tostring(defaultValue)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.TextSize = 11
    box.ClearTextOnFocus = false
    box.PlaceholderText = "1 - 250"
    box.Parent = parent
    corner(box, 5)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n and n >= 1 and n <= 250 then
            callback(n)
            box.Text = tostring(n)
        else
            box.Text = tostring(defaultValue)
        end
    end)
end

makeValueBox(mainPage, "Normal Speed", NORMAL_SPEED, 106, function(v)
    NORMAL_SPEED = v
    if speedMode == "Normal" then applySpeed() end
end)
makeValueBox(mainPage, "Carry Speed", CARRY_SPEED, 135, function(v)
    CARRY_SPEED = v
    if speedMode == "Carry" then applySpeed() end
end)
makeValueBox(mainPage, "Lagger Speed", LAGGER_SPEED, 164, function(v)
    LAGGER_SPEED = v
    if speedMode == "Lagger" then applySpeed() end
end)

sectionLabel(playerPage, "PLAYER FEATURES", 0)
local playerInfo = Instance.new("TextLabel")
playerInfo.BackgroundTransparency = 1
playerInfo.Position = UDim2.fromOffset(2, 22)
playerInfo.Size = UDim2.new(1, -4, 0, 32)
playerInfo.Font = Enum.Font.Gotham
playerInfo.Text = "Player visual controls stay here, not on the floating buttons."
playerInfo.TextColor3 = Color3.fromRGB(190, 205, 215)
playerInfo.TextSize = 10
playerInfo.TextWrapped = true
playerInfo.TextXAlignment = Enum.TextXAlignment.Left
playerInfo.Parent = playerPage

local espButton = makeButton(playerPage, "PLAYER HIGHLIGHT: OFF", UDim2.fromOffset(0, 62), UDim2.new(1, 0, 0, 31))
local function clearHighlights()
    for plr, h in pairs(highlights) do
        if h then h:Destroy() end
        highlights[plr] = nil
    end
end
local function updateHighlights()
    clearHighlights()
    if not playerHighlightEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h = Instance.new("Highlight")
            h.Name = "KiyoPlayerHighlight"
            h.FillTransparency = 0.78
            h.OutlineTransparency = 0
            h.Adornee = plr.Character
            h.Parent = gui
            highlights[plr] = h
        end
    end
end
espButton.MouseButton1Click:Connect(function()
    playerHighlightEnabled = not playerHighlightEnabled
    espButton.Text = playerHighlightEnabled and "PLAYER HIGHLIGHT: ON" or "PLAYER HIGHLIGHT: OFF"
    updateHighlights()
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if playerHighlightEnabled then updateHighlights() end
    end)
end)
Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then highlights[plr]:Destroy() end
    highlights[plr] = nil
end)

-- Left-side open/close control.
local openBtn = makeButton(gui, "K", UDim2.new(0, 14, 0.5, -21), UDim2.fromOffset(42, 42))
openBtn.Name = "OpenGuiButton"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 105, 115)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 18
stroke(openBtn, Color3.fromRGB(0, 220, 230), 0.1)
openBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Right-side floating controls: vertical stack, two rows, no Player features here.
local floatHolder = Instance.new("Frame")
floatHolder.Name = "FloatingActions"
floatHolder.AnchorPoint = Vector2.new(1, 0.5)
floatHolder.Position = UDim2.new(1, -14, 0.5, 0)
floatHolder.Size = UDim2.fromOffset(112, 82)
floatHolder.BackgroundTransparency = 1
floatHolder.Parent = gui
local floatLayout = Instance.new("UIListLayout")
floatLayout.FillDirection = Enum.FillDirection.Vertical
floatLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
floatLayout.VerticalAlignment = Enum.VerticalAlignment.Center
floatLayout.Padding = UDim.new(0, 6)
floatLayout.Parent = floatHolder

local resetBtn = makeButton(floatHolder, "INSTANT RESET", UDim2.new(), UDim2.fromOffset(112, 36))
resetBtn.Name = "InstantResetFloat"
resetBtn.MouseButton1Click:Connect(function()
    local hum = getHumanoid()
    if hum then hum.Health = 0 end
end)

local dropBtn = makeButton(floatHolder, "DROP BRAINROT", UDim2.new(), UDim2.fromOffset(112, 36))
dropBtn.Name = "DropBrainrotFloat"
dropBtn.MouseButton1Click:Connect(function()
    dropBtn.Text = "DROP: API NEEDED"
    task.delay(1.4, function()
        if dropBtn and dropBtn.Parent then dropBtn.Text = "DROP BRAINROT" end
    end)
end)

setTab("Main")
applySpeed()
