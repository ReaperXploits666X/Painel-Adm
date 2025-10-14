local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

-- Painel principal
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 360)
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Painel ADM V1.00"
title.Font = Enum.Font.Fantasy
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local closeMain = Instance.new("TextButton", main)
closeMain.Size = UDim2.new(0, 25, 0, 25)
closeMain.Position = UDim2.new(1, -30, 0, 5)
closeMain.Text = "X"
closeMain.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeMain.TextColor3 = Color3.new(1, 1, 1)
closeMain.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- Painel da lista
local listaFrame = Instance.new("Frame", gui)
listaFrame.Size = UDim2.new(0, 260, 0, 300)
listaFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
listaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listaFrame.Visible = false

local closeLista = Instance.new("TextButton", listaFrame)
closeLista.Size = UDim2.new(0.9, 0, 0, 25)
closeLista.Position = UDim2.new(0.05, 0, 0, 10)
closeLista.Text = "FECHAR LISTA"
closeLista.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
closeLista.TextColor3 = Color3.new(1, 1, 1)
closeLista.MouseButton1Click:Connect(function()
	listaFrame.Visible = false
end)

local scroll = Instance.new("ScrollingFrame", listaFrame)
scroll.Size = UDim2.new(0.9, 0, 0, 230)
scroll.Position = UDim2.new(0.05, 0, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local selectedPlayer = nil

local function updateList()
	scroll:ClearAllChildren()
	local y = 0
	for _, plr in pairs(Players:GetPlayers()) do
		local b = Instance.new("TextButton", scroll)
		b.Size = UDim2.new(1, 0, 0, 22)
		b.Position = UDim2.new(0, 0, 0, y)
		b.Text = plr.Name
		b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.MouseButton1Click:Connect(function()
			selectedPlayer = plr
			for _, btn in pairs(scroll:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				end
			end
			b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		end)
		y += 24
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

Players.PlayerAdded:Connect(function() if listaFrame.Visible then updateList() end end)
Players.PlayerRemoving:Connect(function() if listaFrame.Visible then updateList() end end)

-- Botão abrir lista
local openList = Instance.new("TextButton", main)
openList.Size = UDim2.new(0.9, 0, 0, 25)
openList.Position = UDim2.new(0.05, 0, 0, 40)
openList.Text = "LISTA DE JOGADORES"
openList.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
openList.TextColor3 = Color3.new(1, 1, 1)
openList.MouseButton1Click:Connect(function()
	listaFrame.Visible = true
	updateList()
end)

-- Comandos ADM
local comandos = {
	{"KICK", function(t)
		local hrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CFrame = CFrame.new(9999, 9999, 9999) end
	end},
	{"JAIL", function(t)
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
	{"UNJAIL", function()
		for _, v in pairs(workspace:GetChildren()) do
			if v.Name == "JailCube" then v:Destroy() end
		end
	end},
	{"FREEZE", function(t)
		for _, part in pairs(t.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = true end
		end
	end},
	{"UNFREEZE", function(t)
		for _, part in pairs(t.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Anchored = false end
		end
	end},
	{"KILL", function(t)
		local h = t.Character and t.Character:FindFirstChildOfClass("Humanoid")
		if h then h:TakeDamage(9999) end
	end},
	{"TP", function(t)
		local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local targethrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if hrp and targethrp then hrp.CFrame = targethrp.CFrame + Vector3.new(2, 0, 0) end
	end},
}

for i, cmd in ipairs(comandos) do
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.9, 0, 0, 25)
	b.Position = UDim2.new(0.05, 0, 0, 80 + (i-1)*28)
	b.Text = cmd[1]
	b.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.MouseButton1Click:Connect(function()
		if selectedPlayer then
			cmd[2](selectedPlayer)
			b.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
			wait(0.2)
			b.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
		end
	end)
end
