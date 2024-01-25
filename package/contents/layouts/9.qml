import QtQuick 2.5

Item {
    property string name: "Three Horizontal Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 12,
            height: 4
        },
        {
            x: 0,
            y: 4,
            width: 12,
            height: 4
        },
        {
            x: 0,
            y: 8,
            width: 12,
            height: 4
        }
    ]
}
