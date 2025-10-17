local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Criar GUI principal
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PainelAdminV1Demo"

-- Botão para abrir/fechar o painel
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Abrir Painel"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18

-- Painel principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true

toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Fechar Painel" or "Abrir Painel"
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Painel Admin V1.0 Demo"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Lista de jogadores (ScrollingFrame)
local selectedPlayer = nil
local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(1, -20, 0, 120)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
playerList.BorderSizePixel = 0
playerList.Visible = false

local listLayout = Instance.new("UIListLayout", playerList)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)

local toggleList = Instance.new("TextButton", frame)
toggleList.Size = UDim2.new(1, -20, 0, 40)
toggleList.Text = "Mostrar Lista de Jogadores"
toggleList.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
toggleList.TextColor3 = Color3.new(0, 0, 0)
toggleList.Font = Enum.Font.SourceSans
toggleList.TextSize = 18

toggleList.MouseButton1Click:Connect(function()
	playerList.Visible = not playerList.Visible
	toggleList.Text = playerList.Visible and "Ocultar Lista de Jogadores" or "Mostrar Lista de Jogadores"
end)

local function atualizarLista()
	for _, child in pairs(playerList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	for _, p in pairs(Players:GetPlayers()) do
		local btn = Instance.new("TextButton", playerList)
		btn.Size = UDim2.new(1, -10, 0, 30)
		btn.Text = p.Name
		btn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		btn.TextColor3 = Color3.new(0, 0, 0)
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 16
		btn.MouseButton1Click:Connect(function()
			selectedPlayer = p.Name
			toggleList.Text = "Selecionado: " .. p.Name
			playerList.Visible = false
		end)
	end

	playerList.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 34)
end

Players.PlayerAdded:Connect(atualizarLista)
Players.PlayerRemoving:Connect(atualizarLista)
atualizarLista()

-- Função para criar botões
local function criarBotao(nome, acao)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Text = nome
	btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.MouseButton1Click:Connect(acao)
end

-- Botões de ação
criarBotao("Ativar Voo", function()
	ReplicatedStorage.AdminCommands:FireServer("Fly")
end)

criarBotao("Aumentar Velocidade", function()
	ReplicatedStorage.AdminCommands:FireServer("Speed", 100)
end)

criarBotao("Invisibilidade", function()
	ReplicatedStorage.AdminCommands:FireServer("Invis")
end)

criarBotao("Resetar Personagem", function()
	ReplicatedStorage.AdminCommands:FireServer("Reset")
end)

criarBotao("Killar Jogador", function()
	if selectedPlayer then
		ReplicatedStorage.AdminCommands:FireServer("Say", ";kill " .. selectedPlayer)
		ReplicatedStorage.AdminCommands:FireServer("Kill", selectedPlayer)
	end
end)

criarBotao("Kickar Jogador", function()
	if selectedPlayer then
		ReplicatedStorage.AdminCommands:FireServer("Say", ";kick " .. selectedPlayer)
		ReplicatedStorage.AdminCommands:FireServer("Kick", selectedPlayer)
	end
end)
