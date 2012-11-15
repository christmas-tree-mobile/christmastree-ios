import QtQuick 1.1
import com.nokia.symbian 1.0

import "Core"

import "Settings.js" as SettingsScript

Window {
    id: mainWindow

    function setSetting(key, value) {
        SettingsScript.setSetting(key, value);
    }

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        PageStack {
            id:           mainPageStack
            anchors.fill: parent
        }

        TreePage {
            id: treePage
        }

        SettingsPage {
            id: settingsPage
        }

        HelpPage {
            id: helpPage
        }

        MouseArea {
            id:           screenLockMouseArea
            anchors.fill: parent
            z:            50
            enabled:      mainPageStack.busy
        }
    }

    Component.onCompleted: {
        treePage.setArtwork(SettingsScript.getSetting("BackgroundNum", 1), SettingsScript.getSetting("TreeNum", 1));

        mainPageStack.push(treePage);
    }
}
