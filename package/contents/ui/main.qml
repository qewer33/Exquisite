import QtQuick 2.0
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0
import org.kde.kirigami 2.20 as Kirigami

import "lib"

PlasmaCore.Dialog {
    id: mainDialog
    location: PlasmaCore.Types.Floating
    flags: Qt.X11BypassWindowManagerHint | Qt.FramelessWindowHint
    visible: false

    property var activeClient
    property var screen

    property int columns: 5
    property int position: 1
    property double tileScale: 1.3
    property bool nameAbove: false
    property bool headerVisible: true
    property bool activeWindowLabelVisible: true
    property bool restartButtonVisible: true
    property bool animationsEnabled: true
    property bool hideOnDesktopClick: true
    property bool hideOnFirstTile: false
    property bool hideOnLayoutTiled: false
    property int tileGap: 0
    property bool rememberWindowGeometries: true
    property bool tileAvailableWindowsOnBackgroundClick: true
    property bool hideTiledWindowTitlebar: false

    property var oldWindowGemoetries: new Map()
    property var tileShortcuts: new Map()

    // On Wayland, all calling raise does is generate a warning message.
    // So if we detect that we are likely on Wayland, disable it going forward.
    property bool suppressRaise: false

    function loadConfig(){
        columns = KWin.readConfig("columns", 5);
        position = KWin.readConfig("position", 1);
        tileScale = KWin.readConfig("tileScale", 1.3);
        nameAbove = KWin.readConfig("nameAbove", false);
        headerVisible = KWin.readConfig("showHeader", true);
        activeWindowLabelVisible = KWin.readConfig("showActiveWindowLabel", true);
        restartButtonVisible = KWin.readConfig("showRestartButton", true);
        animationsEnabled = KWin.readConfig("enableAnimations", true);
        hideOnDesktopClick = KWin.readConfig("hideOnDesktopClick", true);
        hideOnFirstTile = KWin.readConfig("hideOnFirstTile", false);
        hideOnLayoutTiled = KWin.readConfig("hideOnLayoutTiled", false);
        tileGap = KWin.readConfig("tileGap", 0);
        rememberWindowGeometries = KWin.readConfig("rememberWindowGeometries", true);
        tileAvailableWindowsOnBackgroundClick = KWin.readConfig("tileAvailableWindowsOnBackgroundClick", true);
        hideTiledWindowTitlebar = KWin.readConfig("hideTiledWindowTitlebar", false);
    }

    function show() {
        // Get the current screen.
        mainDialog.screen = workspace.clientArea(KWin.MaximizeArea, workspace.activeScreen, workspace.currentDesktop);
        var screen = mainDialog.screen

        // We want layoutsRepeater to regenerate all of it's children.
        // To make that happen, we save the model it is using, set the model to
        // undefined, and then restore the model.
        // It's a hack, but it works.
        var model = layoutsRepeater.model;
        layoutsRepeater.model = undefined;
        layoutsRepeater.model = model;

        focusTimer.running = true;

        activeClient = workspace.activeClient;

        mainDialog.visible = true;

        mainDialog.doRaise(true);

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
        focusTimer.running = false;
        mainDialog.visible = false;
        mainDialog.tileShortcuts.clear();
    }

    function checkRaise() {
        if (suppressRaise) {
            return;
        }
        // This is a horrible hack.
        // But a bug showed that on Wayland, workspace.activeClient is useful, but on X11 that is not the case.
        // And we want to suppress Raise on Wayland.
        if (mainDialog.activeClient != undefined && workspace.activeClient != undefined) {
            suppressRaise = true;
        }
    }

    function doRaise(forceActiveFocus) {
        checkRaise();
        if (!suppressRaise) {
            mainDialog.raise();
        }
        mainDialog.requestActivate();
        if (forceActiveFocus) {
            focusField.forceActiveFocus();
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
                mainDialog.hide();
                connectSource(`bash ${Qt.resolvedUrl("./").replace(/^(file:\/{2})/,"")}restartKWin.sh`);
            }
        }

        RowLayout {
            id: headerRowLayout
            visible: mainDialog.headerVisible

            PlasmaComponents.Label {
                text: " Exquisite"
            }

            Item { Layout.fillWidth: true }

            PlasmaCore.FrameSvgItem {
                width: 22
                height: width
                visible: activeWindowLabelVisible

                PlasmaCore.IconItem {
                    anchors.fill: parent
                    source: activeClient ? activeClient.icon : ""
                }
            }

            PlasmaComponents.Label {
                visible: activeWindowLabelVisible
                text: activeClient ? activeClient.caption : ""
            }

            Item { Layout.fillWidth: true }

            PlasmaComponents.Button {
                text: "Restart KWin"
                icon.name: "view-refresh-symbolic"
                visible: restartButtonVisible
                onClicked: {
                    command.exec()
                }
            }

            PlasmaComponents.Button {
                id: closeButton
                icon.name: "dialog-close"
                flat: true
                onClicked: {
                    mainDialog.hide();
                }
            }
        }

        GridLayout {
            id: gridLayout
            rowSpacing: 10
            columnSpacing: 10
            columns: mainDialog.columns

            Repeater {
                id: layoutsRepeater
                model: FolderListModel {
                    id: folderModel
                    folder: Qt.resolvedUrl("../") + "layouts/"
                    nameFilters: ["*.qml"]
                }

                function childHasFocus() {
                    for (let i = 0; i < layoutsRepeater.count; i++) {
                        let item = layoutsRepeater.itemAt(i);
                        if (item.childHasFocus()) return true;
                    }
                    return false;
                }

                ColumnLayout {
                    id: column
                    function childHasFocus() {
                        return layout.childHasFocus();
                    }

                    PlasmaComponents.Label {
                        id: labelTop
                        visible: nameAbove
                        text: layoutFile.item.name
                        color: Kirigami.Theme.disabledTextColor
                        width: layout.width
                        elide: Text.ElideRight
                        Layout.alignment: Qt.AlignHCenter
                    }

                    WindowLayout {
                        Loader {
                            id: layoutFile
                            source: fileUrl
                        }

                        id: layout
                        windows: layoutFile.item.windows
                        screen: {
                            if (layoutFile.item.screen != undefined) {
                                if (layoutFile.item.screen < workspace.numScreens) {
                                    return workspace.clientArea(KWin.MaximizeArea, layoutFile.item.screen, workspace.currentDesktop);
                                } else {
                                    return workspace.clientArea(KWin.MaximizeArea, 0, workspace.currentDesktop);
                                }
                            } else if (mainDialog.screen != undefined) {
                                return mainDialog.screen;
                            } else {
                                return workspace.clientArea(KWin.MaximizeArea, 0, workspace.currentDesktop);
                            }
                        }
                        main: mainDialog
                    }

                    PlasmaComponents.Label {
                        id: labelBottom
                        visible: !nameAbove
                        text: layoutFile.item.name
                        color: Kirigami.Theme.disabledTextColor
                        width: layout.width
                        elide: Text.ElideRight
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        // This item is a "hack" to handle focus related actions
        PlasmaComponents.TextField {
            id: focusField
            visible: false

            onActiveFocusChanged: {
                mainDialog.doRaise(false);
            }

            Keys.onEscapePressed: mainDialog.hide()
            Keys.onPressed: {
                tileShortcuts.forEach((tileFunction, key) => {
                    let shortcutModifier = key[0] ? key[0] : Qt.NoModifier;
                    let shortcutKey = key[1];
                    if (event.key === shortcutKey && event.modifiers === shortcutModifier) {
                        tileFunction();
                    }
                });
            }
        }

        Connections {
            target: workspace
            function onClientActivated(client) {
                if (!client) return;
                if (hideOnDesktopClick && workspace.activeClient.desktopWindow)
                    mainDialog.hide();

                activeClient = workspace.activeClient;
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

        Timer {
            id: focusTimer
            interval: 100
            repeat: true
            running: false

            onTriggered: {
                if (!focusField.focused && !closeButton.hovered && !layoutsRepeater.childHasFocus()) {
                    mainDialog.doRaise(true);
                }
            }
        }
    }

    Component.onCompleted: {
        options.configChanged.connect(mainDialog.loadConfig);
        KWin.registerWindow(mainDialog);
        KWin.registerShortcut(
            "Exquisite",
            "Exquisite",
            "Ctrl+Alt+D",
            function() {
                if (mainDialog.visible) {
                    mainDialog.hide();
                } else {
                    mainDialog.hide();
                    options.configChanged();
                    mainDialog.show();
                }
            }
        );

        mainDialog.loadConfig();
    }
}
