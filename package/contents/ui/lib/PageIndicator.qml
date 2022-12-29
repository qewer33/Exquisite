import QtQuick 2.5
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

RowLayout {
    property int pageCount: 2
    property int currentPage: 0

    Repeater {
        model: pageCount

        Rectangle {
            width: 10
            height: 10
            color: currentPage == index ? PlasmaCore.Theme.highlightColor : PlasmaCore.Theme.buttonBackgroundColor
            border.color: PlasmaCore.Theme.highlightColor
            radius: 999

            MouseArea {
                anchors.fill: parent
                onClicked: currentPage = index;
            }
        }
    }
}
