-- Tuna-compatible window commands, with configurable gaps and no layout cycling.
-- Coordinates are points in the usable screen frame (menu bar/Dock excluded).
local M = {}
local animationDuration = 0.18
local gap = 12 -- Outer margins and spacing between tiles, in points; 0 disables gaps.
local savedFrames = {}

local function clamp(frame, bounds)
    local w = math.max(0, math.min(frame.w, bounds.w))
    local h = math.max(0, math.min(frame.h, bounds.h))
    return {
        x = math.max(bounds.x, math.min(frame.x, bounds.x + bounds.w - w)),
        y = math.max(bounds.y, math.min(frame.y, bounds.y + bounds.h - h)),
        w = w,
        h = h,
    }
end

local function currentScreen(win)
    local frame = win:frame()
    local cx, cy = frame.x + frame.w / 2, frame.y + frame.h / 2
    local best, bestArea, bestDistance
    for _, screen in ipairs(hs.screen.allScreens()) do
        local bounds = screen:fullFrame()
        if cx >= bounds.x and cx < bounds.x + bounds.w
            and cy >= bounds.y and cy < bounds.y + bounds.h then
            return screen
        end
        local w = math.max(0, math.min(frame.x + frame.w, bounds.x + bounds.w) - math.max(frame.x, bounds.x))
        local h = math.max(0, math.min(frame.y + frame.h, bounds.y + bounds.h) - math.max(frame.y, bounds.y))
        local area = w * h
        local dx = math.max(bounds.x - cx, 0, cx - bounds.x - bounds.w)
        local dy = math.max(bounds.y - cy, 0, cy - bounds.y - bounds.h)
        local distance = dx * dx + dy * dy
        if not best or area > bestArea or (area == bestArea and distance < bestDistance) then
            best, bestArea, bestDistance = screen, area, distance
        end
    end
    return best
end

local function animate(win, frame, screen)
    if win:isFullScreen() then return end
    local target = clamp(frame, screen:frame())
    if target.w <= 0 or target.h <= 0 then return end
    -- Tuna's Restore slot is per application, even when it has several windows.
    savedFrames[win:application():pid()] = win:frame()
    -- Hammerspoon replaces an in-flight animation. Its frame() reports the
    -- pending destination, so successive nudges accumulate without a queue.
    win:setFrame(target, animationDuration)
end

local function layoutFrame(bounds, x, y, w, h, spacing)
    -- Share a single gap at each tile boundary, rather than giving both
    -- adjacent tiles a full inset (which would double the interior gap).
    return {
        x = bounds.x + spacing + (bounds.w - spacing) * x,
        y = bounds.y + spacing + (bounds.h - spacing) * y,
        w = (bounds.w - spacing) * w - spacing,
        h = (bounds.h - spacing) * h - spacing,
    }
end

local layoutFrames = {}

local function layout(x, y, w, h, withGap)
    local function frameForBounds(bounds)
        local spacing = withGap == false and 0 or math.max(0, gap)
        return layoutFrame(bounds, x, y, w, h, spacing)
    end
    table.insert(layoutFrames, frameForBounds)
    return function(win)
        local screen = currentScreen(win)
        if not screen then return end
        animate(win, frameForBounds(screen:frame()), screen)
    end
end

