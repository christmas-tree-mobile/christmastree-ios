import QtQuick 2.12
import QtQuick.Controls 2.5

import "../../Util.js" as UtilScript

MultiPointTouchArea {
    id:               helpDialog
    anchors.centerIn: parent
    width:            dialogWidth(rotation, parent.width, parent.height)
    height:           dialogHeight(rotation, parent.width, parent.height)
    visible:          false

    signal opened()
    signal closed()

    signal ok()

    function dialogWidth(rotation, parent_width, parent_height) {
        if (rotation === 90 || rotation === 270) {
            return parent_height;
        } else {
            return parent_width;
        }
    }

    function dialogHeight(rotation, parent_width, parent_height) {
        if (rotation === 90 || rotation === 270) {
            return parent_width;
        } else {
            return parent_height;
        }
    }

    function open() {
        visible = true;

        opened();
    }

    function close() {
        visible = false;

        ok();
        closed();
    }

    Image {
        id:               dialogImage
        anchors.centerIn: parent
        width:            UtilScript.dp(sourceSize.width)
        height:           UtilScript.dp(sourceSize.height)
        source:           "qrc:/resources/images/dialog/help_dialog.png"
        fillMode:         Image.PreserveAspectFit

        Flickable {
            id:                   helpTextFlickable
            anchors.fill:         parent
            anchors.margins:      UtilScript.dp(16)
            anchors.bottomMargin: UtilScript.dp(40)
            contentWidth:         helpText.width
            contentHeight:        helpText.height
            clip:                 true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }

            Text {
                id:                  helpText
                width:               helpTextFlickable.width
                text:                "<b>" + qsTr("How to decorate Christmas Tree") + "</b>" + "<br><br>" +
                                             qsTr("1. Press Settings button to choose how your tree and background image should look like. Press Settings button again to hide list of available options.") + "<br><br>" +
                                             qsTr("2. Press Toys button to open toys gallery. Press Toys button again to hide this gallery.") + "<br><br>" +
                                             qsTr("3. Select toy you like from gallery by holding your finger down on it and then drag selected toy to appropriate place on Christmas Tree. Press and hold down your finger on the toy to send it to background or bring to foreground. Move toy away from Christmas Tree to remove it.") + "<br><br>" +
                                             qsTr("4. Repeat previous step, choosing different toys from gallery until you get your own wonderfully decorated Christmas Tree. Press Capture or Record buttons to save image or GIF of your Christmas Tree or share it with friends.")
                color:               "black"
                font.pointSize:      20
                font.family:         "Helvetica"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment:   Text.AlignVCenter
                wrapMode:            Text.Wrap
            }
        }
    }

    Image {
        id:                       okButtonImage
        anchors.horizontalCenter: dialogImage.horizontalCenter
        anchors.verticalCenter:   dialogImage.bottom
        z:                        1
        width:                    UtilScript.dp(64)
        height:                   UtilScript.dp(64)
        source:                   "qrc:/resources/images/dialog/ok.png"
        fillMode:                 Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent

            onClicked: {
                helpDialog.visible = false;

                helpDialog.ok();
                helpDialog.closed();
            }
        }
    }
}
