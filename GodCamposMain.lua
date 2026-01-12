--[[
    VOIDREAPER_HAVOC666X // V47 - SUPREMO
    LISTA DE FUNÇÕES INCLUÍDAS:
    1. GHOST MODE: Invisível sem bugar o corpo.
    2. SUPER FORÇA (1-100): Aumenta o dano e o alcance sem braço gigante.
    3. LISTA DE JOGADORES: Seleciona o alvo clicando no nome.
    4. FREEZE TARGET: Congela apenas o cara selecionado.
    5. SHADOW ASSAULT: Teleporte automático para as costas do alvo.
    6. KICK ERROR 277: Expulsa o alvo com a mensagem de falha na internet.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Limpa execuções passadas
local old = game:GetService("CoreGui"):FindFirstChild("VoidV47") or LocalPlayer.PlayerGui:FindFirstChild("VoidV47")
if old then old:Destroy() end

local Config = {
    Invis = false,
    Power = 1,
    Target = nil,
    Shadow = false,
    Freeze = false
}

-- --- MOTOR DE COMBATE E EFEITOS ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    -- 1. GHOST MODE (CORRIGIDO)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            if Config.Invis then v.Transparency = 1
            elseif v.Transparency == 1 and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
        end
    end

    -- 2. LÓGICA DE ALVO E DANO (SUPER FORÇA 1-100)
    if Config.Target and Config.Target.Character then
        local tRoot = Config.Target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = char.PrimaryPart
        
        if tRoot and myRoot then
            -- Freeze Alvo
            tRoot.Anchored = Config.Freeze
            
            -- Shadow Assault (Backstab)
            if Config.Shadow and (myRoot.Position - tRoot.Position).Magnitude < 20 then
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
            end

            -- Super Dano (Multiplicador de Ataque)
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and Config.Power > 1 then
                local dist = (myRoot.Position - tRoot.Position).Magnitude
                if dist < (10 + Config.Power/4) then -- Alcance invisível aumenta com a força
                    for i = 1, math.floor(Config.Power/15) + 1 do
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- --- INTERFACE TUDO-EM-UM ---
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer.PlayerGui)
Screen.Name = "VoidV47"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 350)
Main.Position = UDim2.new(0.5, -190, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
Main.Draggable = true
Main.Active = true
Instance.new("UIStroke", Main).Color = Color3.new(1, 0, 0)

-- LISTA DE JOGADORES (ESQUERDA)
local List = Instance.new("ScrollingFrame", Main)
List.Size = UDim2.new(0, 150, 0, 260)
List.Position = UDim2.new(0, 10, 0, 40)
List.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
Instance.new("UIListLayout", List)

local function Refresh()
    for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton", List)
            b.Size = UDim2.new(1, 0, 0, 30)
            b.Text = p.DisplayName
            b.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.MouseButton1Click:Connect(function() 
                Config.Target = p 
            end)
        end
    end
end
Refresh()

-- BOTÕES DE FUNÇÕES (DIREITA)
local function AddB(name, y, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 200, 0, 40)
    b.Position = UDim2.new(0, 170, 0, y)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(func)
end

AddB("GHOST MODE (ON/OFF)", 40, function() Config.Invis = not Config.Invis end)
AddB("FREEZE ALVO (ON/OFF)", 85, function() Config.Freeze = not Config.Freeze end)
AddB("SHADOW ASSAULT (ON/OFF)", 130, function() Config.Shadow = not Config.Shadow end)
AddB("KICK ERRO 277 (ALVO)", 175, function() if Config.Target then Config.Target:Kick("\n\nErro de Conexão (277)") end end)

-- CONTROLE DE FORÇA (DANO)
local pLabel = Instance.new("TextLabel", Main)
pLabel.Size = UDim2.new(0, 200, 0, 20)
pLabel.Position = UDim2.new(0, 170, 0, 225)
pLabel.Text = "FORÇA DO DANO: 1"
pLabel.TextColor3 = Color3.new(1, 1, 0)
pLabel.BackgroundTransparency = 1

AddB("FORÇA +10", 255, function() Config.Power = math.min(Config.Power + 10, 100) pLabel.Text = "FORÇA DO DANO: "..Config.Power end)
AddB("FORÇA -10", 300, function() Config.Power = math.max(Config.Power - 10, 1) pLabel.Text = "FORÇA DO DANO: "..Config.Power end)

-- Botão VOID (Abrir/Fechar)
local Open = Instance.new("TextButton", Screen)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Position = UDim2.new(0, 5, 0.5, -25)
Open.Text = "VOID"
Open.BackgroundColor3 = Color3.new(0,0,0)
Open.TextColor3 = Color3.new(1,0,0)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)
Open.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("V47 - ALL FEATURES LOADED")
