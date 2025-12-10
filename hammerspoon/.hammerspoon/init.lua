require("hs.ipc")

-------------------------------------------------
-- CONFIGURATION
-------------------------------------------------

local padding = 10             -- per-window padding
local animationDuration = 0.12

hs.window.animationDuration = animationDuration

-------------------------------------------------
-- HELPERS
-------------------------------------------------

-- Just return the full screen frame; all padding is applied per-window
local function screenFrame(screen)
    return screen:frame()
end

-- Apply padding inside a target region
local function padded(region)
    return {
        x = region.x + padding,
        y = region.y + padding,
        w = region.w - padding * 2,
        h = region.h - padding * 2
    }
end

local function set(win, region)
    if not win then return end
    win:setFrame(region, animationDuration)
end

-------------------------------------------------
-- WINDOW LAYOUTS
-------------------------------------------------

-- Fullscreen (with padding)
local function fullscreen(win)
    local s = screenFrame(win:screen())
    set(win, padded(s))
end

-- Small fullscreen (centered with inset)
local function smallFullscreen(win, inset)
    inset = inset or 150
    local s = screenFrame(win:screen())
    local region = {
        x = s.x + inset,
        y = s.y + inset,
        w = s.w - inset * 2,
        h = s.h - inset * 2
    }
    set(win, padded(region))
end

-- Keep current size but center on screen
local function center(win)
    local f = win:frame()
    local s = screenFrame(win:screen())
    local region = {
        x = s.x + (s.w - f.w) / 2,
        y = s.y + (s.h - f.h) / 2,
        w = f.w,
        h = f.h
    }
    set(win, region)
end

-------------------------------------------------
-- SPLITS
-------------------------------------------------

local function leftHalf(win)
    local s = screenFrame(win:screen())
    local region = { x = s.x, y = s.y, w = s.w / 2, h = s.h }
    set(win, padded(region))
end

local function rightHalf(win)
    local s = screenFrame(win:screen())
    local region = { x = s.x + s.w/2, y = s.y, w = s.w / 2, h = s.h }
    set(win, padded(region))
end

local function topHalf(win)
    local s = screenFrame(win:screen())
    local region = { x = s.x, y = s.y, w = s.w, h = s.h / 2 }
    set(win, padded(region))
end

local function bottomHalf(win)
    local s = screenFrame(win:screen())
    local region = { x = s.x, y = s.y + s.h/2, w = s.w, h = s.h / 2 }
    set(win, padded(region))
end

-------------------------------------------------
-- QUARTER GRID (2×2)
-------------------------------------------------

local function grid(win, gx, gy, gw, gh)
    local s = screenFrame(win:screen())
    local cellW = s.w / 2
    local cellH = s.h / 2

    local region = {
        x = s.x + gx * cellW,
        y = s.y + gy * cellH,
        w = gw * cellW,
        h = gh * cellH
    }

    set(win, padded(region))
end

-------------------------------------------------
-- MOVE TO NEXT MONITOR
-------------------------------------------------

function moveToNextMonitor(win, dir)
    -- get the screen where the focused window is displayed, a.k.a. current screen
    local screen = win:screen()
    -- compute the unitRect of the focused window relative to the current screen
    -- and move the window to the next screen setting the same unitRect 
    win:move(win:frame():toUnitRect(screen:frame()), dir == 'left' and screen:previous() or screen:next(), true):centerOnScreen()
    center(win)
end

-------------------------------------------------
-- HOTKEYS
-------------------------------------------------

local mash = {"ctrl", "alt", "cmd"}

-- Fullscreen, small fullscreen, center
hs.hotkey.bind(mash, "f", function() fullscreen(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "m", function() smallFullscreen(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "c", function() center(hs.window.focusedWindow()) end)

-- Splits
hs.hotkey.bind(mash, "h", function() leftHalf(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "l", function() rightHalf(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "k", function() topHalf(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "j", function() bottomHalf(hs.window.focusedWindow()) end)

-- Quarter grid (2×2)
hs.hotkey.bind(mash, "y", function() grid(hs.window.focusedWindow(), 0, 0, 1, 1) end)
hs.hotkey.bind(mash, "u", function() grid(hs.window.focusedWindow(), 1, 0, 1, 1) end)
hs.hotkey.bind(mash, "i", function() grid(hs.window.focusedWindow(), 0, 1, 1, 1) end)
hs.hotkey.bind(mash, "o", function() grid(hs.window.focusedWindow(), 1, 1, 1, 1) end)

-- Move window to next monitor
hs.hotkey.bind(mash, "right", function() moveToNextMonitor(hs.window.focusedWindow(), 'right') end)
hs.hotkey.bind(mash, "left", function() moveToNextMonitor(hs.window.focusedWindow(), 'left') end)

