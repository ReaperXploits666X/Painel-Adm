--[[
    VoidReaper Hub Admin
    Criado por Reaper Xploits
    Baseado no Nytherune Hub original
]]

-- Carrega a biblioteca de interface
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("VoidReaper Hub Admin", "DarkTheme")

-- Abas principais
local AdminTab = Window:NewTab("Admin")
local AvatarTab = Window:NewTab("Avatar")
local HouseTab = Window:NewTab("Casas")
local SettingsTab = Window:NewTab("Configurações")

-- Carrega os módulos externos
loadstring(game:HttpGet("https://raw.githubusercontent.com/Minemods/VoidReaperHub/main/admin.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Minemods/VoidReaperHub/main/avatar.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Minemods/VoidReaperHub/main/house.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Minemods/VoidReaperHub/main/settings.lua"))()

--[[
    VoidReaper Hub Admin - Comandos
    Criado por Reaper Xploits
    Baseado no Nytherune Hub original
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local target = nil

local AdminSection = Window:FindFirstChild("Admin"):FindFirstChildOfClass("Section")

AdminSection:NewButton("Selecionar Jogador", "Clique em um jogador para selecionar", function()
    mouse.Button1Down:Connect(function()
        local part = mouse.Target
        if part and part.Parent and Players:GetPlayerFromCharacter(part.Parent) then
            target = Players:GetPlayerFromCharacter(part.Parent)
            print("Selecionado:", target.Name)
        end
    end)
end)

AdminSection:NewButton("Bring", "Teleporta o jogador até você", function()
    if target and target.Character then
        target.Character:MoveTo(lp.Character.HumanoidRootPart.Position)
    end
end)

AdminSection:NewButton("Fling", "Arremessa o jogador", function()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local v = Instance.new("BodyVelocity")
        v.Velocity = Vector3.new(9999,9999,9999)
        v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v.Parent = target.Character.HumanoidRootPart
        wait(0.2)
        v:Destroy()
    end
end)

AdminSection:NewButton("Kill", "Elimina o jogador", function()
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

AdminSection:NewButton("Btools", "Dá ferramentas de construção", function()
    local tool = Instance.new("HopperBin", lp.Backpack)
    tool.BinType = 2
end)

AdminSection:NewButton("Givem", "Dá armas ao jogador", function()
    local gun = game:GetService("ReplicatedStorage"):FindFirstChild("Gun")
    if gun then
        gun:Clone().Parent = lp.Backpack
    end
end)

AdminSection:NewButton("View", "Ver jogador selecionado", function()
    if target and target.Character then
        workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
    end
end)

AdminSection:NewSlider("Speed", "Altera a velocidade do personagem", 100, 16, function(val)
    lp.Character.Humanoid.WalkSpeed = val
end)

--[[
    VoidReaper Hub Admin - Avatar
    Criado por Reaper Xploits
    Baseado no Nytherune Hub original
]]

local AvatarSection = Window:FindFirstChild("Avatar"):FindFirstChildOfClass("Section")
local lp = game:GetService("Players").LocalPlayer

AvatarSection:NewButton("Remover Roupas", "Remove todas as roupas do personagem", function()
    for _, item in pairs(lp.Character:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("Accessory") or item:IsA("Hat") then
            item:Destroy()
        end
    end
end)

AvatarSection:NewButton("Resetar Personagem", "Reseta o personagem", function()
    lp.Character:BreakJoints()
end)

AvatarSection:NewButton("Tamanho Pequeno", "Deixa o personagem pequeno", function()
    for _, part in pairs(lp.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * 0.5
        end
    end
end)

AvatarSection:NewButton("Tamanho Grande", "Deixa o personagem gigante", function()
    for _, part in pairs(lp.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * 2
        end
    end
end)

AvatarSection:NewButton("Animação Dança", "Faz o personagem dançar", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://3189773368" -- Exemplo de dança
    local track = lp.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(anim)
    track:Play()
end)

AvatarSection:NewButton("Animação Flutuar", "Faz o personagem flutuar", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://507771019" -- Exemplo de flutuar
    local track = lp.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(anim)
    track:Play()
end)

--[[
    VoidReaper Hub Admin - Casas
    Criado por Reaper Xploits
    Baseado no Nytherune Hub original
]]

local HouseSection = Window:FindFirstChild("Casas"):FindFirstChildOfClass("Section")
local lp = game:GetService("Players").LocalPlayer

HouseSection:NewButton("Teleportar para Casa", "Teleporta para sua casa", function()
    local house = workspace:FindFirstChild(lp.Name .. "House")
    if house and house:FindFirstChild("Door") then
        lp.Character:MoveTo(house.Door.Position + Vector3.new(0, 5, 0))
    else
        warn("Casa não encontrada.")
    end
end)

HouseSection:NewButton("Abrir Todas as Portas", "Abre todas as portas da casa", function()
    local house = workspace:FindFirstChild(lp.Name .. "House")
    if house then
        for _, obj in pairs(house:GetDescendants()) do
            if obj:IsA("ClickDetector") and obj.Parent.Name == "Door" then
                fireclickdetector(obj)
            end
        end
    end
end)

HouseSection:NewButton("Entrar na Casa", "Entra na casa pela porta", function()
    local house = workspace:FindFirstChild(lp.Name .. "House")
    if house and house:FindFirstChild("Door") then
        lp.Character:MoveTo(house.Door.Position + Vector3.new(0, 2, 0))
    end
end)

HouseSection:NewButton("Sair da Casa", "Teleporta para fora da casa", function()
    lp.Character:MoveTo(Vector3.new(0, 10, 0)) -- posição genérica fora da casa
end)

--[[
    VoidReaper Hub Admin - Configurações
    Criado por Reaper Xploits
    Baseado no Nytherune Hub original
]]

local SettingsSection = Window:FindFirstChild("Configurações"):FindFirstChildOfClass("Section")
local lp = game:GetService("Players").LocalPlayer

-- Proteção contra kick
SettingsSection:NewButton("Anti-Kick", "Impede que você seja expulso", function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if getnamecallmethod() == "Kick" then
            return
        end
        return old(self, unpack(args))
    end)
end)

-- Proteção contra crash
SettingsSection:NewButton("Anti-Crash", "Bloqueia tentativas de crash", function()
    game:GetService("RunService"):SetThrottleFramerateEnabled(false)
end)

-- Sistema de chave (opcional)
SettingsSection:NewButton("Verificar Chave", "Verifica se você tem acesso", function()
    local chave = "VoidReaperX"
    local input = tostring(game:GetService("Players").LocalPlayer.Name)
    if input == chave then
        print("Acesso liberado para:", input)
    else
        warn("Chave inválida para:", input)
        game:GetService("Players").LocalPlayer:Kick("Chave inválida.")
    end
end)

-- Resetar configurações
SettingsSection:NewButton("Resetar Configurações", "Reseta proteções e velocidade", function()
    game:GetService("RunService"):SetThrottleFramerateEnabled(true)
    lp.Character.Humanoid.WalkSpeed = 16
end)
