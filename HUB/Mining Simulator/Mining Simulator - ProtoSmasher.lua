--[[ TODO:
+ Get Coffee
]]
local s=setmetatable({},{__index=function(s,i) return game:service(i) end});
local Window=loadstring(game:HttpGet("https://pastebin.com/raw/7dwwSvap",true))();

local p=s.Players.LocalPlayer
local rs=s.ReplicatedStorage
local g=s.GuiService:GetGuiInset();
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
local toggle={toolsValue=0};
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
		for i, v in next, get_nil_instances() do
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

	function transparencyOres(t,o)
		for i,_ in pairs(ws.Blocks:GetChildren()) do
			if _.Name=='Grass' then
				for i,_ in pairs(_.RootModel:GetChildren()) do
					_.Transparency=t
				end
			end
			if _.Name~='Grass' then
				if not filter(_.Name) then
					_.PrimaryPart.Transparency=t
				end
				if filter(_.Name) and o~=false  then
					_.PrimaryPart.Transparency=t
					for i, _ in next, _:GetDescendants() do
						if _:IsA'MeshPart' then
							_.Transparency=t
						end
					end
				elseif filter(_.Name) then
					_.PrimaryPart.Transparency=0
					for i, _ in next, _:GetDescendants() do
						if _:IsA'MeshPart' then
							_.Transparency=0
						end
					end
				end
			end
		end
	end

	p.CharacterAdded:connect(function(char)
		c=char
	end)

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

	function hasMax(getMax)
		local display=c:FindFirstChild('Amount', true)
		local a,b=display.Text:match('(%d+)/(%d+)');
		if b==nil then a,b = display.Text:match('(%d+)/(%a+)');end
		if tonumber(toggle.Coffe)~=nil then
			if  tonumber(b)>=tonumber(toggle.Coffe)then b=toggle.Coffe;else b=b;end
		end
		return getMax and b or (a == b);
	end

	function backpackIsFull(leasure)
		local display = c:FindFirstChild('Amount', true)
		if not display then return false end 
		a,b = display.Text:match('(%d+)/(%d+)');
		if b==nil then a,b = display.Text:match('(%d+)/(%a+)'); end
		if tonumber(toggle.Coffe)~=nil then
			if  tonumber(b)>=tonumber(toggle.Coffe)then b=toggle.Coffe;else b=b;end
		end
		return (a == b) or (tonumber(a) > tonumber(b)-(leasure or 0));
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
		if toggle.espBase~=false then
			return Ore.PrimaryPart.Color
		else
			return toggle.espColor
		end
	end
	
	function espOres(Ore)
		if Ore:FindFirstChild(Ore.Name) then return end
		local textDrawing=Drawing.new("Text")
		textDrawing.Text=Ore.Name
		textDrawing.Color=WTC(Ore)
		textDrawing.Position=WTS(Ore)
		textDrawing.Size=toggle.espSize
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
				local enabled=(toggle.espEnabled and (Ore.PrimaryPart.Position-c.HumanoidRootPart.Position).magnitude <= toggle.espDistance)
				if destroyed and textDrawing~=nil and lineDrawing~=nil then
					textDrawing:Remove()
					lineDrawing:Remove()
				end
				if Ore~=nil then
					textDrawing.Position=WTS(Ore)
					textDrawing.Size=toggle.espSize
					textDrawing.Color=WTC(Ore)
					textDrawing.Visible=enabled

					lineDrawing.Visible=(enabled and toggle.espLines)
					lineDrawing.To=WTL(Ore)
					lineDrawing.Color=WTC(Ore)
				end
				local _, screen = ca:WorldToViewportPoint(Ore.PrimaryPart.Position)
				if screen then
					textDrawing.Visible=enabled
					lineDrawing.Visible=(enabled and toggle.espLines)
				else
					textDrawing.Visible=false
					lineDrawing.Visible=false
				end
			end)
		end)
	end

	function GetNetwork()
		for i,v in pairs(getgc()) do
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
do --Main
	function Init()
		local Window=Window:CreateWindow'Mining Simulator';
		Window:Text'Auto Stuff';
		Window:Box('Amount',{location=toggle,part='Coffe'})
		Window:Toggle('Self Sell (Incomplete)',{location=toggle,part='Sell'})
		Window:Toggle('Auto Rebirth (Incomplete)',{location=toggle,part='Rebirth'})
		Window:Toggle('Instance Mine',{location=toggle,part='mine'})
		Window:Text'Nuke';
		Window:Toggle('Nuke Aura',{location=toggle,part='Nuke'})
		Window:Toggle('Auto Chest',{location=toggle,part='Chest'})
		Window:Toggle('Auto Ore',{location=toggle,part='Ore'})
		Window:Section()
		Window:Text'Teleport';
		Window:Dropdown('World',{location=toggle,part='maps',list={'Map','Space','Candy','Toy','Food','Dino','Altantis','Beach','Crystal','Forest','Lava'}})
		Window:Section()
		Window:Text'Visual';
		Window:Toggle('Enabled',{location=toggle,part='transac'})
		Window:Toggle('make ores invisible',{location=toggle,part='maorin'})
		Window:Slider('Transparency',{location=toggle,part='trasn',precise=true, default=0, min=0, max=1});
		Window:Toggle('FullBright',{location=toggle,part='full'})
		Window:Text'ESP';
		Window:Toggle('Enabled Ores',{location=toggle,part='espEnabled'})
		Window:Toggle('Base Color',{location=toggle,part='espBase'})
		Window:Toggle('Tracer Lines',{location=toggle,part='espLines'})
		Window:ColorPicker('Color',{location=toggle,part='espColor'})
		Window:Slider('Text Size', {location=toggle, part='espSize', precise=false, default=15, min=12, max=20});
		Window:Slider('Distance', {location=toggle, part='espDistance', precise=false, default=100, min=50, max=500});
		Window:Section()
		Window:Text'Misc';
		Window:Box('Crate/Pets',{location=toggle,part='Coffee'})
		Window:Slider('Value', {location=toggle, part='AmountBuys', precise=false, default=1, min=1, max=100});
		Window:Toggle('Buy Crates/Pets',{location=toggle,part='selore'})
		Window:Toggle('Open Crates',{location=toggle,part='seloe'})
		Window:Toggle('Auto Equip Eggs',{location=toggle,part='elore'})
		Window:Toggle('Collapse',{location=toggle,part='selapse'})
		Window:Toggle('Tools Rainbow',{location=toggle,part='selfore'})
		return wait(1/10)
	end
