local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local target = nil

-- GUI principal
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "VoidReaperHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 400)
frame.Position = UDim2.new(0.5, -210, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "VoidReaper Hub Admin 1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Botão minimizar
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -60, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18

-- Botão fechar
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 18

-- Conteúdo
local content = Instance.new("ScrollingFrame", frame)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.CanvasSize = UDim2.new(0, 0, 0, 1000)
content.ScrollBarThickness = 6

-- Créditos
local credits = Instance.new("TextLabel", frame)
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -20)
credits.BackgroundTransparency = 1
credits.Text = "Script VoidReaper Hub foi feito por Reaper Xploits & NovaheX"
credits.TextColor3 = Color3.fromRGB(200, 200, 200)
credits.Font = Enum.Font.Gotham
credits.TextSize = 12

-- Botão restaurar
local restore = Instance.new("TextButton", gui)
restore.Size = UDim2.new(0, 200, 0, 30)
restore.Position = UDim2.new(0, 10, 0, 10)
restore.Text = "Abrir VoidReaper Hub"
restore.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
restore.TextColor3 = Color3.fromRGB(255, 255, 255)
restore.Font = Enum.Font.GothamBold
restore.TextSize = 14
restore.Visible = false

-- Funções dos botões
minimize.MouseButton1Click:Connect(function()
    frame.Visible = false
    restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
    frame.Visible = true
    restore.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Dropdown de jogadores
local dropdown = Instance.new("TextButton", content)
dropdown.Size = UDim2.new(1, 0, 0, 30)
dropdown.Position = UDim2.new(0, 0, 0, 0)
dropdown.Text = "Selecionar Jogador"
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14

local playerList = Instance.new("Frame", content)
playerList.Size = UDim2.new(1, 0, 0, 120)
playerList.Position = UDim2.new(0, 0, 0, 30)
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.Visible = false

dropdown.MouseButton1Click:Connect(function()
    playerList:ClearAllChildren()
    playerList.Visible = not playerList.Visible
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.MouseButton1Click:Connect(function()
                target = p
                dropdown.Text = "Selecionado: " .. p.Name
                playerList.Visible = false
            end)
            y = y + 20
        end
    end
end)

-- Função para criar botões de comando
local function createCommand(name, action)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, #content:GetChildren() * 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(action)
end

-- Comandos funcionais
createCommand("Kick", function()
    if target then target:Kick("Você foi expulso pelo VoidReaper Hub.") end
end)

createCommand("Kill", function()
    if target and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

createCommand("KillPlus", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local explosion = Instance.new("Explosion", workspace)
        explosion.Position = target.Character.HumanoidRootPart.Position
        target.Character.Humanoid.Health = 0
    end
end)

createCommand("Fling", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local v = Instance.new("BodyVelocity")
        v.Velocity = Vector3.new(9999,9999,9999)
        v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v.Parent = target.Character.HumanoidRootPart
        wait(0.2)
        v:Destroy()
    end
end)

createCommand("Freeze", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = true
    end
end)

createCommand("Unfreeze", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = false
    end
end)

createCommand("Jail", function()
    if target and target.Character then
        local jail = Instance.new("Part", workspace)
        jail.Size = Vector3.new(10,10,10)
        jail.Position = lp.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
        jail.Anchored = true
        jail.Name = "JailCell"
        target.Character:MoveTo(jail.Position)
    end
end)

createCommand("Unjail", function()
    if workspace:FindFirstChild("JailCell") then
        workspace.JailCell:Destroy()
    end
end)

createCommand("TP", function()
    if target and target.Character then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position)
    end
end)

createCommand("View", function()
    if target and target.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
end)

createCommand("LoopKill", function()
    while target and target.Character and target.Character:FindFirstChild("Humanoid") do
        target.Character.Humanoid.Health = 0
        wait(1)
    end
end)

createCommand("Crash", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 100 do
            local v = Instance.new("BodyVelocity")
            v.Velocity = Vector3.new(math.random(-9999,9999),9999,math.random(-9999,9999))
            v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            v.Parent = target.Character.HumanoidRootPart
            wait(0.05)
            v:Destroy()
        end
    end
end)

createCommand("Godmode", function()
    lp.Character.Humanoid.Name = "God"
end)

createCommand("Btools", function()
    local tool = Instance.new("HopperBin", lp.Backpack)
    tool.BinType = 2
end)

createCommand("Speed 50", function()
    lp.Character.Humanoid.WalkSpeed = 50
end)

createCommand("Speed 100", function()
    lp.Character.Humanoid.WalkSpeed = 100
end)

createCommand("Speed Reset", function()
    lp.Character.Humanoid.WalkSpeed = 16
end)
