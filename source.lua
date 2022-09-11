
if UHGOpen or _G.Open then
	local message = Instance.new("Message", game:GetService("CoreGui"))
	message.Text = "UHG Is already open. To close press F1."
	game:GetService("Debris"):AddItem(message, 3)
	return
end

game.StarterGui:SetCore("SendNotification", {
		Title = "Ultimate Hack GUI"; 
		Text = "Thanks for using my GUI!"; 
		Duration = 5;
})

pcall(function() getfenv().UGHOpen = true end)

_G.Open = true

--// Services \\--
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

--// Lists \\--
local connections = {}

--// Callbacks \\--
function ReturnGitRaw(link)
	local newLink = link:gsub("github.com", 'raw.githubusercontent.com'):gsub('/blob','')
	-- setclipboard(newLink)
	return newLink
end

function AddConnection(name, func)
	connections[name] = func
end

--// Objects \\--
local UICorner = Instance.new("UICorner")

local MainScreen = Instance.new("ScreenGui", CoreGui)
MainScreen.Name = "UHGGui"
local DragFrame = Instance.new("Frame", MainScreen)
UICorner = UICorner:Clone()
UICorner.CornerRadius = UDim.new(0.2,0)
UICorner.Parent = DragFrame
local MainFrame = Instance.new("Frame", DragFrame)
UICorner = UICorner:Clone()
UICorner.CornerRadius = UDim.new(0.025,0)
UICorner.Parent = MainFrame
MainFrame.Size = UDim2.new(1,0,0,400)
MainFrame.Position = UDim2.new(0,0,0.5,0)
DragFrame.Size = UDim2.new(0,700, 0, 100)
DragFrame.Position = UDim2.new(0.5,0,0.2,0)
DragFrame.AnchorPoint = Vector2.new(0.5,0.5)
DragFrame.ZIndex = 1000
DragFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MainFrame.BackgroundColor3 = Color3.fromRGB(196,196,196)
MainFrame.ZIndex = 800
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Parent = MainFrame
ButtonsFrame.ZIndex = 801
-- MainFrame.ClipsDescendants = true
ButtonsFrame.Size = UDim2.new(0.8,0,0.7,0)
ButtonsFrame.Position = UDim2.new(0.1,0,0.2,0)
local UIGrid = Instance.new("UIGridLayout", ButtonsFrame)
UIGrid.CellPadding = UDim2.new(0, 20, 0, 20)
UIGrid.CellSize = UDim2.new(0,125,0,50)
ButtonsFrame.AutomaticSize = Enum.AutomaticSize.None
ButtonsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
local cmds = {}
local function AddBtn(btnname, cmdname, desc, callback, ...)
	cmds[btnname:lower()] = callback
	local Button = Instance.new("TextButton", ButtonsFrame)
	Button.Name = btnname
	Button.ZIndex = 802
	Button.Text = cmdname
	Button.TextScaled = true
	Button.BackgroundColor3 = Color3.fromRGB(138, 112, 112)

	local args = {...}
	Button.Activated:Connect(function()
		callback(unpack(args))
	end)
	local H = false
	Button.MouseEnter:Connect(function ()
	
		for i,v in pairs(MainScreen:GetChildren()) do
			if v.Name == "Description" then
				v:Destroy()
			end
		end
		local NewUI = Instance.new("TextLabel", MainScreen)
		NewUI.TextColor3 = Color3.new(1,1,1)
		NewUI.BackgroundTransparency = 1
		NewUI.Name = 'Description'
		NewUI.Position = UDim2.new(0.5,0,0.5,0)
		NewUI.AnchorPoint = Vector2.new(0.5,0.5)
		NewUI.Text = desc
		NewUI.Size = UDim2.new(1,0,0,10)
		NewUI.ZIndex = 9999
		local function followMouse()
			local mouseLocation = UIS:GetMouseLocation()
			NewUI.Position = UDim2.new(0, mouseLocation.X+NewUI.TextBounds.X/2, 0, mouseLocation.Y-36)
		end
		RunService:BindToRenderStep("moveGuiToMouse", 10, followMouse)
		H = false
		for i = 1,#NewUI.Text do
			if H == true then
				break
			end
			local sound = Instance.new("Sound", workspace)
			sound.RollOffMaxDistance = math.huge
			sound.Volume = 2
			sound.Name = 'tpying-sound'
			sound.SoundId = 'rbxassetid://7147454322'
			sound:Play()
			NewUI.MaxVisibleGraphemes = i
			task.wait(0.01)
		end
	end)

	Button.MouseLeave:Connect(function()
		for i,v in pairs(workspace:GetChildren()) do
			if v.Name == 'tpying-sound' and v:IsA("Sound") then
				v:Stop()
				v:Destroy()
			end
		end
		H = true
		for i,v in pairs(MainScreen:GetChildren()) do
			if v.Name == "Description" then
				v:Destroy()
			end
		end
		RunService:UnbindFromRenderStep("moveGuiToMouse")
	end)
end

--// This code is from Infinite Yield.
--// Please give them credit and go use their GUI 
function dragGUI(gui)
	task.spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

local notifyNumber = 0
local notif_warnings = {
	['ERROR'] = Color3.fromRGB(255, 149, 0),
	['WARNING'] = Color3.fromRGB(255, 0, 0),
	['MESSAGE'] = Color3.fromRGB(59, 59, 59)
}

dragGUI(DragFrame)

