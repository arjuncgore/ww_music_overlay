-- ==== CONFIG ====
-- local cfg         = {
--     overlay    = true,
--     look       = {
--         X = 20,
--         Y = 1380,
--         color = '#000000',
--         size = 3,
--         max_len = 30,
--     },
--     pic_look   = {
--         X = 10,
--         Y = 1380,
--         size = 10
--      },
--     previous   = "F10",
--     play_pause = "F11",
--     next       = "F12",
-- }

-- ==== VARS ====
local waywall     = require("waywall")
local text_handle = nil
local layout      = ""
local artist      = ""
local title       = ""
local pic_handle  = nil
local pic_path    = ""
local M           = {}

-- ==== HELPERS ====
local function str_max(str, max_len)
    str = str or ""
    if max_len == nil or max_len <= 3 then
        return str
    end
    if #str <= max_len then
        return str
    end
    return str:sub(1, max_len - 3) .. "..."
end

-- ==== PLUG ====
M.setup = function(config, cfg)
    -- ==== FUNCTIONS ====
    local update_overlay = function()
        local handle_artist = io.popen("playerctl metadata --format {{artist}}")
        local handle_title  = io.popen("playerctl metadata --format {{title}}")
        local handle_pic    = io.popen("playerctl metadata --format '{{ mpris:artUrl }}'")

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
        if handle_pic then
            pic_path = handle_pic:read("*l")
            handle_pic:close()
        else
            pic_path = ""
        end
    end
    local enable_overlay = function()
        update_overlay()

        if text_handle then
            text_handle:close()
            text_handle = nil
        end
        if pic_handle then
            pic_handle:close()
            pic_handle = nil
        end

        -- ==== CONFIGURE THE LOOK OF THE OVERLAY HERE ====
        if artist ~= "" then
            layout = str_max(artist, cfg.look.max_len) .. "\n" .. str_max(title, cfg.look.max_len)
        else
            layout = str_max(title, cfg.look.max_len)
        end

        text_handle = waywall.text(layout,
            { x = cfg.look.X, y = cfg.look.Y, color = cfg.look.color, size = cfg.look.size })
        if pic_path ~= "" then
            pic_handle = waywall.image(pic_path:gsub("^file://", ""),
                { x = cfg.pic_look.X, y = cfg.pic_look.Y, w = cfg.pic_look.size, h = cfg.pic_look.size })
        end
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
