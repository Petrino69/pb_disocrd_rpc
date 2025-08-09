Config = {
    -- ID aplikace z Discord Developer Portalu
    appId = '', -- <-- doplň své App ID (přiklad 1887242531582940812)

    serverName = '',  -- zobrazí se v presence
    -- Assety musí existovat u dané aplikace na Discordu
    -- assety se nastavují v Discord Developer Portalu v sekci Rich Presence
    assets = {
        large = { name = '', text = '' },
        small = { name = '',   text = '' }
    },

    -- Max 2 tlačítka (Discord limit)
    buttons = {
        { label = 'Připojit se', url = 'fivem://connect/chillside.example' },
        { label = 'Discord',     url = 'https://discord.gg/yourinvite' }
        -- cokoli dalšího se ignoruje (omezuje klient)
    },

    updateInterval = 30,   -- s, jak často aktualizovat dynamickou část (počet hráčů, apod.)
    showServerId   = true, -- zobrazovat server ID hráče
    showPlayerName = true, -- zobrazovat jméno hráče
    maxPlayers     = 64    -- volitelné; zobrazí „x/64“. Pokud nechceš, dej nil
}