local notificationFrame = Instance.new("Frame", MainScreen)
notificationFrame.Position = UDim2.new(0.79, 0, 0.37, 0)
notificationFrame.BackgroundTransparency = 1
notificationFrame.Size = UDim2.new(0.2,0,0.6,0)
function notify(text, warning)

	local sound = Instance.new("Sound", workspace)
	sound.SoundId = 'rbxassetid://1760921747'
	sound.RollOffMaxDistance = math.huge
	sound.Volume = 10
	sound:Play()
	local uilist = Instance.new("UIListLayout", notificationFrame)
	uilist.Padding = UDim.new(0,5)
	uilist.FillDirection = Enum.FillDirection.Vertical
	uilist.SortOrder = Enum.SortOrder.Name
	uilist.VerticalAlignment = Enum.VerticalAlignment.Bottom
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 50)
	local NotificationF = Instance.new("Frame", notificationFrame)
	corner = corner:Clone()
	corner.Parent = NotificationF
	corner.CornerRadius = UDim.new(0,25)
	NotificationF.Position = UDim2.new(1.5, 0, 0, 0)
	NotificationF.Size = UDim2.new(1,0,0.3,0)
	NotificationF.ZIndex = 998
	NotificationF.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
	-- NotificationF:TweenPosition()
	local Notification = Instance.new("TextLabel", NotificationF)
	corner = corner:Clone()
	corner.Parent = Notification
	corner.CornerRadius = UDim.new(0,25)
	Notification.BackgroundTransparency = 0
	Notification.TextTransparency = 0
	Notification.BackgroundColor3 = notif_warnings[warning]
	Notification.Text = warning
	NotificationF.Name = notifyNumber
	notifyNumber += 1
	Notification.TextScaled = true
	Notification.ZIndex = 999
	Notification.Size = UDim2.new(1, 0, 0.3, 0)
	Notification.Position = UDim2.new(0, 0, 0, 0)

	local NotificationMessage = Instance.new("TextLabel", NotificationF)
	NotificationMessage.Name = "NotificationMessage"
	NotificationMessage.Size = UDim2.new(1,0,0.5,0)
	NotificationMessage.BackgroundTransparency = 1
	NotificationMessage.TextColor3 = Color3.fromRGB(255,255,255)
	NotificationMessage.BorderSizePixel = 0
	NotificationMessage.TextStrokeTransparency = 0
	NotificationMessage.TextTransparency = 0
	NotificationMessage.Position = UDim2.new(0, 0, 0.4, 0)
	NotificationMessage.Text = text
	NotificationMessage.ZIndex = 999
	NotificationMessage.TextScaled = true
	local DisTween = TweenService:Create(
		Notification,
		TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 4),
		{BackgroundTransparency = 1, TextTransparency = 1}
	)
	TweenService:Create(
		NotificationF,
		TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 4),
		{BackgroundTransparency = 1}
	):Play()
	TweenService:Create(
		NotificationMessage,
		TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 4),
		{BackgroundTransparency = 1, TextTransparency = 1}
	):Play()
	DisTween:Play()
	DisTween.Completed:Connect(function(playback)
		if (playback == Enum.PlaybackState.Completed) then
			NotificationF:Destroy()
			notifyNumber += 1
		end
	end)
end

AddConnection("DisconnectGUI", UIS.InputBegan:Connect(function(key)
	if (key.KeyCode == Enum.KeyCode.F1) then
		for ConName, _ in pairs(connections) do
			connections[ConName]:Disconnect()
		end

		connections = {}
		_G.Open = false
		if CoreGui:FindFirstChild("UHGGui") then
			CoreGui:FindFirstChild("UHGGui"):Destroy()
		elseif LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("UHGGui") then
			LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("UHGGui"):Destroy()
		end
		pcall(function() getfenv().UGHOpen = false end)
		return
	end
end))

AddBtn("MTITrollHack", "MTI Troll Hack", "Give yourself any troll in Mutliversal Trollge Incidents.", function ()
	local Title = Instance.new("TextLabel", MainScreen)
	Title.Position = UDim2.new(0,0,0,0)
	Title.Size = UDim2.new(0,150,0,30)
	Title.Text = "MTI Troll Hack."
	Title.ZIndex = 500
	Title.BackgroundColor3 = Color3.fromRGB(96,96,96)
	local MTIFrame = Instance.new("Frame", Title)
	MTIFrame.Size = UDim2.new(1, 0, 0, 90)
	local chooseTroll = Instance.new("TextBox", MTIFrame)
	chooseTroll.Size = UDim2.new(0.8, 0, 0.5, 0)
	chooseTroll.Position = UDim2.new(0.1,0, 0.4, 0)
	chooseTroll.BackgroundColor3 = Color3.fromRGB(145,145,145)
	UICorner = UICorner:Clone()
	UICorner.Parent = Title
	UICorner.CornerRadius = UDim.new(0, 20)
	UICorner = UICorner:Clone()
	UICorner.Parent = MTIFrame
	UICorner.CornerRadius = UDim.new(0, 20)
	UICorner = UICorner:Clone()
	UICorner.Parent = chooseTroll
	UICorner.CornerRadius = UDim.new(0, 20)
	local close = Instance.new("TextButton", Title)
	close.BackgroundColor3 = Color3.fromRGB(255,0,0)
	close.Font = Enum.Font.ArialBold
	close.TextColor3 = Color3.new(1,1,1)
	close.Text = "X"
	close.Size = UDim2.new(0,25,0,25)
	close.Position = UDim2.new(1,0,0,0)
	close.ZIndex = 5
	close.TextScaled = true
	UICorner = UICorner:Clone()
	UICorner.Parent = close
	UICorner.CornerRadius = UDim.new(0, 10)

	local giveTroll
	giveTroll = chooseTroll.FocusLost:Connect(function(enter)
		if enter then
			local troll = nil
			local children = ReplicatedStorage.Characters:GetDescendants()
			for _, child in pairs(children) do
				if child ~= nil and child.Name:gsub(" ", ""):lower() == chooseTroll.Text:gsub(' ',''):lower() and child:IsA("Model") then
					troll = child
					break
				end

				troll = nil
			end
			
			if troll ~= nil then
				local args = {
					[1] = troll
				}
				ReplicatedStorage.EventFolder.TrollTransform:FireServer(unpack(args))
			elseif troll == nil then
				notify(('"%s" is not a valid troll in this game. Please retry.'):format(chooseTroll.Text:lower()), "ERROR")
			end
		end
	end)

	close.Activated:Connect(function ()
		giveTroll:Disconnect()
		Title:Destroy()
	end)
	dragGUI(Title)
end)

