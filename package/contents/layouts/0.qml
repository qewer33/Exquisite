import QtQuick 2.6

Item {
    property string name: "Two Vertical Split"
    property var windows: [
        {
            shortcut: "CTRL+ALT+1",
            row: 0,
            rowSpan: 6,
            column: 0,
            columnSpan: 12,
        },
        {
            shortcut: "CTRL+ALT+2",
            row: 0,
            rowSpan: 6,
            column: 6,
            columnSpan: 12
        }
    ]
}

