# 0.5 Release

### Features

- Pressing the ESC key now hides Exquisite
- You can now assign shortcut to individual tiles in a layout. Shortcuts only work when Exquisite is open.
    - You can edit the layouts in: ~/.local/share/kwin/scripts/exquisite/layouts
- Exquisite now has an option to show the currently active window's title in the header bar, enabled by default
- New "Under Mouse Cursor" option added to Exquisite spawn location options
    - This option only works with Plasma releases above 5.27.5
- New "Hide titlebars of tiled windows" option, disabled by default
- New "Tile scale" option to adjust the size of Exquisite's window tiles, 1.3 by default
- New "Gap between tiles" option to adjust the gap between tiled windows and screen edges, 0 by default
- Completely revamped settings dialog
    - Now with tabs!

### Changed

- "Restart KWin" button is now disabled by default
- Removed titlebar "Help" button
- **!!! IMPORTANT !!!**: Layouts are now defined by (`x`, `y`, `width`, `height`) instead of (`row`, `rowSpan`, `column`, `columnSpan`). You will need to port your custom layouts, read below for a quick porting guide:
    - `row` -> `y`
    - `rowSpan` -> `width`
    - `column` -> `x`
    - `columnSpan` -> `height`

### Bug Fixes

- Autotiling now only tiles windows on the current screen and current activity
- Fix bug where on certain screen sizes and layouts, windows didn't tile properly and caused windows to visually bug


# 0.4 Release

### Features

- New "Toggle Exquisite" widget for visually toggling the Exquisite window
    - The widget is fairly simple and can be placed on both the desktop and panels. It's icon is configurable
- Save and restore geometry of tiled windows
    - Tested and seems to be working quite well
- Auto tile available windows when the background button of a layout is clicked
    - Could be somewhat buggy since it's not tested properly, please report any issues or suggestions you might have
- "Restart KWin" button in the header that... well, restarts KWin
    - Restarting KWin in a Wayland session as of now will cause the entire session to restart. If the button is clicked on a Wayland session, a confirmation dialog will pop up warning the user about this
- "Help" button in the header that opens the GitHub repository link
- All of the features above are enabled by default but configurable from the Exquisite settings

### Bug Fixes

- Normal window tiling should be more robust now
- "Can't read property 'desktopWindow' of null" errors on KWin logs are gone (thanks to @emvaized on GitHub)