AddBtn("FlingGUI", "Fling Gui", "Use this to fling people.", function ()
	local Title = Instance.new("TextLabel", MainScreen)
	Title.Size = UDim2.new(0, 300, 0, 50)
	Title.Text = "Fling Gui (FE)"
	Title.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
	Title.TextScaled = true
	Title.TextColor3 = Color3.new(1,1,1)
	Title.ZIndex = 50
	local FlingFrame = Instance.new("Frame", Title)
	FlingFrame.Size = UDim2.new(1,0,0,250)
	FlingFrame.Position = UDim2.new(0,0,0.25,0)
	FlingFrame.ZIndex = 30
	local close = Instance.new("TextButton", Title)
	close.Size = UDim2.new(0,40,0,40)
	close.Position = UDim2.new(1,0,0,0)
	close.ZIndex = 100
	close.Text = "X"
	close.TextScaled = true
	close.TextColor3 = Color3.new(1,1,1)
	close.Font = Enum.Font.SourceSansBold
	close.BackgroundColor3 = Color3.fromRGB(255,0,0)
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = close
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0, 50)
	UICorner.Parent = Title
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0, 25)
	UICorner.Parent = FlingFrame

	local player = Instance.new("TextBox", FlingFrame)
	player.Size = UDim2.new(0.7, 0, 0.2, 0)
	player.Position = UDim2.new(0.15,0,0.3,0)
	player.BackgroundColor3 = Color3.fromRGB(214, 214, 214)
	player.PlaceholderText = "Player name here..."
	player.Text = ""

	local power = Instance.new("TextBox", FlingFrame)
	power.Size = UDim2.new(0.7,0,0.2,0)
	power.Position = UDim2.new(0.15,0,0.7,0)
	power.BackgroundColor3 = Color3.fromRGB(214,214,214)
	power.PlaceholderText = "Power here."
	power.Text = ""

	local PLTITLE, POTITLE = Instance.new("TextLabel", FlingFrame),Instance.new("TextLabel", FlingFrame)
	PLTITLE.Size = UDim2.new(1,0,0.1,0)
	PLTITLE.Position = UDim2.new(0,0,0.2,0)
	PLTITLE.Text = "Player"
	PLTITLE.BackgroundTransparency = 1
	PLTITLE.TextScaled = true
	POTITLE.Size = UDim2.new(1,0,0.1,0)
	POTITLE.Position = UDim2.new(0,0,0.6,0)
	POTITLE.Text = "Power"
	POTITLE.BackgroundTransparency = 1
	POTITLE.TextScaled = true
	PLTITLE.ZIndex = 70
	POTITLE.ZIndex = 70
	--[[
		for i,v in pairs(game.Players:GetPlayers()) do 
                 if v.Name:lower():sub(1,#target) == target:lower() then
                     LocalPlayer = v
   			         LocalPlayer:kick("Kicked by an admin")
                 end
             end
	]]
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0, 25)
	UICorner.Parent = player
	player.ZIndex = 60
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0, 25)
	UICorner.Parent = power
	power.ZIndex = 60
	close.Activated:Connect(function ()
		Title:Destroy()
	end)

	local runFling = Instance.new("TextButton", FlingFrame)
	runFling.Size = UDim2.new(0.6,0,0,40)
	runFling.BackgroundColor3 = Color3.fromRGB(0,255,0)
	runFling.Text = "Troll 'em"
	runFling.TextScaled = true
	runFling.TextColor3 = Color3.new(1,1,1)
	runFling.TextStrokeTransparency = 0
	runFling.Position = UDim2.new(0.2,0,1,0)
	
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0, 25)
	UICorner.Parent = runFling
	runFling.ZIndex = 70

	local active = false
	runFling.Activated:Connect(function ()
		local powert = power.Text:gsub("[^%-%d]", ""):gsub(' ','')
		local powerNum = tonumber(powert)
		if powerNum < 50000 then notify("Fling power has to be atleast 50000 or greater.", "ERROR") return end
		if active then notify("You cannot fling while flinging someone.", "ERORR") return end
		local char = nil
		for _, plr in pairs(game.Players:GetPlayers()) do 
			if plr.Name:lower():sub(1,#player.Text:gsub(" ",'')) == player.Text:gsub(" ",''):lower() or plr.DisplayName:lower():sub(1,#player.Text:gsub(" ",'')) == player.Text:gsub(" ",''):lower() then
				char = plr.Character
				break
			end
		end
		if Players:GetPlayerFromCharacter(char) == LocalPlayer then notify("You cannot fling yourself.", "WARNING") return end
		if char == nil then notify(("Player not found from \"%s\"."), "ERROR") return end
		active = true
		local part = Instance.new("Part", workspace)
		part.Position = LocalPlayer.Character.HumanoidRootPart.Position
		part.Anchored = true
		part.CanCollide = false
		part.Transparency = 1
		local angular = Instance.new("BodyAngularVelocity", LocalPlayer.Character.HumanoidRootPart)
		angular.P = 10000000000000000000000000000
		angular.AngularVelocity = Vector3.new(tonumber(power.Text),tonumber(power.Text),tonumber(power.Text))* math.rad(360)
		angular.MaxTorque = Vector3.new(tonumber(power.Text),tonumber(power.Text),tonumber(power.Text))

		while char:FindFirstChild("Humanoid").Health > 0 do
			LocalPlayer.Character.HumanoidRootPart.CanCollide = true
			LocalPlayer.Character.HumanoidRootPart.Position = char.HumanoidRootPart.Position
			wait()
		end

		notify("The player you are flinging has left, or died.", "MESSAGE")
		local com=nil
		com=game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function (c)
			if active == true then
				c:WaitForChild("HumanoidRootPart").CFrame = part.CFrame
				part:Destroy()
				com:Disconnect()
			end
		end)
		active = false
	end)

	dragGUI(Title)
