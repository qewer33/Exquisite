import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.5
import Qt.labs.folderlistmodel 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

import "../lib"

RowLayout {
    id: root

    property int cellWidth: 40
    property int cellHeight: 20
    property var windows: []
    property string layoutName: "New Layout e"

    function refresh() {
        let i = windowListView.currentIndex;
        windowListView.model = undefined;
        windowListView.model = windows;
        windowListView.currentIndex = i;
        windowGridRepeater.model = undefined;
        windowGridRepeater.model = 12*12;
    }

    function save() {
        var db = LocalStorage.openDatabaseSync("ExquisiteCustomLayouts", "1.0", "Custom layouts for the Exquisite KWin script", 1000000);
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Layouts(name TEXT, windows TEXT, UNIQUE(name))');
            tx.executeSql("INSERT OR REPLACE INTO layouts (name, windows) VALUES(?, ?)", [layoutName, JSON.stringify(windows)]);
        });
    }

    function load(_name) {
        var db = LocalStorage.openDatabaseSync("ExquisiteCustomLayouts", "1.0", "Custom layouts for the Exquisite KWin script", 1000000);
        db.transaction(function (tx) {
            let res = tx.executeSql("SELECT * FROM layouts WHERE name = ?", [_name]);
            layoutName = res.rows.item(0).name
            windows = JSON.parse(res.rows.item(0).windows);
            for (let i in windows) {
                windows[i].color = Qt.rgba(Math.random(),Math.random(),Math.random(),1);
            }
        });
        refresh();
    }

    function remove(_name) {
        var db = LocalStorage.openDatabaseSync("ExquisiteCustomLayouts", "1.0", "Custom layouts for the Exquisite KWin script", 1000000);
        db.transaction(function (tx) {
            tx.executeSql("DELETE FROM layouts WHERE name = ?", [_name]);
        });
    }

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("ExquisiteCustomLayouts", "1.0", "Custom layouts for the Exquisite KWin script", 1000000);
        db.transaction(function (tx) {
            let res = tx.executeSql(`SELECT * FROM layouts`);
        });
    }

    Item { Layout.fillWidth: true }

    ColumnLayout {
        width: 150
        Layout.fillHeight: true

        PlasmaComponents.Button {
            id: addButton
            text: "Add Window"
            icon.name: "list-add-symbolic"
            implicitWidth: 150

            onClicked: {
                let randomColor = Qt.rgba(Math.random(),Math.random(),Math.random(),1);
                windows.push(
                    {
                        x: 0,
                        y: 0,
                        width: 5,
                        height: 5,
                        color: randomColor
                    }
                );
                windowListView.currentIndex = windows.length-1;
                refresh();
            }
        }

        ListView {
            id: windowListView
            model: windows
            width: 150
            height: root.height
            highlightFollowsCurrentItem: false
            clip: true
            Layout.fillHeight: true

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                active: true
            }
            highlight: Rectangle {
                color: PlasmaCore.Theme.highlightColor
                radius: 2
                height: addButton.height
                width: !scrollBar.visible ? windowListView.width : windowListView.width - scrollBar.width
                y: windowListView.currentItem ? windowListView.currentItem.y : 0
            }
            delegate: MouseArea {
                id: delegateMouseArea
                width: !scrollBar.visible ? parent.width : parent.width - scrollBar.width
                height: childrenRect.height
                onClicked: {
                    windowListView.currentIndex = index;
                    refresh();
                }

                RowLayout {
                    width: parent.width

                    Rectangle {
                        width: 16
                        height: 16
                        radius: 999
                        color: windows[index].color
                    }

                    PlasmaComponents.Label {
                        text: " Window " + index
                        Layout.fillWidth: true
                    }

                    PlasmaComponents.Button {
                        icon.name: "edit-delete-remove"

                        onClicked: {
                            windows.splice(index, 1);
                            refresh();
                        }
                    }
                }
            }
        }
    }

    GridLayout {
        id: grid
        rowSpacing: 0
        columnSpacing: 0
        columns: 12
        rows: 12
        Layout.fillHeight: true
        Layout.fillWidth: true

        property bool dragging: false
        property int currentX: 0
        property int currentY: 0
        property int clickX: 0
        property int clickY: 0

        Repeater {
            id: windowGridRepeater
            model: 12*12

            Rectangle {
                property int rectY: Math.floor(index/12)
                property int rectX: index - rectY*12

                implicitWidth: cellWidth
                implicitHeight: cellHeight
                color: {
                    for (let i in windows) {
                        let window = windows.slice().reverse()[i];

                        if (grid.dragging && rectX >= grid.clickX && rectX <= grid.currentX &&
                            rectY >= grid.clickY && rectY <= grid.currentY) {
                            return PlasmaCore.Theme.highlightColor;
                        }

                        if (rectX >= window.x && rectX < window.x + window.width &&
                            rectY >= window.y && rectY < window.y + window.height) {
                            return window.color;
                        }
                    }
                    return PlasmaCore.Theme.disabledTextColor;
                }
                border.color: {
                    for (let i in windows) {
                        let window = windows[i];

                        if (rectX >= window.x && rectX < window.x + window.width &&
                            rectY >= window.y && rectY < window.y + window.height) {
                            if (i == windowListView.currentIndex) return PlasmaCore.Theme.highlightColor;
                        }
                    }
                    return PlasmaCore.Theme.backgroundColor;
                }
                border.width: 1
            }
        }

        MouseArea {
            anchors.fill: parent

            function getRectX() {
                var pos = grid.mapToItem(grid, 0, 0);
                return Math.round((mouseX - pos.x - root.cellWidth/2) / root.cellWidth);
            }

            function getRectY() {
                var pos = grid.mapToItem(grid, 0, 0);
                return Math.round((mouseY - pos.y - root.cellHeight/2) / root.cellHeight);
            }

            onPressed: {
                grid.dragging = true;
                grid.clickX = getRectX();
                grid.clickY = getRectY();
                grid.currentX = getRectX();
                grid.currentY = getRectY();
            }
            onPositionChanged: {
                grid.currentX = getRectX();
                grid.currentY = getRectY();
            }
            onReleased: {
                grid.dragging = false;
                windows[windowListView.currentIndex] = {
                    x: grid.clickX,
                    y: grid.clickY,
                    width: grid.currentX - grid.clickX + 1,
                    height: grid.currentY - grid.clickY + 1,
                    color: windows[windowListView.currentIndex].color
                };
                refresh();
            }
        }
    }

    Item { Layout.fillWidth: true }
}
