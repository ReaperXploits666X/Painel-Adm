local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

-- Painel principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 500)
frame.Position = UDim2.new(0.5, -170, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Título
local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 50)
titulo.Text = "Painel ADM"
titulo.TextColor3 = Color3.fromRGB(255, 215, 0)
titulo.Font = Enum.Font.Fantasy
titulo.TextSize = 24
titulo.BackgroundTransparency = 1

-- Botão para abrir/fechar lista
local toggleLista = Instance.new("TextButton", frame)
toggleLista.Size = UDim2.new(0.9, 0, 0, 35)
toggleLista.Position = UDim2.new(0.05, 0, 0, 60)
toggleLista.Text = "Abrir Lista de Jogadores"
toggleLista.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
toggleLista.TextColor3 = Color3.new(0, 0, 0)
toggleLista.Font = Enum.Font.Fantasy
toggleLista.TextSize = 18

-- Lista de jogadores
local lista = Instance.new("ScrollingFrame", frame)
lista.Size = UDim2.new(0.9, 0, 0, 150)
lista.Position = UDim2.new(0.05, 0, 0, 105)
lista.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
lista.BorderSizePixel = 0
lista.CanvasSize = UDim2.new(0, 0, 0, 0)
lista.ScrollBarThickness = 6
lista.Visible = false

local jogadorSelecionado = nil

-- Atualiza lista de jogadores
local function atualizarLista()
	lista:ClearAllChildren()
	local y = 0
	for _, jogador in pairs(game.Players:GetPlayers()) do
		local botao = Instance.new("TextButton", lista)
		botao.Size = UDim2.new(1, 0, 0, 30)
		botao.Position = UDim2.new(0, 0, 0, y)
		botao.Text = jogador.Name
		botao.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		botao.TextColor3 = Color3.new(1, 1, 1)
		botao.Font = Enum.Font.Fantasy
		botao.TextSize = 16
		botao.MouseButton1Click:Connect(function()
			jogadorSelecionado = jogador
			titulo.Text = "Painel ADM - " .. jogador.Name
			for _, b in pairs(lista:GetChildren()) do
				if b:IsA("TextButton") then
					b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				end
			end
			botao.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		end)
		y += 35
	end
	lista.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Atualiza ao clicar
toggleLista.MouseButton1Click:Connect(function()
	lista.Visible = not lista.Visible
	toggleLista.Text = lista.Visible and "Fechar Lista de Jogadores" or "Abrir Lista de Jogadores"
	if lista.Visible then atualizarLista() end
end)

-- Atualiza automaticamente quando alguém entra ou sai
game.Players.PlayerAdded:Connect(function() if lista.Visible then atualizarLista() end end)
game.Players.PlayerRemoving:Connect(function() if lista.Visible then atualizarLista() end end)
