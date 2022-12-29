import QtQuick 2.6

Item {
    property string name: "Two Horizontal Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 12,
            height: 6
        },
        {
            x: 0,
            y: 6,
            width: 12,
            height: 6
        }
    ]
}
