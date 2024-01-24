import QtQuick 2.5

Item {
    property string name: "Four Tiled"
    property var windows: [
        {
            row: 0,
            rowSpan: 6,
            column: 0,
            columnSpan: 6,
            shortcut: "1"
        },
        {
            row: 0,
            rowSpan: 6,
            column: 6,
            columnSpan: 6,
            shortcut: "2"
        },
        {
            row: 6,
            rowSpan: 6,
            column: 0,
            columnSpan: 6,
            shortcut: "3"
        },
        {
            row: 6,
            rowSpan: 6,
            column: 6,
            columnSpan: 6,
            shortcut: "4"
        }
    ]
}
