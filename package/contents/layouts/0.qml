import QtQuick 2.6

Item {
    property string name: "Two Vertical Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 6,
            height: 12,
            shortcutModifier: Qt.ControlModifier,
            shortcutKey: Qt.Key_A
        },
        {
            x: 6,
            y: 0,
            width: 6,
            height: 12,
            shortcutModifier: Qt.ControlModifier,
            shortcutKey: Qt.Key_S
        }
    ]
}

