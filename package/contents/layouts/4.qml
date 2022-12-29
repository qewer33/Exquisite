import QtQuick 2.6

Item {
    property string name: "One Up Two Down"
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
            width: 6,
            height: 6
        },
        {
            x: 6,
            y: 6,
            width: 6,
            height: 6
        }
    ]
}

