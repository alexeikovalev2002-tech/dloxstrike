-- true am am | ESP + Silent Aim + FOV (Xeno PC Edition)

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UserInput   = game:GetService("UserInputService")
local player      = Players.LocalPlayer

print("[true am am] загрузка...")

-- ====== ПРОВЕРКА ЭКЗЕКУТОРА ======
local hasMT   = type(getrawmetatable) == "function"
local hasHook = type(hookfunction)   == "function"
local hasCClo = type(newcclosure)    == "function"
local hasGNC  = type(getnamecallmethod) == "function"

print(("[true am am] MT:%s Hook:%s CClo:%s GNC:%s"):format(
    tostring(hasMT), tostring(hasHook), tostring(hasCClo), tostring(hasGNC)))

-- ====== МЕНЮ ======
local gui = Instance.new("ScreenGui")
gui.Name = "TrueAmAm"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 280)
frame.Position = UDim2.new(0.5, -140, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

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

local function makeBtn(text, pos, size, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local minimizeBtn = makeBtn("−", UDim2.new(1, -70, 0, 10), UDim2.new(0, 28, 0, 28), Color3.fromRGB(255, 200, 50))
minimizeBtn.TextSize = 20

local closeBtn = makeBtn("X", UDim2.new(1, -38, 0, 10), UDim2.new(0, 28, 0, 28), Color3.fromRGB(200, 60, 60))
closeBtn.TextSize = 16

-- Кнопка "am" (свёрнуто)
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
Instance.new("UICorner", expandBtn).CornerRadius = UDim.new(1, 0)

minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false; expandBtn.Visible = true
end)
expandBtn.MouseButton1Click:Connect(function()
    frame.Visible = true; expandBtn.Visible = false
end)

-- ====== СОСТОЯНИЕ ======
local espEnabled   = false
local aimEnabled   = false
local aimFov       = 150
local currentTarget = nil
local showFovCircle = true

-- ====== КНОПКИ ======
local espBtn = makeBtn("ESP Все: ВЫКЛ", UDim2.new(0, 15, 0, 60), UDim2.new(1, -30, 0, 36), Color3.fromRGB(60, 60, 80))
local aimBtn = makeBtn("Silent Aim: ВЫКЛ", UDim2.new(0, 15, 0, 102), UDim2.new(1, -30, 0, 36), Color3.fromRGB(60, 60, 80))

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -30, 0, 16)
fovLabel.Position = UDim2.new(0, 15, 0, 144)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. aimFov .. " px"
fovLabel.TextColor3 = Color3.fromRGB(200, 180, 230)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 11
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = frame

local fovMinusBtn = makeBtn("−", UDim2.new(0, 15, 0, 162), UDim2.new(0, 45, 0, 28), Color3.fromRGB(200, 100, 100))
local fovPlusBtn  = makeBtn("+", UDim2.new(0, 65, 0, 162), UDim2.new(0, 45, 0, 28), Color3.fromRGB(100, 200, 100))
local circleBtn   = makeBtn("Круг: ВКЛ", UDim2.new(0, 115, 0, 162), UDim2.new(1, -130, 0, 28), Color3.fromRGB(100, 200, 100))
circleBtn.TextSize = 12

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

-- ====== FOV КРУГ ======
local fovBorder = Instance.new("Frame")
fovBorder.AnchorPoint = Vector2.new(0.5, 0.5)
fovBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
fovBorder.BackgroundTransparency = 1
fovBorder.BorderSizePixel = 0
fovBorder.ZIndex = 5
fovBorder.Visible = false
fovBorder.Parent = gui
Instance.new("UICorner", fovBorder).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3
fovStroke.Parent = fovBorder

local function updateFovCircle()
    local sz = aimFov * 2
    fovBorder.Size = UDim2.new(0, sz, 0, sz)
    fovLabel.Text = "FOV: " .. aimFov .. " px"
end
updateFovCircle()

-- ====== ЦЕЛЬ (враги = все игроки кроме меня) ======
local function isEnemy(model)
    if not model or not model:IsA("Model") then return false end
    local plr = Players:GetPlayerFromCharacter(model)
    return plr ~= nil and plr ~= player
end

local function getClosestTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, closestDist = nil, aimFov

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                    if sp.Z > 0 and onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < closestDist then
                            closestDist = d
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ====== ESP ======
local espTargets = {}

local function removeESP(head)
    local d = espTargets[head]
    if d then
        if d.hl then d.hl:Destroy() end
        if d.bb then d.bb:Destroy() end
        espTargets[head] = nil
    end
end

local function removeAllESP()
    for head in pairs(espTargets) do removeESP(head) end
    espTargets = {}
