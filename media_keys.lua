-- ==== CONFIG ====
local cfg         = {
    overlay    = true,
    look       = {
        X = 20,
        Y = 1380,
        color = '#000000',
        size = 3,
    },
    previous   = "F10",
    play_pause = "F10",
    next       = "F10",
}

-- ==== VARS ====
local waywall     = require("waywall")
local text_handle = nil
local layout      = ""
local artist      = ""
local title       = ""
local M           = {}

-- ==== PLUG ====
M.setup           = function(config, cfg)
    -- ==== FUNCTIONS ====
    local update_overlay = function()
        local handle_artist = io.popen("playerctl metadata --format {{artist}}")
        local handle_title  = io.popen("playerctl metadata --format {{title}}")

        if handle_artist then
            artist = handle_artist:read("*l")
            handle_artist:close()
        else
            artist = "not found"
        end
        if handle_title then
            title = handle_title:read("*l")
            handle_title:close()
        else
            title = "not found"
        end
    end
    local enable_overlay = function()
        update_overlay()

        if text_handle then
            text_handle:close()
            text_handle = nil
        end

        -- ==== CONFIGURE THE LOOK OF THE OVERLAY HERE ====
        if artist ~= "" then
            layout = artist .. ": " .. title
        else
            layout = title
        end

        text_handle = waywall.text(layout,
            { x = cfg.look.X, y = cfg.look.Y, color = cfg.look.color, size = cfg.look.size })
    end

    waywall.listen("state", function()
        -- Update on state update
        if cfg.overlay then
            enable_overlay()
        end
    end)


    config.actions[cfg.previous] = function()
        waywall.exec("playerctl previous")
        waywall.sleep(100)
        if cfg.overlay then
            enable_overlay()
        end
    end

    config.actions[cfg.play_pause] = function()
        waywall.exec("playerctl play-pause")
        waywall.sleep(100)
        if cfg.overlay then
            enable_overlay()
        end
    end

    config.actions[cfg.next] = function()
        waywall.exec("playerctl next")
        waywall.sleep(100)
        if cfg.overlay then
            enable_overlay()
        end
    end
end

return M
