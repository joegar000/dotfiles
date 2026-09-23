hs.loadSpoon("SpoonInstall")

require('windows')
require('missioncontrol')

spoon.SpoonInstall:andUse("MouseFollowsFocus", {
    start = true,
})

spoon.SpoonInstall:andUse("Caffeine", {
    start = true,
})
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "C", function()
    local enabled = not hs.caffeinate.get("displayIdle")
    spoon.Caffeine:setState(enabled)
    hs.alert.show(
        enabled and "☕ Caffeine ON" or "😴 Caffeine OFF",
        {
            strokeColor = { white = 1, alpha = 0.08 },
            fillColor = { white = 0.08, alpha = 0.94 },
            textColor = { white = 1, alpha = 1 },
            textFont = ".AppleSystemUIFont",
            textSize = 17,
            radius = 14,
            padding = 14,
            fadeInDuration = 0.08,
            fadeOutDuration = 0.18,
        },
        hs.screen.mainScreen(),
        0.7
    )
end)
