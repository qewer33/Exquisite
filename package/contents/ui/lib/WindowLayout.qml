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

    property var main
    property var windows
    property var screen
    property var clickedWindows: []

    function tileWindow(client, window, root) {
        var screen = root.screen;
        if (screen == undefined) { console.log("screen not defined"); return; }
        if (!client.normalWindow) return;
        if (root.main.rememberWindowGeometries && !root.main.oldWindowGemoetries.has(client)) root.main.oldWindowGemoetries.set(client, [client.geometry.width, client.geometry.height]);

        let xMult = screen.width / 12.0;
        let yMult = screen.height / 12.0;
        let x = 0.0;
        let y = 0.0;
        let width = 0.0;
        let height = 0.0;

        x = window.rawX ?? Math.round(window.x * xMult) + tileGap;
        y = window.rawY ?? Math.round(window.y * yMult) + tileGap;
        width = window.rawWidth ?? Math.round(window.width * xMult) - 2*tileGap;
        height = window.rawHeight ?? Math.round(window.height * yMult) - 2*tileGap;

        client.setMaximize(false, false);
        client.geometry = Qt.rect(screen.x + x, screen.y + y, width, height);
        if (root.main.hideTiledWindowTitlebar) client.noBorder = true;
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
        main.doRaise(true);

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
                tileWindow(client, windows[i], root);
                workspace.activeClient = client;
            }

            if (hideOnFirstTile || hideOnLayoutTiled) main.hide();
        }
    }

    function spanCheck(normal, raw, screenSize) {
	if (raw != undefined) {
	    let val = Math.min(raw / (screenSize / 12.0), 12.0)
	    val = Math.round(val);
	    return val;
	} else {
	    return normal;
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
                Layout.column: { root.spanCheck(windows[index].x, windows[index].rawX, screen.width); }
                Layout.row: { root.spanCheck(windows[index].y, windows[index].rawY, screen.height); }
                Layout.rowSpan: { root.spanCheck(windows[index].width, windows[index].rawWidth, screen.width); }
                Layout.columnSpan: { root.spanCheck(windows[index].height, windows[index].rawHeight, screen.height); }

                onClicked: {
                    main.doRaise(true);
                    main.requestActivate();
                    focusField.forceActiveFocus();

                    tileWindow(main.activeClient, windows[index], root);

                    if (!clickedWindows.includes(windows[index])) clickedWindows.push(windows[index]);

                    if (hideOnFirstTile) main.hide();
                    if (hideOnLayoutTiled && clickedWindows.length === windows.length) {
                        clickedWindows = [];
                        main.hide();
                    }
                }

                Component.onCompleted: {
                    let window = windows[index];

                    // Register shortcuts
                    if (window.shortcutKey) {
                        let key = [window.shortcutModifier, window.shortcutKey];
                        main.tileShortcuts.set(key, function(workspace, window, tileWindow, root) {
                            return function() {
                                if (window == undefined || root == undefined || workspace == undefined || main == undefined || main.activeClient == undefined) {
                                    return;
                                }
                                tileWindow(main.activeClient, window, root);
                            }
                        }(workspace, window, tileWindow, root));
                    }
                }
            }
        }
    }
}
