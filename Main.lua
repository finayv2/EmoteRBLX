local Emotes, EmoteChoices = loadstring(game:HttpGet('https://raw.githubusercontent.com/finayv2/EmoteRBLX/main/Emotes.lua'))();
local EquippedEmotes = {"Godlike", "Top Rock", "Quiet Waves", "Side to Side", "Line Dance", "Shuffle", "Hero Landing", "Monkey"}

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


if isfolder("Emote-System") then
    local AutoLoad = readfile("Emote-System/AutoLoad.txt")
    print(AutoLoad)
    if AutoLoad == "true" then
        CreateMessage("Autoloaded saved emotes!", "Success")
        EquippedEmotes = game:service'HttpService':JSONDecode(readfile("Emote-System/EmoteSave.txt"))
    end
end

repeat wait() until game:IsLoaded()
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

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


            for i,v in pairs(EquippedEmotes) do
                if i == tonumber(args[3]) then
                    EquippedEmotes[i] = goodtext
                    game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEquippedEmotes(EquippedEmotes)
                    CreateMessage("Changed ".. args[3] .." To '"..goodtext.."'!", "Success")
                end
            end
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
        if not args[3] == "false" and args[3] == "true" then
            CreateMessage("Please enter 'true' or 'false' for AutoLoad!", "Info")
            return
        end

        writefile("Emote-System/AutoLoad.txt", args[3])
        CreateMessage("Set AutoLoad to ".. args[3] .."!", "Success")
    end
}


game.Players.LocalPlayer.Chatted:Connect(function(msg)
    local args = string.split(msg, " ")
    if args[1] == "/e" then
        Commands[string.lower(args[2])](args, msg)
    end
end)
