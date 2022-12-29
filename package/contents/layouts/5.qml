import QtQuick 2.6

Item {
    property string name: "Two Up One Down"
    property var windows: [
        {
            x: 0,
            y: 6,
            width: 12,
            height: 6
        },
        {
            x: 0,
            y: 0,
            width: 6,
            height: 6
        },
        {
            x: 6,
            y: 0,
            width: 6,
            height: 6
        }
    ]
}

