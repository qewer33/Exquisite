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

    function tileWindow(window, row, rowSpan, column, columnSpan) {
        if (!window.normalWindow) return;
        if (rememberWindowGeometries && !oldWindowGemoetries.has(window)) oldWindowGemoetries.set(window, [window.geometry.width, window.geometry.height]);

        let screen = workspace.clientArea(KWin.MaximizeArea, workspace.activeScreen, window.desktop);

        let xMult = screen.width / 12.0;
        let yMult = screen.height / 12.0;

        let newX = Math.round(column * xMult);
        let newY = Math.round(row * yMult);
        let newWidth = Math.round(rowSpan * xMult);
        let newHeight = Math.round(columnSpan * yMult);

        window.setMaximize(false, false);
        window.geometry = Qt.rect(screen.x + newX, screen.y + newY, newWidth, newHeight);
        if (hideTiledWindowTitlebar) window.noBorder = true;
    }

    function childHasFocus() {
        for (let i = 0; i < repeater.count; i++) {
            let item = repeater.itemAt(i);
            if (item.focus) return true;
        }
        return false;
    }

    onClicked: {
        mainDialog.raise();
        mainDialog.requestActivate();
        textField.forceActiveFocus();

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
                tileWindow(client, windows[i].row, windows[i].rowSpan, windows[i].column, windows[i].columnSpan);
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
                text: windows[index].shortcut ? windows[index].shortcut : ""
                Layout.row: windows[index].row
                Layout.rowSpan: windows[index].rowSpan
                Layout.column: windows[index].column
                Layout.columnSpan: windows[index].columnSpan

                onClicked: {
                    mainDialog.raise();
                    mainDialog.requestActivate();
                    focusField.forceActiveFocus();

                    tileWindow(activeClient, windows[index].row, windows[index].rowSpan, windows[index].column, windows[index].columnSpan);

                    if (!clickedWindows.includes(windows[index])) clickedWindows.push(windows[index]);

                    if (hideOnFirstTile) mainDialog.visible = false;
                    if (hideOnLayoutTiled && clickedWindows.length === windows.length) {
                        clickedWindows = [];
                        mainDialog.visible = false;
                    }
                }

                Component.onCompleted: {
                    if (windows[index].shortcut) {
                        tileShortcuts.set(windows[index].shortcut, () => {
                            tileWindow(activeClient, windows[index].row, windows[index].rowSpan, windows[index].column, windows[index].columnSpan);
                        });
                    }
                }
            }
        }
    }
}
