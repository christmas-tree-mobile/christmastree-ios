import QtQuick 2.12

import "../../Util.js" as UtilScript

Image {
    id:       toy
    width:    sourceSize.width  * imageScale
    height:   sourceSize.height * imageScale
    source:   imageSource(toyNumber, toyType)
    fillMode: Image.PreserveAspectFit
    enabled:  !destroyToyAnimation.running

    property int toyNumber:   0

    property real imageScale: 1.0

    property string toyType:  ""

    property var treePage:    null

    function imageSource(toy_number, toy_type) {
        if (toy_number !== 0 && toy_type !== "") {
            return "qrc:/resources/images/tree/toys/%1_%2.png".arg(toy_type).arg(toy_number);
        } else {
            return "";
        }
    }

    function destroyToy() {
        destroyToyAnimation.start();
    }

    MouseArea {
        id:           toyMouseArea
        anchors.fill: parent

        property int pressEventX: 0
        property int pressEventY: 0

        onPressed: {
            var mapped = mapToItem(toy.parent, mouse.x, mouse.y);

            toy.x = mapped.x - toy.width / 2;
            toy.y = mapped.y - toy.height;

            pressEventX = mapped.x;
            pressEventY = mapped.y;

            pressAndHoldTimer.start();
        }

        onPositionChanged: {
            var mapped = mapToItem(toy.parent, mouse.x, mouse.y);

            toy.x = mapped.x - toy.width / 2;
            toy.y = mapped.y - toy.height;

            if (Math.abs(mapped.x - pressEventX) > UtilScript.dp(16) ||
                Math.abs(mapped.y - pressEventY) > UtilScript.dp(16)) {
                pressAndHoldTimer.stop();
            }
        }

        onReleased: {
            if (!treePage.validateToy(toy.x + toy.width / 2, toy.y + toy.height / 2)) {
                toy.destroyToy();
            }

            pressAndHoldTimer.stop();
        }

        Timer {
            id:       pressAndHoldTimer
            interval: 600

            onTriggered: {
                if (toyMouseArea.pressed) {
                    if (toy.z === 4) {
                        toy.z = 2;
                    } else {
                        toy.z = 4;
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: destroyToyAnimation

        NumberAnimation {
            target:   toy
            property: "y"
            to:       parent.height
            duration: 200
        }

        ScriptAction {
            script: {
                toy.destroy();
            }
        }
    }

    SequentialAnimation {
        id:      twinkleSequentialAnimation
        loops:   Animation.Infinite
        running: toy.toyType === "twinkle"

        NumberAnimation {
            target:   toy
            property: "opacity"
            from:     1.0
            to:       0.5
            duration: 500
        }

        NumberAnimation {
            target:   toy
            property: "opacity"
            from:     0.5
            to:       1.0
            duration: 500
        }
    }
}
