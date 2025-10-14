local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "AdministradorOficial"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 360)
frame.Position = UDim2.new(0.5, -140, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Text = "Administrador Oficial"
titulo.TextColor3 = Color3.fromRGB(255, 0, 0)
titulo.Font = Enum.Font.Fantasy
titulo.TextSize = 22
titulo.BackgroundTransparency = 1

local lista = Instance.new("ScrollingFrame", frame)
lista.Size = UDim2.new(0.9, 0, 0, 100)
lista.Position = UDim2.new(0.05, 0, 0, 50)
lista.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
lista.BorderSizePixel = 0
lista.ScrollBarThickness = 6
lista.CanvasSize = UDim2.new(0, 0, 0, 0)

local jogadorSelecionado = nil

local function atualizarLista()
	lista:ClearAllChildren()
	local y = 0
	for _, jogador in pairs(game.Players:GetPlayers()) do
		local b = Instance.new("TextButton", lista)
		b.Size = UDim2.new(1, 0, 0, 25)
		b.Position = UDim2.new(0, 0, 0, y)
		b.Text = jogador.Name
		b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.Fantasy
		b.TextSize = 14
		b.MouseButton1Click:Connect(function()
			jogadorSelecionado = jogador
			titulo.Text = "ADM - " .. jogador.Name
		end)
		y += 28
	end
	lista.CanvasSize = UDim2.new(0, 0, 0, y)
end

atualizarLista()
game.Players.PlayerAdded:Connect(atualizarLista)
game.Players.PlayerRemoving:Connect(atualizarLista)

local comandos = {
	{"Expulsar", function(t)
		local gui = Instance.new("ScreenGui", t:WaitForChild("PlayerGui"))
		local tela = Instance.new("Frame", gui)
		tela.Size = UDim2.new(1, 0, 1, 0)
		tela.BackgroundColor3 = Color3.new(0, 0, 0)
		local msg = Instance.new("TextLabel", tela)
		msg.Size = UDim2.new(1, 0, 0, 100)
		msg.Position = UDim2.new(0, 0, 0.5, -50)
		msg.Text = "Você foi expulso pelo Administrador"
		msg.TextColor3 = Color3.new(1, 0, 0)
		msg.Font = Enum.Font.Fantasy
		msg.TextSize = 32
		msg.BackgroundTransparency = 1
	end},
	{"Matar", function(t)
		local h = t.Character and t.Character:FindFirstChildOfClass("Humanoid")
		if h then h:TakeDamage(9999) end
	end},
	{"Prender", function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local cage = Instance.new("Part", workspace)
			cage.Size = Vector3.new(6, 6, 6)
			cage.Anchored = true
			cage.Position = hrp.Position
			cage.Transparency = 0.5
			cage.Color = Color3.fromRGB(0, 170, 255)
			cage.Name = "JailCube"
		end
	end},
	{"Soltar", function()
		for _, v in pairs(workspace:GetChildren()) do
			if v.Name == "JailCube" then v:Destroy() end
		end
	end},
	{"Congelar", function(t)
		for _, part in pairs(t.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = true end
		end
	end},
	{"Descongelar", function(t)
		for _, part in pairs(t.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = false end
		end
	end},
	{"Trazer", function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		local myhrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if hrp and myhrp then hrp.CFrame = myhrp.CFrame + Vector3.new(2, 0, 0) end
	end},
	{"Ir até", function(t)
		local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		local targethrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp and targethrp then hrp.CFrame = targethrp.CFrame + Vector3.new(2, 0, 0) end
	end},
	{"Atravessar Portas", function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Name == "Door" then
				v.CanCollide = false
				v.Transparency = 0.5
			end
		end
	end},
	{"Apagar Luzes", function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("PointLight") or v:IsA("SurfaceLight") then
				v.Enabled = false
			end
		end
	end},
}

for i, cmd in ipairs(comandos) do
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.42, 0, 0, 26)
	b.Position = UDim2.new(0.05 + ((i-1)%2)*0.48, 0, 0, 160 + math.floor((i-1)/2)*30)
	b.Text = cmd[1]
	b.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	b.TextColor3 = Color3.new(0, 0, 0)
	b.Font = Enum.Font.Fantasy
	b.TextSize = 14
	b.MouseButton1Click:Connect(function()
		if jogadorSelecionado or cmd[1] == "Soltar" or cmd[1] == "Atravessar Portas" or cmd[1] == "Apagar Luzes" then
			cmd[2](jogadorSelecionado)
		end
	end)
end
