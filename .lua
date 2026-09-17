-- true am am | ESP + Silent Aim + FOV
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

print("[true am am] загрузка...")

-- ===== МЕНЮ =====
local gui = Instance.new("ScreenGui")
gui.Name = "TrueAmAm"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 280)
frame.Position = UDim2.new(0.5, -140, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
})
gradient.Rotation = 45
gradient.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 100, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 30)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.Text = "true am am"
title.TextColor3 = Color3.fromRGB(220, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -70, 0, 10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local expandBtn = Instance.new("TextButton")
expandBtn.Size = UDim2.new(0, 50, 0, 50)
expandBtn.Position = UDim2.new(0, 20, 0, 100)
expandBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
expandBtn.Text = "am"
expandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
expandBtn.Font = Enum.Font.GothamBold
expandBtn.TextSize = 20
expandBtn.BorderSizePixel = 0
expandBtn.Visible = false
expandBtn.Active = true
expandBtn.Draggable = true
expandBtn.Parent = gui

local expCorner = Instance.new("UICorner")
expCorner.CornerRadius = UDim.new(1, 0)
expCorner.Parent = expandBtn

minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    expandBtn.Visible = true
end)
expandBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    expandBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ===== КНОПКИ =====
local espEnabled = false
local aimEnabled = false
local aimFov = 150
local currentTarget = nil
local showFovCircle = true

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -30, 0, 36)
espBtn.Position = UDim2.new(0, 15, 0, 60)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
espBtn.Text = "ESP Все: ВЫКЛ"
espBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14
espBtn.BorderSizePixel = 0
espBtn.Parent = frame

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, -30, 0, 36)
aimBtn.Position = UDim2.new(0, 15, 0, 102)
aimBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
aimBtn.Text = "Silent Aim: ВЫКЛ"
aimBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
aimBtn.Font = Enum.Font.GothamBold
aimBtn.TextSize = 14
aimBtn.BorderSizePixel = 0
aimBtn.Parent = frame

-- FOV строка
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -30, 0, 16)
fovLabel.Position = UDim2.new(0, 15, 0, 144)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 150 px"
fovLabel.TextColor3 = Color3.fromRGB(200, 180, 230)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 11
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = frame

-- FOV кнопки + / -
local fovMinusBtn = Instance.new("TextButton")
fovMinusBtn.Size = UDim2.new(0, 45, 0, 28)
fovMinusBtn.Position = UDim2.new(0, 15, 0, 162)
fovMinusBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
fovMinusBtn.Text = "−"
fovMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fovMinusBtn.Font = Enum.Font.GothamBold
fovMinusBtn.TextSize = 18
fovMinusBtn.BorderSizePixel = 0
fovMinusBtn.Parent = frame
Instance.new("UICorner", fovMinusBtn).CornerRadius = UDim.new(0, 6)

local fovPlusBtn = Instance.new("TextButton")
fovPlusBtn.Size = UDim2.new(0, 45, 0, 28)
fovPlusBtn.Position = UDim2.new(0, 65, 0, 162)
fovPlusBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
fovPlusBtn.Text = "+"
fovPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fovPlusBtn.Font = Enum.Font.GothamBold
fovPlusBtn.TextSize = 18
fovPlusBtn.BorderSizePixel = 0
fovPlusBtn.Parent = frame
Instance.new("UICorner", fovPlusBtn).CornerRadius = UDim.new(0, 6)

-- Кнопка показать/скрыть круг
local circleBtn = Instance.new("TextButton")
circleBtn.Size = UDim2.new(1, -130, 0, 28)
circleBtn.Position = UDim2.new(0, 115, 0, 162)
circleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
circleBtn.Text = "Круг: ВКЛ"
circleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
circleBtn.Font = Enum.Font.GothamBold
circleBtn.TextSize = 12
circleBtn.BorderSizePixel = 0
circleBtn.Parent = frame
Instance.new("UICorner", circleBtn).CornerRadius = UDim.new(0, 6)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 30)
status.Position = UDim2.new(0, 15, 0, 200)
status.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
status.BackgroundTransparency = 0.4
status.BorderSizePixel = 0
status.Text = "Готов"
status.TextColor3 = Color3.fromRGB(150, 150, 170)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)

-- ===== FOV КРУГ =====
-- Рисуем круг из линий (Frame) вокруг центра экрана
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FovCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.ZIndex = 5
fovCircle.Visible = false
fovCircle.Parent = gui

-- Обводка круга (UIStroke с закруглением = круг)
local fovBorder = Instance.new("Frame")
fovBorder.AnchorPoint = Vector2.new(0.5, 0.5)
fovBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
fovBorder.BackgroundTransparency = 1
fovBorder.BorderSizePixel = 0
fovBorder.ZIndex = 5
fovBorder.Parent = fovCircle
local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovBorder
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3
fovStroke.Parent = fovBorder