end)

local Respawning = false
AddBtn("Respawn", "Reset", "Resets your character and brings you back to the same spot.", function ()
	if Respawning then notify("Wait until you respawn.", "WARNING") return end

	Respawning = true
	local Part = Instance.new("Part", workspace)
	Part.Position = LocalPlayer.Character.HumanoidRootPart.Position
	Part.Anchored = true
	Part.CanCollide = true
	Part.Transparency = 1

	LocalPlayer.Character.Humanoid:Destroy()
	LocalPlayer.Character:Destroy()
	local con
	con=LocalPlayer.CharacterAdded:Connect(function (c)
		if Respawning then
			wait(1)
			for i = 1,5 do
				if Respawning then			
					notify("Successfully respawned.", "MESSAGE")
				end
				c:WaitForChild("HumanoidRootPart").CFrame = Part.CFrame
				task.wait()
				Respawning = false
			end
			Part:Destroy()
			con:Disconnect()
		end
	end)
end)

AddConnection("OnLocalLeave", Players.PlayerRemoving:Connect(function(plr)
	if plr == LocalPlayer then
		for ConName, _ in pairs(connections) do
			connections[ConName]:Disconnect()
		end
		connections = {}
		_G.Open = false
		pcall(function() getfenv().UHGOpen = false end)
		return
	end
end))

