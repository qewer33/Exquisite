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
    property bool maximizeOnBackgroundClick: true
    property var clickedWindows: []

    onClicked: {
        if (root.maximizeOnBackgroundClick) {
            workspace.activeClient.setMaximize(true, true);
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
                    let focusedWindow = workspace.activeClient;
                    if (focusedWindow.desktopWindow) return;

                    if (!focusedWindow.normalWindow) return;

                    let screen = workspace.clientArea(KWin.MaximizeArea, workspace.activeScreen, focusedWindow.desktop);

                    let xMult = screen.width / 12.0;
                    let yMult = screen.height / 12.0;

                    let newX = windows[index].column * xMult;
                    let newY = windows[index].row * yMult;
                    let newWidth = windows[index].rowSpan * xMult;
                    let newHeight = windows[index].columnSpan * yMult;

                    focusedWindow.setMaximize(false, false);
                    focusedWindow.geometry = Qt.rect(screen.x + newX, screen.y + newY, newWidth, newHeight);

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
