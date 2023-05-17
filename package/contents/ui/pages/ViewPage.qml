import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.5
import Qt.labs.folderlistmodel 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

import "../lib"

ColumnLayout {
    id: root

    function refreshCustomLayouts() {
        var db = LocalStorage.openDatabaseSync("ExquisiteCustomLayouts", "1.0", "Custom layouts for the Exquisite KWin script", 1000000);
        let rw = [];
        db.transaction(function (tx) {
            let res = tx.executeSql(`SELECT * FROM layouts`);
            for (let i = 0; i < res.rows.length; i++) {
                rw.push(res.rows.item(i));
            }
        });
        customLayoutsRepeater.model = undefined;
        customLayoutsRepeater.model = rw;
        customLayoutsRepeater.visible = false;
        customLayoutsRepeater.visible = true;
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
            rowSpacing: 10
            columnSpacing: 10
            columns: mainDialog.columns
            rows: mainDialog.rows
            Layout.fillWidth: true

            FolderListModel {
                id: defaultLayoutsFolderModel
                folder: Qt.resolvedUrl("../../") + "layouts/"
                nameFilters: ["*.qml"]
            }

            Repeater {
                id: defaultLayoutsRepeater
                model: defaultLayoutsFolderModel

                WindowLayout {
                    id: windowLayout

                    Loader {
                        id: layoutFile
                        source: fileUrl
                    }

                    visible: index >= pageIndicator.currentPage * columns * rows && index < (pageIndicator.currentPage+1) * columns * rows
                    isDefault: true
                    showName: viewEditMode
                    name: layoutFile.item.name
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
                id: customLayoutsRepeater
                model: []

                Component.onCompleted: refreshCustomLayouts();

                WindowLayout {
                    id: windowLayout

                    visible: defaultLayoutsFolderModel.count+index >= pageIndicator.currentPage * columns * rows && defaultLayoutsFolderModel.count+index < (pageIndicator.currentPage+1) * columns * rows
                    showName: viewEditMode
                    name: modelData.name
                    windows: JSON.parse(modelData.windows)

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
                id: fillerRepeater
                model: pageIndicator.pageCount * rows * columns

                Rectangle {
                    implicitWidth: 160*tileScale * PlasmaCore.Units.devicePixelRatio
                    implicitHeight: 90*tileScale * PlasmaCore.Units.devicePixelRatio
                    color: "transparent"
                    visible: {
                        pageIndicator.currentPage === pageIndicator.pageCount-1 &&
                        index >= defaultLayoutsFolderModel.count + customLayoutsRepeater.model.length &&
                        index < pageIndicator.pageCount * rows * columns
                    }
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
        pageCount: Math.ceil((16+customLayoutsRepeater.model.length)/(mainDialog.rows*mainDialog.columns))
    }
}