local con
AddBtn("ClickFling", "Part Fling", "Wherever you click any unanchored object will be flung.", function ()
	if con ~= nil then notify("You cannot use this command more than once at a time.", "WARNING") return end
	notify("Please use the \"Reset\" script to disable this command.", "MESSAGE")
	HumanDied = false
	_G.ClickFling=false -- Set this to true if u want.


	plr = game.Players.LocalPlayer
	char=game.Players.LocalPlayer.Character
	ct={}
	te=table.insert

	HumanDied=false

	local mode = 0
	local dancing = false

	for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
		if v:IsA("BasePart") then 
			te(ct,game:GetService("RunService").Heartbeat:connect(function()
				pcall(function()
					v.Velocity = Vector3.new(0,-30,0)
					sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
					sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",999999999)
					game.Players.LocalPlayer.ReplicationFocus = workspace
				end)
			end))
		end
	end

	function g(t,tex,dur)
	game.StarterGui:SetCore("SendNotification", {
		Title = t; 
		Text = tex; 
		Duration = dur or 5;
	})
	end

	local srv= game:GetService("RunService")

	fl=Instance.new('Folder',char);fl.Name='CWExtra'

	char.Archivable = true
	local reanim = char:Clone()
	reanim.Name='NexoPD'

	for i,v in next, reanim:GetDescendants() do
	if v:IsA('BasePart') or v:IsA('Decal') then
	v.Transparency = 1 
	end 
	end

	--flinge = false

	penis=5.65
	plr.Character=nil
	plr.Character=char
	char.Humanoid.AutoRotate=false
	char.Humanoid.WalkSpeed=0
	char.Humanoid.JumpPower=0
	char.Torso.Anchored = true
	g('UHG','Reanimating...\nPlease wait '..penis..' seconds.')
	wait(penis)
	char.Torso.Anchored=false
	g('UHG','Reanimated..')
	char.Humanoid.Health=0
	--reanim.Humanoid.AutoRotate=false
	reanim.Animate.Disabled = false
	reanim.Parent = fl
	reanim.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame*CFrame.new(0,5,0)

	function create(part, parent, p, r)
	Instance.new("Attachment",part)
	Instance.new("AlignPosition",part)
	Instance.new("AlignOrientation",part)
	Instance.new("Attachment",parent)
	part.Attachment.Name = part.Name
	parent.Attachment.Name = part.Name
	part.AlignPosition.Attachment0 = part[part.Name]
	part.AlignOrientation.Attachment0 = part[part.Name]
	part.AlignPosition.Attachment1 = parent[part.Name]
	part.AlignOrientation.Attachment1 = parent[part.Name]
	parent[part.Name].Position = p or Vector3.new()
	part[part.Name].Orientation = r or Vector3.new()
	part.AlignPosition.MaxForce = 999999999
	part.AlignPosition.MaxVelocity = math.huge
	part.AlignPosition.ReactionForceEnabled = false
	part.AlignPosition.Responsiveness = math.huge
	part.AlignOrientation.Responsiveness = math.huge
	part.AlignPosition.RigidityEnabled = false
	part.AlignOrientation.MaxTorque = 999999999
	part.Massless=true
	end

	function Pos(part, parent, p)
	Instance.new("Attachment",part)
	Instance.new("AlignPosition",part)
	Instance.new("Attachment",parent)
	part.Attachment.Name = part.Name
	parent.Attachment.Name = part.Name
	part.AlignPosition.Attachment0 = part[part.Name]
	--part.AlignOrientation.Attachment0 = part[part.Name]
	part.AlignPosition.Attachment1 = parent[part.Name]
	--part.AlignOrientation.Attachment1 = parent[part.Name]
	parent[part.Name].Position = p or Vector3.new()
	part.AlignPosition.MaxForce = 999999999
	part.AlignPosition.MaxVelocity = math.huge
	part.AlignPosition.ReactionForceEnabled = false
	part.AlignPosition.Responsiveness = math.huge
	--part.AlignOrientation.Responsiveness = math.huge
	--part.AlignPosition.RigidityEnabled = false
	--part.AlignOrientation.MaxTorque = 999999999
	part.Massless=true
	end

	for i,part in next, char:GetDescendants() do
	if part:IsA('BasePart') then
	te(ct,srv.RenderStepped:Connect(function()
	part.CanCollide=false
	end))
	end
	end

	for i,part in next, char:GetDescendants() do
	if part:IsA('BasePart') then
	te(ct,srv.Stepped:Connect(function()
	part.CanCollide=false
	end))
	end
	end

	for i,part in next, reanim:GetDescendants() do
	if part:IsA('BasePart') then
	te(ct,srv.RenderStepped:Connect(function()
	part.CanCollide=false
	end))
	end
	end

	for i,part in next, reanim:GetDescendants() do
	if part:IsA('BasePart') then
	te(ct,srv.Stepped:Connect(function()
	part.CanCollide=false
	end))
	end
	end

	for i,v in next, char:GetDescendants() do
	if v:IsA('Accessory') then
	create(v.Handle,reanim[v.Name].Handle)
	end
	end

	--Pos(fhrp,reanim['Torso'])
	create(char['Head'],reanim['Head'])
	create(char['Torso'],reanim['Torso'])
	Pos(char['HumanoidRootPart'],reanim['Torso'],Vector3.new(0,0,0))
	create(char['Right Arm'],reanim['Right Arm'])
	create(char['Left Arm'],reanim['Left Arm'])
	create(char['Right Leg'],reanim['Right Leg'])
	create(char['Left Leg'],reanim['Left Leg'])

	m = plr:GetMouse()

	local LVecPart = Instance.new("Part", fl) LVecPart.CanCollide = false LVecPart.Transparency = 1

	te(ct,srv.RenderStepped:Connect(function()
	local lookVec = workspace.CurrentCamera.CFrame.lookVector
	local Root = reanim["HumanoidRootPart"]
	LVecPart.Position = Root.Position
	LVecPart.CFrame = CFrame.new(LVecPart.Position, Vector3.new(lookVec.X * 10000, lookVec.Y, lookVec.Z * 10000))
	end))

	wdown=false
	sdown=false
	adown=false
	ddown=false
	spacedown=false

	--reanim.HumanoidRootPart.RootJoint.Part0=nil

	function flinger(p)
	f=Instance.new('BodyAngularVelocity',p)
	f.AngularVelocity = Vector3.new(9e9,9e9,9e9)
	f.MaxTorque=Vector3.new(9e9,9e9,9e9)
	end

	flinger(char.HumanoidRootPart)

	m=plr:GetMouse()

	--char.HumanoidRootPart.Transparency = 0

	bp=Instance.new('BodyPosition',char.HumanoidRootPart)
	bp.P = 9e9
	bp.D = 9e9
	bp.MaxForce=Vector3.new(99999,99999,99999)

	local click

	te(ct,srv.Heartbeat:Connect(function()
	if click == true then
	bp.Position=m.Hit.p
	char.HumanoidRootPart.Position=m.Hit.p
	else
	bp.Position=reanim.Torso.Position
	char.HumanoidRootPart.Position=reanim.Torso.Position
	end
	end))

	local Highlight = Instance.new("SelectionBox")
	Highlight.Adornee = char.HumanoidRootPart
	Highlight.LineThickness=0.05
	Highlight.Color3 = Color3.fromRGB(30,255,30)
	Highlight.Parent = char.HumanoidRootPart
	Highlight.Name = "RAINBOW"

	hrp = Highlight

	spawn(function()
	while true do
	srv.Stepped:Wait()
	if ded then break end
	hrp.Color3 = Color3.new(255/255,0/255,0/255)
	for i = 0,255,10 do
	wait()
	hrp.Color3 = Color3.new(255/255,i/255,0/255)
	end
	for i = 255,0,-10 do
	wait()
	hrp.Color3 = Color3.new(i/255,255/255,0/255)
	end
	for i = 0,255,10 do
	wait()
	hrp.Color3 = Color3.new(0/255,255/255,i/255)
	end
	for i = 255,0,-10 do
	wait()
	hrp.Color3 = Color3.new(0/255,i/255,255/255)
	end
	for i = 0,255,10 do
	wait()
	hrp.Color3 = Color3.new(i/255,0/255,255/255)
	end
	for i = 255,0,-10 do
	wait()
	hrp.Color3 = Color3.new(255/255,0/255,i/255)
	end
	end
	end)

	te(ct,m.Button1Down:Connect(function()
	click=true
	end))

	te(ct,m.Button1Up:Connect(function()
	click=false
	end))

	te(ct,m.KeyDown:Connect(function(e)
	if e ==' ' then
	spacedown=true end
	if e =='w' then
	wdown=true end
	if e =='s' then
	sdown=true end
	if e =='a' then
	adown=true end
	if e =='d' then
	ddown=true
	end
	end))

	te(ct,m.KeyUp:Connect(function(e)
	if e ==' ' then
	spacedown=false end
	if e =='w' then
	wdown=false end
	if e =='s' then
	sdown=false end
	if e =='a' then
	adown=false end
	if e =='d' then
	ddown=false
	end
	end))

	local function MoveClone(X,Y,Z)
	LVecPart.CFrame = LVecPart.CFrame * CFrame.new(-X,Y,-Z)
	reanim.Humanoid.WalkToPoint = LVecPart.Position
	end

	te(ct,srv.RenderStepped:Connect(function()
	if wdown==true then
	MoveClone(0,0,1e4) end
	if sdown==true then
	MoveClone(0,0,-1e4) end
	if adown==true then
	MoveClone(1e4,0,0) end
	if ddown==true then
	MoveClone(-1e4,0,0)
	end
	if spacedown==true then
	reanim.Humanoid.Jump=true end
	if wdown ~= true and adown ~= true and sdown ~= true and ddown ~= true then
	reanim.Humanoid.WalkToPoint = reanim.HumanoidRootPart.Position end
	end))

	--reanim.HumanoidRootPart.RootJoint.Part1=nil

	workspace.CurrentCamera.CameraSubject = reanim.Humanoid

	reset=Instance.new('BindableEvent')
	te(ct,reset.Event:Connect(function()
	reanim:Destroy()
	HumanDied=true
	reanimated=false
	for i,v in next, char:GetDescendants() do if v:IsA('BasePart') then v.Anchored=true end end
	hc=char.Humanoid:Clone()
	char.Humanoid:Destroy()
	hc.Parent=char
	game.Players:Chat('-re')
	for i,v in pairs(ct) do v:Disconnect() end
	game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
	reset:Remove()
	end))

	game:GetService("StarterGui"):SetCore("ResetButtonCallback", reset)

	IT = Instance.new
	CF = CFrame.new
	VT = Vector3.new
	RAD = math.rad
	C3 = Color3.new
	UD2 = UDim2.new
	BRICKC = BrickColor.new
	ANGLES = CFrame.Angles
	EULER = CFrame.fromEulerAnglesXYZ
	COS = math.cos
	ACOS = math.acos
	SIN = math.sin
	ASIN = math.asin
	ABS = math.abs
	MRANDOM = math.random
	FLOOR = math.floor

	speed = 1
	sine = 1
	srv = game:GetService('RunService')

	function hatset(yes,part,c1,c0,nm)
		reanim[yes].Handle.AccessoryWeld.Part1=reanim[part]
		reanim[yes].Handle.AccessoryWeld.C1=c1 or CFrame.new()
		reanim[yes].Handle.AccessoryWeld.C0=c0 or CFrame.new()--3bbb322dad5929d0d4f25adcebf30aa5
		if nm==true then
			for i,v in next, workspace[game.Players.LocalPlayer.Name][yes].Handle:GetDescendants() do
			if v:IsA('Mesh') or v:IsA('SpecialMesh') then
				v:Remove()
			end
		end
	end
	end
	end)

