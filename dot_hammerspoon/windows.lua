-- ~/.hammerspoon/window.lua

local M = {}

-- ─────────────────────────────────────────────────────────────
-- Configuration
-- ─────────────────────────────────────────────────────────────

local hyper = { "ctrl", "alt", "cmd", "shift" }

local padding = 15
local animationDuration = 0.18


-- ─────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────

local function screenFrame(screen)
    local frame = screen:frame()

    frame.x = frame.x + padding
    frame.y = frame.y + padding
    frame.w = frame.w - (padding * 2)
    frame.h = frame.h - (padding * 2)

    return frame
end

local function animateWindow(win, frame)
    if animationDuration > 0 then
        win:move(frame, animationDuration)
    else
        win:setFrame(frame)
    end
end

local function currentWindow()
    return hs.window.focusedWindow()
end

local function moveToFrame(x, y, w, h)
    local win = currentWindow()
    if not win then return end

    local frame = screenFrame(win:screen())

    animateWindow(win, {
        x = frame.x + frame.w * x,
        y = frame.y + frame.h * y,
        w = frame.w * w,
        h = frame.h * h,
    })
end


-- ─────────────────────────────────────────────────────────────
-- Standard positions
-- ─────────────────────────────────────────────────────────────

function M.left()
    moveToFrame(0, 0, 0.5, 1)
end

function M.right()
    moveToFrame(0.5, 0, 0.5, 1)
end

function M.top()
    moveToFrame(0, 0, 1, 0.5)
end

function M.bottom()
    moveToFrame(0, 0.5, 1, 0.5)
end

function M.topLeft()
    moveToFrame(0, 0, 0.5, 0.5)
end

function M.topRight()
    moveToFrame(0.5, 0, 0.5, 0.5)
end

function M.bottomLeft()
    moveToFrame(0, 0.5, 0.5, 0.5)
end

function M.bottomRight()
    moveToFrame(0.5, 0.5, 0.5, 0.5)
end

function M.maximize()
    local win = currentWindow()
    if not win then return end

    animateWindow(win, screenFrame(win:screen()))
end

function M.center()
    moveToFrame(0.25, 0.15, 0.5, 0.5)
end


-- ─────────────────────────────────────────────────────────────
-- Monitor movement
-- ─────────────────────────────────────────────────────────────

function M.nextScreen()
    local win = currentWindow()
    if not win then return end

    local screen = win:screen()
    local nextScreen = screen:toEast()

    if nextScreen then
        win:moveToScreen(nextScreen, animationDuration)
    end
end

function M.previousScreen()
    local win = currentWindow()
    if not win then return end

    local screen = win:screen()
    local previousScreen = screen:toWest()

    if previousScreen then
        win:moveToScreen(previousScreen, animationDuration)
    end
end


-- Move to another monitor
function M.nextScreenRight()
    local win = currentWindow()
    if not win then return end

    local nextScreen = win:screen():toEast()
    if not nextScreen then return end

    local frame = screenFrame(nextScreen)

    win:moveToScreen(nextScreen, animationDuration)

    animateWindow(win, {
        x = frame.x,
        y = frame.y,
        w = win:size().w,
        h = frame.h,
    })
end

function M.previousScreenLeft()
    local win = currentWindow()
    if not win then return end

    local previousScreen = win:screen():toWest()
    if not previousScreen then return end

    local frame = screenFrame(previousScreen)

    win:moveToScreen(previousScreen, animationDuration)

    animateWindow(win, {
        x = frame.x,
        y = frame.y,
        w = win:size().w,
        h = frame.h,
    })
end


-- ─────────────────────────────────────────────────────────────
-- Hotkeys
-- ─────────────────────────────────────────────────────────────

local bindings = {
    -- Halves
    { "h", M.left },
    { "l", M.right },
    { "k", M.top },
    { "j", M.bottom },

    -- Corners
    { "y", M.topLeft },
    { "u", M.topRight },
    { "b", M.bottomLeft },
    { "n", M.bottomRight },

    -- Other sizes
    { "m", M.maximize },
    { "c", M.center },

    -- Screen
    { ";", M.previousScreenLeft },
    { "'", M.nextScreenRight },
}

for _, binding in ipairs(bindings) do
    local key = binding[1]
    local fn = binding[2]
    local modifiers = binding[3]

    local mods = hyper
    if modifiers then
        mods = hs.fnutils.concat(hyper, modifiers)
    end

    hs.hotkey.bind(mods, key, fn)
end

return M
