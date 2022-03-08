# EmoteRBLX

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
      
  end
]]
