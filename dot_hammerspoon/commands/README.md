# Hammerspoon commands for Tuna

`init.lua` registers URL handlers and remembers the application window used before
opening Tuna. `windows.lua` implements the window actions. The original
`../windows.lua` remains available, with its hotkeys commented out.

## Use in Tuna

1. Keep Hammerspoon running.
2. Enable **Settings → Sources → Tuna → Scripts**. The default script directory is
   `~/Library/Scripts`; if you configured custom directories, include it there.
3. Rescan with **⌘R**, then search for **Hammerspoon: Left Half**, or another action.
   Check the Scripts source's global-search scope if the commands are only visible
   while browsing that source.
4. Assign the script's **Run** action to your preferred Combo Mode binding.

Alternatively, bind a URL using Tuna's **Open URL in Background** action:

```text
hammerspoon://window?action=left-half
hammerspoon://window?action=almost-maximize
hammerspoon://window?action=next-display
```

Tuna's configuration is managed manually. These commands do not edit it.

## Behavior

- Based on Tuna 0.106 with **Cycling = none**. Future changes to Tuna's settings
  do not automatically change these Lua implementations.
- Set `gap` near the top of `windows.lua` (currently `12`) to adjust outer margins
  for Almost Maximize and spacing between tiled halves, thirds, quarters, sixths,
  and centered fractional layouts.
  Values are in points; `0` disables gaps. Apply the file and reload Hammerspoon
  after changing it. Maximize and the other non-tiled actions retain their own sizing.
- Frame changes use the single `animationDuration = 0.18` setting in `windows.lua`.
- Center preserves size; Reasonable Size uses 60% of both usable dimensions;
  Almost Maximize uses the shared `gap` inset; Maximize fills the usable screen.
- Nudges move 40 points. Larger/smaller adjust both dimensions by 80 points,
  with a 240 × 160 minimum before screen clamping.
- Restore swaps the last frame per application, matching Tuna's behavior.
- Next/Previous Display follow the physical left-to-right arrangement (top-to-bottom
  when left edges align) and wrap at the ends. Transfers recognize existing layout
  geometry and recalculate it on the destination, preserving fixed gaps even between
  landscape and portrait displays. Custom-sized windows use the same gap-aware
  coordinate system; a maximized width or height remains maximized.
- Fullscreen windows are not resized. Apps may impose their own minimum sizes.
- A closed remembered target is skipped. A one-second handoff after Tuna dismisses
  allows its asynchronously delivered URL to use the captured window.
- Hide commands hide applications, not individual windows. Space commands switch
  desktops on the display under the pointer, include fullscreen Spaces, and do not
  wrap. They use `hs.spaces.gotoSpace`, which briefly opens Mission Control and uses
  the native transition rather than the frame-animation duration.

All 54 fixed window-management actions have scripts, plus **Space 1** for the
current desktop setup. Numbered `space-N` URLs update when Spaces/displays change.
If you add desktops and want separate searchable numbered commands, copy the
Space 1 script and change its name and action number.

## Add or restore commands

Add a window action to the `M` table in `windows.lua`. Frame actions above the
window-required wrapper receive a surviving `hs.window`; global actions below it
must handle a missing target. Add a matching executable script to the chezmoi
source `private_Library/Scripts/`, following an existing `executable_hammerspoon-window-*.sh`.
Reload Hammerspoon and rescan Tuna after applying the files.

To return to the legacy setup, restore its commented startup lines in `init.lua`
one directory above, and uncomment the desired hotkey-registration blocks.
Mission Control and MouseFollowsFocus are disabled at startup; Caffeine's menu-bar
toggle remains available and its old hotkey callback is retained.
