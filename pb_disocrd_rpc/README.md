# pb_disocrd_rpc – Discord Rich Presence

Lehký a stabilní **Discord Rich Presence** pro FiveM s podporou tlačítek, emoji a ACE oprávnění pro admin příkazy.

## Funkce
- Čistý a čitelný Rich Presence: jméno hráče, server ID, počet hráčů, volitelný název serveru.
- Tlačítka  – např. **Připojit se** a **Discord**.
- Bezpečné volání Discord API (inicializace jen jednou, průběžný update).
- Admin-only příkazy přes ACE (`/rp_refresh`, `/rp_debug`).

---

## Instalace
1. Vlož složku resource do `resources/` a v `server.cfg` přidej:
   ```cfg
   ensure pb_disocrd_rpc
   ```

2. V souboru **`config.lua`** nastav:
   ```lua
   Config = {
       appId = '1887242531582940812', -- tvoje Discord Application ID (JAKO STRING)
       serverName = 'test_rp',

       assets = {
           large = { name = 'test_rp', text = 'test_rp' },
           small = { name = 'icon_small',   text = 'FiveM' }
       },

       buttons = {
           { label = 'Připojit se', url = 'https://cfx.re/join/TVUJ_KOD' },
           { label = 'Discord',     url = 'https://discord.gg/TVUJEPOZVANKA' }
       },

       updateInterval = 30,
       showServerId   = true,
       showPlayerName = true,
       maxPlayers     = 64
   }
   ```

---

## DŮLEŽITÉ: Discord **App ID** a **Assety**
### 1) App ID (Application ID)
- Vezmi z **Discord Developer Portalu** (Applications → tvoje aplikace → *Application ID*).
- **Musí být STRING** (uveď do uvozovek):  
  ```lua
  Config.appId = '1887242531582940812'  -- ✅ správně
  -- Config.appId = 1887242531582940812  -- ❌ špatně (ztráta přesnosti => RP se nespustí)
  ```

### 2) Assety (obrázky)
- V Developer Portalu → *Rich Presence* → *Art Assets* **nahraj** obrázky a pojmenuj je **přesně** jako v `config.lua`:
  - `assets.large.name` → např. `test_rp` (typicky 512×512)
  - `assets.small.name` → např. `icon_small` (např. 128×128)
- `text` je tooltip po najetí myší (volitelné).

> **Pozn.:** Změny assetů se na Discordu můžou projevit se zpožděním (někdy několik minut).

---

## Tlačítka – pravidla a tipy
- Discord zobrazuje **max 2 tlačítka**.
- **URL musí být `https://`** (ne `fivem://`). Pro připojení k serveru použij **cfx.re join link**:  
  `https://cfx.re/join/TVUJ_KOD`
- Tlačítka často **neuvidíš na svém vlastním profilu** – uvidí je **ostatní** (desktop Discord).  
- Na mobilu se tlačítka běžně **nezobrazují**.

### Rychlý test tlačítek
Ve hře (chat/F8) spusť:
```
/rp_testbuttons
```
Skript dočasně nastaví validní https tlačítka. Zkontroluj z jiného účtu na desktopu.

---

## Oprávnění (ACE) – jen pro adminy
Příkazy jsou registrované jako **restricted** a povolíme je jen `group.admin`.

V `server.cfg` přidej (a případně nastav svou license/steam identitu do `group.admin`):
```cfg
# add_principal identifier.license:TVOJE_LICENSE group.admin

add_ace group.admin command.rp_refresh allow
add_ace group.admin command.rp_debug allow
```

Použitelné příkazy (pro adminy):
- `/rp_refresh` – okamžitý refresh údajů.
- `/rp_debug` – vypíše stav (init, App ID, počet tlačítek).

---

## Nejčastější problémy (Troubleshooting)
- **Nic se nezobrazuje:**  
  - Zkontroluj, že **App ID je string** v uvozovkách.  
  - V Discordu → *User Settings → Activity Privacy* musí být zapnuté **“Display current activity as a status message”**.  
  - Neběží jiný RP script, který by to přepisoval?

- **Nevidím tlačítka:**  
  - Ověř z **jiného účtu na desktopu**.  
  - URL tlačítek musí být **https://** (ne `fivem://`).  
  - Na mobilu se tlačítka většinou nezobrazují.

- **Nezobrazují se obrázky:**  
  - Název assetu v `config.lua` **musí 1:1** odpovídat názvu v Developer Portalu.  
  - Po nahrání assetů vyčkej pár minut (cache).

- **Počet hráčů nesedí:**  
  - Client čte počet přes `GetActivePlayers()` – je to lokální pohled. Na přesný údaj ze serveru si můžeš přidat malý server event (volitelné).

---

## Struktura resource
```
chillside-richpresence/
├─ fxmanifest.lua
├─ config.lua
└─ client.lua
```

---

## Poznámky
- Skript používá **Lua 5.4** a běží čistě na klientovi.
- Inicializace probíhá jednou; dynamická část (text + tlačítka) se aktualizuje co `Config.updateInterval` sekund.
- Labely tlačítek drž spíš krátké (≈ 16–32 znaků).

