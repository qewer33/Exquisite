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