M["left-half"] = layout(0, 0, 0.5, 1)
M["right-half"] = layout(0.5, 0, 0.5, 1)
M["top-half"] = layout(0, 0, 1, 0.5)
M["bottom-half"] = layout(0, 0.5, 1, 0.5)
M["center-half"] = layout(0.25, 0, 0.5, 1)
M["center-third"] = layout(1 / 3, 0, 1 / 3, 1)
M["center-two-thirds"] = layout(1 / 6, 0, 2 / 3, 1)
M["center-three-fourths"] = layout(1 / 8, 0, 3 / 4, 1)
M["top-left-quarter"] = layout(0, 0, 0.5, 0.5)
M["top-right-quarter"] = layout(0.5, 0, 0.5, 0.5)
M["bottom-left-quarter"] = layout(0, 0.5, 0.5, 0.5)
M["bottom-right-quarter"] = layout(0.5, 0.5, 0.5, 0.5)
M["first-third"] = layout(0, 0, 1 / 3, 1)
M["middle-third"] = layout(1 / 3, 0, 1 / 3, 1)
M["last-third"] = layout(2 / 3, 0, 1 / 3, 1)
M["first-two-thirds"] = layout(0, 0, 2 / 3, 1)
M["last-two-thirds"] = layout(1 / 3, 0, 2 / 3, 1)
M["first-three-fourths"] = layout(0, 0, 3 / 4, 1)
M["last-three-fourths"] = layout(1 / 4, 0, 3 / 4, 1)
M["first-fourth"] = layout(0, 0, 1 / 4, 1)
M["second-fourth"] = layout(1 / 4, 0, 1 / 4, 1)
M["third-fourth"] = layout(1 / 2, 0, 1 / 4, 1)
M["last-fourth"] = layout(3 / 4, 0, 1 / 4, 1)
M["top-third"] = layout(0, 0, 1, 1 / 3)
M["top-two-thirds"] = layout(0, 0, 1, 2 / 3)
M["top-three-fourths"] = layout(0, 0, 1, 3 / 4)
M["bottom-third"] = layout(0, 2 / 3, 1, 1 / 3)
M["bottom-two-thirds"] = layout(0, 1 / 3, 1, 2 / 3)
M["bottom-three-fourths"] = layout(0, 1 / 4, 1, 3 / 4)
M["top-left-sixth"] = layout(0, 0, 1 / 3, 1 / 2)
M["top-center-sixth"] = layout(1 / 3, 0, 1 / 3, 1 / 2)
M["top-right-sixth"] = layout(2 / 3, 0, 1 / 3, 1 / 2)
M["bottom-left-sixth"] = layout(0, 1 / 2, 1 / 3, 1 / 2)
M["bottom-center-sixth"] = layout(1 / 3, 1 / 2, 1 / 3, 1 / 2)
M["bottom-right-sixth"] = layout(2 / 3, 1 / 2, 1 / 3, 1 / 2)
M["maximize"] = layout(0, 0, 1, 1, false)
M["reasonable-size"] = layout(0.2, 0.2, 0.6, 0.6, false)
M["almost-maximize"] = layout(0, 0, 1, 1)

M["center"] = function(win)
    local screen = currentScreen(win)
    if not screen then return end
    local bounds = screen:frame()
    local frame = clamp(win:frame(), bounds)
    frame.x = bounds.x + (bounds.w - frame.w) / 2
    frame.y = bounds.y + (bounds.h - frame.h) / 2
    animate(win, frame, screen)
end

local function maximizeAxis(axis)
    return function(win)
        local screen = currentScreen(win)
        if not screen then return end
        local frame, bounds = win:frame(), screen:frame()
        if axis == "height" then
            frame.y, frame.h = bounds.y, bounds.h
        else
            frame.x, frame.w = bounds.x, bounds.w
        end
        animate(win, frame, screen)
    end
end

M["maximize-height"] = maximizeAxis("height")
M["maximize-width"] = maximizeAxis("width")

local function resize(delta)
    return function(win)
        local screen = currentScreen(win)
        if not screen then return end
        local frame = win:frame()
        local w, h = math.max(240, frame.w + delta), math.max(160, frame.h + delta)
        animate(win, {
            x = frame.x + (frame.w - w) / 2,
            y = frame.y + (frame.h - h) / 2,
            w = w,
            h = h,
        }, screen)
    end
end

M["make-larger"] = resize(80)
M["make-smaller"] = resize(-80)

M["restore"] = function(win)
    local frame = savedFrames[win:application():pid()]
    local screen = currentScreen(win)
    if frame and screen then animate(win, frame, screen) end
end

local function nudge(dx, dy)
    return function(win)
        local screen = currentScreen(win)
        if not screen then return end
        local frame = win:frame()
        frame.x = frame.x + dx
        frame.y = frame.y + dy
        animate(win, frame, screen)
    end
end

M["move-left"] = nudge(-40, 0)
M["move-right"] = nudge(40, 0)
M["move-up"] = nudge(0, -40)
M["move-down"] = nudge(0, 40)

local function near(a, b)
    return math.abs(a - b) <= 1 -- Hammerspoon rounds frames down to whole points.
end

