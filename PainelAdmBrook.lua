-- Painel Admin Brookhaven - VoidReaper Style
-- Criado por Minemods e Reaper Xploits

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local target = nil

-- Interface
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("VoidReaper Admin Panel", "DarkTheme")
local AdminTab = Window:NewTab("Admin")
local AdminSection = AdminTab:NewSection("Comandos")

-- Selecionar jogador
AdminSection:NewButton("Selecionar Jogador", "Clique em um jogador para selecionar", function()
    mouse.Button1Down:Connect(function()
        local part = mouse.Target
        if part and part.Parent and Players:GetPlayerFromCharacter(part.Parent) then
            target = Players:GetPlayerFromCharacter(part.Parent)
            print("Selecionado:", target.Name)
        end
    end)
end)

-- Comandos principais
AdminSection:NewButton("Kick", "Expulsa o jogador", function()
    if target then
        target:Kick("Você foi expulso pelo VoidReaper Hub.")
    end
end)

AdminSection:NewButton("Kill", "Mata o jogador", function()
    if target and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

AdminSection:NewButton("KillPlus", "Mata com efeito", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local explosion = Instance.new("Explosion", workspace)
        explosion.Position = target.Character.HumanoidRootPart.Position
        target.Character.Humanoid.Health = 0
    end
end)

AdminSection:NewButton("Fling", "Arremessa o jogador", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local v = Instance.new("BodyVelocity")
        v.Velocity = Vector3.new(9999,9999,9999)
        v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v.Parent = target.Character.HumanoidRootPart
        wait(0.2)
        v:Destroy()
    end
end)

-- Comandos avançados
AdminSection:NewButton("Freeze", "Congela o jogador", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = true
    end
end)

AdminSection:NewButton("Unfreeze", "Descongela o jogador", function()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = false
    end
end)

AdminSection:NewButton("Jail", "Prende o jogador", function()
    if target and target.Character then
        local jail = Instance.new("Part", workspace)
        jail.Size = Vector3.new(10,10,10)
        jail.Position = lp.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
        jail.Anchored = true
        jail.Name = "JailCell"
        target.Character:MoveTo(jail.Position)
    end
end)

AdminSection:NewButton("Unjail", "Libera o jogador", function()
    if workspace:FindFirstChild("JailCell") then
        workspace.JailCell:Destroy()
    end
end)

AdminSection:NewButton("TP", "Teleporta o jogador até você", function()
    if target and target.Character then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position)
    end
end)

AdminSection:NewButton("View", "Ver jogador", function()
    if target and target.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
end)

AdminSection:NewButton("LoopKill", "Mata o jogador repetidamente", function()
    while target and target.Character and target.Character:FindFirstChild("Humanoid") do
        target.Character.Humanoid.Health = 0
        wait(1)
    end
end)

AdminSection:NewButton("Crash", "Tenta travar o jogador", function()
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

AdminSection:NewButton("Godmode", "Invencibilidade", function()
    lp.Character.Humanoid.Name = "God"
end)

AdminSection:NewButton("Bring", "Puxa o jogador até você", function()
    if target and target.Character then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
    end
end)

AdminSection:NewButton("Btools", "Ferramentas de construção", function()
    local tool = Instance.new("HopperBin", lp.Backpack)
    tool.BinType = 2
end)

AdminSection:NewSlider("Speed", "Velocidade do personagem", 100, 16, function(val)
    lp.Character.Humanoid.WalkSpeed = val
end)
