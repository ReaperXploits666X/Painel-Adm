--[[
    VoidReaper Hub Admin 1.0
    Script feito por Reaper Xploits & NovaheX
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local target = nil

-- Interface estilo Nytherune (Kavo UI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("VoidReaper Hub Admin 1.0", "DarkTheme")

-- Aba principal
local AdminTab = Window:NewTab("Admin")
local AdminSection = AdminTab:NewSection("Selecionar Jogador")

-- Lista suspensa de jogadores
local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= lp then
        table.insert(playerNames, p.Name)
    end
end

local dropdown = AdminSection:NewDropdown("Jogadores", "Escolha um jogador", playerNames, function(selected)
    target = Players:FindFirstChild(selected)
end)

Players.PlayerAdded:Connect(function(p)
    table.insert(playerNames, p.Name)
    dropdown:Refresh(playerNames)
end)

Players.PlayerRemoving:Connect(function(p)
    for i, name in pairs(playerNames) do
        if name == p.Name then
            table.remove(playerNames, i)
            break
        end
    end
    dropdown:Refresh(playerNames)
end)

-- Comandos
local CommandSection = AdminTab:NewSection("Comandos")

local function safeTarget()
    return target and target.Character
end

CommandSection:NewButton("Kick", "Expulsa o jogador", function()
    if target then target:Kick("Você foi expulso pelo VoidReaper Hub.") end
end)

CommandSection:NewButton("Kill", "Mata o jogador", function()
    if safeTarget() and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

CommandSection:NewButton("KillPlus", "Mata com explosão", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        local explosion = Instance.new("Explosion", workspace)
        explosion.Position = target.Character.HumanoidRootPart.Position
        target.Character.Humanoid.Health = 0
    end
end)

CommandSection:NewButton("Fling", "Arremessa o jogador", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        local v = Instance.new("BodyVelocity")
        v.Velocity = Vector3.new(9999,9999,9999)
        v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v.Parent = target.Character.HumanoidRootPart
        wait(0.2)
        v:Destroy()
    end
end)

CommandSection:NewButton("Freeze", "Congela o jogador", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = true
    end
end)

CommandSection:NewButton("Unfreeze", "Descongela o jogador", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = false
    end
end)

CommandSection:NewButton("Jail", "Prende o jogador", function()
    if safeTarget() then
        local jail = Instance.new("Part", workspace)
        jail.Size = Vector3.new(10,10,10)
        jail.Position = lp.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
        jail.Anchored = true
        jail.Name = "JailCell"
        target.Character:MoveTo(jail.Position)
    end
end)

CommandSection:NewButton("Unjail", "Libera o jogador", function()
    if workspace:FindFirstChild("JailCell") then
        workspace.JailCell:Destroy()
    end
end)

CommandSection:NewButton("TP", "Teleporta o jogador até você", function()
    if safeTarget() then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position)
    end
end)

CommandSection:NewButton("View", "Ver jogador", function()
    if safeTarget() and target.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
end)

CommandSection:NewButton("LoopKill", "Mata repetidamente", function()
    while safeTarget() and target.Character:FindFirstChild("Humanoid") do
        target.Character.Humanoid.Health = 0
        wait(1)
    end
end)

CommandSection:NewButton("Crash", "Tenta travar o jogador", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
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

CommandSection:NewButton("Godmode", "Invencibilidade", function()
    lp.Character.Humanoid.Name = "God"
end)

CommandSection:NewButton("Bring", "Puxa o jogador até você", function()
    if safeTarget() then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
    end
end)

CommandSection:NewButton("Btools", "Ferramentas de construção", function()
    local tool = Instance.new("HopperBin", lp.Backpack)
    tool.BinType = 2
end)

CommandSection:NewSlider("Speed", "Velocidade do personagem", 100, 16, function(val)
    lp.Character.Humanoid.WalkSpeed = val
end)

-- Aba de Créditos
local CreditsTab = Window:NewTab("Créditos")
local CreditsSection = CreditsTab:NewSection("Informações")
CreditsSection:NewLabel("Script VoidReaper Hub foi feito por Reaper Xploits & NovaheX")

-- Aba de Controle
local ControlTab = Window:NewTab("Painel")
local ControlSection = ControlTab:NewSection("Controles")

ControlSection:NewButton("Minimizar Painel", "Esconde o painel temporariamente", function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "KavoUI" then
            gui.Enabled = false
        end
    end
end)

ControlSection:NewButton("Restaurar Painel", "Mostra o painel novamente", function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "KavoUI" then
            gui.Enabled = true
        end
    end
end)

ControlSection:NewButton("Fechar Painel", "Remove o painel completamente", function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "KavoUI" then
            gui:Destroy()
        end
    end
end)
