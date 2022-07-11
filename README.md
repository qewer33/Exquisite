## Exquisite

![screenshot_0](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_0.png?raw=true)
![screenshot_1](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_1.png?raw=true)

Exquisite is a KWin script that brings Windows 11 like window tiling to KDE Plasma.

### Installation

Clone the repo and run `./install.sh`. Will soon be uploaded to the KDE Store.

### Usage

The default shortcut is `CTRL + ALT + D` but it can be configured from `System Settings > Shortcuts > KWin > Exquisite`. Click a window and click a layout box on the Exquisite window to place that window in that layout. You can do this for multiple windows and close the Exquisite window when you're done (by the close button on the top right or by pressing the shortcut keys).

### Configuration

Exquisite can be configured from `System Settings > Window Management > KWin Scripts`. Curreent configuration options include:

- Column count for the main window
- Main window position (Top, Center or Bottom)
- Main window header visibility
- Whetever to maximize or not when the background button on a layout is clicked, the default behaviour might annoy some people

Keep in mind, Kwin needs to be restarted for the settings to apply (either log out and back in or run `kwin_x11 --replace &`, use `kwin_wayland` if you're on a Wayland session).

### Custom Layouts

Exquisite allows for custom layouts. They are stored in `~/.local/kwin/scripts/exquisite/layouts/`. More documentation soon.
