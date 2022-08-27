
repeat task.wait() until game:GetService("Players").LocalPlayer
if not game:GetService("StarterPlayer").UserEmotesEnabled then return end

local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Emotes, EmoteChoices, RealNames = loadstring(game:HttpGet('https://raw.githubusercontent.com/finayv2/EmoteRBLX/main/Emotes.lua'))();

local EquippedEmotes = {
    {Slot = 1, Name = ""},
    {Slot = 2, Name = ""},
    {Slot = 3, Name = ""},
    {Slot = 4, Name = ""},
    {Slot = 5, Name = ""},
    {Slot = 6, Name = ""},
    {Slot = 7, Name = ""},
    {Slot = 8, Name = ""},
}



local Message = {["Success"] = Color3.fromRGB(65,255,144); ["Info"] = Color3.fromRGB(226, 250, 6); ["Failed"] = Color3.fromRGB(255, 78, 65)}
function Message:Send(Text, Type)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Emote System]: "..Text;
        Font = Enum.Font.Cartoon;
        Color = Message[Type];
        FontSize = Enum.FontSize.Size96;	
    })
end

local Caches = {
    EmoteSettings = {};
}

local Autoload, SettingsE;
function Caches:CheckSettings()
    if Caches.EmoteSettings['Autoload'] then
        SettingsE = HttpService:JSONDecode(readfile("Emote-System/EmoteSave.txt")) or EquippedEmotes

        return Caches.EmoteSettings['Autoload'], SettingsE
    end

    if isfolder('Emote-System') then
        Autoload = readfile("Emote-System/AutoLoad.txt") or false
        SettingsE = HttpService:JSONDecode(readfile("Emote-System/EmoteSave.txt")) or EquippedEmotes

        EquippedEmotes = SettingsE

        Caches.EmoteSettings['Autoload'] = Autoload
        return Caches.EmoteSettings['Autoload'], SettingsE
    end
    return nil, nil
end

function Caches:ChangeEmote(Humanoid, Pos, Emoticon)
    if not Humanoid then return end
    if not Pos then return end
    if not Emoticon then return end

    for i,v in pairs(EquippedEmotes) do
        if v.Slot == tonumber(Pos) then
            EquippedEmotes[i].Name = Emoticon
        end
    end

    Humanoid:SetEmotes(Emotes)
    Humanoid:SetEquippedEmotes(EquippedEmotes)
end


function Caches:FindHumanoidDescription(Humanoid)
    if not Humanoid then return end

    local Success, Err = pcall(function()
        local Fake = Humanoid.HumanoidDescription
    end)

    if Err then return false end
        
    return Humanoid.HumanoidDescription 
end


local AutoLoad, SettingsEmotes, Humanoid, HumanoidDescription;
local function CharacterLoaded(Character)
    AutoLoad, SettingsEmotes = Caches:CheckSettings()

    Humanoid = Character:WaitForChild("Humanoid")

    if (Humanoid.RigType ~= Enum.HumanoidRigType.R6) then
        HumanoidDescription = Caches:FindHumanoidDescription(Humanoid)
        
        if Autoload and HumanoidDescription then
            EquippedEmotes = SettingsEmotes
            Message:Send("Autoloaded saved emotes!", "Success")
        else
            if HumanoidDescription then
                EquippedEmotes = HumanoidDescription:GetEquippedEmotes()
            end
        end
        
        if HumanoidDescription then
            for _,v in pairs(EquippedEmotes) do
                Caches:ChangeEmote(HumanoidDescription, v.Slot, v.Name)
                _,v = nil;
            end
        end
    end
end


local CorrectText;
local Commands = {
    ["replace"] = function(args, msg)
        msg:gsub('(%a*)%d(.*)', function(Text1, Text2)
            CorrectText = Text2:sub(2)

            if not table.find(EmoteChoices, CorrectText) then
                Message:Send("Failed to Find '".. CorrectText .."'!", "Failed")
                return
            end

            local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription
            Caches:ChangeEmote(Humanoid, args[3], CorrectText)

            Message:Send("Changed ".. args[3] .." To '"..CorrectText.."'!", "Success")
        end)
    end;

    ['play'] = function(args, msg)
        local Splited = string.split(msg, string.lower(args[2]))[2]
        local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
        local EmoteText = string.gsub(Splited, "^%s*", "")

        if not table.find(EmoteChoices, EmoteText) then
            Message:Send("Failed to Find '".. EmoteText .."'!", "Failed")
            return
        end

        Humanoid:PlayEmote(EmoteText)

        Message:Send("Played ".. EmoteText .."!", "Success")
    end;

    ["help"] = function()
        Message:Send("Check console (F9) for Emote Names! (or Syn Console)", "Info")
        warn([[
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
        ]])

        table.foreach(EmoteChoices, print)
    end;


    ["save"] = function()
        if isfolder("Emote-System") then
            writefile("Emote-System/EmoteSave.txt", HttpService:JSONEncode(EquippedEmotes))
        else
            makefolder("Emote-System")
            writefile("Emote-System/EmoteSave.txt", HttpService:JSONEncode(EquippedEmotes))
            writefile("Emote-System/AutoLoad.txt", "true")
        end

        Message:Send("Saved current equipped emotes!", "Success")
    end;

    ["load"] = function()
        EquippedEmotes = HttpService:JSONDecode(readfile("Emote-System/EmoteSave.txt"))
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").HumanoidDescription:SetEquippedEmotes(EquippedEmotes)

        Message:Send("Loaded last save!", "Success")
    end;

    ["autoload"] = function(args)

        writefile('Emote-System/AutoLoad.txt', tostring(args[3]))
        Message:Send("Set AutoLoad to "..args[3], "Success")
    end;

    ['refresh'] = function()
        CharacterLoaded(LocalPlayer.Character)

        Message:Send("Refreshed!", "Success")
    end
}

local ChatArgs, Command;
LocalPlayer.Chatted:Connect(function(Message)
    ChatArgs = string.split(Message, " ")

    if ChatArgs[1] == "/e" then
        Command = Commands[string.lower(ChatArgs[2])]
        
        if Command then
            Command(ChatArgs, Message)
        end
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


if LocalPlayer.Character then
    CharacterLoaded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(CharacterLoaded)
