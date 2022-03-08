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

local RobloxEmotes = {}
local EmoteChoices = {}
for _, emote in ipairs(emotesTable) do
    RobloxEmotes[string.split(emote[1], "-")[1]] = {emote[2]}
    table.insert(EmoteChoices, string.split(emote[1], "-")[1])
end

return RobloxEmotes, EmoteChoices
