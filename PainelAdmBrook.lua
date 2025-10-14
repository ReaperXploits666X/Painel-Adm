local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "PainelADM"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 360)
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local border = Instance.new("UIStroke", main)
border.Thickness = 2
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Painel ADM"
title.Font = Enum.Font.Fantasy
title.TextSize = 16
title.BackgroundTransparency = 1

local closeMain = Instance.new("TextButton", main)
closeMain.Size = UDim2.new(0, 25, 0, 25)
closeMain.Position = UDim2.new(1, -30, 0, 5)
closeMain.Text = "X"
closeMain.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeMain.TextColor3 = Color3.new(1, 1, 1)
closeMain.Font = Enum.Font.Fantasy
closeMain.TextSize = 14
closeMain.MouseButton1Click:Connect(function()
	main.Visible = false
end)

local version = Instance.new("TextLabel", main)
version.Size = UDim2.new(0, 100, 0, 20)
version.Position = UDim2.new(1, -105, 1, -25)
version.Text = "V1.00"
version.TextColor3 = Color3.new(1, 1, 1)
version.Font = Enum.Font.Fantasy
version.TextSize = 12
version.BackgroundTransparency = 1

local hue = 0
RunService.RenderStepped:Connect(function()
	hue = (hue + 0.005) % 1
	local yellow = Color3.fromHSV((hue + 0.1) % 1, 1, 1)
	local blue = Color3.fromHSV((hue + 0.6) % 1, 1, 1)
	border.Color = yellow
	title.TextColor3 = blue
end)

local listaFrame = Instance.new("Frame", gui)
listaFrame.Size = UDim2.new(0, 260, 0, 300)
listaFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
listaFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
listaFrame.Visible = false

local listaBorder = Instance.new("UIStroke", listaFrame)
listaBorder.Thickness = 2
listaBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local listaTitle = Instance.new("TextLabel", listaFrame)
listaTitle.Size = UDim2.new(1, 0, 0, 35)
listaTitle.Text = "Painel ADM"
listaTitle.Font = Enum.Font.Fantasy
listaTitle.TextSize = 16
listaTitle.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", listaFrame)
closeBtn.Size = UDim2.new(0.9, 0, 0, 25)
closeBtn.Position = UDim2.new(0.05, 0, 0, 40)
closeBtn.Text = "FECHAR LISTA"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.Fantasy
closeBtn.TextSize = 13

local scroll = Instance.new("ScrollingFrame", listaFrame)
scroll.Size = UDim2.new(0.9, 0, 0, 200)
scroll.Position = UDim2.new(0.05, 0, 0, 70)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local selectedPlayer = nil

local function updateList()
	scroll:ClearAllChildren()
	local y = 0
	for _, plr in pairs(Players:GetPlayers()) do
		local b = Instance.new("TextButton", scroll)
		b.Size = UDim2.new(1, 0, 0, 22)
		b.Position = UDim2.new(0, 0, 0, y)
		b.Text = plr.Name
		b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.Fantasy
		b.TextSize = 13
		b.MouseButton1Click:Connect(function()
			selectedPlayer = plr
			for _, btn in pairs(scroll:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end
			end
			b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		end)
		y += 24
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

closeBtn.MouseButton1Click:Connect(function()
	listaFrame.Visible = false
end)

Players.PlayerAdded:Connect(function() if listaFrame.Visible then updateList() end end)
Players.PlayerRemoving:Connect(function() if listaFrame.Visible then updateList() end end)

local openList = Instance.new("TextButton", main)
openList.Size = UDim2.new(0.9, 0, 0, 25)
openList.Position = UDim2.new(0.05, 0, 0, 40)
openList.Text = "LISTA DE JOGADORES"
openList.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
openList.TextColor3 = Color3.new(1, 1, 1)
openList.Font = Enum.Font.Fantasy
openList.TextSize = 13

openList.MouseButton1Click:Connect(function()
	listaFrame.Visible = true
	updateList()
end)

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
		local hrp = lp.Character and lp.Character:Find
