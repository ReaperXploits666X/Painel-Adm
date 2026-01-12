--[[
    VOIDREAPER_HAVOC666X // V42
    FIX: Script não aparecia no Delta.
    NEW: Slider de Força (1 a 100) simplificado.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Garante que não haja duplicatas
if game:GetService("CoreGui"):FindFirstChild("VoidV42") then 
    game:GetService("CoreGui").VoidV42:Destroy() 
end

local Config = {
    Invis = false,
    Shadow = false,
    ForceValue = 1,
    Target = nil
}

-- --- SISTEMA DE FORÇA E GHOST ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        -- Força (Hitbox)
        if Config.ForceValue > 1 then
            local p = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
            if p then
                p.Size = Vector3.new(Config.ForceValue, Config.ForceValue, Config.ForceValue)
                p.CanCollide = false
            end
        end
        -- Ghost
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if Config.Invis then v.Transparency = 1 
                elseif v.Transparency == 1 then v.Transparency = 0 end
            end
        end
    end
end)

-- --- INTERFACE ESTILIZADA ---
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = "VoidV42"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150) -- Centro da tela
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true -- Pode arrastar

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "VOID OVERLORD V42"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.new(0,0,0)

-- Botão Ghost
local b1 = Instance.new("TextButton", Main)
b1.Size = UDim2.new(0, 230, 0, 40)
b1.Position = UDim2.new(0, 10, 0, 40)
b1.Text = "GHOST MODE: OFF"
b1.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
b1.TextColor3 = Color3.new(1, 1, 1)
b1.MouseButton1Click:Connect(function()
    Config.Invis = not Config.Invis
    b1.Text = "GHOST MODE: " .. (Config.Invis and "ON" or "OFF")
end)

-- Label de Força
local flabel = Instance.new("TextLabel", Main)
flabel.Size = UDim2.new(0, 230, 0, 30)
flabel.Position = UDim2.new(0, 10, 0, 90)
flabel.Text = "FORÇA (HITBOX): 1"
flabel.TextColor3 = Color3.new(1, 1, 0)
flabel.BackgroundTransparency = 1

-- Slider Simples (Botões de + e - para evitar bugs de arrastar no Delta)
local bPlus = Instance.new("TextButton", Main)
bPlus.Size = UDim2.new(0, 110, 0, 40)
bPlus.Position = UDim2.new(0, 130, 0, 120)
bPlus.Text = "FORÇA +"
bPlus.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
bPlus.TextColor3 = Color3.new(1,1,1)
bPlus.MouseButton1Click:Connect(function()
    Config.ForceValue = math.min(Config.ForceValue + 5, 100)
    flabel.Text = "FORÇA (HITBOX): " .. Config.ForceValue
end)

local bMinus = Instance.new("TextButton", Main)
bMinus.Size = UDim2.new(0, 110, 0, 40)
bMinus.Position = UDim2.new(0, 10, 0, 120)
bMinus.Text = "FORÇA -"
bMinus.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
bMinus.TextColor3 = Color3.new(1,1,1)
bMinus.MouseButton1Click:Connect(function()
    Config.ForceValue = math.max(Config.ForceValue - 5, 1)
    flabel.Text = "FORÇA (HITBOX): " .. Config.ForceValue
end)

-- Botão de Minimizar (Canto da tela)
local MinBtn = Instance.new("TextButton", Screen)
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Position = UDim2.new(0, 10, 0, 10)
MinBtn.Text = "VOID"
MinBtn.BackgroundColor3 = Color3.new(0,0,0)
MinBtn.TextColor3 = Color3.new(1,0,0)
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
Tog.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
