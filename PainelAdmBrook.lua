local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

-- Painel principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 500)
frame.Position = UDim2.new(0.5, -170, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 4
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 0.1

-- Borda RGB amarela animada
task.spawn(function()
	while true do
		for i = 0, 1, 0.02 do
			frame.BorderColor3 = Color3.fromRGB(255, math.floor(i*255), 0)
			wait(0.05)
		end
		for i = 1, 0, -0.02 do
			frame.BorderColor3 = Color3.fromRGB(255, math.floor(i*255), 0)
			wait(0.05)
		end
	end
end)

-- Título
local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 50)
titulo.Text = " Painel ADM"
titulo.TextColor3 = Color3.fromRGB(255, 215, 0)
titulo.Font = Enum.Font.Fantasy
titulo.TextSize = 26
titulo.BackgroundTransparency = 1

-- Lista de jogadores
local jogadorSelecionado = nil
local listaJogadores = Instance.new("ScrollingFrame", frame)
listaJogadores.Size = UDim2.new(0.9, 0, 0, 120)
listaJogadores.Position = UDim2.new(0.05, 0, 0, 60)
listaJogadores.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
listaJogadores.BorderSizePixel = 0
listaJogadores.CanvasSize = UDim2.new(0, 0, 0, 0)
listaJogadores.ScrollBarThickness = 6

local function atualizarLista()
	listaJogadores:ClearAllChildren()
	local y = 0
	for _, jogador in pairs(game.Players:GetPlayers()) do
		local botao = Instance.new("TextButton", listaJogadores)
		botao.Size = UDim2.new(1, 0, 0, 30)
		botao.Position = UDim2.new(0, 0, 0, y)
		botao.Text = jogador.Name
		botao.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		botao.TextColor3 = Color3.new(1, 1, 1)
		botao.Font = Enum.Font.Fantasy
		botao.TextSize = 16
		botao.MouseButton1Click:Connect(function()
			jogadorSelecionado = jogador
			titulo.Text = " Painel ADM - " .. jogador.Name
		end)
		y += 35
	end
	listaJogadores.CanvasSize = UDim2.new(0, 0, 0, y)
end

atualizarLista()

-- Comandos simulados
local comandos = {
	{nome = "Kick", acao = function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CFrame = CFrame.new(Vector3.new(9999, 9999, 9999)) end
		local gui = Instance.new("ScreenGui", t:WaitForChild("PlayerGui"))
		local tela = Instance.new("Frame", gui)
		tela.Size = UDim2.new(1, 0, 1, 0)
		tela.BackgroundColor3 = Color3.new(0, 0, 0)
		local msg = Instance.new("TextLabel", tela)
		msg.Size = UDim2.new(1, 0, 0, 100)
		msg.Position = UDim2.new(0, 0, 0.5, -50)
		msg.Text = "Você foi expulso pelo ADM"
		msg.TextColor3 = Color3.new(1, 0, 0)
		msg.Font = Enum.Font.Fantasy
		msg.TextSize = 32
		msg.BackgroundTransparency = 1
	end},

	{nome = "Kill", acao = function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(0, 10000, 0)
			task.wait(0.2)
			hrp.CFrame = hrp.CFrame + Vector3.new(0, 10000, 0)
		end
	end},

	{nome = "Jail", acao = function(t)
		local char = t.Character
		if not char then return end
		local cage = Instance.new("Part")
		cage.Size = Vector3.new(6, 6, 6)
		cage.Anchored = true
		cage.Transparency = 0.5
		cage.Color = Color3.fromRGB(0, 170, 255)
		cage.Position = char:FindFirstChild("HumanoidRootPart").Position
		cage.Name = "JailCube"
		cage.Parent = workspace
		for _, parte in pairs(char:GetDescendants()) do
			if parte:IsA("BasePart") then parte.Color = Color3.fromRGB(30, 30, 30) end
		end
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 0 h.JumpPower = 0 end
	end},

	{nome = "Unjail", acao = function(t)
		for _, obj in pairs(workspace:GetChildren()) do
			if obj.Name == "JailCube" then obj:Destroy() end
		end
	end},

	{nome = "Freeze", acao = function(t)
		local char = t.Character
		if not char then return end
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = true end
		end
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 0 h.JumpPower = 0 end
	end},

	{nome = "Unfreeze", acao = function(t)
		local char = t.Character
		if not char then return end
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = false end
		end
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 16 h.JumpPower = 50 end
	end},

	{nome = "Bring", acao = function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		local myhrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if hrp and myhrp then hrp.CFrame = myhrp.CFrame + Vector3.new(2, 0, 0) end
	end},

	{nome = "TP", acao = function(t)
		local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		local targethrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp and targethrp then hrp.CFrame = targethrp.CFrame + Vector3.new(2, 0, 0) end
	end},

	{nome = "Unban Houses", acao = function()
		local banned = game.ReplicatedStorage:FindFirstChild("BannedLots")
		if banned then banned:Destroy() end
	end},

	{nome = "Get All House Access", acao = function()
		for _, house in pairs(workspace:GetChildren()) do
			if house:FindFirstChild("Door") then
				for _, part in pairs(house:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end
	end},
}

-- Botões de comando
for i, cmd in ipairs(comandos) do
	local botao = Instance.new("TextButton", frame)
	botao.Size = UDim2.new(0.42, 0, 0, 35)
	botao.Position = UDim2.new(0.05 + ((i-1)%2)*0.48, 0, 0, 200 + math.floor((i-1)/2)*40)
	botao.Text = cmd.nome
	botao.BackgroundColor3 = Color3.fromRGB(255,
