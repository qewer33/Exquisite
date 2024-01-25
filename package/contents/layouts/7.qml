import QtQuick 2.5

Item {
    property string name: "Three Vertical Split"
    property var windows: [
        {
            x: 0,
            y: 0,
            width: 4,
            height: 12,
            shortcutModifier: Qt.AltModifier,
            shortcutKey: Qt.Key_A
        },
        {
            x: 4,
            y: 0,
            width: 4,
            height: 12,
            shortcutModifier: Qt.AltModifier,
            shortcutKey: Qt.Key_S
        },
        {
            x: 8,
            y: 0,
            width: 4,
            height: 12,
            shortcutModifier: Qt.AltModifier,
            shortcutKey: Qt.Key_D
        }
    ]
}
