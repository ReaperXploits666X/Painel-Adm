--[[
    VOIDREAPER_HAVOC666X // V44 SUPREME
    FUNÇÕES INCLUÍDAS:
    1. GHOST MODE (Invisibilidade com correção de corpo)
    2. VOID FORCE (Ajuste de força/hitbox 1-100)
    3. TARGET SYSTEM (Lista de jogadores selecionável)
    4. FREEZE TARGET (Trava o alvo selecionado)
    5. FAKE KICK 277 (Expulsa o alvo com erro de net)
    6. SHADOW ASSAULT (Teleporte para as costas do alvo)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- --- LIMPEZA DE VERSÕES ---
local old = game:GetService("CoreGui"):FindFirstChild("VoidProject") or LocalPlayer.PlayerGui:FindFirstChild("VoidProject")
if old then old:Destroy() end

local Config = {
    Invis = false,
    Force = 1,
    Target = nil,
    Shadow = false,
    Freeze = false
}

-- --- MOTOR DO SCRIPT (FORÇA/GHOST/SHADOW/FREEZE) ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        -- Invisibilidade & Anti-Bloco
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if Config.Invis then v.Transparency = 1 
                elseif v.Transparency == 1 then v.Transparency = 0 end
            end
        end
        -- Força (Hitbox)
        if Config.Force > 1 then
            local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
            if hand then hand.Size = Vector3.new(Config.Force, Config.Force, Config.Force) hand.CanCollide = false end
        end
    end

    -- Lógica de Alvo
    if Config.Target and Config.Target.Character then
        local tRoot = Config.Target.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            -- Freeze Alvo
            tRoot.Anchored = Config.Freeze
            -- Shadow Assault (Backstab)
            if Config.Shadow then
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                if myRoot and (myRoot.Position - tRoot.Position).Magnitude < 15 then
                    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
end)

-- --- INTERFACE ---
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer.PlayerGui)
Screen.Name = "VoidProject"
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 350, 0, 320)
Main.Position = UDim2.new(0.5, -175, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Main.Draggable = true
Main.Active = true

-- LISTA DE JOGADORES (LADO ESQUERDO)
local List = Instance.new("ScrollingFrame", Main)
List.Size = UDim2.new(0, 140, 1, -40)
List.Position = UDim2.new(0, 10, 0, 30)
List.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Instance.new("UIListLayout", List)

local tLabel = Instance.new("TextLabel", Main)
tLabel.Size = UDim2.new(1, 0, 0, 25)
tLabel.Text = "ALVO: NENHUM"
tLabel.TextColor3 = Color3.new(1, 1, 0)
tLabel.BackgroundTransparency = 1

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
                tLabel.Text = "ALVO: " .. p.Name:upper()
            end)
        end
    end
end
Refresh()
Players.PlayerAdded:Connect(Refresh)

-- BOTÕES DE FUNÇÃO (LADO DIREITO)
local function AddBtn(name, y, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 180, 0, 35)
    b.Position = UDim2.new(0, 160, 0, y)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(func)
    return b
end

local bInvis = AddBtn("GHOST MODE: OFF", 30, function() 
    Config.Invis = not Config.Invis 
    Screen.Main.TextButton.Text = "GHOST MODE: " .. (Config.Invis and "ON" or "OFF")
end)

AddBtn("SHADOW ASSAULT: OFF", 70, function() Config.Shadow = not Config.Shadow end)
AddBtn("FREEZE ALVO: OFF", 110, function() Config.Freeze = not Config.Freeze end)
AddBtn("KICK ERROR 277", 150, function() if Config.Target then Config.Target:Kick("\n\n(Error Code: 277)\nCheck Connection.") end end)

-- CONTROLE DE FORÇA
local fLabel = Instance.new("TextLabel", Main)
fLabel.Size = UDim2.new(0, 180, 0, 20)
fLabel.Position = UDim2.new(0, 160, 0, 195)
fLabel.Text = "FORÇA: 1"
fLabel.TextColor3 = Color3.new(1,1,1)
fLabel.BackgroundTransparency = 1

AddBtn("FORÇA +10", 220, function() Config.Force = math.min(Config.Force + 10, 100) fLabel.Text = "FORÇA: "..Config.Force end)
AddBtn("FORÇA -10", 260, function() Config.Force = math.max(Config.Force - 10, 1) fLabel.Text = "FORÇA: "..Config.Force end)

-- BOTÃO VOID (ABRIR/FECHAR)
local Open = Instance.new("TextButton", Screen)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Position = UDim2.new(0, 5, 0.5, -25)
Open.Text = "VOID"
Open.BackgroundColor3 = Color3.new(0,0,0)
Open.TextColor3 = Color3.new(1,0,0)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)
Open.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