local function transferFrame(frame, oldBounds, newBounds)
    -- Recognize the actual geometry, without remembering the last command.
    -- Reapplying known layouts prevents rounding drift and also preserves
    -- gap-free layouts such as Maximize and Reasonable Size.
    for _, frameForBounds in ipairs(layoutFrames) do
        local candidate = frameForBounds(oldBounds)
        if near(frame.x, candidate.x) and near(frame.y, candidate.y)
            and near(frame.w, candidate.w) and near(frame.h, candidate.h) then
            return frameForBounds(newBounds)
        end
    end

    -- Invert the same coordinate system used by layoutFrame. Adding the gap
    -- back to the window size accounts for inter-tile spacing as well as margins.
    local spacing = math.max(0, gap)
    if oldBounds.w <= spacing or oldBounds.h <= spacing then return nil end
    local target = layoutFrame(newBounds,
        (frame.x - oldBounds.x - spacing) / (oldBounds.w - spacing),
        (frame.y - oldBounds.y - spacing) / (oldBounds.h - spacing),
        (frame.w + spacing) / (oldBounds.w - spacing),
        (frame.h + spacing) / (oldBounds.h - spacing), spacing)

    -- Preserve an individually maximized axis for otherwise custom-sized windows.
    if near(frame.x, oldBounds.x) and near(frame.w, oldBounds.w) then
        target.x, target.w = newBounds.x, newBounds.w
    end
    if near(frame.y, oldBounds.y) and near(frame.h, oldBounds.h) then
        target.y, target.h = newBounds.y, newBounds.h
    end
    return target
end

local function changeDisplay(step)
    return function(win)
        local screens = hs.screen.allScreens()
        if #screens < 2 then return end
        -- macOS enumeration order need not match the physical arrangement.
        -- Use left-to-right order, then top-to-bottom for stacked displays.
        table.sort(screens, function(left, right)
            local a, b = left:fullFrame(), right:fullFrame()
            if a.x ~= b.x then return a.x < b.x end
            if a.y ~= b.y then return a.y < b.y end
            return left:id() < right:id()
        end)
        local oldScreen = currentScreen(win)
        if not oldScreen then return end
        for index, screen in ipairs(screens) do
            if screen:id() == oldScreen:id() then
                local targetScreen = screens[(index - 1 + step) % #screens + 1]
                local oldBounds, newBounds = screen:frame(), targetScreen:frame()
                if oldBounds.w <= 0 or oldBounds.h <= 0 then return end
                local target = transferFrame(win:frame(), oldBounds, newBounds)
                if target then animate(win, target, targetScreen) end
                return
            end
        end
    end
end

M["previous-display"] = changeDisplay(-1)
M["next-display"] = changeDisplay(1)

-- Frame actions require a surviving target. Global actions below do not.
for id, action in pairs(M) do
    M[id] = function(win)
        if win then action(win) end
    end
end

local function hideApplications(except)
    for _, app in ipairs(hs.application.runningApplications()) do
        if app:kind() == 1 and app:bundleID() ~= "com.brnbw.Tuna"
            and (not except or app:pid() ~= except:pid()) then
            app:hide()
        end
    end
end

M["hide-all-windows"] = function()
    hideApplications()
end

M["hide-all-except-frontmost"] = function(win)
    if not win then return end
    local app = win:application()
    hideApplications(app)
    app:activate()
end

local function switchSpace(index, step)
    local screen = hs.mouse.getCurrentScreen()
    if not screen then return end
    local spaces = hs.spaces.spacesForScreen(screen)
    if not spaces then return end
    local current = hs.spaces.activeSpaceOnScreen(screen)
    if step then
        for i, space in ipairs(spaces) do
            if space == current then index = i + step break end
        end
    end
    -- Space transitions are native macOS transitions, not frame animations.
    -- gotoSpace briefly uses Mission Control; the legacy custom module is off.
    local destination = index and spaces[index]
    if destination and destination ~= current then
        hs.spaces.gotoSpace(destination)
    end
end

M["previous-space"] = function() switchSpace(nil, -1) end
M["next-space"] = function() switchSpace(nil, 1) end

-- Match Tuna's numbered Space commands. Rebuild after desktop/display changes.
local function registerSpaces()
    for id in pairs(M) do
        if id:match("^space%-%d+$") then M[id] = nil end
    end
    local count = 0
    for _, screen in ipairs(hs.screen.allScreens()) do
        local spaces = hs.spaces.spacesForScreen(screen)
        count = math.max(count, spaces and #spaces or 0)
    end
    for index = 1, count do
        M["space-" .. index] = function() switchSpace(index) end
    end
end

registerSpaces()

-- Keep watcher lifetimes tied to the required module, separate from URL actions.
return {
    actions = M,
    spaceWatcher = hs.spaces.watcher.new(registerSpaces):start(),
    screenWatcher = hs.screen.watcher.new(registerSpaces):start(),
}
