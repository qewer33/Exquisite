import QtQuick 2.0
import QtQuick.Controls 2.5
import org.kde.kirigami 2.4 as Kirigami

import "../lib"

Item {
    id: configGeneral
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_icon: configIcon.value

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        ConfigIcon {
            id: configIcon
            Kirigami.FormData.label: i18nd("plasma_applet_org.kde.plasma.kickoff", "Icon:")
        }
    }
}
