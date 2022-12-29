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
    implicitWidth: 160*tileScale * PlasmaCore.Units.devicePixelRatio
    implicitHeight: 90*tileScale * PlasmaCore.Units.devicePixelRatio

    property var windows
    property var clickedWindows: []

    function tileWindow(window, x, y, width, height) {
        if (!window.normalWindow) return;
        if (rememberWindowGeometries && !oldWindowGemoetries.has(window)) oldWindowGemoetries.set(window, [window.geometry.width, window.geometry.height]);

        let screen = workspace.clientArea(KWin.MaximizeArea, workspace.activeScreen, window.desktop);

        let xMult = screen.width / 12.0;
        let yMult = screen.height / 12.0;

        let newX = x * xMult;
        let newY = y * yMult;
        let newWidth = width * xMult;
        let newHeight = height * yMult;

        window.setMaximize(false, false);
        window.geometry = Qt.rect(screen.x + newX, screen.y + newY, newWidth, newHeight);
        if (hideTiledWindowTitlebar) window.noBorder = true;
    }

    function autotileWindows() {
        let clientList = [];
        for (let i = 0; i < workspace.clientList().length; i++) {
            let client = workspace.clientList()[i];
            if (client.normalWindow && workspace.currentDesktop === client.desktop &&
                !client.minimized && client.screen === workspace.activeScreen)
                clientList.push(client);
        }

        for (let i = 0; i < clientList.length; i++) {
            if (i >= windows.length || i >= clientList.length) return;
            let client = clientList[i];
            tileWindow(client, windows[i].x, windows[i].y, windows[i].width, windows[i].height);
            workspace.activeClient = client;
        }

        if (hideOnFirstTile || hideOnLayoutTiled) mainDialog.visible = false;
    }

    onClicked: if (tileAvailableWindowsOnBackgroundClick) autotileWindows();

    SpanGridLayout {
        anchors.fill: parent
        anchors.margins: 10
        rows: 12
        columns: 12

        Repeater {
            model: windows.length

            PlasmaComponents.Button {
                Layout.row: windows[index].y || windows[index].row
                Layout.rowSpan: windows[index].width || windows[index].rowSpan
                Layout.column: windows[index].x || windows[index].column
                Layout.columnSpan: windows[index].height || windows[index].columnSpan
                onClicked: {
                    tileWindow(workspace.activeClient, windows[index].x, windows[index].y, windows[index].width, windows[index].height);

                    if (!clickedWindows.includes(windows[index])) clickedWindows.push(windows[index]);

                    if (hideOnFirstTile) mainDialog.visible = false;
                    if (hideOnLayoutTiled && clickedWindows.length === windows.length) {
                        clickedWindows = [];
                        mainDialog.visible = false;
                    }
                }
            }
        }
    }
}
