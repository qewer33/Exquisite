import QtQuick 2.5

Item {
    property string name: "Three Horizontal Split"
    property var windows: [
        {
            row: 0,
            rowSpan: 12,
            column: 0,
            columnSpan: 4
        },
        {
            row: 4,
            rowSpan: 12,
            column: 0,
            columnSpan: 4
        },
        {
            row: 8,
            rowSpan: 12,
            column: 0,
            columnSpan: 4
        }
    ]
}
