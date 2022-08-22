# EmoteRBLX
tons of credit goes to https://v3rmillion.net/member.php?action=profile&uid=445047
```Lua
[[
            Animation Changer finay#1197

            Usage:

            /e replace [Number on Emotes Wheel] [Emote name]
            Ex: /e replace 3 Tree

            /e play [Emote name]
            Ex: /e replace Shrug

            /e save -- Saves your current emote wheel 

            /e load -- Loads your save

            /e help -- prints out all emotes

            /e autoload [boolen] (true or false) -- will auto load your save every time you reset

            /e refresh -- refreshes emote wheel
        ]]
```

Put main script in autoexe
```Lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/finayv2/EmoteRBLX/main/Main.lua'))();
```

API Emote
```Lua
local Emotes, EmoteChoices = loadstring(game:HttpGet('https://raw.githubusercontent.com/finayv2/EmoteRBLX/main/Emotes.lua'))();

for i,v in pairs(EmoteChoices) do
    print(v) -- // Prints the emote names
end

for i,v in pairs(Emotes) do
    --// 'i' prints emote name 
    --// 'v' prints another table including the anim ID
    
    print(i,unpack(v))
end

--[[
  example use
  
  game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEmotes(Emotes)
  
  for i,v in pairs(Emotes)
      print(unpack(v))
  end
]]

```
