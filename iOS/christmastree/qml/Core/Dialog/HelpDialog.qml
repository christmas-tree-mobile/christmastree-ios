import QtQuick 2.9
import QtQuick.Controls 2.2

MouseArea {
    id:               helpDialog
    anchors.centerIn: parent
    visible:          false

    property int parentWidth:  parent.width
    property int parentHeight: parent.height

    signal opened()
    signal closed()

    signal ok()

    onParentWidthChanged: {
        if (typeof(parent) !== "undefined" && parent !== null) {
            if (rotation === 0 || rotation === 180) {
                width  = parent.width;
                height = parent.height;
            } else if (rotation === 90 || rotation === 270) {
                width  = parent.height;
                height = parent.width;
            }
        }
    }

    onParentHeightChanged: {
        if (typeof(parent) !== "undefined" && parent !== null) {
            if (rotation === 0 || rotation === 180) {
                width  = parent.width;
                height = parent.height;
            } else if (rotation === 90 || rotation === 270) {
                width  = parent.height;
                height = parent.width;
            }
        }
    }

    onRotationChanged: {
        if (typeof(parent) !== "undefined" && parent !== null) {
            if (rotation === 0 || rotation === 180) {
                width  = parent.width;
                height = parent.height;
            } else if (rotation === 90 || rotation === 270) {
                width  = parent.height;
                height = parent.width;
            }
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
        width:            Math.min(parent.width, parent.height) - 16
        height:           Math.min(parent.width, parent.height) - 72
        source:           "qrc:/resources/images/dialog/help_dialog.png"
        fillMode:         Image.PreserveAspectFit

        property bool geometrySettled: false

        onPaintedWidthChanged: {
            if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                geometrySettled = true;

                width  = paintedWidth;
                height = paintedHeight;
            }
        }

        onPaintedHeightChanged: {
            if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                geometrySettled = true;

                width  = paintedWidth;
                height = paintedHeight;
            }
        }

        Flickable {
            id:                   helpTextFlickable
            anchors.fill:         parent
            anchors.margins:      16
            anchors.bottomMargin: 40
            contentWidth:         helpText.width
            contentHeight:        helpText.height
            clip:                 true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }

            Text {
                id:                   helpText
                width:                helpTextFlickable.width
                color:                "black"
                horizontalAlignment:  Text.AlignHCenter
                verticalAlignment:    Text.AlignVCenter
                wrapMode:             Text.Wrap
                text:                 "<b>" + qsTr("How to decorate Christmas Tree") + "</b>" + "<br><br>" +
                                              qsTr("1. Press Settings button to choose how your tree and background image should look like. Press Settings button again to hide list of available options.") + "<br><br>" +
                                              qsTr("2. Press Toys button to open toys gallery. Press Toys button again to hide this gallery.") + "<br><br>" +
                                              qsTr("3. Select toy you like from gallery by holding your finger on it and then drag selected toy to appropriate place on Christmas Tree. Press and hold your finger on the toy to send it to background or bring to foreground. Move toy away from Christmas Tree to remove it.") + "<br><br>" +
                                              qsTr("4. Repeat previous step, choosing different toys from gallery until you get your own wonderfully decorated Christmas Tree. Press Capture or Record buttons to save image or GIF of your Christmas Tree or share it with friends.")
            }
        }
    }

    Image {
        id:                       okButtonImage
        anchors.horizontalCenter: dialogImage.horizontalCenter
        anchors.verticalCenter:   dialogImage.bottom
        width:                    64
        height:                   64
        z:                        dialogImage.z + 1
        source:                   "qrc:/resources/images/dialog/ok.png"

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
