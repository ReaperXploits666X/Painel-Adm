--[[
    VOIDREAPER_HAVOC666X // V37
    MOD: Freeze Aura focado apenas no alvo selecionado.
    FIX: Invisibilidade e Interface Mobile.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Config = {
    Invis = false,
    FreezeTarget = false, -- Agora foca no alvo
    Visible = true
}

-- --- 1. SISTEMA DE INVISIBILIDADE ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if Config.Invis then
                    v.Transparency = 1
                elseif v.Transparency == 1 then
                    v.Transparency = 0
                end
            end
        end
    end
end)

-- --- 2. INTERFACE ---
if CoreGui:FindFirstChild("OverlordV37") then CoreGui.OverlordV37:Destroy() end
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "OverlordV37"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Position = UDim2.new(0.5, -110, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true 
Instance.new("UIStroke", Main).Color = Color3.new(1, 0, 0)
Instance.new("UICorner", Main)

local function AddToggle(name, setting, y)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        Config[setting] = not Config[setting]
        b.Text = name .. ": " .. (Config[setting] and "ON" or "OFF")
        b.TextColor3 = Config[setting] and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
    end)
end

AddToggle("GHOST MODE", "Invis", 40)
AddToggle("FREEZE TARGET", "FreezeTarget", 85) -- Botão focado no alvo

-- --- SELEÇÃO DE ALVO ---
local Box = Instance.new("TextBox", Main)
Box.Size = UDim2.new(1, -20, 0, 35)
Box.Position = UDim2.new(0, 10, 0, 135)
Box.PlaceholderText = "NOME DO ALVO..."
Box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Box.TextColor3 = Color3.new(1, 1, 1)

local KickBtn = Instance.new("TextButton", Main)
KickBtn.Size = UDim2.new(1, -20, 0, 40)
KickBtn.Position = UDim2.new(0, 10, 0, 180)
KickBtn.Text = "KICK: FAKE ERROR 277"
KickBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
KickBtn.TextColor3 = Color3.new(1, 1, 1)

KickBtn.MouseButton1Click:Connect(function()
    local targetName = Box.Text:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Name:lower():sub(1, #targetName) == targetName then
            p:Kick("\n\n(Error Code: 277)\nPlease check your internet connection and try again.")
        end
    end
end)

-- Botão Minimizar (H)
local Tog = Instance.new("TextButton", Screen)
Tog.Size = UDim2.new(0, 45, 0, 45)
Tog.Position = UDim2.new(0.02, 0, 0.4, 0)
Tog.Text = "H"
Tog.BackgroundColor3 = Color3.new(0, 0, 0)
Tog.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UIStroke", Tog).Color = Color3.new(1, 0, 0)
Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)
Tog.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- LÓGICA FREEZE FOCADA NO ALVO ---
task.spawn(function()
    while task.wait(0.3) do
        if Config.FreezeTarget then
            local targetName = Box.Text:lower()
            if targetName ~= "" then
                for _, p in pairs(Players:GetPlayers()) do
                    -- Verifica se o nome do jogador começa com o que você digitou
                    if p ~= LocalPlayer and p.Name:lower():sub(1, #targetName) == targetName then
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            -- Se o alvo estiver a menos de 20 studs, ele congela
                            if d < 20 then
                                p.Character.HumanoidRootPart.Anchored = true
                            else
                                p.Character.HumanoidRootPart.Anchored = false
                            end
                        end
                    end
                end
            end
        else
            -- Se desligar o botão, garante que ninguém fique travado
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Anchored = false
                end
            end
        end
    end
end)
