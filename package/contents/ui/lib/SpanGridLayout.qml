// formatted and modified version of:
// https://stackoverflow.com/questions/61803473/qml-gridlayout-row-and-column-span-understanding

import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {
    id: layout

    property int rows: 12
    property int columns: 12
    property int rowSpacing: 3
    property int columnSpacing: 3

    onChildrenChanged: updatePreferredSizes()
    onWidthChanged: updatePreferredSizes()
    onHeightChanged: updatePreferredSizes()
    onColumnsChanged: updatePreferredSizes()
    onRowsChanged: updatePreferredSizes()

    function updatePreferredSizes() {
        if (layout.children.length === 0) return;

        var cellWidth = layout.width / columns;
        var cellHeight = layout.height / rows;

        for (var i = 0; i < layout.children.length; i++) {
            var item = layout.children[i];

            var column = item.Layout.column;
            var row = item.Layout.row;
            var columnSpan = item.Layout.columnSpan;
            var rowSpan = item.Layout.rowSpan;

            item.x = column * cellWidth;
            item.y = row * cellHeight;
            item.height = columnSpan * cellHeight;
            item.width = rowSpan * cellWidth;
        }
    }
}
