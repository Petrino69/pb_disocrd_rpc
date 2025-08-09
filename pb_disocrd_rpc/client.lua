local function sanitize(str)
    if type(str) ~= 'string' then return '' end
    return (str:gsub('[%c]', '')):sub(1, 128)
end

local function clampButtons(btns)
    local out, count = {}, 0
    if type(btns) ~= 'table' then return out end
    for _, b in ipairs(btns) do
        if type(b) == 'table' and b.label and b.url and b.label ~= '' and b.url ~= '' then
            count = count + 1
            out[count] = { label = sanitize(b.label), url = b.url }
            if count == 2 then break end
        end
    end
    return out
end

local function validateConfig(cfg)
    if not cfg or type(cfg) ~= 'table' then return false, 'Chybí Config.' end
    if not cfg.appId or cfg.appId == '' then return false, 'Chybí Config.appId (string).' end
    if type(cfg.appId) ~= 'string' then return false, 'Config.appId musí být string (uvozovky).' end
    if not cfg.assets or not cfg.assets.large or not cfg.assets.small then
        return false, 'Chybí Config.assets (large/small).'
    end
    if not cfg.updateInterval or cfg.updateInterval < 5 then
        cfg.updateInterval = 15
    end
    cfg.buttons = clampButtons(cfg.buttons)
    return true
end

local initialized = false

local function applyStatic()
    SetDiscordAppId(Config.appId) 
    SetDiscordRichPresenceAsset(sanitize(Config.assets.large.name))
    SetDiscordRichPresenceAssetText(sanitize(Config.assets.large.text or ''))

    SetDiscordRichPresenceAssetSmall(sanitize(Config.assets.small.name))
    SetDiscordRichPresenceAssetSmallText(sanitize(Config.assets.small.text or ''))
end

local function applyButtons()

    for i = 1, 2 do

        SetDiscordRichPresenceAction(i - 1, '', '')
    end
    for i, b in ipairs(Config.buttons) do
        SetDiscordRichPresenceAction(i - 1, b.label, b.url)
    end
end

local function buildPresenceString()
    local parts = {}
    if Config.serverName and Config.serverName ~= '' then
        parts[#parts+1] = ('🏷️ %s'):format(sanitize(Config.serverName))
    end
    if Config.showPlayerName then
        local name = GetPlayerName(PlayerId()) or 'Hráč'
        parts[#parts+1] = ('👤 %s'):format(sanitize(name))
    end
    if Config.showServerId then
        local sid = GetPlayerServerId(PlayerId()) or 0
        parts[#parts+1] = ('ID %d'):format(sid)
    end
    local pCount = #GetActivePlayers()
    if Config.maxPlayers and tonumber(Config.maxPlayers) then
        parts[#parts+1] = ('🧑‍🤝‍🧑 %d/%d'):format(pCount, Config.maxPlayers)
    else
        parts[#parts+1] = ('🧑‍🤝‍🧑 %d'):format(pCount)
    end
    return table.concat(parts, ' | ')
end

local function updatePresence()
    if not initialized then return end
    SetRichPresence(buildPresenceString())
    applyButtons()
end

local function initDiscord()
    if initialized then return end
    local ok, err = validateConfig(Config)
    if not ok then
        print(('[RichPresence] ⚠️ %s'):format(err))
        return
    end
    applyStatic()
    initialized = true
    print('[RichPresence] ✅ Inicializováno.')
end

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    CreateThread(function()
        initDiscord()
        if not initialized then return end
        updatePresence()
        while true do
            Wait((Config.updateInterval or 30) * 1000)
            updatePresence()
        end
    end)
end)

AddEventHandler('onClientResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    SetRichPresence('')
    initialized = false
end)

RegisterCommand('rp_refresh', function()
    if not initialized then initDiscord() end
    updatePresence()
    print('[RichPresence] 🔄 Ruční refresh proveden.')
end, true) 

RegisterCommand('rp_debug', function()
    print(('[RichPresence] init=%s, appId="%s"'):format(tostring(initialized), tostring(Config.appId)))
    print(('[RichPresence] buttons=%d'):format(#(Config.buttons or {})))
end, true) 
