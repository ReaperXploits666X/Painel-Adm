local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "AdminPanel"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 380)
frame.Position = UDim2.new(0.5, -140, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Supreme Administrator"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Fantasy
title.TextSize = 22
title.BackgroundTransparency = 1

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 28)
toggle.Position = UDim2.new(0.05, 0, 0, 45)
toggle.Text = "Open Player List"
toggle.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
toggle.TextColor3 = Color3.new(0, 0, 0)
toggle.Font = Enum.Font.Fantasy
toggle.TextSize = 16

local list = Instance.new("ScrollingFrame", frame)
list.Size = UDim2.new(0.9, 0, 0, 100)
list.Position = UDim2.new(0.05, 0, 0, 80)
list.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
list.BorderSizePixel = 0
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Visible = false

local selectedPlayer = nil

local function updateList()
	list:ClearAllChildren()
	local y = 0
	for _, player in pairs(game.Players:GetPlayers()) do
		local b = Instance.new("TextButton", list)
		b.Size = UDim2.new(1, 0, 0, 25)
		b.Position = UDim2.new(0, 0, 0, y)
		b.Text = player.Name
		b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.Fantasy
		b.TextSize = 14
		b.MouseButton1Click:Connect(function()
			selectedPlayer = player
			title.Text = "Admin - " .. player.Name
			for _, btn in pairs(list:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				end
			end
			b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		end)
		y += 28
	end
	list.CanvasSize = UDim2.new(0, 0, 0, y)
end

toggle.MouseButton1Click:Connect(function()
	list.Visible = not list.Visible
	toggle.Text = list.Visible and "Close Player List" or "Open Player List"
	updateList()
end)

game.Players.PlayerAdded:Connect(function() if list.Visible then updateList() end end)
game.Players.PlayerRemoving:Connect(function() if list.Visible then updateList() end end)

local commands = {
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
	{"Unban Houses", function()
		local banned = game.ReplicatedStorage:FindFirstChild("BannedLots")
		if banned then banned:Destroy() end
	end},
	{"House Access", function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Name == "Door" then
				v.CanCollide = false
				v.Transparency = 0.5
			end
		end
	end},
}

for i, cmd in ipairs(commands) do
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.42, 0, 0, 26)
	b.Position = UDim2.new(0.05 + ((i-1)%2)*0.48, 0, 0, 190 + math.floor((i-1)/2)*30)
	b.Text = cmd[1]
	b.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	b.TextColor3 = Color3.new(0, 0, 0)
	b.Font = Enum.Font.Fantasy
	b.TextSize = 14
	b.MouseButton1Click:Connect(function()
		if selectedPlayer or cmd[1] == "Unjail" or cmd[1] == "Unban Houses" or cmd[1] == "House Access" then
			cmd[2](selectedPlayer)
		end
	end)
end
