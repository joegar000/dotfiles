require("hs.ipc")


hs.hotkey.bind({'alt', 'cmd'}, 'right',
  function()
    -- get the focused window
    local win = hs.window.focusedWindow()
    -- get the screen where the focused window is displayed, a.k.a. current screen
    local screen = win:screen()
    -- compute the unitRect of the focused window relative to the current screen
    -- and move the window to the next screen setting the same unitRect 
    win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true):centerOnScreen()
  end
)

hs.hotkey.bind({'alt', 'cmd'}, 'left',
  function()
    -- get the focused window
    local win = hs.window.focusedWindow()
    -- get the screen where the focused window is displayed, a.k.a. current screen
    local screen = win:screen()
    -- compute the unitRect of the focused window relative to the current screen
    -- and move the window to the next screen setting the same unitRect 
    win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true):centerOnScreen()
  end
)

-- half of screen
-- {frame.x, frame.y, window.w, window.h}
-- First two elements: we decide the position of frame
-- Last two elements: we decide the size of frame
hs.hotkey.bind({'ctrl', 'alt'}, 'left', function() hs.window.focusedWindow():moveToUnit({0, 0, 0.5, 1}) end)
hs.hotkey.bind({'ctrl', 'alt'}, 'right', function() hs.window.focusedWindow():moveToUnit({0.5, 0, 0.5, 1}) end)
hs.hotkey.bind({'ctrl', 'alt'}, 'up', function() hs.window.focusedWindow():moveToUnit({0, 0, 1, 0.5}) end)
hs.hotkey.bind({'ctrl', 'alt'}, 'down', function() hs.window.focusedWindow():moveToUnit({0, 0.5, 1, 0.5}) end)

-- quarter of screen
--[[
    u i
    j k
--]]
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'u', function() hs.window.focusedWindow():moveToUnit({0, 0, 0.5, 0.5}) end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'k', function() hs.window.focusedWindow():moveToUnit({0.5, 0.5, 0.5, 0.5}) end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'i', function() hs.window.focusedWindow():moveToUnit({0.5, 0, 0.5, 0.5}) end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'j', function() hs.window.focusedWindow():moveToUnit({0, 0.5, 0.5, 0.5}) end)


-- full screen
hs.hotkey.bind({'alt'}, 'm', function() hs.window.focusedWindow():moveToUnit({0, 0, 0.99, 0.99}):centerOnScreen() end)

-- smaller screen
hs.hotkey.bind({'alt'}, 'n', function() hs.window.focusedWindow():moveToUnit({0, 0, 0.8, 0.8}):centerOnScreen() end)

-- center screen
hs.hotkey.bind({'ctrl', 'alt'}, 'c', function() hs.window.focusedWindow():centerOnScreen() end)



-- Move window to a reasonable size (30% width, 70% height, centered)
function moveWindowReasonableSize()
  local win = hs.window.focusedWindow()
  if not win then return end

  local screen = win:screen()
  local frame = screen:frame()

  local targetWidth = frame.w * 0.3
  local targetHeight = frame.h * 0.7
  local targetFrame = {
    x = frame.x + ((frame.w - targetWidth) / 2),
    y = frame.y + ((frame.h - targetHeight) / 2),
    w = targetWidth,
    h = targetHeight
  }

  win:move(targetFrame, nil, true, 0.2)
end

-- Move window to the left half
function moveWindowLeftAnimated()
  local win = hs.window.focusedWindow()
  if not win then return end

  local screen = win:screen()
  local frame = screen:frame()

  local targetFrame = {
    x = frame.x,
    y = frame.y,
    w = frame.w / 2,
    h = frame.h
  }

  win:move(targetFrame, nil, true, 0.2)
end

-- Move window to the right half
function moveWindowRightAnimated()
  local win = hs.window.focusedWindow()
  if not win then return end

  local screen = win:screen()
  local frame = screen:frame()

  local targetFrame = {
    x = frame.x + (frame.w / 2),
    y = frame.y,
    w = frame.w / 2,
    h = frame.h
  }

  win:move(targetFrame, nil, true, 0.2)
end

-- Maximize window
function maximizeWindowAnimated()
  local win = hs.window.focusedWindow()
  if not win then return end

  local screen = win:screen()
  local frame = screen:frame()

  win:move(frame, nil, true, 0.2)
end

