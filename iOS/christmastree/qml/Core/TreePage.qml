import QtQuick 2.9
import QtMultimedia 5.9

import "Tree"

Item {
    id: treePage

    property bool appInForeground:       Qt.application.active
    property bool pageActive:            false

    property int currentBackgroundNum:   1
    property int maxBackgroundNum:       3
    property int currentTreeNum:         1
    property int maxTreeNum:             3
    property int maxToyNum:              37
    property int maxTwinkleNum:          7
    property int currentSnowflakesCount: 10
    property int defaultSnowflakesCount: 10
    property int upperTreePointX:        160
    property int upperTreePointY:        75
    property int lowerLeftTreePointX:    40
    property int lowerLeftTreePointY:    464
    property int lowerRightTreePointX:   284
    property int lowerRightTreePointY:   470

    property var newToy:                 null

    function setArtwork(background_num, tree_num) {
        if (background_num <= maxBackgroundNum) {
            currentBackgroundNum = background_num;
        }
        if (tree_num <= maxTreeNum) {
            currentTreeNum = tree_num;
        }
        if (currentBackgroundNum === 3) {
            currentSnowflakesCount = 0;
        } else {
            currentSnowflakesCount = defaultSnowflakesCount;
        }
    }

    function validateToy(center_x, center_y) {
        var x0 = center_x;
        var x1 = upperTreePointX;
        var x2 = lowerLeftTreePointX;
        var x3 = lowerRightTreePointX;

        var y0 = center_y;
        var y1 = upperTreePointY;
        var y2 = lowerLeftTreePointY;
        var y3 = lowerRightTreePointY;

        var mul1 = (x1 - x0) * (y2 - y1) - (x2 - x1) * (y1 - y0);
        var mul2 = (x2 - x0) * (y3 - y2) - (x3 - x2) * (y2 - y0);
        var mul3 = (x3 - x0) * (y1 - y3) - (x1 - x3) * (y3 - y0);

        if ((mul1 > 0 && mul2 > 0 && mul3 > 0) || (mul1 < 0 && mul2 < 0 && mul3 < 0)) {
            return true;
        } else {
            return false;
        }
    }

/*
    Audio {
        id:     audio
        source: "../../sound/music.mp3"
        volume: 0.5
        muted:  treePage.appInForeground ? false : true

        onStopped: {
            position = 0;

            play();
        }

        onError: {
            position = 0;

            play();
        }
    }
*/

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:               backgroundImage
            anchors.centerIn: parent
            width:            parent.width
            height:           parent.height
            source:           "qrc:/resources/images/tree/background_%1.png".arg(treePage.currentBackgroundNum)
            fillMode:         Image.PreserveAspectCrop

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

            Image {
                id:               treeImageBg
                anchors.centerIn: parent
                width:            parent.width
                height:           parent.height
                z:                1
                source:           "qrc:/resources/images/tree/tree_%1_bg.png".arg(treePage.currentTreeNum)
                fillMode:         Image.PreserveAspectCrop

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
            }

            Image {
                id:               treeImageFg
                anchors.centerIn: parent
                width:            parent.width
                height:           parent.height
                z:                3
                source:           "qrc:/resources/images/tree/tree_%1_fg.png".arg(treePage.currentTreeNum)
                fillMode:         Image.PreserveAspectCrop

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
            }
        }

