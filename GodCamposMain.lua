--[[
    VOIDREAPER_HAVOC666X // V41 POWER CONTROL
    NEW: Slider de Força (1 a 100).
    NEW: Hitbox Expander dinâmico.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Config = {
    Invis = false,
    ShadowAssault = false,
    VoidPowerValue = 1, -- Valor inicial do Slider
    Target = nil
}

-- --- SISTEMA DE CORPO & HITBOX ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        -- Lógica de Força (Hitbox)
        if Config.VoidPowerValue > 1 then
            for _, v in pairs(char:GetChildren()) do
                if v.Name:find("Arm") or v.Name:find("Hand") then
                    -- O tamanho aumenta conforme o slider (1 a 100)
                    local s = Config.VoidPowerValue
                    v.Size = Vector3.new(s, s, s)
                    v.CanCollide = false
                end
            end
        end

        -- Invisibilidade
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

-- --- INTERFACE ---
if CoreGui:FindFirstChild("OverlordV41") then CoreGui.OverlordV41:Destroy() end
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "OverlordV41"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 350)
Main.Position = UDim2.new(0.5, -190, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Draggable = true
Main.Active = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

-- --- LISTA DE JOGADORES ---
local List = Instance.new("ScrollingFrame", Main)
List.Size = UDim2.new(0, 150, 0, 250)
List.Position = UDim2.new(0, 10, 0, 40)
List.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UIListLayout", List)

local function Refresh()
    for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton", List)
            b.Size = UDim2.new(1, 0, 0, 30)
            b.Text = p.DisplayName
            b.BackgroundColor3 = Color3.fromRGB(30,0,0)
            b.TextColor3 = Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function() Config.Target = p end)
        end
    end
end
Refresh()

-- --- SLIDER DE FORÇA (1-100) ---
local SliderFrame = Instance.new("Frame", Main)
SliderFrame.Size = UDim2.new(0, 180, 0, 40)
SliderFrame.Position = UDim2.new(0, 180, 0, 200)
SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local SliderBtn = Instance.new("TextButton", SliderFrame)
SliderBtn.Size = UDim2.new(0, 20, 1, 0)
SliderBtn.BackgroundColor3 = Color3.new(1, 0, 0)
SliderBtn.Text = ""

local ValueLabel = Instance.new("TextLabel", Main)
ValueLabel.Size = UDim2.new(0, 180, 0, 20)
ValueLabel.Position = UDim2.new(0, 180, 0, 180)
ValueLabel.Text = "FORÇA: 1"
ValueLabel.TextColor3 = Color3.new(1,1,1)
ValueLabel.BackgroundTransparency = 1

SliderBtn.MouseButton1Down:Connect(function()
    local moveConnection
    moveConnection = RunService.RenderStepped:Connect(function()
        local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
        local relativePos = mousePos - SliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativePos / SliderFrame.AbsoluteSize.X, 0, 1)
        
        SliderBtn.Position = UDim2.new(percentage, -10, 0, 0)
        Config.VoidPowerValue = math.floor(percentage * 100) + 1
        ValueLabel.Text = "FORÇA: " .. Config.VoidPowerValue
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if moveConnection then moveConnection:Disconnect() end
        end
    end)
end)

-- --- BOTÕES ---
local function AddBtn(name, y, setting)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 180, 0, 40)
    b.Position = UDim2.new(0, 180, 0, y)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        Config[setting] = not Config[setting]
        b.Text = name .. ": " .. (Config[setting] and "ON" or "OFF")
    end)
end

AddBtn("GHOST MODE", 40, "Invis")
AddBtn("SHADOW ASSAULT", 90, "ShadowAssault")

-- Botão Minimizar
local Tog = Instance.new("TextButton", Screen)
Tog.Size = UDim2.new(0, 50, 0, 50)
Tog.Position = UDim2.new(0.02, 0, 0.4)
Tog.Text = "V41"
Tog.BackgroundColor3 = Color3.new(0,0,0)
Tog.TextColor3 = Color3.new(1,0,0)
Tog.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
