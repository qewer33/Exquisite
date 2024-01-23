import QtQuick 2.5

Item {
    property string name: "1:2:1 Triple Split"
    property var windows: [
        {
            row: 0,
            rowSpan: 3,
            column: 0,
            columnSpan: 12
        },
        {
            row: 0,
            rowSpan: 6,
            column: 3,
            columnSpan: 12
        },
        {
            row: 0,
            rowSpan: 3,
            column: 9,
            columnSpan: 12
        }
    ]
}
