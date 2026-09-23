local mcNav = {
    active = false,
    thumbnails = {},
    selected = nil,
    hotkeys = {},
    labels = {},
}

local reservedKeys = {
    h = true,
    j = true,
    k = true,
    l = true,
}

local fallbackKeys = {
    "a", "s", "d", "f",
    "q", "w", "e", "r",
    "z", "x", "c", "v",
    "g", "t", "y", "u",
    "b", "n", "m", "p",
}

local function center(frame)
    return {
        x = frame.x + frame.w / 2,
        y = frame.y + frame.h / 2,
    }
end

local function distanceScore(fromFrame, toFrame, direction)
    local a = center(fromFrame)
    local b = center(toFrame)

    local dx = b.x - a.x
    local dy = b.y - a.y

    if direction == "left" and dx >= 0 then return nil end
    if direction == "right" and dx <= 0 then return nil end
    if direction == "up" and dy >= 0 then return nil end
    if direction == "down" and dy <= 0 then return nil end

    if direction == "left" or direction == "right" then
        return math.abs(dx) + math.abs(dy) * 2
    else
        return math.abs(dy) + math.abs(dx) * 2
    end
end

local function sortThumbnailsVisually(thumbnails)
    local rowTolerance = 120

    table.sort(thumbnails, function(a, b)
        local ac = center(a.frame)
        local bc = center(b.frame)

        local sameRow = math.abs(ac.y - bc.y) < rowTolerance

        if sameRow then
            return ac.x < bc.x
        end

        return ac.y < bc.y
    end)
end

local function normalizeShortcutText(text)
    if not text then
        return ""
    end

    return string.lower(text)
end

local function candidateLetters(text)
    text = normalizeShortcutText(text)

    local result = {}
    local seen = {}

    -- Prefer the first letter of each word.
    for word in text:gmatch("[%w]+") do
        local c = word:sub(1, 1)

        if c:match("[a-z]") and not seen[c] then
            seen[c] = true
            table.insert(result, c)
        end
    end

    -- Then consider every remaining letter.
    for c in text:gmatch("[a-z]") do
        if not seen[c] then
            seen[c] = true
            table.insert(result, c)
        end
    end

    return result
end

local function findAvailableLetter(text, used)
    for _, c in ipairs(candidateLetters(text)) do
        if not used[c] and not reservedKeys[c] then
            return c
        end
    end

    return nil
end

local function assignShortcuts()
    local used = {}

    for _, thumb in ipairs(mcNav.thumbnails) do
        thumb.shortcut = nil

        local appName = nil

        if thumb.win and thumb.win:application() then
            appName = thumb.win:application():name()
        end

        -- Prefer the application name.
        local shortcut = findAvailableLetter(appName, used)

        -- If that collides, use the window title.
        if not shortcut then
            shortcut = findAvailableLetter(thumb.title, used)
        end

        -- Last resort: generic fallback pool.
        if not shortcut then
            for _, key in ipairs(fallbackKeys) do
                if not used[key] and not reservedKeys[key] then
                    shortcut = key
                    break
                end
            end
        end

        if shortcut then
            thumb.shortcut = shortcut
            used[shortcut] = true
        end
    end
end

local function clearLabels()
    for _, label in ipairs(mcNav.labels) do
        label:delete()
    end

    mcNav.labels = {}
end

local function drawLabels()
    clearLabels()

    for _, thumb in ipairs(mcNav.thumbnails) do
        local key = thumb.shortcut

        if key then
            local f = thumb.frame
            local labelSize = 44

            local canvas = hs.canvas.new({
                x = f.x + 16,
                y = f.y + 16,
                w = labelSize,
                h = labelSize,
            })

            canvas[1] = {
                type = "rectangle",
                action = "fill",
                fillColor = {
                    red = 0.08,
                    green = 0.08,
                    blue = 0.08,
                    alpha = 0.90,
                },
                roundedRectRadii = {
                    xRadius = 8,
                    yRadius = 8,
                },
            }

            canvas[2] = {
                type = "text",
                text = string.upper(key),
                textColor = {
                    white = 1,
                    alpha = 1,
                },
                textSize = 24,
                textAlignment = "center",
                frame = {
                    x = 0,
                    y = 7,
                    w = labelSize,
                    h = labelSize,
                },
            }

            canvas:level(hs.canvas.windowLevels.overlay)

            canvas:behavior({
                "canJoinAllSpaces",
                "stationary",
                "ignoresCycle",
            })

            canvas:show()

            table.insert(mcNav.labels, canvas)
        end
    end
end

local function moveMouseToThumbnail(thumb)
    if not thumb then
        return
    end

    local c = center(thumb.frame)

    hs.mouse.absolutePosition(c)

    -- Mission Control does not always update its native
    -- hover border from pointer teleportation alone.
    hs.eventtap.event.newMouseEvent(
        hs.eventtap.event.types.mouseMoved,
        c
    ):post()
end

local function findThumbnails()
    local wm = hs.application.get("com.apple.WindowManager")

    if not wm then
        print("Could not find WindowManager")
        return {}
    end

    local root = hs.axuielement.applicationElement(wm)
    local results = {}

    local function walk(el, depth)
        depth = depth or 0

        if depth > 10 then
            return
        end

        if el:attributeValue("AXRole") == "AXButton" then
            local wid = el:attributeValue("wid")
            local frame = el:attributeValue("AXFrame")

            if wid and frame then
                table.insert(results, {
                    element = el,
                    wid = wid,
                    win = hs.window.get(wid),
                    title = el:attributeValue("AXTitle"),
                    identifier = el:attributeValue("AXIdentifier"),
                    frame = frame,
                })
            end
        end

        for _, child in ipairs(el:attributeValue("AXChildren") or {}) do
            walk(child, depth + 1)
        end
    end

    walk(root)

    return results