local opened = false
AddBtn("firetouch", "Fire All Touch Interests", "Fires every single .Touched and TouchInterest in workspace.", function ()
	if opened then notify("You can only have one of these GUI's open.", "WARNING") return end
	opened = true
	local Title = Instance.new("TextLabel", MainScreen)
	notify("Be warned this may cause lag considering on how nany objects in the game there are.", "WARNING")
	Title.Name = "Title"
	Title.Text = "Touch Interest Activator"
	Title.Size = UDim2.new(0,500,0,50)
	Title.BackgroundColor3 = Color3.fromRGB(98,98,98)
	Title.TextScaled = true
	Title.Position = UDim2.new(0.1,0,0.3,0)
	Title.ZIndex = 20
	local Frame = Instance.new("Frame", Title)
	Frame.Size = UDim2.new(1,0,0,200)
	Frame.BackgroundColor3 = Color3.fromRGB(196,196,196)
	Frame.Position = UDim2.new(0,0,0.5,0)
	local ClassTypes = Instance.new("TextButton", Frame)
	ClassTypes.Size = UDim2.new(0,50,0,25)
	ClassTypes.BackgroundColor3 = Color3.fromRGB(235,235,235)
	ClassTypes.TextColor3 = Color3.new(0,0,0)
	ClassTypes.Text = "Types"
	ClassTypes.TextScaled = true
	ClassTypes.Position = UDim2.new(0.05,0,0.25,0)
	local runClass = Instance.new("TextButton", Frame)
	runClass.Size = UDim2.new(0,100,0,75)
	runClass.BackgroundColor3 = Color3.fromRGB(0,255,0)
	runClass.TextColor3 = Color3.new(1,1,1)
	runClass.Text = "Fire Detectors"
	runClass.TextScaled = true
	runClass.TextStrokeTransparency = 0
	runClass.Position = UDim2.new(0.05,0,0.5,0)
	local Update = Instance.new("TextButton", Frame)
	Update.Size = UDim2.new(0,75,0,40)
	Update.BackgroundColor3 = Color3.fromRGB(50,150,0)
	Update.TextColor3 = Color3.new(1,1,1)
	Update.Text = "Update Board"
	Update.TextScaled = true
	Update.TextStrokeTransparency = 0
	Update.Position = UDim2.new(0.4,0,0.3,0)
	local chosenClass = Instance.new("TextButton", Frame)
	chosenClass.Size = UDim2.new(0,50,0,25)
	chosenClass.BackgroundTransparency = 1
	chosenClass.TextColor3 = Color3.new(1,1,1)
	chosenClass.TextStrokeTransparency = 0
	chosenClass.Text = "All"
	chosenClass.TextScaled = true
	chosenClass.Position = UDim2.new(0.05,0,0.1,0)
	local TypeFrame = Instance.new("Frame", ClassTypes)
	TypeFrame.Size = UDim2.new(1.2,0,0,40)
	TypeFrame.Position = UDim2.new(0.8,0,1,0)
	TypeFrame.Visible = false
	local list = Instance.new("UIListLayout", TypeFrame)
	list.Padding = UDim.new(0,5)
	list.FillDirection = Enum.FillDirection.Vertical
	TypeFrame.ZIndex = 9999
	local close = Instance.new("TextButton", Title)
	close.Size = UDim2.new(0,50,0,50)
	close.Position = UDim2.new(1,0,0,0)
	close.BackgroundColor3 = Color3.fromRGB(255,0,0)
	close.Text = "X"
	close.TextScaled = true
	close.Font = Enum.Font.SourceSansBold
	close.TextColor3 = Color3.new(1,1,1)
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0,15)
	UICorner.Parent = close
	local function new_class(Name)
		local Class = Instance.new("TextButton", TypeFrame)
		Class.Size = UDim2.new(1,0,0,10)
		Class.Name = Name.."Class"
		Class.Text = Name
		Class.ZIndex = 10000
		Class.TextColor3 = Color3.new(1,1,1)
		Class.BackgroundColor3 = Color3.fromRGB(40,40,40)
		UICorner = UICorner:Clone()
		UICorner.CornerRadius = UDim.new(1,0)
		UICorner.Parent = Class

		Class.Activated:Connect(function ()
			TypeFrame.Visible = false
			chosenClass.Text = Class.Text
		end)
	end
	new_class("Tools")
	new_class("All")
	new_class("Parts")
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0,5)
	UICorner.Parent = ClassTypes
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0,25)
	UICorner.Parent = Title
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0,25)
	UICorner.Parent = Frame
	UICorner = UICorner:Clone()
	UICorner.CornerRadius = UDim.new(0,2.5)
	UICorner.Parent = TypeFrame

	ClassTypes.Activated:Connect(function ()
		TypeFrame.Visible = not TypeFrame.Visible
	end)
	local Objects = Instance.new("ScrollingFrame", Frame)
	Objects.Size = UDim2.new(0,200,0.8,0)
	Objects.BorderSizePixel = 0
	Objects.Position = UDim2.new(0.6,0,0.2,0)
	Objects.BackgroundColor3 = Color3.fromRGB(223,223,223)
	list:Clone().Parent = Objects
	Objects.AutomaticSize = Enum.AutomaticSize.None
	Objects.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local chosenCon
	local images = {
		['tools'] = 'rbxassetid://7673024',
		['parts'] = 'rbxassetid://157942893',
		['all'] = 'rbxassetid://8781568413'
	}

	Update.Activated:Connect(function ()
		if chosenClass.Text:lower() == "tools" or chosenClass.Text:lower() == "parts" or
			chosenClass.Text:lower() == "all" then
			for _, child in pairs(Objects:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end
		end
		for _, obj in pairs(workspace:GetDescendants()) do
			if chosenClass.Text:lower() == "tools" then
				if obj:IsA("Tool") then
					local ItemFrame = Instance.new("Frame", Objects)
					ItemFrame.Size = UDim2.new(1,0,0,20)
					ItemFrame.BackgroundTransparency = 0
					Objects.AutomaticSize = Enum.AutomaticSize.None
					Objects.AutomaticCanvasSize = Enum.AutomaticSize.Y
					local ItemImage = images[chosenClass.Text:lower()]
					local Image = Instance.new("ImageLabel", ItemFrame)
					Image.Image = ItemImage
					Image.BackgroundTransparency = 1
					Image.ImageTransparency = 0
					Image.Visible = true
					Image.Size = UDim2.new(0.1,0,1,0)
					Image.Position = UDim2.new(0.8,0,0,0)
					local ItemName = Instance.new("TextLabel", ItemFrame)
					ItemName.Text = obj.Name
					ItemName.BackgroundTransparency = 1
					ItemName.Size = UDim2.new(0.7,0,1,0)
					ItemName.Position = UDim2.new(0.2,0,0,0)
					ItemName.TextXAlignment = Enum.TextXAlignment.Left
					ItemName.Font = Enum.Font.Fondamento
					ItemName.TextColor3 = Color3.new(1,1,1)
					ItemName.TextStrokeTransparency = 0
					ItemName.TextScaled = true
				end
			elseif chosenClass.Text:lower() == "parts" then
				if obj:IsA("BasePart") then
					local ItemFrame = Instance.new("Frame", Objects)
					ItemFrame.Size = UDim2.new(1,0,0,20)
					ItemFrame.BackgroundTransparency = 0
					Objects.AutomaticSize = Enum.AutomaticSize.None
					Objects.AutomaticCanvasSize = Enum.AutomaticSize.Y
					local ItemImage = images[chosenClass.Text:lower()]
					local Image = Instance.new("ImageLabel", ItemFrame)
					Image.Image = ItemImage
					Image.BackgroundTransparency = 1
					Image.ImageTransparency = 0
					Image.Visible = true
					Image.Size = UDim2.new(0.1,0,1,0)
					Image.Position = UDim2.new(0.8,0,0,0)
					local ItemName = Instance.new("TextLabel", ItemFrame)
					ItemName.Text = obj.Name
					ItemName.BackgroundTransparency = 1
					ItemName.Size = UDim2.new(0.7,0,1,0)
					ItemName.Position = UDim2.new(0.2,0,0,0)
					ItemName.TextXAlignment = Enum.TextXAlignment.Left
					ItemName.Font = Enum.Font.Fondamento
					ItemName.TextColor3 = Color3.new(1,1,1)
					ItemName.TextStrokeTransparency = 0
					ItemName.TextScaled = true
				end
			elseif chosenClass.Text:lower() == "all" then
				if obj:IsA("Tool") or obj:IsA("BasePart") then
					local ItemFrame = Instance.new("Frame", Objects)
					ItemFrame.Size = UDim2.new(1,0,0,20)
					ItemFrame.BackgroundTransparency = 0
					Objects.AutomaticSize = Enum.AutomaticSize.None
					Objects.AutomaticCanvasSize = Enum.AutomaticSize.Y
					local ItemImage = images[chosenClass.Text:lower()]
					local Image = Instance.new("ImageLabel", ItemFrame)
					Image.Image = ItemImage
					Image.BackgroundTransparency = 1
					Image.ImageTransparency = 0
					Image.Visible = true
					Image.Size = UDim2.new(0.1,0,1,0)
					Image.Position = UDim2.new(0.8,0,0,0)
					local ItemName = Instance.new("TextLabel", ItemFrame)
					ItemName.Text = obj.Name
					ItemName.BackgroundTransparency = 1
					ItemName.Size = UDim2.new(0.7,0,1,0)
					ItemName.Position = UDim2.new(0.2,0,0,0)
					ItemName.TextXAlignment = Enum.TextXAlignment.Left
					ItemName.Font = Enum.Font.Fondamento
					ItemName.TextColor3 = Color3.new(1,1,1)
					ItemName.TextStrokeTransparency = 0
					ItemName.TextScaled = true
				end
			end
		end
	end)

	close.Activated:Connect(function ()
		Title:Destroy()
		opened = false
	end)

	local cooldown = false
	runClass.Activated:Connect(function ()
		if cooldown then notify("Please wait before using this again, we are cleaning up all the lag causers here.", "ERROR") return end

		cooldown = true
		for _,v in pairs(workspace:GetDescendants()) do
			if chosenClass.Text:lower() == 'tools' then
				if v:IsA("Tool") and v:FindFirstChild("Handle") then
					firetouchinterest(v.Handle, LocalPlayer.Character.HumanoidRootPart, 0)
					firetouchinterest(v.Handle, LocalPlayer.Character.HumanoidRootPart, 1)
				end
			elseif chosenClass.Text:lower() == 'parts' then
				if v:IsA("BasePart") then
					firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart,0)
					firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart,1)
				end
			elseif chosenClass.Text:lower() == 'all' then
				if v:IsA("Tool") then
					firetouchinterest(v.Handle, LocalPlayer.Character.HumanoidRootPart, 0)
					firetouchinterest(v.Handle, LocalPlayer.Character.HumanoidRootPart, 1)
				end
				if v:IsA("BasePart") then
					firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart,0)
					firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart,1)
				end
			end

			wait(10)
			cooldown = false
		end
	end)

	dragGUI(Title)
