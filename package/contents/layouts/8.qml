import QtQuick 2.5

Item {
    property string name: "1:2:1 Triple Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 3,
            height: 12
        },
        {
            x: 3,
            y: 0,
            width: 6,
            height: 12
        },
        {
            x: 9,
            y: 0,
            width: 3,
            height: 12
        }
    ]
}