end

local function moveSelection(direction)
    if not mcNav.selected then
        return
    end

    local best = nil
    local bestScore = nil

    for _, candidate in ipairs(mcNav.thumbnails) do
        if candidate ~= mcNav.selected then
            local score = distanceScore(
                mcNav.selected.frame,
                candidate.frame,
                direction
            )

            if score and (not bestScore or score < bestScore) then
                best = candidate
                bestScore = score
            end
        end
    end

    if best then
        mcNav.selected = best
        moveMouseToThumbnail(best)
    end
end

local function stopMissionControlNav()
    mcNav.active = false

    clearLabels()

    for _, hotkey in ipairs(mcNav.hotkeys) do
        hotkey:disable()
    end

    mcNav.hotkeys = {}
    mcNav.thumbnails = {}
    mcNav.selected = nil
end

local function activateThumbnail(thumb)
    if not thumb then
        return
    end

    local c = center(thumb.frame)

    moveMouseToThumbnail(thumb)

    stopMissionControlNav()

    hs.timer.doAfter(0.02, function()
        hs.eventtap.leftClick(c)
    end)
end

local function selectCurrent()
    if mcNav.selected then
        activateThumbnail(mcNav.selected)
    end
end

local function findClosestThumbnailToMouse()
    local mouse = hs.mouse.absolutePosition()

    local best = nil
    local bestDistance = nil

    for _, thumb in ipairs(mcNav.thumbnails) do
        local c = center(thumb.frame)

        local dx = c.x - mouse.x
        local dy = c.y - mouse.y

        local distance = dx * dx + dy * dy

        if not bestDistance or distance < bestDistance then
            best = thumb
            bestDistance = distance
        end
    end

    return best
end

local function installNavigationHotkeys()
    mcNav.hotkeys = {
        hs.hotkey.bind({}, "h", function()
            moveSelection("left")
        end),

        hs.hotkey.bind({}, "j", function()
            moveSelection("down")
        end),

        hs.hotkey.bind({}, "k", function()
            moveSelection("up")
        end),

        hs.hotkey.bind({}, "l", function()
            moveSelection("right")
        end),

        hs.hotkey.bind({}, "return", function()
            selectCurrent()
        end),

        hs.hotkey.bind({}, "escape", function()
            stopMissionControlNav()
            hs.spaces.closeMissionControl()
        end),
    }

    for _, thumb in ipairs(mcNav.thumbnails) do
        if thumb.shortcut then
            local capturedThumb = thumb

            table.insert(
                mcNav.hotkeys,
                hs.hotkey.bind({}, thumb.shortcut, function()
                    activateThumbnail(capturedThumb)
                end)
            )
        end
    end
end

local function toggleMissionControlNav()
    if mcNav.active then
        stopMissionControlNav()
        hs.spaces.closeMissionControl()
        return
    end

    hs.spaces.openMissionControl()

    hs.timer.doAfter(0.5, function()
        mcNav.thumbnails = findThumbnails()

        if #mcNav.thumbnails == 0 then
            print("No Mission Control thumbnails found")
            return
        end

        mcNav.active = true

        -- Make shortcut assignment deterministic.
        sortThumbnailsVisually(mcNav.thumbnails)

        -- Assign shortcuts based on app/window names.
        assignShortcuts()

        -- Draw labels over each Mission Control thumbnail.
        drawLabels()

        -- Start on whichever thumbnail is nearest the
        -- user's current mouse position.
        mcNav.selected = findClosestThumbnailToMouse()

        if mcNav.selected then
            moveMouseToThumbnail(mcNav.selected)
        end

        installNavigationHotkeys()
    end)
end

local function enableMissionControlNav()
    if mcNav.active then
        return
    end

    mcNav.thumbnails = findThumbnails()

    if #mcNav.thumbnails == 0 then
        return
    end

    mcNav.active = true

    sortThumbnailsVisually(mcNav.thumbnails)
    assignShortcuts()
    drawLabels()

    mcNav.selected = findClosestThumbnailToMouse()

    if mcNav.selected then
        moveMouseToThumbnail(mcNav.selected)
    end

    installNavigationHotkeys()
end


local missionControlVisible = false

local function isMissionControlVisible()
    local wm = hs.application.get("com.apple.WindowManager")

    if not wm then
        return false
    end

    local root = hs.axuielement.applicationElement(wm)

    local function findMCDisplay(el, depth)
        depth = depth or 0

        if depth > 6 then
            return false
        end

        if el:attributeValue("AXIdentifier") == "mc.display" then
            return true
        end

        for _, child in ipairs(el:attributeValue("AXChildren") or {}) do
            if findMCDisplay(child, depth + 1) then
                return true
            end
        end

        return false
    end

    return findMCDisplay(root)
end

_G.mcVisibilityWatcher = hs.timer.doEvery(0.1, function()
    local visible = isMissionControlVisible()

    if visible and not missionControlVisible then
        missionControlVisible = true

        -- Give Mission Control just a moment to finish laying
        -- out all of the thumbnail AXButtons.
        hs.timer.doAfter(0.1, function()
            if isMissionControlVisible() then
                enableMissionControlNav()
            end
        end)

    elseif not visible and missionControlVisible then
        missionControlVisible = false

        if mcNav.active then
            stopMissionControlNav()
        end
    end
end)

-- Temporary activation shortcut.
-- Change this to whatever you want.
-- hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "o", toggleMissionControlNav)
