import QtQuick 2.12

Image {
    id:     toy
    width:  sourceSize.width
    height: sourceSize.height

    property int    toyNumber: 0
    property string toyType:   ""

    onToyNumberChanged: {
        if (toyNumber !== 0 && toyType !== "") {
            source = "qrc:/resources/images/tree/toys/%1_%2.png".arg(toyType).arg(toyNumber);

            if (toyType === "twinkle") {
                twinkleAnimationTimer.start();
            }
        }
    }

    onToyTypeChanged: {
        if (toyNumber !== 0 && toyType !== "") {
            source = "qrc:/resources/images/tree/toys/%1_%2.png".arg(toyType).arg(toyNumber);

            if (toyType === "twinkle") {
                twinkleAnimationTimer.start();
            }
        }
    }

    function enlargeToy() {
        var center_x = x + width  / 2;
        var center_y = y + height / 2;

        width  = sourceSize.width  * 2;
        height = sourceSize.height * 2;

        x = center_x - width  / 2;
        y = center_y - height / 2;
    }

    function reduceToy() {
        var center_x = x + width / 2;

        width  = sourceSize.width;
        height = sourceSize.height;

        x = center_x - width / 2;
    }

    function destroyToy() {
        destroyToyPropertyAnimation.start();
    }

    MouseArea {
        id:           toyMouseArea
        anchors.fill: parent

        property int pressX: 0
        property int pressY: 0

        onPressed: {
            var mapped = mapToItem(toy.parent, mouseX, mouseY);

            toy.x = mapped.x - toy.width / 2;
            toy.y = mapped.y - toy.height;

            pressX = mapped.x;
            pressY = mapped.y;

            pressAndHoldTimer.start();
        }

        onPositionChanged: {
            var mapped = mapToItem(toy.parent, mouseX, mouseY);

            toy.x = mapped.x - toy.width / 2;
            toy.y = mapped.y - toy.height;

            if (Math.abs(mapped.x - pressX) > 16 ||
                Math.abs(mapped.y - pressY) > 16) {
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

    PropertyAnimation {
        id:       destroyToyPropertyAnimation
        target:   toy
        property: "y"
        to:       parent.height
        duration: 200

        onRunningChanged: {
            if (running) {
                toyMouseArea.enabled = false;
            } else {
                toy.destroy();
            }
        }
    }

    SequentialAnimation {
        id:    twinkleSequentialAnimation
        loops: Animation.Infinite

        PropertyAnimation {
            target:   toy
            property: "opacity"
            from:     1.0
            to:       0.5
            duration: 500
        }

        PropertyAnimation {
            target:   toy
            property: "opacity"
            from:     0.5
            to:       1.0
            duration: 500
        }
    }

    Timer {
        id:       twinkleAnimationTimer
        interval: 100

        onTriggered: {
            twinkleSequentialAnimation.start();
        }
    }
}