end)

AddBtn("FnfBot", "Funky Friday Bot", "This is a bot for Funky Friday.", function ()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua'))()
end)

AddBtn("RejoinCmd", "Rejoin Game", "Rejoin the current server your in. (Only works in publics)", function()
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("\nRejoining...")
		wait()
		game:GetService('TeleportService'):Teleport(game.PlaceId, Players.LocalPlayer)
	else
		game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
	end
end)

function attach(speaker,target)
	if tools(speaker) then
		local char = speaker.Character
		local tchar = target.Character
		local hum = speaker.Character:FindFirstChildOfClass("Humanoid")
		local hrp = getRoot(speaker.Character)
		local hrp2 = getRoot(target.Character)
		hum.Name = "1"
		local newHum = hum:Clone()
		newHum.Parent = char
		newHum.Name = "Humanoid"
		wait()
		hum:Destroy()
		workspace.CurrentCamera.CameraSubject = char
		newHum.DisplayDistanceType = "None"
		local tool = speaker:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool") or speaker.Character:FindFirstChildOfClass("Tool")
		tool.Parent = char
		hrp.CFrame = hrp2.CFrame * CFrame.new(0, 0, 0) * CFrame.new(math.random(-100, 100)/200,math.random(-100, 100)/200,math.random(-100, 100)/200)
		local n = 0
		repeat
			wait(.1)
			n = n + 1
			hrp.CFrame = hrp2.CFrame
		until (tool.Parent ~= char or not hrp or not hrp2 or not hrp.Parent or not hrp2.Parent or n > 250) and n > 2
	else
		notify('Tool Required.',"ERROR")
	end
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