/*
        Particles {
            id:                snowflakes1
            anchors.fill:      parent
            z:                 5
            source:            "qrc:/resources/images/snowflake-1.png"
            opacity:           0.75
            lifeSpan:          1000
            count:             treePage.currentSnowflakesCount
            angle:             90
            angleDeviation:    30
            velocity:          30
            velocityDeviation: 10

            ParticleMotionWander {
                xvariance: 30
                pace:      100
            }
        }

        Particles {
            id:                snowflakes2
            anchors.fill:      parent
            z:                 5
            source:            "qrc:/resources/images/snowflake-2.png"
            opacity:           0.5
            lifeSpan:          1000
            count:             treePage.currentSnowflakesCount
            angle:             90
            angleDeviation:    30
            velocity:          30
            velocityDeviation: 10

            ParticleMotionWander {
                xvariance: 30
                pace:      100
            }
        }

        Particles {
            id:                snowflakes3
            anchors.fill:      parent
            z:                 5
            source:            "qrc:/resources/images/snowflake-3.png"
            opacity:           0.5
            lifeSpan:          1000
            count:             treePage.currentSnowflakesCount
            angle:             90
            angleDeviation:    30
            velocity:          30
            velocityDeviation: 10

            ParticleMotionWander {
                xvariance: 30
                pace:      100
            }
        }

        Particles {
            id:                snowflakes4
            anchors.fill:      parent
            z:                 5
            source:            "qrc:/resources/images/snowflake-4.png"
            opacity:           0.25
            lifeSpan:          1000
            count:             treePage.currentSnowflakesCount
            angle:             90
            angleDeviation:    30
            velocity:          30
            velocityDeviation: 10

            ParticleMotionWander {
                xvariance: 30
                pace:      100
            }
        }
*/

        Image {
            id:             toysButtonImage
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/tree/button_toys.png"

            MouseArea {
                id:           toysButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    if (toysListRectangle.visible) {
                        toysListRectangle.visible = false;
                        toysButtonImage.source    = "qrc:/resources/images/tree/button_toys.png";
                    } else {
                        toysListRectangle.visible = true;
                        toysButtonImage.source    = "qrc:/resources/images/tree/button_toys_pressed.png";
                    }
                }
            }
        }

        Image {
            id:                       captureButtonImage
            anchors.bottom:           parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width:                    48
            height:                   48
            z:                        15
            source:                   "qrc:/resources/images/tree/button_capture.png"

            MouseArea {
                id:           captureButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    if (CaptureHelper.captureDeclarativeItem(backgroundImage)) {
                        imageCapturedQueryDialog.open();
                    } else {
                        imageCaptureFailedQueryDialog.open();
                    }
                }
            }
        }

        Image {
            id:             settingsButtonImage
            anchors.bottom: parent.bottom
            anchors.right:  parent.right
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/tree/button_settings.png"

            MouseArea {
                id:           settingsButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    settingsPage.initSettings(treePage.currentBackgroundNum, treePage.currentTreeNum);

                    mainPageStack.replace(settingsPage);
                }
            }
        }

        Rectangle {
            id:             toysListRectangle
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            anchors.right:  parent.right
            width:          72
            z:              20
            color:          "black"
            opacity:        0.75
            visible:        false

            ListView {
                id:           toysListView
                anchors.fill: parent
                orientation:  ListView.Vertical
                model:        toysVisualDataModel

                VisualDataModel {
                    id: toysVisualDataModel

                    model: ListModel {
                        id: toysListModel
                    }

                    delegate: Image {
                        id:     toysItemDelegate
                        width:  sourceSize.width
                        height: sourceSize.height
                        source: "qrc:/resources/images/tree/toys/%1_%2.png".arg(toyType).arg(toyNumber)

                        MouseArea {
                            id:           toysItemMouseArea
                            anchors.fill: parent

                            property int pressX: 0
                            property int pressY: 0

                            onPressed: {
                                var mapped = mapToItem(backgroundImage, mouseX, mouseY);

                                pressX = mapped.x;
                                pressY = mapped.y;

                                pressAndHoldTimer.start();
                            }

                            onPositionChanged: {
                                var mapped = mapToItem(backgroundImage, mouseX, mouseY);

                                if (treePage.newToy !== null) {
                                    treePage.newToy.x = mapped.x - treePage.newToy.width / 2;
                                    treePage.newToy.y = mapped.y - treePage.newToy.height;
                                }
                            }

                            onReleased: {
                                preventStealing = false;

                                if (treePage.newToy !== null) {
                                    if (!treePage.validateToy(treePage.newToy.x + treePage.newToy.width / 2, treePage.newToy.y + treePage.newToy.height / 2)) {
                                        treePage.newToy.destroyToy();
                                    }

                                    treePage.newToy = null;
                                }

                                pressAndHoldTimer.stop();
                            }

                            Timer {
                                id:       pressAndHoldTimer
                                interval: 500

                                onTriggered: {
                                    if (toysItemMouseArea.pressed) {
                                        toysItemMouseArea.preventStealing = true;

                                        var component = Qt.createComponent("Tree/Toy.qml");

                                        if (component.status === Component.Ready) {
                                            treePage.newToy = component.createObject(backgroundImage, {"z": 4, "toyType": toyType, "toyNumber": toyNumber});

                                            treePage.newToy.x = toysItemMouseArea.pressX - treePage.newToy.width / 2;
                                            treePage.newToy.y = toysItemMouseArea.pressY - treePage.newToy.height;
                                        } else {
                                            console.log(component.errorString());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        toysListModel.clear();

        for (var i = 1; i <= treePage.maxToyNum; i++) {
            toysListModel.append({"toyType": "toy", "toyNumber": i});
        }

        for (i = 1; i <= treePage.maxTwinkleNum; i++) {
            toysListModel.append({"toyType": "twinkle", "toyNumber": i});
        }
    }
}
