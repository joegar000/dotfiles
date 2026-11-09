local amber = dofile(os.getenv("HOME") .. "/.local/share/rex/amber/amber.lua")

amber.setup({
  plugins = {
    { "rawnly/smart-splits-backend-rex", main = "smart-splits-rex", opts = { resize_amount = 3 } },
  },
})

for key, direction in pairs({ h = 'left', j = 'down', k = 'up', l = 'right' }) do
  rex.bind('ctrl+' .. key, 'smart_splits_focus', { direction = direction, key = 'ctrl+' .. key })
  rex.bind('alt+' .. key, 'smart_splits_resize', { direction = direction, key = 'alt+' .. key })
end

-- Tmux-style shortcuts, matching ~/.tmux.conf where Rex has an equivalent.
-- Press Ctrl+B, release it, then press the next key. Escape cancels a sequence.
-- Reload after editing: rex config reload (or Ctrl+B, r).

-- Tabs (tmux windows).
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
rex.bind("ctrl+b>,", "client.tab.rename")
rex.bind("ctrl+b>shift+7", "client.tab.close") -- & on a US keyboard

-- Tmux defaults to zero-based window numbers; Rex's tab API is one-based.
for number = 0, 9 do
  rex.bind("ctrl+b>" .. number, "client.tab.goto", { index = number + 1 })
end

-- Splits: % creates a pane to the right; " creates a pane below (US keyboard).
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+b>x", "pane.close")
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>m", "pane.zoom") -- Your custom tmux zoom key.
rex.bind("ctrl+b>shift+1", "pane.move_to_new_tab") -- !

-- Your Vim-style pane navigation.
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>o", "pane.focus_next")

-- Native app moves retain Rex's animations.
rex.bind("ctrl+b>shift+h", "pane.move", { direction = "left" })
rex.bind("ctrl+b>shift+j", "pane.move", { direction = "down" })
rex.bind("ctrl+b>shift+k", "pane.move", { direction = "up" })
rex.bind("ctrl+b>shift+l", "pane.move", { direction = "right" })

-- Your arrow-key resizing. Rex measures the amount in percent, not cells.
for _, direction in ipairs({ "left", "down", "up", "right" }) do
  rex.bind("ctrl+b>" .. direction, "pane.resize", {
    direction = direction,
    amount = 5,
  })
end

-- Sessions and Rex's equivalent of your workmux sidebar toggle.
rex.bind("ctrl+b>s", "session.switch")
rex.bind("ctrl+b>shift+4", "session.rename") -- $
rex.bind("ctrl+b>shift+9", "session.previous") -- (
rex.bind("ctrl+b>shift+0", "session.next") -- )
rex.bind("ctrl+b>w", "client.sidebar.toggle")

-- Rex's command palette serves as the command prompt.
rex.bind("ctrl+b>shift+;", "client.palette.toggle") -- :
rex.bind("ctrl+b>r", "client.config.reload")

-- Send a literal Ctrl+B to the terminal (also useful for nested tmux).
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
