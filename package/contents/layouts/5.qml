import QtQuick 2.6

Item {
    property string name: "Two Up One Down"
    property var windows: [
        {
            row: 0,
            rowSpan: 6,
            column: 0,
            columnSpan: 6
        },
        {
            row: 0,
            rowSpan: 6,
            column: 6,
            columnSpan: 6
        },
        {
            row: 6,
            rowSpan: 12,
            column: 0,
            columnSpan: 6
        }
    ]
}

