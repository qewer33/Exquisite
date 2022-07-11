import QtQuick 2.5

Item {
    property string name: "Three Vertical Split"
    property var windows: [
        {
            row: 0,
            rowSpan: 4,
            column: 0,
            columnSpan: 12
        },
        {
            row: 0,
            rowSpan: 4,
            column: 4,
            columnSpan: 12
        },
        {
            row: 0,
            rowSpan: 4,
            column: 8,
            columnSpan: 12
        }
    ]
}
