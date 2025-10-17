local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PainelAdminV1Demo"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

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

-- Lista de jogadores
local selectedPlayer = nil
local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 40)
dropdown.Text = "Selecionar Jogador"
dropdown.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
dropdown.TextColor3 = Color3.new(0, 0, 0)
dropdown.Font = Enum.Font.SourceSans
dropdown.TextSize = 18

local function atualizarLista()
	dropdown:ClearAllChildren()
	for _, p in pairs(Players:GetPlayers()) do
		local opt = Instance.new("TextButton", dropdown)
		opt.Size = UDim2.new(1, 0, 0, 30)
		opt.Text = p.Name
		opt.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
		opt.TextColor3 = Color3.new(0, 0, 0)
		opt.MouseButton1Click:Connect(function()
			selectedPlayer = p.Name
			dropdown.Text = "Selecionado: " .. p.Name
			for _, child in pairs(dropdown:GetChildren()) do
				if child:IsA("TextButton") then child.Visible = false end
			end
		end)
	end
end

dropdown.MouseButton1Click:Connect(function()
	for _, child in pairs(dropdown:GetChildren()) do
		if child:IsA("TextButton") then
			child.Visible = not child.Visible
		end
	end
end)

Players.PlayerAdded:Connect(atualizarLista)
Players.PlayerRemoving:Connect(atualizarLista)
atualizarLista()

-- Botões
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminCommands = ReplicatedStorage:WaitForChild("AdminCommands")

AdminCommands.OnServerEvent:Connect(function(player, comando, valor)
	if player.Name ~= "SeuNomeAqui" then return end -- Substitua pelo seu nome de usuário

	if comando == "Fly" then
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.Velocity = Vector3.new(0, 50, 0) end

	elseif comando == "Speed" then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = valor end

	elseif comando == "Invis" then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Transparency = 1 end
		end

	elseif comando == "Reset" then
		player:LoadCharacter()

	elseif comando == "Kill" then
		local target = game.Players:FindFirstChild(valor)
		if target and target.Character then
			local hum = target.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		end

	elseif comando == "Kick" then
		local target = game.Players:FindFirstChild(valor)
		if target then
			target:Kick("Você foi expulso pelo admin.")
		end

	elseif comando == "Say" then
		local head = player.Character and player.Character:FindFirstChild("Head")
		if head then
			game:GetService("Chat"):Chat(head, valor, Enum.ChatColor.Red)
		end
	end
end)
