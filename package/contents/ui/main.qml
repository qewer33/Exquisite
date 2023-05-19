import QtQuick 2.0
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

import "pages"
import "lib"

PlasmaCore.Dialog {
    id: mainDialog
    width: viewPage.width + 2*PlasmaCore.Units.mediumSpacing
    height: mainColumnLayout.height + PlasmaCore.Units.mediumSpacing
    type: PlasmaCore.Dialog.WindowType.AppletPopup
    location: PlasmaCore.Types.Floating
    flags: Qt.X11BypassWindowManagerHint | Qt.FramelessWindowHint
    visible: false

    property int position: workspace.cursorPos ? 3 : 1
    property int columns: 4
    property int rows: 2
    property double tileScale: 1.3
    property bool pagesUIVisible: true
    property bool headerVisible: true
    property bool restartButtonVisible: true
    property bool animationsEnabled: true
    property bool hideOnDesktopClick: true
    property bool hideOnFirstTile: false
    property bool hideOnLayoutTiled: false
    property bool rememberWindowGeometries: true
    property bool tileAvailableWindowsOnBackgroundClick: true
    property bool hideTiledWindowTitlebar: false

    property bool layoutEditMode: false
    property bool viewEditMode: false

    property var oldWindowGemoetries: new Map()

    function loadConfig(){
        position = KWin.readConfig("position", workspace.cursorPos ? 3 : 1);
        columns = KWin.readConfig("columns", 4);
        rows = KWin.readConfig("rows", 2);
        tileScale = KWin.readConfig("tileScale", 1.3);
        pagesUIVisible = KWin.readConfig("showPagesUI", true);
        headerVisible = KWin.readConfig("showHeader", true);
        restartButtonVisible = KWin.readConfig("showRestartButton", true);
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
        switch (position) {
            case 0:
                mainDialog.x = screen.x + screen.width/2 - mainDialog.width/2;
                mainDialog.y = screen.y;
                break;
            case 1:
                mainDialog.x = screen.x + screen.width/2 - mainDialog.width/2;
                mainDialog.y = screen.y + screen.height/2 - mainDialog.height/2;
                break;
            case 2:
                mainDialog.x = screen.x + screen.width/2 - mainDialog.width/2;
                mainDialog.y = screen.y + screen.height - mainDialog.height;
                break;
            case 3:
                if (workspace.cursorPos.x > screen.x + screen.width - mainDialog.width/2)
                    mainDialog.x = workspace.cursorPos.x - mainDialog.width;
                else if (workspace.cursorPos.x < screen.x + mainDialog.width/2)
                    mainDialog.x = workspace.cursorPos.x;
                else
                    mainDialog.x = workspace.cursorPos.x - mainDialog.width/2;

                if (workspace.cursorPos.y > screen.y + screen.height - mainDialog.height/2)
                    mainDialog.y = workspace.cursorPos.y - mainDialog.height;
                else if (workspace.cursorPos.y < screen.y + mainDialog.height/2)
                    mainDialog.y = workspace.cursorPos.y;
                else
                    mainDialog.y = workspace.cursorPos.y - mainDialog.height/2;
                break;
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

                PlasmaComponents.TextField {
                    text: editPage.layoutName
                    visible: layoutEditMode
                    onActiveFocusChanged: {
                        mainDialog.raise();
                        mainDialog.requestActivate();
                    }
                    onEditingFinished: editPage.layoutName = text;
                }

                PlasmaComponents.Button {
                    text: "Save"
                    icon.name: "document-save-symbolic"
                    flat: true
                    visible: layoutEditMode
                    onClicked: {
                        layoutEditMode = false;
                        editPage.save();
                        viewPage.refreshCustomLayouts();
                    }
                }

                PlasmaComponents.Button {
                    text: "Cancel"
                    icon.name: "edit-delete-remove"
                    flat: true
                    visible: layoutEditMode
                    onClicked: {
                        layoutEditMode = false;
                    }
                }

                PlasmaComponents.Button {
                    text: "New Layout"
                    icon.name: "list-add-symbolic"
                    flat: true
                    visible: !layoutEditMode
                    onClicked: {
                        mainDialog.raise();
                        mainDialog.requestActivate();
                        layoutEditMode = true;
                        editPage.layoutName = "New Layout";
                        editPage.windows = [];
                        editPage.refresh();
                    }
                }

                PlasmaComponents.Button {
                    text: !viewEditMode ? "Edit Mode" : "Exit Edit Mode"
                    icon.name: !viewEditMode ? "edit-symbolic" : "edit-delete-remove"
                    flat: true
                    visible: !layoutEditMode
                    onClicked: {
                        viewEditMode = !viewEditMode;
                    }
                }

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
                    icon.name: "dialog-close"
                    flat: true
                    onClicked: {
                        mainDialog.visible = false;
                    }
                }
            }
        }

        ViewPage {
            id: viewPage
            visible: !layoutEditMode
        }

        EditPage {
            id: editPage
            visible: layoutEditMode
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
