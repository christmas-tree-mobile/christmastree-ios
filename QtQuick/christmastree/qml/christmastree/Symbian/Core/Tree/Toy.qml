import QtQuick 1.1

Image {
    id:     toy
    width:  sourceSize.width
    height: sourceSize.height
    smooth: true

    property int    toyNumber: 0
    property string toyType:   ""

    onToyNumberChanged: {
        if (toyNumber !== 0 && toyType !== "") {
            source = "../../../images/" + treePage.imageDir + "/toys/" + toyType + "-" + toyNumber + ".png";

            if (toyType === "twinkle") {
                twinkleSequentialAnimation.start();
            }
        }
    }

    onToyTypeChanged: {
        if (toyNumber !== 0 && toyType !== "") {
            source = "../../../images/" + treePage.imageDir + "/toys/" + toyType + "-" + toyNumber + ".png";

            if (toyType === "twinkle") {
                twinkleSequentialAnimation.start();
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
        var center_x = x + width  / 2;
        var center_y = y + height / 2;

        width  = sourceSize.width;
        height = sourceSize.height;

        x = center_x - width  / 2;
        y = center_y - height / 2;
    }

    function destroyToy() {
        destroyToyPropertyAnimation.start();
    }

    MouseArea {
        id:           toyMouseArea
        anchors.fill: parent

        onPressed: {
            var mapped = mapToItem(toy.parent, mouseX, mouseY);

            toy.enlargeToy();

            toy.x = mapped.x - toy.width  / 2;
            toy.y = mapped.y - toy.height / 2;
        }

        onPositionChanged: {
            var mapped = mapToItem(toy.parent, mouseX, mouseY);

            toy.x = mapped.x - toy.width  / 2;
            toy.y = mapped.y - toy.height / 2;
        }

        onReleased: {
            toy.reduceToy();

            if (!treePage.validateToy(toy.x + toy.width / 2, toy.y + toy.height / 2)) {
                toy.destroyToy();
            }
        }

        onDoubleClicked: {
            if (toy.z === 4) {
                toy.z = 2;
            } else {
                toy.z = 4;
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
            id:       twinkleDecOpacityPropertyAnimation
            target:   toy
            property: "opacity"
            from:     1.0
            to:       0.5
            duration: 2000
        }

        PropertyAnimation {
            id:       twinkleIncOpacityPropertyAnimation
            target:   toy
            property: "opacity"
            from:     0.5
            to:       1.0
            duration: 2000
        }
    }
}
