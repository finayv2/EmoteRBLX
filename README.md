# EmoteRBLX

```Lua
--[[
    Commands:
    /e help -- shows all emote names
    /e replace [slot] [emote name]
    /e autoload
    /e save -- saves equipped emotes
    /e load -- loads last save file
]]

example for /e replace 3 Tree
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
