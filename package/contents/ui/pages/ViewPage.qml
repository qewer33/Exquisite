import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

import "../lib"

ColumnLayout {
    id: root

    Component {
        id: folderListModelComponent
        FolderListModel {
            folder: ""
            nameFilters: []
        }
    }

    function refresh() {
        for (let i = 0; i < customLayoutsRepeater.count; i++) {
            console.log(customLayoutsRepeater.itemAt(i).name + " : " + fileIO.name)
            if (customLayoutsRepeater.itemAt(i).name === fileIO.name) {
                customLayoutsRepeater.itemAt(i).windows = [];
                customLayoutsRepeater.itemAt(i).windows = fileIO.windows;
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

            FolderListModel {
                id: customLayoutsFolderModel
                folder: "/home/qewer33/.config/exquisite/customLayouts/"
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
                model: customLayoutsFolderModel

                WindowLayout {
                    id: windowLayout

                    Loader {
                        id: layoutFile
                        source: fileUrl
                    }

                    visible: defaultLayoutsFolderModel.count+index >= pageIndicator.currentPage * columns * rows && defaultLayoutsFolderModel.count+index < (pageIndicator.currentPage+1) * columns * rows
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
                model: pageIndicator.pageCount * rows * columns

                Rectangle {
                    implicitWidth: 160*tileScale * PlasmaCore.Units.devicePixelRatio
                    implicitHeight: 90*tileScale * PlasmaCore.Units.devicePixelRatio
                    color: "transparent"
                    visible: {
                        pageIndicator.currentPage === pageIndicator.pageCount-1 &&
                        index >= defaultLayoutsFolderModel.count + customLayoutsFolderModel.count &&
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
        pageCount: Math.ceil((defaultLayoutsFolderModel.count+customLayoutsFolderModel.count)/(rows*columns))
    }
}
