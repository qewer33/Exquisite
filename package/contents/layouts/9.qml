import QtQuick 2.5

Item {
    property string name: "1:3 Left Sidebar"
    property var windows: [
        {
            row: 0,
            rowSpan: 3,
            column: 0,
            columnSpan: 12
        },
        {
            row: 0,
            rowSpan: 9,
            column: 3,
            columnSpan: 12
        }
    ]
}