end

local function createESP(head, model)
    if espTargets[head] then return end
    if not head or not head.Parent then return end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 50, 50)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
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

    espTargets[head] = {hl = hl, bb = bb, distLabel = distLabel}
end

-- ====== SILENT AIM (нормальный) ======
local aimReady = false

local function setupSilentAim()
    -- Способ 1: через hookmetamethod / getrawmetatable
    if hasMT and hasCClo and hasGNC then
        local ok = pcall(function()
            local mt = getrawmetatable(game)
            if not mt then error("no mt") end
            setreadonly(mt, false)

            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if aimEnabled and currentTarget and currentTarget.Parent then
                    -- Хук на рейкаст от лица/камеры
                    if method == "FindPartOnRay"
                        or method == "FindPartOnRayWithIgnoreList"
                        or method == "FindPartOnRayWithWhitelist"
                        or method == "Raycast" then
                        local cam = workspace.CurrentCamera
                        if cam then
                            local origin = cam.CFrame.Position
                            local dir = (currentTarget.Position - origin).Unit * 1000
                            if method == "Raycast" then
                                return Raycast(origin, dir * 1000)
                            else
                                local oldRay = self
                                return oldNamecall(self, Ray.new(origin, dir), ...)
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)

            setreadonly(mt, true)
        end)
        if ok then aimReady = true; return true end
    end

    -- Способ 2: через hookfunction на Index mouse.Hit/Target
    if hasHook then
        local ok = pcall(function()
            local mouse = player:GetMouse()
            local oldHit   = mouse.Hit
            local oldTarget= mouse.Target
            -- hookfunction на метаметод Mouse
            local mt = getrawmetatable(mouse)
            if mt then
                local oldIdx = mt.__index
                setreadonly(mt, false)
                mt.__index = newcclosure(function(t, k)
                    if t == mouse and aimEnabled and currentTarget and currentTarget.Parent then
                        if k == "Hit" then
                            return CFrame.lookAt(mouse.Origin.Position, currentTarget.Position)
                        elseif k == "Target" then
                            return currentTarget
                        end
                    end
                    return oldIdx(t, k)
                end)
                setreadonly(mt, true)
            end
        end)
        if ok then aimReady = true; return true end
    end

    return false
end

if setupSilentAim() then
    print("[true am am] Silent Aim готов")
    status.Text = "Silent Aim готов ✓"
else
    status.Text = "⚠ Silent Aim недоступен"
end

-- ====== ЦИКЛ ======
RunService.RenderStepped:Connect(function()
    -- FOV круг
    if fovBorder then
        fovBorder.Visible = (showFovCircle and aimEnabled)
    end

    -- Silent Aim — поиск цели
    if aimEnabled then
        currentTarget = getClosestTarget()
        if currentTarget then
            status.Text = "🎯 " .. currentTarget.Parent.Name
        else
            status.Text = "🔍 Нет цели"
        end
    end

    -- ESP
    if espEnabled then
        local cam = workspace.CurrentCamera
        local camPos = cam.CFrame.Position
        local found, count = {}, 0

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head and head:IsA("BasePart") then
                        found[head] = true
                        if not espTargets[head] then createESP(head, char) end
                        local d = espTargets[head]
                        if d and d.distLabel then
                            d.distLabel.Text = math.floor((head.Position - camPos).Magnitude) .. "m"
                            count = count + 1
                        end
                    end
                end
            end
        end

        for head in pairs(espTargets) do
            if not head.Parent or not found[head] then removeESP(head) end
        end

        if not aimEnabled then status.Text = "ESP: " .. count end
    end
end)

-- ====== ОБРАБОТЧИКИ КНОПОК ======
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
        status.Text = "❌ Silent Aim недоступен"
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
    end
end)

fovPlusBtn.MouseButton1Click:Connect(function()
    aimFov = math.min(500, aimFov + 10); updateFovCircle()
end)
fovMinusBtn.MouseButton1Click:Connect(function()
    aimFov = math.max(20, aimFov - 10); updateFovCircle()
end)
circleBtn.MouseButton1Click:Connect(function()
    showFovCircle = not showFovCircle
    circleBtn.Text = showFovCircle and "Круг: ВКЛ" or "Круг: ВЫКЛ"
    circleBtn.BackgroundColor3 = showFovCircle and Color3.fromRGB(100,200,100) or Color3.fromRGB(60,60,80)
end)

closeBtn.MouseButton1Click:Connect(function()
    removeAllESP()
    aimEnabled = false
    currentTarget = nil
    gui:Destroy()
end)

print("[true am am] загружен! Silent Aim:", aimReady)