function tools(plr)
	if plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass('Tool') or plr.Character:FindFirstChildOfClass('Tool') then
		return true
	end
end

function bring(speaker,target,fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = getRoot(speaker.Character).CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and getRoot(speaker.Character)
				wait(0.3)
			end
			local hrp = getRoot(speaker.Character)
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = NormPos
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			wait(1)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	else
		notify('Tool Required.', "WARNING")
	end
end

AddBtn("BringCmd", "Bring Player", "Teleports a player to you.", function ()
	if MainScreen:FindFirstChild("Teleporter") then notify("You can only have one Bring gui.", "ERROR") return end
	local TeleportFrame = Instance.new("TextBox", MainScreen)
	TeleportFrame.Position = UDim2.new(0.2,0,0.2,0)
	TeleportFrame.Name = "Teleporter"
	TeleportFrame.PlaceholderText = "Player name.."
	TeleportFrame.Text = ""
	local plr = nil
	TeleportFrame.Size = UDim2.new(0, 100,0,50)
	TeleportFrame.TextScaled = true
	TeleportFrame.FocusLost:Connect(function ()
		for _, v in pairs(game:GetService("Players"):GetPlayers()) do
			if v.Name:lower():sub(1,#TeleportFrame.Text:gsub(" ",'')) == TeleportFrame.Text:gsub(" ",''):lower() or v.DisplayName:lower():sub(1,#TeleportFrame.Text:gsub(" ",'')) == TeleportFrame.Text:gsub(" ",''):lower() then
				plr = v
			end
		end
		if plr ~= nil and TeleportFrame.Text:gsub(' ','') ~= "" then
			bring(LocalPlayer,plr,true)
		elseif plr == nil then
			notify(("Cannot find player (%s)"):format(TeleportFrame.Text:gsub(' ','')), "WARNING")
		end
		TeleportFrame:Destroy()
	end)
end)

local ver = "1.0.0-Wa"

if pcall(function() loadstring(ReturnGitRaw('https://github.com/CmdContentUser/UltimateHackGUI/blob/main/version'))() end) then
	if ver == version then
		return
	else
		notify(("Your current UHG is outdated, current version \"%s\". Newest Version \"%s\""):format(ver, version), "WARNING")
	end
end
local prefix = ">"
AddConnection("MsgHook", LocalPlayer.Chatted:Connect(function (msg)
	msg=msg:gsub(prefix, ""):gsub('/e',''):gsub(' ','')

	local str = msg
	local newStr = ''
	for i = 1,#msg do
		newStr = str:sub(1,i)
		print(newStr:lower())
		if cmds[newStr:lower()] then
			print(cmds[newStr:lower()])
			cmds[newStr:lower()]()
			break
		end
	end
end))
