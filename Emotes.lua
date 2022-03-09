local cursor = ''
local emotesTable = {}

while true do
    local requestString = ('https://catalog.roblox.com/v1/search/items/details?Category=%s&Subcategory=%s&IncludeNotForSale=true&Limit=30&Cursor=%s'):format(
        game:GetService('HttpService'):JSONDecode(game:HttpGet('https://catalog.roblox.com/v1/categories')).AvatarAnimations, game:GetService('HttpService'):JSONDecode(game:HttpGet('https://catalog.roblox.com/v1/subcategories')).EmoteAnimations, cursor
    )
    local response = game:GetService('HttpService'):JSONDecode(game:HttpGet(requestString))
    cursor = response.nextPageCursor
    
    for _, data in ipairs(response.data) do
        table.insert(emotesTable, {
            data.name,
            data.id
        })
    end

    if not cursor then
        break
    end
end

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