-- Функция обновления размера круга
local function updateFovCircle()
    if not fovCircle then return end
    -- Размер = FOV * 2 (радиус * 2)
    fovCircle.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
    fovBorder.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
    fovLabel.Text = "FOV: " .. aimFov .. " px"
end

updateFovCircle()

-- ===== СПИСОК РЕАЛЬНЫХ ИГРОКОВ =====
local function getRealPlayerNames()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            names[string.lower(plr.Name)] = plr
        end
    end
    return names
end

-- ===== ESP =====
local espTargets = {}

local function removeESP(head)
    local data = espTargets[head]
    if data then
        if data.hl then data.hl:Destroy() end
        if data.bb then data.bb:Destroy() end
        espTargets[head] = nil
    end
end

local function removeAllESP()
    for head, _ in pairs(espTargets) do
        removeESP(head)
    end
    espTargets = {}
end

local function createESP(head, model)
    if espTargets[head] then return end
    if not head or not head.Parent then return end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 50, 50)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = model
    hl.Parent = model

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 200, 0, 40)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 5000
    bb.Adornee = head
    bb.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = model.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextScaled = true
    nameLabel.Parent = bb

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = bb

    espTargets[head] = {hl = hl, bb = bb, nameLabel = nameLabel, distLabel = distLabel, model = model}
end

-- ===== SILENT AIM =====
local function getClosestTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest = nil
    local closestDist = aimFov

    local chars = workspace:FindFirstChild("Characters")
    if not chars then return nil end

    local realNames = getRealPlayerNames()

    for _, model in pairs(chars:GetChildren()) do
        if model:IsA("Model") and realNames[string.lower(model.Name)] then
            local head = model:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                if sp.Z > 0 and onScreen then
                    local screenPos = Vector2.new(sp.X, sp.Y)
                    local dist = (screenPos - center).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

local aimReady = false
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        if aimEnabled and currentTarget and currentTarget.Parent then
            if method == "ViewportPointToRay" and self == workspace.CurrentCamera then
                local cam = workspace.CurrentCamera
                local origin = cam.CFrame.Position
                local dir = (currentTarget.Position - origin).Unit * 1000
                return Ray.new(origin, dir)
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    aimReady = true
    print("[true am am] Silent Aim активирован")
end)

-- ===== ЦИКЛ =====
RunService.RenderStepped:Connect(function()
    -- Показ FOV круга
    if showFovCircle and aimEnabled then
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    -- Silent Aim
    if aimEnabled then
        currentTarget = getClosestTarget()
        if currentTarget then
            status.Text = "🎯 Цель: " .. currentTarget.Parent.Name
        else
            status.Text = "🔍 Нет цели"
        end
    end

    -- ESP
    if espEnabled then
        local chars = workspace:FindFirstChild("Characters")
        if chars then
            local realNames = getRealPlayerNames()
            local camPos = workspace.CurrentCamera.CFrame.Position
            local found = {}
            local count = 0

            for _, model in pairs(chars:GetChildren()) do
                if model:IsA("Model") and realNames[string.lower(model.Name)] then
                    local head = model:FindFirstChild("Head")
                    if head and head:IsA("BasePart") then
                        found[head] = true
                        if not espTargets[head] then
                            createESP(head, model)
                        end
                        local data = espTargets[head]
                        if data then
                            if data.distLabel then
                                local d = (head.Position - camPos).Magnitude
                                data.distLabel.Text = math.floor(d) .. "m"
                            end
                            count = count + 1
                        end
                    end
                end
            end

            for head, _ in pairs(espTargets) do
                if not head or not head.Parent or not found[head] then
                    removeESP(head)
                end
            end

            if not aimEnabled then
                status.Text = "Найдено: " .. count
            end
        end
    end
end)

-- ===== КНОПКИ =====
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "ESP Все: ВКЛ"
        espBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    else
        espBtn.Text = "ESP Все: ВЫКЛ"
        espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        removeAllESP()
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    if not aimReady then
        status.Text = "❌ Silent Aim не поддерживается"
        return
    end
    aimEnabled = not aimEnabled
    if aimEnabled then
        aimBtn.Text = "Silent Aim: ВКЛ"
        aimBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    else
        aimBtn.Text = "Silent Aim: ВЫКЛ"
        aimBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        currentTarget = nil
        fovCircle.Visible = false
    end
end)

fovPlusBtn.MouseButton1Click:Connect(function()
    aimFov = math.min(500, aimFov + 10)
    updateFovCircle()
end)

fovMinusBtn.MouseButton1Click:Connect(function()
    aimFov = math.max(20, aimFov - 10)
    updateFovCircle()
end)

circleBtn.MouseButton1Click:Connect(function()
    showFovCircle = not showFovCircle
    if showFovCircle then
        circleBtn.Text = "Круг: ВКЛ"
        circleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    else
        circleBtn.Text = "Круг: ВЫКЛ"
        circleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        fovCircle.Visible = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    removeAllESP()
    aimEnabled = false
    currentTarget = nil
end)

print("[true am am] загружен!")
