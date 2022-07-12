## Exquisite

![screenshot_0](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_0.png?raw=true)
![screenshot_1](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_1.png?raw=true)

Exquisite is a KWin script that brings Windows 11 like window tiling to KDE Plasma.

### Installation

You can donwload Exquisite from the KDE Store (`System Settings > Window Management > KWin Scripts > Get New Scripts...`). For development, you can clone the repo and run `./install.sh`. KWin needs to be restarted on every install (either log out and back in or run `kwin_x11 --replace`, use `kwin_wayland` if you're on a Wayland session).

### Usage

The default shortcut is `Ctrl + Alt + D` but it can be configured from `System Settings > Shortcuts > KWin > Exquisite`. Click on a window and click a layout box on the Exquisite window to place that window in that layout. You can do this for multiple windows and close the Exquisite window when you're done (by the close button on the top right or by pressing the shortcut keys).


https://user-images.githubusercontent.com/69015181/178298525-5c9ac287-b9d0-42da-9011-152f8e858d65.mp4


### Configuration

Exquisite can be configured from `System Settings > Window Management > KWin Scripts`. Current configuration options include:

- Column count for the main window
- Main window position (Top, Center or Bottom)
- Main window header visibility
- Whether to hide when a window is tiled
- Whether to hide when a layout is tiled (all windows in the layout has been clicked)
- Whether to maximize the window or not when the background button on a layout is clicked, the default behaviour might annoy some people

Keep in mind, KWin needs to be restarted for the settings to apply.

### Modifying and Creating Layouts

Exquisite layouts are stored in `~/.local/kwin/scripts/exquisite/layouts/`. You can freely change them, remove the ones you don't need or add new ones. They're named by numbers so if you're going to add a new one, look at the last ones number and name your file one up that number. Let's take a look at an existing one (`0.qml`) to understand how they are structured:

```qml
import QtQuick 2.6

Item {
    property string name: "Two Vertical Split"
    property var windows: [
        {
            row: 0,
            rowSpan: 6,
            column: 0,
            columnSpan: 12
        },
        {
            row: 0,
            rowSpan: 6,
            column: 6,
            columnSpan: 12
        }
    ]
}
```

The import statement and Item declaration are boilerplate, what we really need to understand are the two properties: `name` and `windows`. `name` is pretty self explanatory, it's the name of the layout. The names aren't currently used but they might be in the future, better to write something explanatory rather than not.

The `windows` parameter is an array of JS objects. Each object represents a window and has 4 entries: `row`, `rowSpan`, `column` and `columnSpan`. These entries describe how the window is laid out in the layout, let's take a look at each one in detail:

- `row`: The row that the top left corner of the window will be placed at. Rows start from the left side of a grid so you can think of this parameter as like the `y` position of the window.
- `rowSpan`: The amount of grid cells that the window is going to span inside a row. This includes the origin cell which is `row`. You can think of this as like the `width` of the window.
- `column`: The column that the top left corner of the window will be placed at. Columns start from the upper side of the grid so you can think of this as like the `x` position of the window.
- `columnSpan`: The amount of grid cells that the window is going to span inside a column. This includes the origin cell which is `column`. You can think of this as like the `height` of the window.

The grid that the layout windows are placed in is 12x12 (choose 12 since it's a relatively small number and can be divided by 2, 3 and 4). For `row` and `column`, the minimum value is 0 and the maximum 11. For `rowSpan` and `columnSpan`, the minimum is 1 and the maximum is 12.

Here is an image for better explanation:

![screenshot_1](https://github.com/qewer33/Exquisite/blob/main/assets/layout_explanation.png?raw=true)

The window in this image would be:

```qml
{
    row: 2,
    rowSpan: 7,
    column: 1,
    columnSpan: 9
}
```

