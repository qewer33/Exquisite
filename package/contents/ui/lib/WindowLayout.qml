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

    property var layoutIndex
    property var windows
    property var clickedWindows: []

    function tileWindow(window, row, rowSpan, column, columnSpan) {
        if (!window.normalWindow) return;
        if (rememberWindowGeometries && !oldWindowGemoetries.has(window)) oldWindowGemoetries.set(window, [window.geometry.width, window.geometry.height]);

        let screen = workspace.clientArea(KWin.MaximizeArea, workspace.activeScreen, window.desktop);

        let xMult = screen.width / 12.0;
        let yMult = screen.height / 12.0;

        let newX = column * xMult;
        let newY = row * yMult;
        let newWidth = rowSpan * xMult;
        let newHeight = columnSpan * yMult;

        window.setMaximize(false, false);
        window.geometry = Qt.rect(screen.x + newX, screen.y + newY, newWidth, newHeight);
    }

    onClicked: {
        if (tileAvailableWindowsOnBackgroundClick) {
            let clientList = [];
            for (let i = 0; i < workspace.clientList().length; i++) {
                let client = workspace.clientList()[i];
                if (client.normalWindow && workspace.currentDesktop === client.desktop && !client.minimized)
                    clientList.push(client);
            }

            for (let i = 0; i < clientList.length; i++) {
                console.log(`${i}:${windows.length}:${clientList.length}`);
                if (i >= windows.length || i >= clientList.length) return;
                let client = clientList[i];
                tileWindow(client, windows[i].row, windows[i].rowSpan, windows[i].column, windows[i].columnSpan);
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
            model: windows.length

            PlasmaComponents.Button {
                Layout.row: windows[index].row
                Layout.rowSpan: windows[index].rowSpan
                Layout.column: windows[index].column
                Layout.columnSpan: windows[index].columnSpan

                onClicked: {
                    tileWindow(workspace.activeClient, windows[index].row, windows[index].rowSpan, windows[index].column, windows[index].columnSpan);

                    if (!clickedWindows.includes(windows[index])) clickedWindows.push(windows[index]);

                    if (hideOnFirstTile) mainDialog.visible = false;
                    if (hideOnLayoutTiled && clickedWindows.length === windows.length) {
                        clickedWindows = [];
                        mainDialog.visible = false;
                    }
                }

                PlasmaComponents.Label {
                    anchors.fill: parent
                    text: windows[index].shortcut ? windows[index].shortcut : ""
                    minimumPixelSize: 5
                    minimumPointSize: 2
                    fontSizeMode: Text.HorizontalFit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Component.onCompleted: {
                    if (windows[index].shortcut) {
                        let id = "Exquisite Layout " + layoutIndex + " Window  " + index;
                        let row = windows[index].row;
                        let rowSpan = windows[index].rowSpan;
                        let column = windows[index].column;
                        let columnSpan = windows[index].columnSpan;

                        KWin.registerShortcut(
                            id,
                            id,
                            windows[index].shortcut,
                            function() {
                                tileWindow(workspace.activeClient, row, rowSpan, column, columnSpan);
                            }
                        );
                    }
                }
            }
        }
    }
}
