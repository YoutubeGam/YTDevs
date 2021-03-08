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

local toggle={};
local Mouse=p:GetMouse()

local Client=getsenv(p.PlayerScripts.Client)
do--function
	Client["CCheck"]=function()return;end

	local env=getsenv(game:GetService("Players")["LocalPlayer"]["PlayerScripts"]["Client"])
	local OriginalWeps = {}
	for i, v in pairs(game.ReplicatedStorage.Modules["Weapon Modules"]:GetChildren()) do
		local Module = require(v)
		if Module and Module.Stats.WeaponType == "Gun" then
			OriginalWeps[v.Name] = {
				Spread = 0,
				RPM = 6000,
				Mag = 400000,
				Pool = 800000,
				Damage = 200
			}
			Module.Stats.Damage = 200
			Module.Stats.RPM = 3000
			Module.Stats.Spread = 0
			Module.Stats.Pool = 800000
			Module.Stats.VerticleRecoil = 0
			Module.Stats.HorizontalRecoil = 0
			Module.Stats.RecoilShake = 0
			Module.Stats.MaxPen = 5
			Module.Animations.Reload["CurrentTime"] = 1
		end
	end

debug.setupvalue(env.Mouse1Down, "OriginalWeps", OriginalWeps)
end
local Window=Window:CreateWindow(math.random(0,13077824));
do --main
	function Init()
		--local Window=Window:CreateWindow'Those Who Remain';
		Window:Text'Weapon';
		Window:Toggle('Infinite Ammo',{location=toggle,part='Infinite_Ammo'})
		Window:Toggle('No Recoil',{location=toggle,part='No_Recoil'})
		Window:Toggle('Insta Kill',{location=toggle,part='Insta_Kill'})
		Window:Toggle('No Reload',{location=toggle,part='No_Reload'})
		Window:Section()
        Window:Text'Visual';
		Window:Toggle('Enabled (2d)',{location=toggle,part='Enabled_(2d)'})
		Window:Toggle('Lines',{location=toggle,part='Lines'})
		Window:Toggle('Chams',{location=toggle,part='Chams'})
		Window:Toggle('Info',{location=toggle,part='Info'})
        Window:Toggle('Custom Color',{location=toggle,part='Custom_Color'})
        Window:ColorPicker('Color',{location=toggle,part='espColor'})
        Window:Text'Misc'
        Window:Toggle('FullBright',{location=toggle,part='FullBright'})
        Window:Toggle('No Fog',{location=toggle,part='No_Fog'})
		return wait(1/10)
	end
end

do--script

end

Init()