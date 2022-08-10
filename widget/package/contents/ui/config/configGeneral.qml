/*
    SPDX-FileCopyrightText: 2022 author-name
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import QtQuick.Controls 2.12 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts

import org.kde.kirigami 2.3 as Kirigami

import "../lib"

Kirigami.FormLayout {
    id: generalPage
    anchors.left: parent.left
    anchors.right: parent.right

    signal configurationChanged

    property alias cfg_icon: configIcon.value

    ConfigIcon {
        id: configIcon
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.plasma.kickoff", "Icon:")
    }
}
