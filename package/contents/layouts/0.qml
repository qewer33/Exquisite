import QtQuick 2.6

Item {
    property string name: "Two Vertical Split"
    property var windows: [
        {
            row: 0,
            rowSpan: 6,
            column: 0,
            columnSpan: 12,
            shortcutModifier: Qt.ControlModifier,
            shortcutKey: Qt.Key_A
        },
        {
            row: 0,
            rowSpan: 6,
            column: 6,
            columnSpan: 12,
            shortcutModifier: Qt.AltModifier,
            shortcutKey: Qt.Key_S
        }
    ]
}