end
do--Script
	r.Stepped:Connect(function()

		if toggle.mine and not backpackIsFull() then
			local Bar=pg:FindFirstChild('Progress', true)
			if Bar.Size.X.Scale>0 then
				network:FireServer("MineBlock",{{Mouse.Target.Parent}})
			end
		end

		if toggle.selfore then
			if toggle.toolsValue>1 then
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

		if toggle.Rebirth then
			local s=string.gsub(ls.Coins.Value, ",", "")
			if tonumber(s) >= 10000000+(ls.Rebirths.Value*10000000) then
				network:FireServer("Rebirth",{{}})
			end
		end

		if CurMap~=nil then
			local map=listmaps[toggle.maps]
			if tostring(CurMap)~=map[1] then
				CurMap.Parent = nil
				Maps[map[1]].Parent = workspace
				CurMap = Maps[map[1]]
				network:FireServer("MoveTo",{{map[2]}})
			end
		end

		if toggle.selapse then
			local guia=pg:FindFirstChild('Collapse',true)
			if guia.Visible~=true then guia.Visible=true end
			guia.Amount.Text=math.floor(guia.Progress.Size.X.Scale*100)..'%'
		end
		if toggle.selore then
			if string.find(toggle.Coffee, "Egg") then
				network:FireServer("BuyPet",{{toggle.Coffee,toggle.AmountBuys}})
			else
				network:FireServer("OpenCrate",{{toggle.Coffee,toggle.AmountBuys}})
			end			
		end
		if toggle.seloe then
			AutoOpen()
		end

		if toggle.elore and EquipEggs() then
			EquipEgg()
		end
		
		if toggle.full then
			l.Brightness=1
			l.ClockTime=12
			l.FogEnd=786543
			l.GlobalShadows=false
			l.Ambient=Color3.fromRGB(178, 178, 178)
		else
			l.Brightness=0
			l.FogEnd=300
			l.GlobalShadows=true
			l.Ambient=Color3.fromRGB(0,0,0)
		end
	end)
	coroutine.resume(coroutine.create(function()
		while true do
			if toggle.Sell and backpackIsFull(tonumber(hasMax(true))/10) then
				repeat wait(1);
					Client.teleportToSell()
					wait(1/10)
					network:FireServer("SellItems",{{}})
				until Client.inventoryContents() <= 0
			end
			if toggle.transac then
				wait()--decreases fps, maybe I released another update that removes the drop in fps, with no promise
				transparencyOres(toggle.trasn,toggle.maorin)
			end
			if toggle.Nuke or toggle.espEnabled then
				if string.sub(Depthg.Text,0,1)~="0" then
					for _,i in pairs(ws.Blocks:GetChildren()) do
						if i.Name~="Rock Bottom" then
							if (i.PrimaryPart.Position-c.HumanoidRootPart.Position).magnitude <= 20 and wait(1/10) and toggle.Nuke and not backpackIsFull() then
								if toggle.Chest and string.find(i.Name, "Chest") then
									network:FireServer("MineBlock", {{i}})
								end
								if filter(i.Name) and toggle.Ore and not string.find(i.Name, "Chest") then
									network:FireServer("MineBlock", {{i}})
								end
								if not (toggle.Chest or toggle.Ore) then
									network:FireServer("MineBlock", {{i}})
								end
							end
							if (i.PrimaryPart.Position-c.HumanoidRootPart.Position).magnitude <= toggle.espDistance then
								if filter(i.Name) and toggle.espEnabled then
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