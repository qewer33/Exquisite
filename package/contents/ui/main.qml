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

    property int columns: 4
    property int rows: 2
    property int position: 1
    property double tileScale: 1.3
    property bool pagesUIVisible: true
    property bool headerVisible: true
    property bool restartButtonVisible: true
    property bool animationsEnabled: true
    property bool helpButtonVisible: true
    property bool hideOnDesktopClick: true
    property bool hideOnFirstTile: false
    property bool hideOnLayoutTiled: false
    property bool rememberWindowGeometries: true
    property bool tileAvailableWindowsOnBackgroundClick: true
    property bool hideTiledWindowTitlebar: false

    property var oldWindowGemoetries: new Map()

    function loadConfig(){
        columns = KWin.readConfig("columns", 4);
        rows = KWin.readConfig("rows", 2);
        tileScale = KWin.readConfig("tileScale", 1.3);
        position = KWin.readConfig("position", 1);
        pagesUIVisible = KWin.readConfig("showPagesUI", true);
        headerVisible = KWin.readConfig("showHeader", true);
        restartButtonVisible = KWin.readConfig("showRestartButton", true);
        helpButtonVisible = KWin.readConfig("showHelpButton", true);
        animationsEnabled = KWin.readConfig("enableAnimations", true);
        hideOnDesktopClick = KWin.readConfig("hideOnDesktopClick", true);
        hideOnFirstTile = KWin.readConfig("hideOnFirstTile", false);
        hideOnLayoutTiled = KWin.readConfig("hideOnLayoutTiled", false);
        rememberWindowGeometries = KWin.readConfig("rememberWindowGeometries", true);
        tileAvailableWindowsOnBackgroundClick = KWin.readConfig("tileAvailableWindowsOnBackgroundClick", true);
        hideTiledWindowTitlebar = KWin.readConfig("hideTiledWindowTitlebar", false);
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

    function hide() {
        mainDialog.visible = false;
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
            Layout.fillWidth: true

            PlasmaComponents.Label {
                text: " Exquisite"
                Layout.fillWidth: true
            }

            RowLayout {
                id: headerButtons

                PlasmaComponents.Button {
                    text: "Restart KWin"
                    icon.name: "view-refresh-symbolic"
                    flat: true
                    visible: restartButtonVisible
                    onClicked: {
                        command.exec()
                    }
                }

                PlasmaComponents.Button {
                    text: "Help"
                    icon.name: "question"
                    flat: true
                    visible: helpButtonVisible
                    onClicked: {
                        Qt.openUrlExternally("https://github.com/qewer33/Exquisite#exquisite")
                    }
                }

                PlasmaComponents.Button {
                    icon.name: "dialog-close"
                    flat: true
                    onClicked: {
                        mainDialog.visible = false;
                    }
                }
            }
        }

        RowLayout {
            PlasmaComponents.Button {
                icon.name: "arrow-left"
                flat: true
                Layout.fillHeight: true
                enabled: pageIndicator.currentPage !== 0
                visible: pagesUIVisible

                onClicked: pageIndicator.currentPage--
            }

            GridLayout {
                id: gridLayout
                implicitHeight: windowLayout*2
                rowSpacing: 10
                columnSpacing: 10
                columns: mainDialog.columns
                rows: mainDialog.rows
                Layout.fillWidth: true

                FolderListModel {
                    id: folderModel
                    folder: Qt.resolvedUrl("../") + "layouts/"
                    nameFilters: ["*.qml"]
                }

                Repeater {
                    model: folderModel

                    WindowLayout {
                        id: windowLayout

                        Loader {
                            id: layoutFile
                            source: fileUrl
                        }

                        visible: index >= pageIndicator.currentPage * columns * rows && index < (pageIndicator.currentPage+1) * columns * rows
                        windows: layoutFile.item.windows

                        scale: animationsEnabled ? visible ? 1.0 : 0.5 : 1.0
                        Behavior on scale {
                            NumberAnimation  { duration: 400 ; easing.type: Easing.OutQuad  }
                        }
                        opacity: animationsEnabled ? visible ? 1.0 : 0.3 : 1.0
                        Behavior on opacity {
                            NumberAnimation  { duration: 550 }
                        }
                    }
                }

                Repeater {
                    model: pageIndicator.pageCount * rows * columns

                    Rectangle {
                        implicitWidth: 160*tileScale * PlasmaCore.Units.devicePixelRatio
                        implicitHeight: 90*tileScale * PlasmaCore.Units.devicePixelRatio
                        color: "transparent"
                        visible: pageIndicator.currentPage === pageIndicator.pageCount-1 && index >= folderModel.count && index < pageIndicator.pageCount * rows * columns
                    }
                }
            }

            PlasmaComponents.Button {
                icon.name: "arrow-right"
                flat: true
                Layout.fillHeight: true
                enabled: pageIndicator.currentPage !== pageIndicator.pageCount-1
                visible: pagesUIVisible

                onClicked: pageIndicator.currentPage++
            }
        }

        PageIndicator {
            id: pageIndicator
            Layout.alignment: Qt.AlignCenter
            visible: pagesUIVisible
            pageCount: Math.ceil(folderModel.count/(rows*columns))
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

                if (hideTiledWindowTitlebar) workspace.activeClient.noBorder = false;
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
                    mainDialog.hide();
                } else {
                    mainDialog.loadConfig();
                    mainDialog.show();
                }
            }
        );

        mainDialog.loadConfig();
    }
}
