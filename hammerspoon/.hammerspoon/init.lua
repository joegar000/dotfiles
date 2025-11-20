require("hs.ipc")

function maximizeWithPercentPadding(percent, duration)
    local win = hs.window.focusedWindow()
    percent = percent / 100
    duration = duration or 0.15

    local screen = win:screen()
    local f = screen:frame()   -- usable area (no menubar)

    -- padding in pixels, derived from usable area
    local padX = f.w * percent
    local padY = f.h * percent

    -- final rect inside usable frame
    local rect = hs.geometry.rect(
        f.x + padX,
        f.y + padY,
        f.w - padX * 2,
        f.h - padY * 2
    )

    win:move(rect, duration)
end

function moveWindowHalfWithPadding(direction, percent, duration)
    local win = hs.window.focusedWindow()
    duration = duration or 0.15
    percent = percent / 100

    local f = win:screen():frame()  -- usable screen area

    -- Apply uniform padding
    local padX = f.w * percent
    local padY = f.h * percent
    local insetFrame = hs.geometry.rect(
        f.x + padX,
        f.y + padY,
        f.w - padX * 2,
        f.h - padY * 2
    )

    local x, y, w, h = insetFrame.x, insetFrame.y, insetFrame.w, insetFrame.h

    if direction == "left" then
        w = w / 2 - padX
    elseif direction == "right" then
        x = x + w / 2 + padX
        w = w / 2 - padX
    elseif direction == "up" then
        h = h / 2 - padY
    elseif direction == "down" then
        y = y + h / 2 + padY
        h = h / 2 - padY
    end

    local rect = hs.geometry.rect(x, y, w, h)
    win:move(rect, duration)
end

function moveWindowToCorner(corner, percent, duration)
    local win = hs.window.focusedWindow()
    duration = duration or 0.15
    percent = percent / 100

    local f = win:screen():frame()  -- usable screen area

    -- apply uniform padding
    local padX = f.w * percent
    local padY = f.h * percent
    local insetFrame = hs.geometry.rect(
        f.x + padX,
        f.y + padY,
        f.w - padX * 2,
        f.h - padY * 2
    )

    local x, y, w, h = insetFrame.x, insetFrame.y, insetFrame.w / 2, insetFrame.h / 2

    if corner == "topLeft" then
        w = w - padX
        h = h - padY
    elseif corner == "topRight" then
        w = w - padX
        h = h - padY
        x = x + w + (padX * 2)
    elseif corner == "bottomLeft" then
        w = w - padX
        h = h - padY
        y = y + h + (padY * 2)
    elseif corner == "bottomRight" then
        w = w - padX
        h = h - padY
        x = x + w + (padX * 2)
        y = y + h + (padY * 2)
    else
        return  -- invalid corner
    end

    local rect = hs.geometry.rect(x, y, w, h)
    win:move(rect, duration)
end


function cycleScreen(dir)
    -- get the focused window
    local win = hs.window.focusedWindow()
    -- get the screen where the focused window is displayed, a.k.a. current screen
    local screen = win:screen()
    -- compute the unitRect of the focused window relative to the current screen
    -- and move the window to the next screen setting the same unitRect 
    win:move(win:frame():toUnitRect(screen:frame()), dir == 'left' and screen:previous() or screen:next(), true):centerOnScreen()
end

hs.hotkey.bind({'alt', 'cmd'}, 'right', function() cycleScreen('left') end)

hs.hotkey.bind({'alt', 'cmd'}, 'left', function() cycleScreen('right') end)

-- half of screen
-- {frame.x, frame.y, window.w, window.h}
-- First two elements: we decide the position of frame
-- Last two elements: we decide the size of frame
hs.hotkey.bind({'ctrl', 'alt'}, 'left', function() moveWindowHalfWithPadding('left', 0.5) end)
hs.hotkey.bind({'ctrl', 'alt'}, 'right', function() moveWindowHalfWithPadding('right', 0.5) end)
hs.hotkey.bind({'ctrl', 'alt'}, 'up', function() moveWindowHalfWithPadding('up', 0.5) end)
hs.hotkey.bind({'ctrl', 'alt'}, 'down', function() moveWindowHalfWithPadding('down', 0.5) end)

-- quarter of screen
--[[
    u i
    j k
--]]
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'u', function() moveWindowToCorner('topLeft', 0.5) end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'k', function() moveWindowToCorner('bottomRight', 0.5) end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'i', function() moveWindowToCorner('topRight', 0.5) end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'j', function() moveWindowToCorner('bottomLeft', 0.5) end)


-- full screen
hs.hotkey.bind({'alt'}, 'm', function() maximizeWithPercentPadding(0.5) end)

-- smaller screen
hs.hotkey.bind({'alt'}, 'n', function() maximizeWithPercentPadding(10) end)

-- center screen
hs.hotkey.bind({'ctrl', 'alt'}, 'c', function() hs.window.focusedWindow():centerOnScreen() end)

