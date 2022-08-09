import QtQuick 2.0
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

import "lib"

PlasmaCore.Dialog {
    id: mainDialog
    location: PlasmaCore.Types.Floating
    flags: Qt.X11BypassWindowManagerHint | Qt.FramelessWindowHint
    visible: false

    property int columns: 5
    property int position: 1
    property bool headerVisible: true
    property bool restartButtonVisible: true
    property bool helpButtonVisible: true
    property bool hideOnDesktopClick: true
    property bool hideOnFirstTile: false
    property bool hideOnLayoutTiled: false
    property bool rememberWindowGeometries: true
    property bool tileAvailableWindowsOnBackgroundClick: true

    property var oldWindowGemoetries: new Map()

    function loadConfig(){
        columns = KWin.readConfig("columns", 5);
        position = KWin.readConfig("position", 1);
        headerVisible = KWin.readConfig("showHeader", true);
        restartButtonVisible = KWin.readConfig("showRestartButton", true);
        helpButtonVisible = KWin.readConfig("showHelpButton", true);
        hideOnDesktopClick = KWin.readConfig("hideOnDesktopClick", true);
        hideOnFirstTile = KWin.readConfig("hideOnFirstTile", false);
        hideOnLayoutTiled = KWin.readConfig("hideOnLayoutTiled", false);
        rememberWindowGeometries = KWin.readConfig("rememberWindowGeometries", true);
        tileAvailableWindowsOnBackgroundClick = KWin.readConfig("tileAvailableWindowsOnBackgroundClick", true);
    }

    function show() {
        var screen = workspace.clientArea(KWin.FullScreenArea, workspace.activeScreen, workspace.currentDesktop);
        mainDialog.visible = true;
        if (position === 1) {
            mainDialog.x = screen.x + screen.width/2 - mainDialog.width/2;
            mainDialog.y = screen.y + screen.height/2 - mainDialog.height/2;
        } else if (position === 0) {
            mainDialog.x = screen.x + screen.width/2 - mainDialog.width/2;
            mainDialog.y = screen.y;
        } else if (position === 2) {
            mainDialog.x = screen.x + screen.width/2 - mainDialog.width/2;
            mainDialog.y = screen.y + screen.height - mainDialog.height;
        }
    }

    ColumnLayout {
        id: mainColumnLayout

        PlasmaCore.DataSource {
            id: command
            engine: "executable"
            connectedSources: []
            onNewData: {
                disconnectSource(sourceName);
            }
            function exec() {
                mainDialog.visible = false;
                connectSource(`bash ${Qt.resolvedUrl("./").replace(/^(file:\/{2})/,"")}restartKWin.sh`);
            }
        }

        RowLayout {
            id: headerRowLayout
            visible: mainDialog.headerVisible

            PlasmaComponents.Label {
                text: " Exquisite"
                Layout.fillWidth: true
            }

            PlasmaComponents.Button {
                text: "Restart KWin"
                icon.name: "view-refresh-symbolic"
                visible: restartButtonVisible
                onClicked: {
                    command.exec()
                }
            }

            PlasmaComponents.Button {
                icon.name: "question"
                visible: helpButtonVisible
                onClicked: {
                    Qt.openUrlExternally("https://github.com/qewer33/Exquisite#exquisite")
                }
            }

            PlasmaComponents.Button {
                icon.name: "dialog-close"
                onClicked: {
                    mainDialog.visible = false;
                }
            }
        }

        GridLayout {
            id: gridLayout
            rowSpacing: 10
            columnSpacing: 10
            columns: mainDialog.columns

            Repeater {
                model: FolderListModel {
                    id: folderModel

                    folder: Qt.resolvedUrl("../") + "layouts/"

                    nameFilters: ["*.qml"]
                }

                WindowLayout {
                    Loader {
                        id: layoutFile
                        source: fileUrl
                    }

                    windows: layoutFile.item.windows
                }
            }
        }

        Connections {
            target: workspace
            function onClientActivated(client) {
                if (!client) return;
                if (hideOnDesktopClick && workspace.activeClient.desktopWindow)
                    mainDialog.visible = false;
            }
        }

        Connections {
            target: options
            function onConfigChanged() {
                mainDialog.loadConfig();
            }
        }

        Connections {
            target: workspace.activeClient
            function onMoveResizedChanged() {
                if (rememberWindowGeometries) {
                    let focusedWindow = workspace.activeClient;

                    if (oldWindowGemoetries.has(focusedWindow)) {
                        let newSize = oldWindowGemoetries.get(focusedWindow);
                        focusedWindow.geometry = Qt.rect(focusedWindow.geometry.x, focusedWindow.geometry.y, newSize[0], newSize[1]);
                        oldWindowGemoetries.delete(focusedWindow);
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        KWin.registerWindow(mainDialog);
        KWin.registerShortcut(
            "Exquisite",
            "Exquisite",
            "Ctrl+Alt+D",
            function() {
                if (mainDialog.visible) {
                    mainDialog.visible = false;
                } else {
                    mainDialog.loadConfig();
                    mainDialog.show();
                }
            }
        );

        mainDialog.loadConfig();
    }
}
