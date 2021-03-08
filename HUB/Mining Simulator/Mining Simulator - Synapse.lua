--[[ TODO:
+ Get Coffee
]]
local s=setmetatable({},{__index=function(s,i) return game:service(i) end});

local p=s.Players.LocalPlayer
local rs=s.ReplicatedStorage
local g=s.GuiService:GetGuiInset();
local cg=s.CoreGui
local ws=s.Workspace
local ca=ws.Camera
local sg=s.StarterGui
local r=s.RunService
local l=s.Lighting

local pg=p:FindFirstChild'PlayerGui' or p:WaitForChild'PlayerGui'
local c=p.Character

local ls=p:FindFirstChild('leaderstats',true)
local Depthg=pg:FindFirstChild('Depth',true)

local Client=getsenv(pg.ScreenGui.ClientScript)
local toggle={toolsValue=0;ValueMap=1};
local Mouse=p:GetMouse()
local listmaps={
	{"Map","EarthSpawn"},
	{"SpaceMap","SpaceSpawn"},
	{"Candyland","CandySpawn"},
	{"Toyland","ToySpawn"},
	{"FoodLand","FoodSpawn"},
	{"Dinoland","DinoSpawn"},
	{"SeaMap","SeaSpawn"},
	{"BeachLand","BeachSpawn"},
	{"CrystalCavern","CavernSpawn"},
	{"Forest","ForestSpawn"},
	{"LavaWorld","LavaSpawn"}
}
do --Function

	function GetMapsCorrect()
		for i=1,11,1 do CurMap=workspace:FindFirstChild(tostring(listmaps[i][1]))Maps={[tostring(CurMap)]=CurMap}return;end
	end

	function GetMaps()
		GetMapsCorrect()
		for i, v in next, getnilinstances() do
			local Str=tostring(v)for i=1,11,1 do if Str==listmaps[i][1]then Maps[Str]=v;end;end
		end
	end

	function EquipEggs()
		local FindPet = c:FindFirstChild("Pet")
		if FindPet then
			FindPet = FindPet:FindFirstChild("Fake")
		end
	
		if FindPet then
			if string.find(string.lower(FindPet.Value), "egg") then
				return false
			end
		end
	
		return true
	end

	function EquipEgg()
		local MyPets = remote:InvokeServer("getPlayerData",{{12,""}})
		for i,v in next, MyPets do
			for i2,v2 in pairs(MyPets[i][1]) do
				if i2==3 then Petvalue=tonumber(v2) end
				if string.find(v2,"Egg") then
					local Namepets=tostring(v2)
					network:FireServer("equipPet", {{{Namepets,Namepets,Petvalue}}})	
					wait()
				end
			end
		end
	end

	function AutoOpen()
		local MyCrates = remote:InvokeServer("getPlayerData",{{13,""}})
		for i,v in next, MyCrates do
			for i2,v2 in pairs(MyCrates[i]) do
				network:FireServer("SpinCrate", {{tostring(v2)}})	
				wait()
			end
		end
	end

	function BackpackFull()
		local Backpack = c:FindFirstChild("Backpack")
		if Backpack then
			local Txt = Backpack:FindFirstChild("Decore")
			if Txt then
				Txt = Txt:FindFirstChild("Count")
				if Txt then
					Txt = Txt:FindFirstChild("SurfaceGui")
					if Txt then
						Txt = Txt:FindFirstChild("Amount")
					end
				end
			end
			if Txt then
				local Cur, Max = string.match(Txt.Text, "(%d+)/(%w+)")
				if string.find(Max, "inf") then
					Max = toggle.BrackpackLength
				end
				if tonumber(toggle.BrackpackLength)~=nil then
					if tonumber(Max)>=tonumber(toggle.BrackpackLength)then Max=toggle.BrackpackLength;else Max=Max;end
				end
				Cur, Max = tonumber(Cur), tonumber(Max)
				if Cur <= Max then
					return true
				else
					return false
				end
			end
		end
	
		return false
	end

	function WTS(Ore)
		local screen=ca:WorldToViewportPoint(Ore.PrimaryPart.Position)
		return Vector2.new(screen.x, screen.y+(g.Y/2))
	end

	function WTL(Ore)
		local screen=ca:WorldToScreenPoint(Ore.PrimaryPart.Position)
		return Vector2.new(screen.X, screen.Y+g.Y)
	end

	function WTC(Ore)
		if toggle.BaseColor~=false then
			return Ore.PrimaryPart.Color
		else
			return Color3.new(1,1,1)
		end
	end

	function espOres(Ore)
		if Ore:FindFirstChild(Ore.Name) then return end
		local billboard = Instance.new("BillboardGui", Ore)
		billboard.Name=Ore.Name

		local textDrawing=Drawing.new("Text")
		textDrawing.Text=Ore.Name
		textDrawing.Color=WTC(Ore)
		textDrawing.Position=WTS(Ore)
		textDrawing.Size=15
		textDrawing.Outline=true
		textDrawing.Center=true
		textDrawing.Visible=true

		local lineDrawing=Drawing.new('Line')
		lineDrawing.Visible=true;
		lineDrawing.Thickness=1
		lineDrawing.Transparency=1
		lineDrawing.Color=WTC(Ore)
		lineDrawing.From=Vector2.new(ca.ViewportSize.X/2,ca.ViewportSize.Y/2+400)
		lineDrawing.To=WTL(Ore)
		if not (textDrawing~=nil or lineDrawing~=nil) then return end
		r.Stepped:connect(function()
			pcall(function()
				local destroyed = not Ore:IsDescendantOf(ws)
				local enabled=((toggle.ESPOres and toggle.ESP_Ores) and (Ore.PrimaryPart.Position-c.HumanoidRootPart.Position).magnitude <= 150)
				if destroyed and textDrawing~=nil and lineDrawing~=nil then
					textDrawing:Remove()
					lineDrawing:Remove()
				end
				if Ore~=nil then
					textDrawing.Position=WTS(Ore)
					textDrawing.Color=WTC(Ore)
					textDrawing.Visible=enabled

					lineDrawing.Visible=(enabled and toggle.Tracers)
					lineDrawing.To=WTL(Ore)
					lineDrawing.Color=WTC(Ore)
				end
				local _, screen = ca:WorldToViewportPoint(Ore.PrimaryPart.Position)
				if screen then
					textDrawing.Visible=enabled
					lineDrawing.Visible=(enabled and toggle.Tracers)
				else
					textDrawing.Visible=false
					lineDrawing.Visible=false
				end
			end)
		end)
	end

	function filter(ask)
		if string.find(ask,"Stone")or string.find(ask,"Block") then
			return false
		end
		if ask=="Flour"or ask=="Sand"or ask=="Dirt"or ask=="Grass" then
			return false
		end
		return true
	end

	function Chat(Written, Rainbow)
		local NumberRandom = math.random(0, 13077824)
		sg:SetCore("ChatMakeSystemMessage", {
			Text = Written..NumberRandom,
			Color = Color3.new(255/255,223/255,223/255),
			FontSize = Enum.FontSize.Size24,
		})
		
		for i, v in next, pg.Chat:GetDescendants() do 
			if v:IsA("TextLabel") and v.Text == Written..NumberRandom then
			v.Text=Written
				spawn(function()
					local num = 0
					while Rainbow do
						if num > 1 then
							num = 0
						end
						num = num + 0.002
						v.TextColor3 = Color3.fromHSV(num, 0.4, 1)
						
						if v.Text ~= Written then
							v.TextColor3 = Color3.new(1, 1, 1)
							break
						end
	
						r.RenderStepped:wait()
						end
					end)
				break
			end
		end
	end

	p.CharacterAdded:connect(function(char)
		c=char
	end)

	function GetNetwork()
		for i,v in next, debug.getregistry() do
			if type(v) == "function" and islclosure(v) then
				for i2,v2 in pairs(debug.getupvalues(v)) do
					if type(v2)=="table" and type(v2.FireServer)=="function" then
						for i3,v3 in pairs(v2) do
							if i3=="RemoteEvent" then network=v3;end
						end
						for i3,v3 in pairs(v2) do
							if i3=="RemoteFunction" then remote=v3;end
						end
					end
				end
			end
		end
	end
