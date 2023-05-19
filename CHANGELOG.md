# 1.0 Indev

### Features
- Custom layout creator!
    - You can now create, save and edit custom Exquisite layouts with a GUI
    - "Edit Mode" let's you manage your custom layouts
    - This feature hasn't been tested extensively, please report any bugs or issues you might have
- Multiple pages
    - This allows you to create as many layouts as you want and still be able to access them without the Exquisite window becoming larger
    - If you don't like this change, you can disable it by unchecking the "Show pages UI" option in Exquisite settings
- Exquisite now appears under the mouse cursor by default when activated
    - This option is still configurable (Top, Center, Bottom and Under Mouse Cursor)
- Completely revamped the settings dialog
    - Now with tabs!
- New "Hide titlebars of tiled windows" option, disabled by default
- New "Tile Scale" option to adjust the size of Exquisite's window tiles, 1.3 by default
- 8 more default layouts added. Exquisite now has 16 layouts by default
    - Default layouts can be edited or deleted in: ~/.local/share/kwin/scripts/exquisite/layouts

### Changed
- "Restart KWin" button is now disabled by default
- Removed titlebar "Help" button

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
