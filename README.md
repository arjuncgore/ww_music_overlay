# Music Overlay
Music controls on waywall and an optional overlay (requires playerctl)

## Dependencies
This plugin requires [playerctl](https://github.com/altdesktop/playerctl). Install it on your distro with the following command.
### Fedora
```bash
sudo dnf install playerctl
```
### Arch
```bash
sudo pacman -S playerctl
```
### Debian
```bash
sudo apt install playerctl
```

## Setup
### Using [plug.waywall](https://github.com/its-saanvi/plug.waywall)
```lua
local cfg = {
    overlay = true,
    look = {
        X = 70,
        Y = 920,
        color = '#000000',
        size = 3,
        max_len = 30,
    },
    previous = "F10",
    play_pause = "F11",
    next = "F12",
}

return {
    url = "https://github.com/arjuncgore/ww_music_overlay",
    config = function(config)
        require("music_overlay.init").setup(config, cfg)
    end,
    name = "music_overlay",
    update_on_load = false,
}
```
### Otherwise
#### Clone plugin to waywall config folder
```bash
git clone https://github.com/arjuncgore/ww_music_overlay ~/.config/waywall/music_overlay
```

#### Setup config in init.lua
```lua
-- rest of config
local cfg = {
    overlay = true,
    look = {
        X = 70,
        Y = 920,
        color = '#000000',
        size = 3,
        max_len = 30,
    },
    previous = "F10",
    play_pause = "F11",
    next = "F12",
}

require("music_overlay.init").setup(config, cfg)
return config
```
