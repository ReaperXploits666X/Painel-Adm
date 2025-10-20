--[[
    VoidReaper Hub Admin 1.0
    Criado por Minemods e Reaper Xploits
    Inspirado no Nytherune-Hub
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local target = nil

-- GUI principal
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "VoidReaperHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "VoidReaper Hub Admin 1.0 - by Reaper Xploits"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Botões minimizar e fechar
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -60, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 18

-- Conteúdo
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1

-- Dropdown de jogadores
local dropdown = Instance.new("TextButton", content)
dropdown.Size = UDim2.new(1, 0, 0, 30)
dropdown.Position = UDim2.new(0, 0, 0, 0)
dropdown.Text = "Selecionar Jogador"
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14

local playerList = Instance.new("Frame", content)
playerList.Size = UDim2.new(1, 0, 0, 120)
playerList.Position = UDim2.new(0, 0, 0, 30)
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.Visible = false

dropdown.MouseButton1Click:Connect(function()
    playerList:ClearAllChildren()
    playerList.Visible = not playerList.Visible
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.MouseButton1Click:Connect(function()
                target = p
                dropdown.Text = "Selecionado: " .. p.Name
                playerList.Visible = false
            end)
            y = y + 20
        end
    end
end)

-- Comando: Kick
local kickBtn = Instance.new("TextButton", content)
kickBtn.Size = UDim2.new(1, 0, 0, 30)
kickBtn.Position = UDim2.new(0, 0, 0, 160)
kickBtn.Text = "Kick"
kickBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kickBtn.Font = Enum.Font.GothamBold
kickBtn.TextSize = 14
kickBtn.MouseButton1Click:Connect(function()
    if target then
        target:Kick("Você foi expulso pelo VoidReaper Hub.")
    end
end)

-- Botões minimizar e fechar
local minimized = false
minimize.MouseButton1Click:Connect(function()
    if minimized then
        content.Visible = true
        frame.Size = UDim2.new(0, 400, 0, 300)
        minimized = false
    else
        content.Visible = false
        frame.Size = UDim2.new(0, 400, 0, 30)
        minimized = true
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
