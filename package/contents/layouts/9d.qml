import QtQuick 2.5

Item {
    property string name: "1:4 Left Sidebar Double Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 4,
            height: 12
        },
        {
            x: 4,
            y: 0,
            width: 8,
            height: 6
        },
        {
            x: 4,
            y: 6,
            width: 8,
            height: 6
        }
    ]
}
