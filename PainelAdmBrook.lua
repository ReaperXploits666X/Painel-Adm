local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.5, -130, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Text = "Painel ADM"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.Font = Enum.Font.Fantasy
titulo.TextSize = 20
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
}

for i, cmd in ipairs(comandos) do
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.42, 0, 0, 28)
	b.Position = UDim2.new(0.05 + ((i-1)%2)*0.48, 0, 0, 160 + math.floor((i-1)/2)*35)
	b.Text = cmd[1]
	b.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	b.TextColor3 = Color3.new(0, 0, 0)
	b.Font = Enum.Font.Fantasy
	b.TextSize = 16
	b.MouseButton1Click:Connect(function()
		if jogadorSelecionado or cmd[1] == "Unjail" then
			cmd[2](jogadorSelecionado)
		end
	end)
end
