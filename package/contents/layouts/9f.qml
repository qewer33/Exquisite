import QtQuick 2.5

Item {
    property string name: "Six Tile Grid"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 4,
            height: 6
        },
        {
            x: 4,
            y: 0,
            width: 4,
            height: 6
        },
        {
            x: 8,
            y: 0,
            width: 4,
            height: 6
        },
        {
            x: 0,
            y: 6,
            width: 4,
            height: 6
        },
        {
            x: 4,
            y: 6,
            width: 4,
            height: 6
        },
        {
            x: 8,
            y: 6,
            width: 4,
            height: 6
        },
    ]
}
