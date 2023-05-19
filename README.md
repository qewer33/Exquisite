<div align="center"> 
    
# ✨ Exquisite 
A KWin script that allows you to tile windows in pre-defined places using a graphical interface!
    
[KDE Store link](https://store.kde.org/p/1852610/) | [Widget KDE Store link](https://store.kde.org/p/1878384/)

![](https://img.shields.io/static/v1?style=for-the-badge&label=KWin&message=Script&color=blue&logo=kde)
![](https://img.shields.io/badge/Wayland-Ready-blue?style=for-the-badge&logo=linux)
![](https://img.shields.io/static/v1?style=for-the-badge&label=KDE%20Store&message=7.5K+%20Downloads&color=blue&logo=kde&logoColor=orange)
![](https://img.shields.io/static/v1?style=for-the-badge&label=Qt&message=QML&color=green&logo=qt)

If you like this KWin script and want to support me, consider getting me a coffe! :D

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/B0B8FQ871)
    
</div>
<br>

![screenshot_0](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_0.png?raw=true)
![screenshot_1](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_1.png?raw=true)

## Installation

You can download Exquisite from the KDE Store (`System Settings > Window Management > KWin Scripts > Get New Scripts...`). For development, you can clone the repo and run `./install.sh`. KWin needs to be restarted on every install (either log out and log back in or run `kwin_x11 --replace`, use `kwin_wayland` if you're on a Wayland session).

## Usage

The default shortcut is `Ctrl + Alt + D` but it can be configured from `System Settings > Shortcuts > KWin > Exquisite`. Click on a window and click a layout box on the Exquisite window to place that window in that layout. You can do this for multiple windows and close the Exquisite window when you're done (by the close button on the top right or by pressing the shortcut keys).


https://user-images.githubusercontent.com/69015181/178298525-5c9ac287-b9d0-42da-9011-152f8e858d65.mp4


There is also a widget companion available if you want to toggle Exquisite visually. You can get it from the KDE Store via `Right Click on Desktop > Add Widget > Get New Widgets`. The widget source code lives under the `widget` directory.

![screenshot_widget](https://github.com/qewer33/Exquisite/blob/main/assets/screenshot_widget.png?raw=true)


## Configuration

Exquisite can be configured from `System Settings > Window Management > KWin Scripts`. Current configuration options include:

- Column count for the main window
- Main window position (Top, Center or Bottom)
- Main window header visibility
- Whether to hide when a window is tiled
- Whether to hide when a layout is tiled (all windows in the layout has been clicked)
- Whether to maximize the window or not when the background button on a layout is clicked, the default behaviour might annoy some people

Keep in mind, KWin needs to be restarted for the settings to apply.

## Troubleshooting

### Doesn't Work on Older Plasma/Distribution Versions

If you don't have an up to date system (e.g older Debian or Ubuntu versions), Exquisite [may not work out of the box](https://github.com/qewer33/Exquisite/issues/10). In order to resolve this, you need to make the following changes:

- In the file `~/.local/share/kwin/scripts/exquisite/contents/ui/main.qml`, find the following line (depends on the current version of Exquisite but should be around line 90):
```qml
source: fileUrl
```
and change it to:
```qml
source: fileURL
```

- In the file `~/.local/share/kwin/scripts/exquisite/contents/ui/lib/WindowLayout.qml`, find the following lines (they should be around line 13):
```qml
implicitWidth: 160*1.2 * PlasmaCore.Units.devicePixelRatio
implicitHeight: 90*1.2 * PlasmaCore.Units.devicePixelRatio
```
and change them to:
```qml
implicitWidth: 120
implicitHeight: 70
```

If you have further troubles, [please open an issue](https://github.com/qewer33/Exquisite/issues/new).

## Modifying and Creating Layouts

Exquisite layouts are stored in `~/.local/share/kwin/scripts/exquisite/contents/layouts/`. You can freely change them, remove the ones you don't need or add new ones. They're named by numbers so if you're going to add a new one, look at the last one's number and name your file one up that number. Let's take a look at an existing one (`0.qml`) to understand how they are structured:

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

The import statement and Item declaration are boilerplate, what we really need to understand are the two properties: `name` and `windows`. `name` is pretty self-explanatory, it's the name of the layout. The names aren't currently used but they might be in the future, better to write something explanatory rather than not.

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

