import QtQuick 2.5

Item {
    property string name: "1:2:1 Triple Horizontal Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 12,
            height: 3
        },
        {
            x: 0,
            y: 3,
            width: 12,
            height: 6
        },
        {
            x: 0,
            y: 9,
            width: 12,
            height: 3
        }
    ]
}
