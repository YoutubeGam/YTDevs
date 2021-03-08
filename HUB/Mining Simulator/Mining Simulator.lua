-- Hi, you came looking at the script, feel free to see and modify it. :)
-- Do you like coffee? I wanted so badly but coffee.
if getgenv().MiningSimulator then return;end;getgenv().MiningSimulator=true
local getnil=get_nil_instances or getnilinstances;if getnil==nil then local Message=Instance.new("Hint",game:GetService'CoreGui')Message.Text="Your exploit does not support. :("wait(5)Message:Destroy()return;end
if PROTOSMASHER_LOADED==true then
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/YoutubeGam/YTDevs/master/HUB/Mining%20Simulator/Mining%20Simulator%20-%20ProtoSmasher.lua"))()
else
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/YoutubeGam/YTDevs/master/HUB/Mining%20Simulator/Mining%20Simulator%20-%20Synapse.lua"))()
end