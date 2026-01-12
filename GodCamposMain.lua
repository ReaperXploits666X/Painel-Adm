--[[
    VOIDREAPER_HAVOC666X // V35 FINAL
    FIXED: Movimentação, Invisibilidade Constante, Fake Kick Select.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Config = {
    Invis = false,
    FreezeAura = false,
    Visible = true
}

-- --- 1. INVISIBILIDADE PERMANENTE (CORRIGIDO) ---
RunService.RenderStepped:Connect(function()
    if Config.Invis then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    v.Transparency = 1
                end
            end
        end
    end
end)

-- --- 2. INTERFACE ARRÁSTAVEL E MINIMIZÁVEL ---
if CoreGui:FindFirstChild("OverlordV35") then CoreGui.OverlordV35:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "OverlordV35"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Position = UDim2.new(0.5, -110, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true -- Agora você pode mover!
Instance.new("UIStroke", Main).Color = Color3.new(1, 0, 0)
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SUPREME OVERLORD"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code

-- --- BOTÕES ---
local function AddToggle(name, setting, y)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    
    b.MouseButton1Click:Connect(function()
        Config[setting] = not Config[setting]
        b.Text = name .. ": " .. (Config[setting] and "ON" or "OFF")
        b.TextColor3 = Config[setting] and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
    end)
end

AddToggle("GHOST MODE", "Invis", 40)
AddToggle("FREEZE AURA", "FreezeAura", 85)

-- --- SELEÇÃO DE KICK (ERRO 277) ---
local Box = Instance.new("TextBox", Main)
Box.Size = UDim2.new(1, -20, 0, 35)
Box.Position = UDim2.new(0, 10, 0, 135)
Box.PlaceholderText = "NOME DO JOGADOR..."
Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Box.TextColor3 = Color3.new(1, 1, 1)

local KickBtn = Instance.new("TextButton", Main)
KickBtn.Size = UDim2.new(1, -20, 0, 40)
KickBtn.Position = UDim2.new(0, 10, 0, 180)
KickBtn.Text = "SEND: FAKE ERROR 277"
KickBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
KickBtn.TextColor3 = Color3.new(1, 1, 1)

KickBtn.MouseButton1Click:Connect(function()
    local targetName = Box.Text:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #targetName) == targetName then
            -- MENSAGEM QUE FINGE QUEDA DE INTERNET
            p:Kick("\n\nPlease check your internet connection and try again.\n(Error Code: 277)")
        end
    end
end)

-- --- BOTÃO DE ABRIR/FECHAR ---
local ToggleBtn = Instance.new("TextButton", Screen)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleBtn.Text = "H"
ToggleBtn.BackgroundColor3 = Color3.new(0, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.new(1, 0, 0)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

ToggleBtn.MouseButton1Click:Connect(function()
    Config.Visible = not Config.Visible
    Main.Visible = Config.Visible
end)

-- --- LÓGICA FREEZE ---
task.spawn(function()
    while task.wait(0.5) do
        if Config.FreezeAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if d < 15 then
                        p.Character.HumanoidRootPart.Anchored = true
                        task.wait(1)
                        p.Character.HumanoidRootPart.Anchored = false
                    end
                end
            end
        end
    end
end)

print("SUPREME OVERLORD V35 CARREGADO. USE O 'H' PARA ABRIR/FECHAR.")
