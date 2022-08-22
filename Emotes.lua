

local cursor = ''
local emotesTable = {}

local HttpService = game:GetService("HttpService")
local HttpGet = game.HttpGet
local JSONDecode = HttpService.JSONDecode
local tableinsert = table.insert
local stringformat = string.format

local response;
local requestString;

function thingy()

    
    requestString = stringformat('https://catalog.roblox.com/v1/search/items/details?Category=%s&Subcategory=%s&IncludeNotForSale=true&Limit=30&Cursor=%s',
        JSONDecode(HttpService, HttpGet(game, 'https://catalog.roblox.com/v1/categories')).AvatarAnimations, JSONDecode(HttpService, HttpGet(game, 'https://catalog.roblox.com/v1/subcategories')).EmoteAnimations, cursor
    )
    
    --requestString = ('https://catalog.roblox.com/v1/search/items/details?Category=%s&Subcategory=%s&IncludeNotForSale=true&Limit=30&Cursor=%s'):format(
        --JSONDecode(HttpService, HttpGet(game, 'https://catalog.roblox.com/v1/categories')).AvatarAnimations, JSONDecode(HttpService, HttpGet(game, 'https://catalog.roblox.com/v1/subcategories')).EmoteAnimations, cursor
    --)

    response = JSONDecode(HttpService,HttpGet(game, requestString))
    cursor = response.nextPageCursor

    for _, data in ipairs(response.data) do
        emotesTable[#emotesTable + 1] = {data.name, data.id}
        _, data = nil;
    end



    if cursor then
        thingy()
    end
end

thingy()


table.sort(emotesTable, function(a, b)
    return a[1] < b[1]
end)

local ReturnedWrong;
function FixString(text)
    local Converted = string.split(text, "-")[1]
    if Converted then
        text = string.split(text, "-")[1]
    end
    Converted = string.sub(text,string.len(text))
    if Converted == " " then
        text = text:sub(1, #text - 1)
        ReturnedWrong = FixString(text)
    else
        return text
    end
end

local RobloxEmotes = {}
local EmoteChoices = {}
local RealNames = {}

for _, emote in ipairs(emotesTable) do
    
    if FixString(emote[1]) == nil then
        RobloxEmotes[ReturnedWrong] = {emote[2]}
        table.insert(EmoteChoices, ReturnedWrong)
    else
        RobloxEmotes[FixString(emote[1])] = {emote[2]}
        table.insert(EmoteChoices, FixString(emote[1]))
    end
    
    RealNames[emote[1]] = {emote[2]}
end

return RobloxEmotes, EmoteChoices, RealNames
