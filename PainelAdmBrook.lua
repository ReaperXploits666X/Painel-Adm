local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Text = "Painel Adm 👑"
titulo.TextColor3 = Color3.new(1, 1, 0)
titulo.Font = Enum.Font.Fantasy
titulo.TextSize = 24
titulo.BackgroundTransparency = 1

-- Lista de comandos
local comandos = {
	{nome = ";kick", acao = function(target) target:Kick("Você foi expulso pelo ADM.") end},
	{nome = ";kill", acao = function(target) local h = target.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end},
	{nome = ";jail", acao = function(target)
		local cage = Instance.new("Part")
		cage.Size = Vector3.new(6, 6, 6)
		cage.Anchored = true
		cage.Transparency = 0.5
		cage.Color = Color3.fromRGB(0, 170, 255)
		cage.Position = target.Character:FindFirstChild("HumanoidRootPart").Position
		cage.Name = "JailCube"
		cage.Parent = workspace
	end},
	{nome = ";unjail", acao = function(target)
		for _, obj in pairs(workspace:GetChildren()) do
			if obj.Name == "JailCube" then obj:Destroy() end
		end
	end},
	{nome = ";freeze", acao = function(target)
		local h = target.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 0 h.JumpPower = 0 end
	end},
	{nome = ";unfreeze", acao = function(target)
		local h = target.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 16 h.JumpPower = 50 end
	end},
	{nome = ";bring", acao = function(target)
		local hrp = target.Character:FindFirstChild("HumanoidRootPart")
		local myhrp = p.Character:FindFirstChild("HumanoidRootPart")
		if hrp and myhrp then hrp.CFrame = myhrp.CFrame + Vector3.new(2, 0, 0) end
	end},
	{nome = ";tp", acao = function(target)
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		local targethrp = target.Character:FindFirstChild("HumanoidRootPart")
		if hrp and targethrp then hrp.CFrame = targethrp.CFrame + Vector3.new(2, 0, 0) end
	end},
}

-- Dropdown de jogadores
local listaJogadores = Instance.new("TextButton", frame)
listaJogadores.Size = UDim2.new(0.9, 0, 0, 30)
listaJogadores.Position = UDim2.new(0.05, 0, 0, 50)
listaJogadores.Text = "Abrir Lista de Jogadores"
listaJogadores.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
listaJogadores.TextColor3 = Color3.new(1, 1, 1)
listaJogadores.Font = Enum.Font.Fantasy
listaJogadores.TextSize = 18

local jogadorSelecionado = nil

listaJogadores.MouseButton1Click:Connect(function()
	for _, b in pairs(frame:GetChildren()) do
		if b.Name == "BotaoJogador" then b:Destroy() end
	end
	local y = 90
	for _, jogador in pairs(game.Players:GetPlayers()) do
		local botao = Instance.new("TextButton", frame)
		botao.Name = "BotaoJogador"
		botao.Size = UDim2.new(0.9, 0, 0, 30)
		botao.Position = UDim2.new(0.05, 0, 0, y)
		botao.Text = jogador.Name
		botao.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		botao.TextColor3 = Color3.new(1, 1, 1)
		botao.Font = Enum.Font.Fantasy
		botao.TextSize = 16
		botao.MouseButton1Click:Connect(function()
			jogadorSelecionado = jogador
			listaJogadores.Text = "Selecionado: " .. jogador.Name
		end)
		y += 35
	end
end)

-- Botões de comando
for i, cmd in ipairs(comandos) do
	local botao = Instance.new("TextButton", frame)
	botao.Size = UDim2.new(0.9, 0, 0, 30)
	botao.Position = UDim2.new(0.05, 0, 0, 350 + (i * 35))
	botao.Text = cmd.nome
	botao.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	botao.TextColor3 = Color3.new(0, 0, 0)
	botao.Font = Enum.Font.Fantasy
	botao.TextSize = 16
	botao.MouseButton1Click:Connect(function()
		if jogadorSelecionado then
			cmd.acao(jogadorSelecionado)
		end
	end)
end
