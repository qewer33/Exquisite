import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kwin 2.0

Item {
    property string name: ""
    property string path: ""
    property var windows: []
    property string fileBegin: `import QtQuick 2.5; \n\n Item { \n property string name: \\"${name}\\"; \n property var windows:`
    property string fileEnd: `}`

    function save(_name, _path, _windows) {
        name = _name;
        path = _path;
        windows = _windows;
        for (let i in windows) {
            delete windows[i].color;
        }
        saveCommand.exec();
    }

    function load(_name, _path) {
        name = _name;
        path = _path;
        loadCommand.exec();
    }

    function remove(_name, _path) {
        name = _name;
        path = _path;
        removeCommand.exec();
    }

    PlasmaCore.DataSource {
        id: saveCommand
        engine: "executable"
        connectedSources: []
        onNewData: {
            disconnectSource(sourceName);
        }

        function exec() {
            connectSource(`echo "${fileBegin + JSON.stringify(windows).replace(/"/g, "") + fileEnd}" > ${path + name}.qml`);
        }
    }

    PlasmaCore.DataSource {
        id: loadCommand
        engine: "executable"
        connectedSources: []
        onNewData: {
            var stdout = data["stdout"];
            stdout = stdout.substring(fileBegin.length-2, stdout.length-2);
            // eval here is a bad idea but you can't do anything necessarily
            // dangerous with KWin scripts and Plasma JS scripting either
            // way since the APIs are limited but I'll try to make this in a
            // safe way once I get time for it
            windows = eval(stdout);
            for (let i in windows) {
                windows[i].color = Qt.rgba(Math.random(),Math.random(),Math.random(),1);
            }
            disconnectSource(sourceName);
        }

        function exec() {
            connectSource(`cat ${path + name}.qml`);
        }
    }

    PlasmaCore.DataSource {
        id: removeCommand
        engine: "executable"
        connectedSources: []
        onNewData: {
            disconnectSource(sourceName);
        }

        function exec() {
            connectSource(`rm ${path + name}.qml`);
        }
    }
}
