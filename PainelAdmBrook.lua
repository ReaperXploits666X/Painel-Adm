local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 400)
frame.Position = UDim2.new(0.5, -130, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Borda RGB amarela dinâmica
local border = Instance.new("UIStroke", frame)
border.Thickness = 2
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Título com RGB azul
local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 35)
titulo.Text = "Painel ADM"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.Fantasy
titulo.TextSize = 16
titulo.BackgroundTransparency = 1

-- Efeitos RGB dinâmicos
local hue = 0
game:GetService("RunService").RenderStepped:Connect(function()
	hue = (hue + 0.005) % 1
	local rgb = Color3.fromHSV(hue, 1, 1)
	titulo.TextColor3 = Color3.fromHSV((hue + 0.6) % 1, 1, 1) -- tom azul
	border.Color = rgb -- borda amarela RGB
end)

-- Botão abrir lista
local toggleLista = Instance.new("TextButton", frame)
toggleLista.Size = UDim2.new(0.9, 0, 0, 25)
toggleLista.Position = UDim2.new(0.05, 0, 0, 40)
toggleLista.Text = "Abrir Lista de Jogadores"
toggleLista.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
toggleLista.TextColor3 = Color3.new(1, 1, 1)
toggleLista.Font = Enum.Font.Fantasy
toggleLista.TextSize = 13

-- Lista de jogadores
local lista = Instance.new("ScrollingFrame", frame)
lista.Size = UDim2.new(0.9, 0, 0, 100)
lista.Position = UDim2.new(0.05, 0, 0, 70)
lista.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
lista.BorderSizePixel = 0
lista.CanvasSize = UDim2.new(0, 0, 0, 0)
lista.ScrollBarThickness = 6
lista.Visible = false

local jogadorSelecionado = nil

local function atualizarLista()
	lista:ClearAllChildren()
	local y = 0
	for _, jogador in pairs(game.Players:GetPlayers()) do
		local b = Instance.new("TextButton", lista)
		b.Size = UDim2.new(1, 0, 0, 22)
		b.Position = UDim2.new(0, 0, 0, y)
		b.Text = jogador.Name
		b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.Fantasy
		b.TextSize = 13
		b.MouseButton1Click:Connect(function()
			jogadorSelecionado = jogador
			titulo.Text = "ADM - " .. jogador.Name
			for _, btn in pairs(lista:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end
			end
			b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		end)
		y += 24
	end
	lista.CanvasSize = UDim2.new(0, 0, 0, y)
end

toggleLista.MouseButton1Click:Connect(function()
	lista.Visible = not lista.Visible
	toggleLista.Text = lista.Visible and "Fechar Lista" or "Abrir Lista de Jogadores"
	atualizarLista()
end)

game.Players.PlayerAdded:Connect(function() if lista.Visible then atualizarLista() end end)
game.Players.PlayerRemoving:Connect(function() if lista.Visible then atualizarLista() end end)

-- Comandos ADM
local comandos = {
	{"Kick", function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CFrame = CFrame.new(9999, 9999, 9999) end
	end},
	{"Kill", function(t)
		local h = t.Character and t.Character:FindFirstChildOfClass("Humanoid")
		if h then h:TakeDamage(9999) end
	end},
	{"Jail", function(t)
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
	{"Unjail", function()
		for _, v in pairs(workspace:GetChildren()) do
			if v.Name == "JailCube" then v:Destroy() end
		end
	end},
	{"Freeze", function(t)
		for _, part in pairs(t.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = true end
		end
	end},
	{"Unfreeze", function(t)
		for _, part in pairs(t.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = false end
		end
	end},
	{"Bring", function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		local myhrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if hrp and myhrp then hrp.CFrame = myhrp.CFrame + Vector3.new(2, 0, 0) end
	end},
	{"Teleport", function(t)
		local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		local targethrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp and targethrp then hrp.CFrame = targethrp.CFrame + Vector3.new(2, 0, 0) end
	end},
}

-- Botões em linha vertical
for i, cmd in ipairs(comandos) do
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9, 0, 0, 25)
	b.Position = UDim2.new(0.05, 0, 0, 180 + (i-1)*28)
	b.Text = cmd[1]
	b.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.Fantasy
	b.TextSize = 13
	b.MouseButton1Click:Connect(function()
		if jogadorSelecionado then
			cmd[2](jogadorSelecionado)
		end
	end)
end