end

do --Menu
	function Init()
		if cg:FindFirstChild('Mining_Simulator') then 
			cg.Mining_Simulator:Destroy()
		end
		local Mining_Simulator = Instance.new("ScreenGui")
		local MainFrame = Instance.new("Frame")
		local Title = Instance.new("TextLabel")
		local design = Instance.new("Frame")
		local buttons = Instance.new("Frame")
		local Instant_Mine = Instance.new("TextButton")
		local Nuke_Aura = Instance.new("TextButton")
		local Auto_Chest = Instance.new("TextButton")
		local Auto_Ore = Instance.new("TextButton")
		local Auto_Rebirth = Instance.new("TextButton")
		local CurrentPosition = Instance.new("TextLabel")
		local Auto_Sell = Instance.new("TextButton")
		local Teleport = Instance.new("TextButton")
		local Buy_Crates_Pets = Instance.new("TextButton")
		local Tools_Rainbow = Instance.new("TextButton")
		local Open_Crates = Instance.new("TextButton")
		local Collapse = Instance.new("TextButton")
		local Transparency = Instance.new("TextButton")
		local Auto_Equip_Eggs = Instance.new("TextButton")
		local ESP_Ores = Instance.new("TextButton")
		local Settings = Instance.new("TextButton")
		local Settings_2 = Instance.new("Frame")
		local design_2 = Instance.new("Frame")
		local Title_2 = Instance.new("TextLabel")
		local buttons_2 = Instance.new("Frame")
		local TransparencyLength = Instance.new("TextBox")
		local PetLength = Instance.new("TextBox")
		local TracersLength = Instance.new("TextButton")
		local BrackpackLength = Instance.new("TextBox")
		local BaseColorLength = Instance.new("TextButton")
		local TextLabel = Instance.new("TextLabel")
		local TextLabel_2 = Instance.new("TextLabel")
		local TextLabel_3 = Instance.new("TextLabel")
		local TextLabel_4 = Instance.new("TextLabel")
		local TextLabel_5 = Instance.new("TextLabel")
		local Teleports = Instance.new("Frame")
		local Title_3 = Instance.new("TextLabel")
		local design_3 = Instance.new("Frame")
		local buttons_3 = Instance.new("ScrollingFrame")
		local MapLength = Instance.new("TextButton")
		local SpaceLength = Instance.new("TextButton")
		local CandyLength = Instance.new("TextButton")
		local FoodLength = Instance.new("TextButton")
		local AltantisLength = Instance.new("TextButton")
		local ToyLength = Instance.new("TextButton")
		local DinoLength = Instance.new("TextButton")
		local BeachLength = Instance.new("TextButton")
		local CrystalLength = Instance.new("TextButton")
		local ForestLength = Instance.new("TextButton")
		local LavaLength = Instance.new("TextButton")

		--Properties:

		Mining_Simulator.Name = "Mining_Simulator"
		Mining_Simulator.Parent = cg
		Mining_Simulator.ResetOnSpawn = false

		MainFrame.Name = "MainFrame"
		MainFrame.Parent = Mining_Simulator
		MainFrame.Active = true
		MainFrame.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		MainFrame.BorderSizePixel = 0
		MainFrame.Draggable = true
		MainFrame.Position = UDim2.new(0.286665797, 2, 0.582309544, -253)
		MainFrame.Size = UDim2.new(0, 350, 0, 419)

		Title.Name = "Title"
		Title.Parent = MainFrame
		Title.BackgroundColor3 = Color3.new(1, 1, 1)
		Title.BackgroundTransparency = 1
		Title.Size = UDim2.new(1, 0, 0, 50)
		Title.Font = Enum.Font.SourceSansBold
		Title.Text = "Mining Simulator\nUI: Racist Dolphin#5199\nMade by: Jeff Senpai SenAmigos#9288"
		Title.TextColor3 = Color3.new(1, 1, 1)
		Title.TextSize = 18
		Title.TextTransparency = 0.5

		design.Name = "design"
		design.Parent = MainFrame
		design.BackgroundColor3 = Color3.new(1, 1, 1)
		design.BackgroundTransparency = 0.5
		design.BorderSizePixel = 0
		design.Position = UDim2.new(0.0500000007, 0, 0, 50)
		design.Size = UDim2.new(0.899999976, 0, 0, 2)

		buttons.Name = "buttons"
		buttons.Parent = MainFrame
		buttons.BackgroundColor3 = Color3.new(1, 1, 1)
		buttons.BackgroundTransparency = 1
		buttons.Position = UDim2.new(0, 20, 0, 70)
		buttons.Size = UDim2.new(1, -40, 1, -80)

		Instant_Mine.Name = "Instant_Mine"
		Instant_Mine.Parent = buttons
		Instant_Mine.BackgroundColor3 = Color3.new(1, 1, 1)
		Instant_Mine.BackgroundTransparency = 0.5
		Instant_Mine.BorderSizePixel = 0
		Instant_Mine.Size = UDim2.new(0, 150, 0, 30)
		Instant_Mine.Font = Enum.Font.SourceSansBold
		Instant_Mine.Text = "Instant Mine"
		Instant_Mine.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Instant_Mine.TextSize = 14
		Instant_Mine.TextWrapped = true

		Nuke_Aura.Name = "Nuke_Aura"
		Nuke_Aura.Parent = buttons
		Nuke_Aura.BackgroundColor3 = Color3.new(1, 1, 1)
		Nuke_Aura.BackgroundTransparency = 0.5
		Nuke_Aura.BorderSizePixel = 0
		Nuke_Aura.Position = UDim2.new(1, -150, 0, 0)
		Nuke_Aura.Size = UDim2.new(0, 150, 0, 30)
		Nuke_Aura.Font = Enum.Font.SourceSansBold
		Nuke_Aura.Text = "Nuke Aura"
		Nuke_Aura.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Nuke_Aura.TextSize = 14
		Nuke_Aura.TextWrapped = true

		Auto_Chest.Name = "Auto_Chest"
		Auto_Chest.Parent = buttons
		Auto_Chest.BackgroundColor3 = Color3.new(1, 1, 1)
		Auto_Chest.BackgroundTransparency = 0.5
		Auto_Chest.BorderSizePixel = 0
		Auto_Chest.Position = UDim2.new(1, -150, 0, 40)
		Auto_Chest.Size = UDim2.new(0, 150, 0, 30)
		Auto_Chest.Font = Enum.Font.SourceSansBold
		Auto_Chest.Text = "Auto Chest"
		Auto_Chest.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Auto_Chest.TextSize = 14
		Auto_Chest.TextWrapped = true

		Auto_Ore.Name = "Auto_Ore"
		Auto_Ore.Parent = buttons
		Auto_Ore.BackgroundColor3 = Color3.new(1, 1, 1)
		Auto_Ore.BackgroundTransparency = 0.5
		Auto_Ore.BorderSizePixel = 0
		Auto_Ore.Position = UDim2.new(1, -150, 0, 80)
		Auto_Ore.Size = UDim2.new(0, 150, 0, 30)
		Auto_Ore.Font = Enum.Font.SourceSansBold
		Auto_Ore.Text = "Auto Ore"
		Auto_Ore.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Auto_Ore.TextSize = 14
		Auto_Ore.TextWrapped = true

		Auto_Rebirth.Name = "Auto_Rebirth"
		Auto_Rebirth.Parent = buttons
		Auto_Rebirth.BackgroundColor3 = Color3.new(1, 1, 1)
		Auto_Rebirth.BackgroundTransparency = 0.5
		Auto_Rebirth.BorderSizePixel = 0
		Auto_Rebirth.Position = UDim2.new(0, 0, 0, 80)
		Auto_Rebirth.Size = UDim2.new(0, 150, 0, 30)
		Auto_Rebirth.Font = Enum.Font.SourceSansBold
		Auto_Rebirth.Text = "Auto Rebirth (Incomplet)"
		Auto_Rebirth.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Auto_Rebirth.TextSize = 14
		Auto_Rebirth.TextWrapped = true

		CurrentPosition.Name = "CurrentPosition"
		CurrentPosition.Parent = buttons
		CurrentPosition.BackgroundColor3 = Color3.new(1, 1, 1)
		CurrentPosition.BackgroundTransparency = 1
		CurrentPosition.Position = UDim2.new(0, -3, 0, 322)
		CurrentPosition.Size = UDim2.new(1, 0, 0, 15)
		CurrentPosition.Font = Enum.Font.SourceSansBold
		CurrentPosition.Text = "TESTING"
		CurrentPosition.TextColor3 = Color3.new(1, 1, 1)
		CurrentPosition.TextSize = 18
		CurrentPosition.TextTransparency = 0.5

		Auto_Sell.Name = "Auto_Sell"
		Auto_Sell.Parent = buttons
		Auto_Sell.BackgroundColor3 = Color3.new(1, 1, 1)
		Auto_Sell.BackgroundTransparency = 0.5
		Auto_Sell.BorderSizePixel = 0
		Auto_Sell.Position = UDim2.new(0, 0, 0, 40)
		Auto_Sell.Size = UDim2.new(0, 150, 0, 30)
		Auto_Sell.Font = Enum.Font.SourceSansBold
		Auto_Sell.Text = "Auto Sell (Incomplet)"
		Auto_Sell.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Auto_Sell.TextSize = 14
		Auto_Sell.TextWrapped = true

		Teleport.Name = "Teleport"
		Teleport.Parent = buttons
		Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
		Teleport.BackgroundTransparency = 0.5
		Teleport.BorderSizePixel = 0
		Teleport.Position = UDim2.new(0, 0, 0, 120)
		Teleport.Size = UDim2.new(0, 150, 0, 30)
		Teleport.Font = Enum.Font.SourceSansBold
		Teleport.Text = "Teleport"
		Teleport.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Teleport.TextSize = 14
		Teleport.TextWrapped = true

		Buy_Crates_Pets.Name = "Buy_Crates_Pets"
		Buy_Crates_Pets.Parent = buttons
		Buy_Crates_Pets.BackgroundColor3 = Color3.new(1, 1, 1)
		Buy_Crates_Pets.BackgroundTransparency = 0.5
		Buy_Crates_Pets.BorderSizePixel = 0
		Buy_Crates_Pets.Position = UDim2.new(1, -150, 0, 120)
		Buy_Crates_Pets.Size = UDim2.new(0, 150, 0, 30)
		Buy_Crates_Pets.Font = Enum.Font.SourceSansBold
		Buy_Crates_Pets.Text = "Buy Crates/Pets"
		Buy_Crates_Pets.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Buy_Crates_Pets.TextSize = 14
		Buy_Crates_Pets.TextWrapped = true

		Tools_Rainbow.Name = "Tools_Rainbow"
		Tools_Rainbow.Parent = buttons
		Tools_Rainbow.BackgroundColor3 = Color3.new(1, 1, 1)
		Tools_Rainbow.BackgroundTransparency = 0.5
		Tools_Rainbow.BorderSizePixel = 0
		Tools_Rainbow.Position = UDim2.new(1, -150, 0, 200)
		Tools_Rainbow.Size = UDim2.new(0, 150, 0, 30)
		Tools_Rainbow.Font = Enum.Font.SourceSansBold
		Tools_Rainbow.Text = "Tools Rainbow"
		Tools_Rainbow.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Tools_Rainbow.TextSize = 14
		Tools_Rainbow.TextWrapped = true

		Open_Crates.Name = "Open_Crates"
		Open_Crates.Parent = buttons
		Open_Crates.BackgroundColor3 = Color3.new(1, 1, 1)
		Open_Crates.BackgroundTransparency = 0.5
		Open_Crates.BorderSizePixel = 0
		Open_Crates.Position = UDim2.new(1, -150, 0, 160)
		Open_Crates.Size = UDim2.new(0, 150, 0, 30)
		Open_Crates.Font = Enum.Font.SourceSansBold
		Open_Crates.Text = "Open Crates"
		Open_Crates.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Open_Crates.TextSize = 14
		Open_Crates.TextWrapped = true

		Collapse.Name = "Collapse"
		Collapse.Parent = buttons
		Collapse.BackgroundColor3 = Color3.new(1, 1, 1)
		Collapse.BackgroundTransparency = 0.5
		Collapse.BorderSizePixel = 0
		Collapse.Position = UDim2.new(0, 0, 0, 200)
		Collapse.Size = UDim2.new(0, 150, 0, 30)
		Collapse.Font = Enum.Font.SourceSansBold
		Collapse.Text = "Collapse"
		Collapse.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Collapse.TextSize = 14
		Collapse.TextWrapped = true

		Transparency.Name = "Transparency"
		Transparency.Parent = buttons
		Transparency.BackgroundColor3 = Color3.new(1, 1, 1)
		Transparency.BackgroundTransparency = 0.5
		Transparency.BorderSizePixel = 0
		Transparency.Position = UDim2.new(0, 0, 0, 240)
		Transparency.Size = UDim2.new(0, 150, 0, 30)
		Transparency.Font = Enum.Font.SourceSansBold
		Transparency.Text = "Transparency"
		Transparency.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Transparency.TextSize = 14
		Transparency.TextWrapped = true

		Auto_Equip_Eggs.Name = "Auto_Equip_Eggs"
		Auto_Equip_Eggs.Parent = buttons
		Auto_Equip_Eggs.BackgroundColor3 = Color3.new(1, 1, 1)
		Auto_Equip_Eggs.BackgroundTransparency = 0.5
		Auto_Equip_Eggs.BorderSizePixel = 0
		Auto_Equip_Eggs.Position = UDim2.new(0, 0, 0, 160)
		Auto_Equip_Eggs.Size = UDim2.new(0, 150, 0, 30)
		Auto_Equip_Eggs.Font = Enum.Font.SourceSansBold
		Auto_Equip_Eggs.Text = "Auto Equip Eggs"
		Auto_Equip_Eggs.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Auto_Equip_Eggs.TextSize = 14
		Auto_Equip_Eggs.TextWrapped = true

		ESP_Ores.Name = "ESP_Ores"
		ESP_Ores.Parent = buttons
		ESP_Ores.BackgroundColor3 = Color3.new(1, 1, 1)
		ESP_Ores.BackgroundTransparency = 0.5
		ESP_Ores.BorderSizePixel = 0
		ESP_Ores.Position = UDim2.new(1, -150, 0, 240)
		ESP_Ores.Size = UDim2.new(0, 150, 0, 30)
		ESP_Ores.Font = Enum.Font.SourceSansBold
		ESP_Ores.Text = "ESP Ores"
		ESP_Ores.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		ESP_Ores.TextSize = 14
		ESP_Ores.TextWrapped = true

		Settings.Name = "Settings"
		Settings.Parent = buttons
		Settings.BackgroundColor3 = Color3.new(1, 1, 1)
		Settings.BackgroundTransparency = 0.5
		Settings.BorderSizePixel = 0
		Settings.Position = UDim2.new(0, 0, 0, 280)
		Settings.Size = UDim2.new(0, 310, 0, 30)
		Settings.Font = Enum.Font.SourceSansBold
		Settings.Text = "Settings"
		Settings.TextColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Settings.TextSize = 14
		Settings.TextWrapped = true

		Settings_2.Name = "Settings"
		Settings_2.Parent = MainFrame
		Settings_2.Active = true
		Settings_2.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Settings_2.BorderSizePixel = 0
		Settings_2.Position = UDim2.new(1.01714289, 3, 0.4952268, -138)
		Settings_2.Size = UDim2.new(0, 321, 0, 218)
		Settings_2.Visible = false

		design_2.Name = "design"
		design_2.Parent = Settings_2
		design_2.BackgroundColor3 = Color3.new(1, 1, 1)
		design_2.BackgroundTransparency = 0.5
		design_2.BorderSizePixel = 0
		design_2.Position = UDim2.new(0.0500000007, 0, -0.0614035092, 50)
		design_2.Size = UDim2.new(0.899999976, 0, 0, 2)

		Title_2.Name = "Title"
		Title_2.Parent = Settings_2
		Title_2.BackgroundColor3 = Color3.new(1, 1, 1)
		Title_2.BackgroundTransparency = 1
		Title_2.Position = UDim2.new(-0.00295934943, 0, 0.00229343795, 0)
		Title_2.Size = UDim2.new(1.00295925, 0, -0.063696973, 50)
		Title_2.Font = Enum.Font.SourceSansBold
		Title_2.Text = "Settings Menu"
		Title_2.TextColor3 = Color3.new(1, 1, 1)
		Title_2.TextSize = 18
		Title_2.TextTransparency = 0.5

		buttons_2.Name = "buttons"
		buttons_2.Parent = Settings_2
		buttons_2.BackgroundColor3 = Color3.new(1, 1, 1)
		buttons_2.BackgroundTransparency = 1
		buttons_2.Position = UDim2.new(0, 20, 0, 50)
		buttons_2.Size = UDim2.new(0, 288, 1.05299997, -80)

		TransparencyLength.Name = "TransparencyLength"
		TransparencyLength.Parent = buttons_2
		TransparencyLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		TransparencyLength.BackgroundTransparency = 0.5
		TransparencyLength.BorderSizePixel = 0
		TransparencyLength.Position = UDim2.new(1.02083337, -150, 0, 60)
		TransparencyLength.Size = UDim2.new(0, 135, 0, 20)
		TransparencyLength.ClearTextOnFocus = false
		TransparencyLength.Font = Enum.Font.SourceSansBold
		TransparencyLength.Text = "1"
		TransparencyLength.TextSize = 14
		TransparencyLength.TextWrapped = true

		PetLength.Name = "PetLength"
		PetLength.Parent = buttons_2
		PetLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		PetLength.BackgroundTransparency = 0.5
		PetLength.BorderSizePixel = 0
		PetLength.Position = UDim2.new(1.02083337, -150, 0, 30)
		PetLength.Size = UDim2.new(0, 135, 0, 20)
		PetLength.ClearTextOnFocus = false
		PetLength.Font = Enum.Font.SourceSansBold
		PetLength.Text = ""
		PetLength.TextSize = 14
		PetLength.TextWrapped = true

		TracersLength.Name = "TracersLength"
		TracersLength.Parent = buttons_2
		TracersLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		TracersLength.BackgroundTransparency = 0.5
		TracersLength.BorderSizePixel = 0
		TracersLength.Position = UDim2.new(1.02083337, -150, 0, 120)
		TracersLength.Size = UDim2.new(0, 135, 0, 20)
		TracersLength.Font = Enum.Font.SourceSansBold
		TracersLength.Text = "false"
		TracersLength.TextSize = 14
		TracersLength.TextWrapped = true

		BrackpackLength.Name = "BrackpackLength"
		BrackpackLength.Parent = buttons_2
		BrackpackLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		BrackpackLength.BackgroundTransparency = 0.5
		BrackpackLength.BorderSizePixel = 0
		BrackpackLength.Position = UDim2.new(1.02083337, -150, 0, 0)
		BrackpackLength.Size = UDim2.new(0, 135, 0, 20)
		BrackpackLength.ClearTextOnFocus = false
		BrackpackLength.Font = Enum.Font.SourceSansBold
		BrackpackLength.Text = ""
		BrackpackLength.TextSize = 14
		BrackpackLength.TextWrapped = true

		BaseColorLength.Name = "BaseColorLength"
		BaseColorLength.Parent = buttons_2
		BaseColorLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		BaseColorLength.BackgroundTransparency = 0.5
		BaseColorLength.BorderSizePixel = 0
		BaseColorLength.Position = UDim2.new(1.02083337, -150, 0, 90)
		BaseColorLength.Size = UDim2.new(0, 135, 0, 20)
		BaseColorLength.Font = Enum.Font.SourceSansBold
		BaseColorLength.Text = "false"
		BaseColorLength.TextSize = 14
		BaseColorLength.TextWrapped = true

		TextLabel.Parent = buttons_2
		TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.new(0.5, 0, 0, 20)
		TextLabel.Font = Enum.Font.SourceSansBold
		TextLabel.Text = "Backpack Amount"
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.TextSize = 16
		TextLabel.TextTransparency = 0.5
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		TextLabel_2.Parent = buttons_2
		TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel_2.BackgroundTransparency = 1
		TextLabel_2.Position = UDim2.new(0, 0, 0, 30)
		TextLabel_2.Size = UDim2.new(0.5, 0, 0, 20)
		TextLabel_2.Font = Enum.Font.SourceSansBold
		TextLabel_2.Text = "Crate/Pet Name"
		TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel_2.TextSize = 16
		TextLabel_2.TextTransparency = 0.5
		TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

		TextLabel_3.Parent = buttons_2
		TextLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel_3.BackgroundTransparency = 1
		TextLabel_3.Position = UDim2.new(0, 0, 0, 60)
		TextLabel_3.Size = UDim2.new(0.5, 0, 0, 20)
		TextLabel_3.Font = Enum.Font.SourceSansBold
		TextLabel_3.Text = "Transparency"
		TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
		TextLabel_3.TextSize = 16
		TextLabel_3.TextTransparency = 0.5
		TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

		TextLabel_4.Parent = buttons_2
		TextLabel_4.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel_4.BackgroundTransparency = 1
		TextLabel_4.Position = UDim2.new(0, 0, 0, 90)
		TextLabel_4.Size = UDim2.new(0.5, 0, 0, 20)
		TextLabel_4.Font = Enum.Font.SourceSansBold
		TextLabel_4.Text = "Base Color"
		TextLabel_4.TextColor3 = Color3.new(1, 1, 1)
		TextLabel_4.TextSize = 16
		TextLabel_4.TextTransparency = 0.5
		TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left

		TextLabel_5.Parent = buttons_2
		TextLabel_5.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel_5.BackgroundTransparency = 1
		TextLabel_5.Position = UDim2.new(0, 0, 0, 120)
		TextLabel_5.Size = UDim2.new(0.5, 0, 0, 20)
		TextLabel_5.Font = Enum.Font.SourceSansBold
		TextLabel_5.Text = "Tracer Lines"
		TextLabel_5.TextColor3 = Color3.new(1, 1, 1)
		TextLabel_5.TextSize = 16
		TextLabel_5.TextTransparency = 0.5
		TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

		Teleports.Name = "Teleports"
		Teleports.Parent = MainFrame
		Teleports.Active = true
		Teleports.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
		Teleports.BorderSizePixel = 0
		Teleports.Position = UDim2.new(1.01428568, 3, 0.495226741, -138)
		Teleports.Size = UDim2.new(0, 322, 0, 270)
		Teleports.Visible = false

		Title_3.Name = "Title"
		Title_3.Parent = Teleports
		Title_3.BackgroundColor3 = Color3.new(1, 1, 1)
		Title_3.BackgroundTransparency = 1
		Title_3.Size = UDim2.new(1, 0, 0, 50)
		Title_3.Font = Enum.Font.SourceSansBold
		Title_3.Text = "Teleports"
		Title_3.TextColor3 = Color3.new(1, 1, 1)
		Title_3.TextSize = 18
		Title_3.TextTransparency = 0.5

		design_3.Name = "design"
		design_3.Parent = Teleports
		design_3.BackgroundColor3 = Color3.new(1, 1, 1)
		design_3.BackgroundTransparency = 0.5
		design_3.BorderSizePixel = 0
		design_3.Position = UDim2.new(0.0500000007, 0, 0, 50)
		design_3.Size = UDim2.new(0.899999976, 0, 0, 2)

		buttons_3.Name = "buttons"
		buttons_3.Parent = Teleports
		buttons_3.BackgroundColor3 = Color3.new(1, 1, 1)
		buttons_3.BackgroundTransparency = 1
		buttons_3.BorderSizePixel = 0
		buttons_3.Position = UDim2.new(0, 23, 0, 54)
		buttons_3.Size = UDim2.new(1, -40, 1, -70)
		buttons_3.CanvasSize = UDim2.new(0, 0, 0, 0)
		buttons_3.ScrollBarThickness = 5

		MapLength.Name = "MapLength"
		MapLength.Parent = buttons_3
		MapLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		MapLength.BackgroundTransparency = 0.5
		MapLength.BorderSizePixel = 0
		MapLength.Position = UDim2.new(0, 10, 0, 10)
		MapLength.Size = UDim2.new(0, 120, 0, 20)
		MapLength.Font = Enum.Font.SourceSansBold
		MapLength.Text = "Map"
		MapLength.TextSize = 14
		MapLength.TextWrapped = true

		SpaceLength.Name = "SpaceLength"
		SpaceLength.Parent = buttons_3
		SpaceLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		SpaceLength.BackgroundTransparency = 0.5
		SpaceLength.BorderSizePixel = 0
		SpaceLength.Position = UDim2.new(0, 150, 0, 10)
		SpaceLength.Size = UDim2.new(0, 120, 0, 20)
		SpaceLength.Font = Enum.Font.SourceSansBold
		SpaceLength.Text = "Space"
		SpaceLength.TextSize = 14
		SpaceLength.TextWrapped = true

		CandyLength.Name = "CandyLength"
		CandyLength.Parent = buttons_3
		CandyLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		CandyLength.BackgroundTransparency = 0.5
		CandyLength.BorderSizePixel = 0
		CandyLength.Position = UDim2.new(0, 10, 0, 40)
		CandyLength.Size = UDim2.new(0, 120, 0, 20)
		CandyLength.Font = Enum.Font.SourceSansBold
		CandyLength.Text = "Candy"
		CandyLength.TextSize = 14
		CandyLength.TextWrapped = true

		FoodLength.Name = "FoodLength"
		FoodLength.Parent = buttons_3
		FoodLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		FoodLength.BackgroundTransparency = 0.5
		FoodLength.BorderSizePixel = 0
		FoodLength.Position = UDim2.new(0, 10, 0, 70)
		FoodLength.Size = UDim2.new(0, 120, 0, 20)
		FoodLength.Font = Enum.Font.SourceSansBold
		FoodLength.Text = "Food"
		FoodLength.TextSize = 14
		FoodLength.TextWrapped = true

		AltantisLength.Name = "AltantisLength"
		AltantisLength.Parent = buttons_3
		AltantisLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		AltantisLength.BackgroundTransparency = 0.5
		AltantisLength.BorderSizePixel = 0
		AltantisLength.Position = UDim2.new(0, 10, 0, 100)
		AltantisLength.Size = UDim2.new(0, 120, 0, 20)
		AltantisLength.Font = Enum.Font.SourceSansBold
		AltantisLength.Text = "Altantis"
		AltantisLength.TextSize = 14
		AltantisLength.TextWrapped = true

		ToyLength.Name = "ToyLength"
		ToyLength.Parent = buttons_3
		ToyLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		ToyLength.BackgroundTransparency = 0.5
		ToyLength.BorderSizePixel = 0
		ToyLength.Position = UDim2.new(0, 150, 0, 40)
		ToyLength.Size = UDim2.new(0, 120, 0, 20)
		ToyLength.Font = Enum.Font.SourceSansBold
		ToyLength.Text = "Toy"
		ToyLength.TextSize = 14
		ToyLength.TextWrapped = true

		DinoLength.Name = "DinoLength"
		DinoLength.Parent = buttons_3
		DinoLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		DinoLength.BackgroundTransparency = 0.5
		DinoLength.BorderSizePixel = 0
		DinoLength.Position = UDim2.new(0, 150, 0, 70)
		DinoLength.Size = UDim2.new(0, 120, 0, 20)
		DinoLength.Font = Enum.Font.SourceSansBold
		DinoLength.Text = "Dino"
		DinoLength.TextSize = 14
		DinoLength.TextWrapped = true

		BeachLength.Name = "BeachLength"
		BeachLength.Parent = buttons_3
		BeachLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		BeachLength.BackgroundTransparency = 0.5
		BeachLength.BorderSizePixel = 0
		BeachLength.Position = UDim2.new(0, 150, 0, 100)
		BeachLength.Size = UDim2.new(0, 120, 0, 20)
		BeachLength.Font = Enum.Font.SourceSansBold
		BeachLength.Text = "Beach"
		BeachLength.TextSize = 14
		BeachLength.TextWrapped = true

		CrystalLength.Name = "CrystalLength"
		CrystalLength.Parent = buttons_3
		CrystalLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		CrystalLength.BackgroundTransparency = 0.5
		CrystalLength.BorderSizePixel = 0
		CrystalLength.Position = UDim2.new(0, 10, 0, 130)
		CrystalLength.Size = UDim2.new(0, 120, 0, 20)
		CrystalLength.Font = Enum.Font.SourceSansBold
		CrystalLength.Text = "Crystal"
		CrystalLength.TextSize = 14
		CrystalLength.TextWrapped = true

		ForestLength.Name = "ForestLength"
		ForestLength.Parent = buttons_3
		ForestLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		ForestLength.BackgroundTransparency = 0.5
		ForestLength.BorderSizePixel = 0
		ForestLength.Position = UDim2.new(0, 150, 0, 130)
		ForestLength.Size = UDim2.new(0, 120, 0, 20)
		ForestLength.Font = Enum.Font.SourceSansBold
		ForestLength.Text = "Forest"
		ForestLength.TextSize = 14
		ForestLength.TextWrapped = true

		LavaLength.Name = "LavaLength"
		LavaLength.Parent = buttons_3
		LavaLength.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
		LavaLength.BackgroundTransparency = 0.5
		LavaLength.BorderSizePixel = 0
		LavaLength.Position = UDim2.new(0, 10, 0, 160)
		LavaLength.Size = UDim2.new(0, 120, 0, 20)
		LavaLength.Font = Enum.Font.SourceSansBold
		LavaLength.Text = "Lava"
		LavaLength.TextSize = 14
		LavaLength.TextWrapped = true

		Instant_Mine.MouseButton1Click:connect(function()
			toggle.InstantMine = not toggle.InstantMine
			if toggle.InstantMine then
				Instant_Mine.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Instant_Mine.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Nuke_Aura.MouseButton1Click:connect(function()
			toggle.NukeAura = not toggle.NukeAura
			if toggle.NukeAura then
				Nuke_Aura.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Nuke_Aura.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Auto_Chest.MouseButton1Click:connect(function()
			toggle.AutoChest = not toggle.AutoChest
			if toggle.AutoChest then
				Auto_Chest.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Auto_Chest.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Auto_Ore.MouseButton1Click:connect(function()
			toggle.AutoOre = not toggle.AutoOre
			if toggle.AutoOre then
				Auto_Ore.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Auto_Ore.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Auto_Rebirth.MouseButton1Click:connect(function()
			toggle.AutoRebirth = not toggle.AutoRebirth
			if toggle.AutoRebirth then
				Auto_Rebirth.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Auto_Rebirth.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Auto_Sell.MouseButton1Click:connect(function()
			toggle.AutoSell = not toggle.AutoSell
			if toggle.AutoSell then
				Auto_Sell.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Auto_Sell.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Buy_Crates_Pets.MouseButton1Click:connect(function()
			toggle.BuyCratesPets = not toggle.BuyCratesPets
			if toggle.BuyCratesPets then
				Buy_Crates_Pets.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Buy_Crates_Pets.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Tools_Rainbow.MouseButton1Click:connect(function()
			toggle.ToolsRainbow = not toggle.ToolsRainbow
			if toggle.ToolsRainbow then
				Tools_Rainbow.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Tools_Rainbow.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Open_Crates.MouseButton1Click:connect(function()
			toggle.OpenCrates = not toggle.OpenCrates
			if toggle.OpenCrates then
				Open_Crates.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Open_Crates.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Auto_Equip_Eggs.MouseButton1Click:connect(function()
			toggle.AutoEquipEggs = not toggle.AutoEquipEggs
			if toggle.AutoEquipEggs then
				Auto_Equip_Eggs.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Auto_Equip_Eggs.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Collapse.MouseButton1Click:connect(function()
			toggle.Collapsed = not toggle.Collapsed
			if toggle.Collapsed then
				Collapse.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Collapse.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Transparency.MouseButton1Click:connect(function()
			toggle.Transparencyd = not toggle.Transparencyd
			if toggle.Transparencyd then
				Transparency.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				Transparency.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		ESP_Ores.MouseButton1Click:connect(function()
			toggle.ESPOres = not toggle.ESPOres
			if toggle.ESPOres then
				ESP_Ores.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
			else
				ESP_Ores.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		Settings.MouseButton1Click:connect(function()
			Settings_2.Visible = not Settings_2.Visible
			Teleports.Visible = false
			if Settings_2.Visible then
				Settings.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
				Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			else
				Settings.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		MapLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=1
		end)
		SpaceLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=2
		end)
		CandyLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=3
		end)
		FoodLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=4
		end)
		AltantisLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=5
		end)
		ToyLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=6
		end)
		DinoLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=7
		end)
		BeachLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=8
		end)
		CrystalLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=9
		end)
		ForestLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=10
		end)
		LavaLength.MouseButton1Click:connect(function()
			Teleports.Visible=false
			Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			toggle.ValueMap=11
		end)
		Teleport.MouseButton1Click:connect(function()
			Teleports.Visible = not Teleports.Visible
			Settings_2.Visible = false
			if Teleports.Visible then
				Teleport.BackgroundColor3 = Color3.new(0/255,171/255,11/255)
				Settings.BackgroundColor3 = Color3.new(1, 1, 1)
			else
				Teleport.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
		TracersLength.MouseButton1Click:connect(function()
			toggle.Tracers = not toggle.Tracers
			if toggle.Tracers then
				TracersLength.Text="true"
			else
				TracersLength.Text="false"
			end
		end)
		BaseColorLength.MouseButton1Click:connect(function()
			toggle.BaseColor = not toggle.BaseColor
			if toggle.BaseColor then
				BaseColorLength.Text="true"
			else
				BaseColorLength.Text="false"
			end
		end)

		coroutine.resume(coroutine.create(function()
			while true and wait() do
				toggle.CurrentPosition=CurrentPosition
				toggle.Instant_Mine=Instant_Mine
				toggle.Nuke_Aura=Nuke_Aura
				toggle.Auto_Rebirth=Auto_Rebirth
				toggle.Auto_Ore=Auto_Ore
				toggle.Auto_Chest=Auto_Chest
				toggle.ESP_Ores=ESP_Ores
				toggle.Transparency=Transparency
				toggle.Auto_Sell=Auto_Sell
				toggle.Collapse=Collapse
				toggle.Buy_Crates_Pets=Buy_Crates_Pets
				toggle.Auto_Equip_Eggs=Auto_Equip_Eggs
				toggle.Open_Crates=Open_Crates
				toggle.Tools_Rainbow=Tools_Rainbow
				toggle.Auto_Rebirt=Auto_Rebirth
				toggle.BrackpackLength=BrackpackLength.Text
				toggle.TransparencyLength=TransparencyLength.Text
				toggle.PetLength=PetLength.Text
			end
		end))
	end
end

do-- Script
	r:BindToRenderStep("HAX", 0, function()
		local tor = c:FindFirstChild("HumanoidRootPart")
		if tor and toggle.CurrentPosition then
			local pos=tor.Position;local x=pos.x;local y=pos.y;local z=pos.z;
			toggle.CurrentPosition.Text=("X: "..string.format("%.3f",x)..", Y: "..string.format("%.3f",y)..", Z: "..string.format("%.3f",z))
		end

		if toggle.InstantMine and toggle.Instant_Mine and BackpackFull() then
			local Bar=pg:FindFirstChild('Progress', true)
			if Bar.Size.X.Scale>0 then
				network:FireServer("MineBlock",{{Mouse.Target.Parent}})
			end
		end

		if toggle.Collapse and toggle.Collapsed then
			local guia=pg:FindFirstChild('Collapse',true)
			if guia.Visible~=true then guia.Visible=true end
			guia.Amount.Text=math.floor(guia.Progress.Size.X.Scale*100)..'%'
		end
		
		if toggle.Buy_Crates_Pets and toggle.BuyCratesPets then
			if string.find(toggle.PetLength, "Egg") then
				network:FireServer("BuyPet",{{toggle.PetLength,1}})
			else
				network:FireServer("OpenCrate",{{toggle.PetLength,1}})
			end			
		end

		if toggle.Open_Crates and toggle.OpenCrates then
			AutoOpen()
		end
	
		if (toggle.AutoEquipEggs and toggle.Auto_Equip_Eggs) and EquipEggs() then
			EquipEgg()
		end

		if toggle.AutoRebirth and toggle.Auto_Rebirth then
			local s=string.gsub(ls.Coins.Value, ",", "")
			if tonumber(s) >= 10000000+(ls.Rebirths.Value*10000000) then
				network:FireServer("Rebirth",{{}})
			end
		end

		if toggle.Tools_Rainbow and toggle.ToolsRainbow then
			if toggle.toolsValue > 1 then
				toggle.toolsValue=0
			end
			toggle.toolsValue=toggle.toolsValue+0.0005
			for i,_ in pairs(c.HumanoidRootPart.Parent:GetChildren()) do
				for i,_ in pairs(_:GetDescendants()) do
					if _:IsA'MeshPart' then
						_.Color=Color3.fromHSV(toggle.toolsValue, 1, 1)
						_.Material=Enum.Material.Neon
					end
				end;
			end;
		end

		if CurMap~=nil and toggle.ValueMap~=toggle.ValueMapConfirm then
			local map=listmaps[toggle.ValueMap]
			if tostring(CurMap)~=map[1] then
				CurMap.Parent = nil
				Maps[map[1]].Parent = workspace
				CurMap = Maps[map[1]]
				network:FireServer("MoveTo",{{map[2]}})
				toggle.ValueMapConfirm=toggle.ValueMap
			end
		end
	end)

	coroutine.resume(coroutine.create(function()
		while true do
			if (toggle.AutoSell and toggle.Auto_Sell) and not BackpackFull() then
				repeat wait(1);
					Client.teleportToSell()
					wait(1/10)
					network:FireServer("SellItems",{{}})
				until Client.inventoryContents() <= 0
			end
			
			if toggle.Transparency and toggle.Transparencyd then
				for i,_ in pairs(ws.Blocks:GetChildren()) do
					if _.Name=='Grass' then
						for i,_ in pairs(_.RootModel:GetChildren()) do
							_.Transparency=toggle.TransparencyLength
						end
					end
					if _.Name~='Grass' and not filter(_.Name) then
						_.PrimaryPart.Transparency=toggle.TransparencyLength
					end
				end
			end
			
			if (toggle.ESP_Ores and toggle.ESPOres) or (toggle.NukeAura and toggle.Nuke_Aura) then
				if string.sub(Depthg.Text,0,1) ~= "0" then
					for _,i in pairs(ws.Blocks:GetChildren()) do
						if i.Name~="Rock Bottom" then
							if (i.PrimaryPart.Position-c.HumanoidRootPart.Position).magnitude <= 20 and wait(1/10) and (toggle.NukeAura and toggle.Nuke_Aura) and BackpackFull() then
								if (toggle.Auto_Chest and toggle.AutoChest) and string.find(i.Name, "Chest") then
									network:FireServer("MineBlock", {{i}})
								end
								if filter(i.Name) and (toggle.AutoOre and toggle.Auto_Ore) and not string.find(i.Name, "Chest") then
									network:FireServer("MineBlock", {{i}})
								end
								if not ((toggle.Auto_Chest and toggle.AutoChest) or (toggle.AutoOre and toggle.Auto_Ore)) then
									network:FireServer("MineBlock", {{i}})
								end
							end--
							if (i.PrimaryPart.Position-c.HumanoidRootPart.Position).magnitude <= 150 then
								if filter(i.Name) and (toggle.ESPOres and toggle.ESP_Ores) then
									espOres(i)
								end
							end
						end
					end
				end
			end
			r.RenderStepped:wait()
		end
	end))
end
Init()
GetMaps()
GetNetwork()
Chat("Made by: Jeff Senpai SenAmigos#6768", true)
Chat("Discord: discord.gg/z4xBAwu", true)