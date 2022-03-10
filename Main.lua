local Emotes, EmoteChoices, RealNames = loadstring(game:HttpGet('https://raw.githubusercontent.com/finayv2/EmoteRBLX/main/Emotes.lua'))();
--local EquippedEmotes = {"Godlike", "Top Rock", "Quiet Waves", "Side to Side", "Line Dance", "Shuffle", "Hero Landing", "Monkey"}
local EquippedEmotes = {nil, nil, nil, nil, nil, nil, nil, nil}

game.Loaded:Wait()

function CreateMessage(Text, Type)
    local Colour = {
        ["Success"] = Color3.fromRGB(65,255,144);
        ["Info"] = Color3.fromRGB(226, 250, 6);
        ["Failed"] = Color3.fromRGB(255, 78, 65);
    }

    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Emote System]: "..Text;
        Font = Enum.Font.Cartoon;
        Color = Colour[Type];
        FontSize = Enum.FontSize.Size96;	
    })
end


game.Players.LocalPlayer.CharacterAdded:Connect(function()
    repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

    if isfolder("Emote-System") then
        local AutoLoad = readfile("Emote-System/AutoLoad.txt")
        if AutoLoad == "true" then
            CreateMessage("Autoloaded saved emotes!", "Success")
            EquippedEmotes = game:service'HttpService':JSONDecode(readfile("Emote-System/EmoteSave.txt"))
            return
        end
        
        for _, t in pairs(game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:GetEquippedEmotes()) do
            table.insert(EquippedEmotes, t.Name)
        end
    
    else
        for _, t in pairs(game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:GetEquippedEmotes()) do
            table.insert(EquippedEmotes, t.Name)
        end
    end

    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").HumanoidDescription then
        repeat wait() until typeof(Emotes) == "table"

        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEmotes(Emotes)
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEquippedEmotes(EquippedEmotes)
    end
end)

local Commands = {
    ["replace"] = function(args, msg)
        msg:gsub('(%a*)%d(.*)', function(dnc, Arg4)
            local goodtext = Arg4:sub(2)
            --goodtext = string.gsub(" "..Arg4, "%W%l", string.upper):sub(2)

            if not table.find(EmoteChoices, goodtext) then
                CreateMessage("Failed to Find '".. goodtext .."'!", "Failed")
                return
            end


            EquippedEmotes[tonumber(args[3])] = goodtext

            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEmotes(Emotes)
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEquippedEmotes(EquippedEmotes)
            CreateMessage("Changed ".. args[3] .." To '"..goodtext.."'!", "Success")
        end)
    end;

    ["help"] = function()
        CreateMessage("Check console (F9) for Emote Names!", "Info")
        table.foreach(EmoteChoices, print)
    end;

    ["save"] = function()
        if isfolder("Emote-System") then
            writefile("Emote-System/EmoteSave.txt", game:service'HttpService':JSONEncode(EquippedEmotes))
        else
            makefolder("Emote-System")
            writefile("Emote-System/EmoteSave.txt", game:service'HttpService':JSONEncode(EquippedEmotes))
            writefile("Emote-System/AutoLoad.txt", "true")
        end

        CreateMessage("Saved current equipped emotes!", "Success")
    end;

    ["load"] = function()
        EquippedEmotes = game:service'HttpService':JSONDecode(readfile("Emote-System/EmoteSave.txt"))
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEquippedEmotes(EquippedEmotes)
        CreateMessage("Loaded last save!", "Success")
    end;

    ["autoload"] = function(args)

        if readfile("Emote-System/AutoLoad.txt") == "true" then
            writefile("Emote-System/AutoLoad.txt", "false")
            CreateMessage("Set AutoLoad to False!", "Success")
        else
            writefile("Emote-System/AutoLoad.txt", "true")
            CreateMessage("Set AutoLoad to True!", "Success")
        end
    end
}


game.Players.LocalPlayer.Chatted:Connect(function(msg)
    local args = string.split(msg, " ")
    if args[1] == "/e" then
        Commands[string.lower(args[2])](args, msg)
    end
end)


-- // credit to kiriot 
local m = getmetatable(require(game:GetService("Chat"):WaitForChild("ClientChatModules"):WaitForChild("CommandModules"):WaitForChild("Util")))
old = hookfunction(m.SendSystemMessageToSelf, function(self, msg, ...)
    if msg == "You can't use that Emote." then
		return
	end
	return old(self, msg, ...)
end)
