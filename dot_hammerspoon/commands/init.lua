-- URL entry points. Window implementations live in commands/windows.lua.
local M = {}
local windows = require("commands.windows").actions
local tunaBundleID = "com.brnbw.Tuna"
local lastWindowID
local launcherWindowID
local launcherTargetCaptured = false
local launcherActive = false
local releaseTimer

local function isAppWindow(win)
    if not win or not win:isStandard() then return false end
    local app = win:application()
    if not app then return false end
    local bundleID = app:bundleID()
    return bundleID ~= tunaBundleID and bundleID ~= "org.hammerspoon.Hammerspoon"
end

local function rememberWindow(win)
    if isAppWindow(win) then
        lastWindowID = win:id()
    end
end

local function captureLauncherTarget()
    if releaseTimer then
        releaseTimer:stop()
        releaseTimer = nil
    end
    if not launcherActive then
        launcherWindowID = lastWindowID
        launcherTargetCaptured = true
        launcherActive = true
    end
end

local function releaseLauncherTarget()
    if not launcherActive then return end
    launcherActive = false
    -- Tuna dismisses before LaunchServices delivers the URL. Retain the
    -- snapshot briefly across that handoff, including a destroyed window's
    -- ID: a closed target must not fall back to another app's window.
    releaseTimer = hs.timer.doAfter(1, function()
        launcherWindowID = nil
        launcherTargetCaptured = false
        releaseTimer = nil
    end)
end

rememberWindow(hs.window.focusedWindow())

-- Keep references on the module so the watchers survive garbage collection.
M.windowWatcher = hs.window.filter.new(true):subscribe(hs.window.filter.windowFocused, function(win)
    local app = win:application()
    if app and app:bundleID() == tunaBundleID then
        captureLauncherTarget()
    else
        rememberWindow(win)
    end
end)
M.windowWatcher:subscribe(hs.window.filter.windowUnfocused, function(win)
    local app = win:application()
    if app and app:bundleID() == tunaBundleID then releaseLauncherTarget() end
end)

M.applicationWatcher = hs.application.watcher.new(function(_, event, app)
    if not app or app:bundleID() ~= tunaBundleID then return end
    if event == hs.application.watcher.activated then
        captureLauncherTarget()
    elseif event == hs.application.watcher.deactivated then
        releaseLauncherTarget()
    end
end):start()

local function targetWindow()
    local id
    if launcherTargetCaptured then
        id = launcherWindowID
    else
        rememberWindow(hs.window.focusedWindow())
        id = lastWindowID
    end
    if not id then return nil end
    local win = hs.window.get(id)
    if isAppWindow(win) and win:isVisible() then return win end
end

hs.urlevent.bind("window", function(_, params)
    local action = windows[params.action or ""]
    if not action then
        hs.printf("Unknown window command: %s", params.action or "(missing)")
        return
    end
    local win = targetWindow()
    action(win)
end)

return M
