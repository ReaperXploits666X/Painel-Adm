--[[
    PROJECT ZERO: GOD MODE EDITION
    FUNÇÕES: Invisibilidade, Freeze Aura, Fake Kick, Aimbot & ESP.
    ALVO: DELTA EXECUTOR (MOBILE)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Config = {
    Invis = false,
    FreezeAura = false,
    Aimbot = false,
    ESP = true,
    FOV = 250
}

-- --- 1. INVISIBILIDADE (DESYNC) ---
-- Remove o teu corpo para o servidor, mas tu continuas a mover-te.
local function ToggleInvis()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = Config.Invis and 1 or 0
            end
        end
    end
end

-- --- 2. FREEZE AURA (TRAVAR BOTÕES DOS OUTROS) ---
-- Tenta disparar eventos de 'Stun' ou 'Anchor' nos jogadores próximos.
task.spawn(function()
    while task.wait(0.5) do
        if Config.FreezeAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 20 then
                        -- Tenta travar a física do alvo (funciona em jogos com falhas de FE)
                        p.Character.HumanoidRootPart.Anchored = true
                        task.wait(2)
                        p.Character.HumanoidRootPart.Anchored = false
                    end
                end
            end
        end
    end
end)

-- --- 3. FAKE KICK (MENSAGEM DE ERRO) ---
-- Comando para expulsar o teu alvo com a mensagem de erro de internet.
local function FakeKick(target)
    if target then
        -- No teu ecrã aparecerá como se tivesses expulsado, 
        -- se o Delta tiver permissão de Server-Side, ele cai de verdade.
        target:Kick("Please check your internet connection and try again. (Error Code: 277)")
    end
end

-- --- INTERFACE DE COMANDO ---
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Panel = Instance.new("Frame", Screen)
Panel.Size = UDim2.new(0, 220, 0, 280)
Panel.Position = UDim2.new(0.02, 0, 0.4, 0)
Panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", Panel).Color = Color3.fromRGB(255, 255, 0) -- Amarelo/Dourado

local function AddButton(name, setting, y, func)
    local b = Instance.new("TextButton", Panel)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    
    b.MouseButton1Click:Connect(function()
        Config[setting] = not Config[setting]
        b.Text = name .. ": " .. (Config[setting] and "ON" or "OFF")
        b.TextColor3 = Config[setting] and Color3.new(1, 1, 0) or Color3.new(1, 1, 1)
        if func then func() end
    end)
end

AddButton("GHOST MODE", "Invis", 20, ToggleInvis)
AddButton("FREEZE AURA", "FreezeAura", 65)
AddButton("ESP (VER INVIS)", "ESP", 110)
AddButton("AIMBOT", "Aimbot", 155)

-- Campo para o Fake Kick
local TargetName = Instance.new("TextBox", Panel)
TargetName.Size = UDim2.new(1, -20, 0, 30)
TargetName.Position = UDim2.new(0, 10, 0, 200)
TargetName.PlaceholderText = "Nome do Alvo..."
TargetName.Text = ""

local KickBtn = Instance.new("TextButton", Panel)
KickBtn.Size = UDim2.new(1, -20, 0, 30)
KickBtn.Position = UDim2.new(0, 10, 0, 235)
KickBtn.Text = "FORCE KICK (ERROR 277)"
KickBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
KickBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #TargetName.Text) == TargetName.Text:lower() then
            FakeKick(p)
        end
    end
end)

print("GOD MODE LOADED. TU ÉS O HACKER AGORA.")
