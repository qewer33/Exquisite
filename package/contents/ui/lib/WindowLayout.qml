import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

import "./"

PlasmaComponents.Button {
    id: root
    implicitWidth: 160*1.2 * PlasmaCore.Units.devicePixelRatio
    implicitHeight: 90*1.2 * PlasmaCore.Units.devicePixelRatio

    property var windows
    property var clickedWindows: []

    function tileWindow(client, window) {
        if (!client.normalWindow) return;
        if (rememberWindowGeometries && !oldWindowGemoetries.has(client)) oldWindowGemoetries.set(client, [client.geometry.width, client.geometry.height]);

        let screen = workspace.clientArea(KWin.MaximizeArea, workspace.activeScreen, client.desktop);

        let xMult = screen.width / 12.0;
        let yMult = screen.height / 12.0;

        let newX = Math.round(window.x * xMult) + tileGap;
        let newY = Math.round(window.y * yMult) + tileGap;
        let newWidth = Math.round(window.width * xMult) - 2*tileGap;
        let newHeight = Math.round(window.height * yMult) - 2*tileGap;

        client.setMaximize(false, false);
        client.geometry = Qt.rect(screen.x + newX, screen.y + newY, newWidth, newHeight);
        if (hideTiledWindowTitlebar) client.noBorder = true;
    }

    function childHasFocus() {
        if (root.focus) return true;
        for (let i = 0; i < repeater.count; i++) {
            let item = repeater.itemAt(i);
            if (item.focus) return true;
        }
        return false;
    }

    onClicked: {
        mainDialog.raise();
        mainDialog.requestActivate();
        focusField.forceActiveFocus();

        if (tileAvailableWindowsOnBackgroundClick) {
            let clientList = [];
            for (let i = 0; i < workspace.clientList().length; i++) {
                let client = workspace.clientList()[i];
                if (client.normalWindow && workspace.currentDesktop === client.desktop && !client.minimized)
                    clientList.push(client);
            }

            for (let i = 0; i < clientList.length; i++) {
                if (i >= windows.length || i >= clientList.length) return;
                let client = clientList[i];
                tileWindow(client, windows[i]);
                workspace.activeClient = client;
            }

            if (hideOnFirstTile || hideOnLayoutTiled) mainDialog.visible = false;
        }
    }

    SpanGridLayout {
        anchors.fill: parent
        anchors.margins: 10
        rows: 12
        columns: 12

        Repeater {
            id: repeater
            model: windows.length

            PlasmaComponents.Button {
                text: {
                    let window = windows[index];
                    if (window.shortcutKey) {
                        let out = ""
                        if (window.shortcutModifier) {
                            let modifiers = {
                                [Qt.ControlModifier]: "Ctrl",
                                [Qt.ShiftModifier]: "Shift",
                                [Qt.AltModifier]: "Alt",
                                [Qt.MetaModifier]: "Meta",
                            }
                            out += modifiers[window.shortcutModifier] + "+"
                        }
                        out += String.fromCharCode(window.shortcutKey);
                        return out;
                    } else return "";
                }
                Layout.row: windows[index].y
                Layout.rowSpan: windows[index].width
                Layout.column: windows[index].x
                Layout.columnSpan: windows[index].height

                onClicked: {
                    mainDialog.raise();
                    mainDialog.requestActivate();
                    focusField.forceActiveFocus();

                    tileWindow(activeClient, windows[index]);

                    if (!clickedWindows.includes(windows[index])) clickedWindows.push(windows[index]);

                    if (hideOnFirstTile) mainDialog.visible = false;
                    if (hideOnLayoutTiled && clickedWindows.length === windows.length) {
                        clickedWindows = [];
                        mainDialog.visible = false;
                    }
                }

                Component.onCompleted: {
                    let window = windows[index];

                    // Register shortcuts
                    if (window.shortcutKey) {
                        let key = [window.shortcutModifier, window.shortcutKey];
                        tileShortcuts.set(key, () => {
                            tileWindow(activeClient, window);
                        });
                    }
                }
            }
        }
    }
}
