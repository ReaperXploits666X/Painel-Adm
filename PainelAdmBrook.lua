--[[
    VoidReaper Hub Admin 1.0
    Script feito por Reaper Xploits & NovaheX
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local target = nil

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("VoidReaper Hub Admin 1.0", "DarkTheme")

-- Funções Básicas
local BasicTab = Window:NewTab("Funções Básicas")
local BasicSection = BasicTab:NewSection("Selecionar Jogador")

local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= lp then
        table.insert(playerNames, p.Name)
    end
end

local dropdown = BasicSection:NewDropdown("Jogadores", "Escolha um jogador", playerNames, function(selected)
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

local function safeTarget()
    return target and target.Character
end

local function createBasic(name, func)
    BasicSection:NewButton(name, "", func)
end

createBasic("Kick", function()
    if target then target:Kick("Expulso pelo VoidReaper Hub.") end
end)

createBasic("Bring", function()
    if safeTarget() then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
    end
end)

createBasic("Kill", function()
    if safeTarget() and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

createBasic("KillPlus", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        local explosion = Instance.new("Explosion", workspace)
        explosion.Position = target.Character.HumanoidRootPart.Position
        target.Character.Humanoid.Health = 0
    end
end)

createBasic("Jail", function()
    if safeTarget() then
        local jail = Instance.new("Part", workspace)
        jail.Size = Vector3.new(10,10,10)
        jail.Position = lp.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
        jail.Anchored = true
        jail.Name = "JailCell"
        target.Character:MoveTo(jail.Position)
    end
end)

createBasic("Unjail", function()
    if workspace:FindFirstChild("JailCell") then
        workspace.JailCell:Destroy()
    end
end)

createBasic("Freeze", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = true
    end
end)

createBasic("Unfreeze", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Anchored = false
    end
end)

createBasic("Float", function()
    if safeTarget() and target.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyPosition", target.Character.HumanoidRootPart)
        bv.Position = target.Character.HumanoidRootPart.Position + Vector3.new(0,10,0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        wait(2)
        bv:Destroy()
    end
end)

-- Administração
local AdminTab = Window:NewTab("Administração")
local AdminSection = AdminTab:NewSection("Comandos Admin")

AdminSection:NewButton("Adm", "", function()
    print("Comando adm executado")
end)

AdminSection:NewButton("UnAdm", "", function()
    print("Comando unadm executado")
end)

AdminSection:NewButton("Check", "", function()
    print("Comando check executado")
end)

AdminSection:NewButton("Tag", "", function()
    print("Comando tag executado")
end)

AdminSection:NewButton("UnTag", "", function()
    print("Comando untag executado")
end)

AdminSection:NewButton("Tag All", "", function()
    print("Comando tag all executado")
end)

AdminSection:NewButton("UnTag All", "", function()
    print("Comando untag all executado")
end)

-- Especiais
local SpecialTab = Window:NewTab("Especiais")
local SpecialSection = SpecialTab:NewSection("Funções Especiais")

SpecialSection:NewButton("Crash", "", function()
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

SpecialSection:NewButton("Token", "", function()
    print("Comando token executado")
end)

SpecialSection:NewButton("Avatar", "", function()
    print("Comando avatar executado")
end)

-- Aba Terror
local TerrorTab = Window:NewTab("Terror")
local TerrorSection = TerrorTab:NewSection("JumpScares")

TerrorSection:NewButton("Jump1", "", function()
    print("Jump1 ativado")
end)

TerrorSection:NewButton("Jumps2", "", function()
    print("Jumps2 ativado")
end)

TerrorSection:NewButton("Jumps3", "", function()
    print("Jumps3 ativado")
end)

TerrorSection:NewButton("Jumps4", "", function()
    print("Jumps4 ativado")
end)

-- Aba Avatar
local AvatarTab = Window:NewTab("Avatar")
local AvatarSection = AvatarTab:NewSection("Copiar Aparência")

AvatarSection:NewButton("Copiar Avatar", "", function()
    print("Avatar copiado")
end)

-- Créditos
local CreditsTab = Window:NewTab("Créditos")
local CreditsSection = CreditsTab:NewSection("Informações")
CreditsSection:NewLabel("Script VoidReaper Hub foi feito por Reaper Xploits & NovaheX")

-- Controle
local ControlTab = Window:NewTab("Painel")
local ControlSection = ControlTab:NewSection("Controles")

ControlSection:NewButton("Minimizar Painel", "", function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "KavoUI" then
            gui.Enabled = false
        end
    end
end)

ControlSection:NewButton("Restaurar Painel", "", function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "KavoUI" then
            gui.Enabled = true
        end
    end
end)

ControlSection:NewButton("Fechar Painel", "", function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "KavoUI" then
            gui:Destroy()
        end
    end
end)
