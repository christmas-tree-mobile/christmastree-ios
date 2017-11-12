import QtQuick 1.1
import QtMultimediaKit 1.1
import com.nokia.meego 1.0
import Qt.labs.particles 1.0

import "Tree"

Page {
    id:              treePage
    anchors.fill:    parent
    orientationLock: PageOrientation.LockPortrait

    property int currentBackgroundNum:   1
    property int maxBackgroundNum:       3
    property int currentTreeNum:         1
    property int maxTreeNum:             3
    property int maxToyNum:              37
    property int maxTwinkleNum:          7
    property int currentSnowflakesCount: 10
    property int defaultSnowflakesCount: 10

    property int upperTreePointX:      imageDir === "360x640" ? 180 : 238
    property int upperTreePointY:      imageDir === "360x640" ? 50  : 66
    property int lowerLeftTreePointX:  imageDir === "360x640" ? 10  : 12
    property int lowerLeftTreePointY:  imageDir === "360x640" ? 550 : 730
    property int lowerRightTreePointX: imageDir === "360x640" ? 350 : 464
    property int lowerRightTreePointY: imageDir === "360x640" ? 550 : 730

    property bool appInForeground:     Qt.application.active

    property string imageDir:          "360x640"

    property QtObject newToy:          null

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

    function setVolume(volume) {
        audio.volume = volume;
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

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:           backgroundImage
            anchors.fill: parent
            source:       "../../images/" + treePage.imageDir + "/bg-" + treePage.currentBackgroundNum + ".png"
            fillMode:     Image.PreserveAspectFit
            smooth:       true

            Image {
                id:           treeImageBg
                anchors.fill: parent
                z:            1
                source:       "../../images/" + treePage.imageDir + "/tree-" + treePage.currentTreeNum + "-bg.png"
                fillMode:     Image.PreserveAspectFit
                smooth:       true
            }

            Image {
                id:           treeImageFg
                anchors.fill: parent
                z:            3
                source:       "../../images/" + treePage.imageDir + "/tree-" + treePage.currentTreeNum + "-fg.png"
                fillMode:     Image.PreserveAspectFit
                smooth:       true
            }
        }

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

        Image {
            id:           helpButtonImage
            anchors.top:  parent.top
            anchors.left: parent.left
            width:        48
            height:       48
            z:            15
            source:       "qrc:/resources/images/help.png"

            MouseArea {
                id:           helpButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    mainPageStack.replace(helpPage);
                }
            }
        }

        Image {
            id:            settingsButtonImage
            anchors.top:   parent.top
            anchors.right: parent.right
            width:         48
            height:        48
            z:             15
            source:        "qrc:/resources/images/settings.png"

            MouseArea {
                id:           settingsButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    settingsPage.initSettings(treePage.currentBackgroundNum, treePage.currentTreeNum);

                    mainPageStack.replace(settingsPage);
                }
            }
        }

        Image {
            id:             toysButtonImage
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/toys.png"

            MouseArea {
                id:           toysButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    if (toysListRectangle.visible) {
                        toysListRectangle.visible = false;
                        toysButtonImage.source    = "qrc:/resources/images/toys.png";
                    } else {
                        toysListRectangle.visible = true;
                        toysButtonImage.source    = "qrc:/resources/images/toys-pressed.png";
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
            source:                   "qrc:/resources/images/capture.png"

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
            id:             exitButtonImage
            anchors.bottom: parent.bottom
            anchors.right:  parent.right
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/exit.png"

            MouseArea {
                id:           exitButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    Qt.quit();
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
                cacheBuffer:  (treePage.maxToyNum + treePage.maxTwinkleNum) * 256 // To prevent strange issue with "untouchable toys" on Symbian
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
                        source: "../../images/" + treePage.imageDir + "/toys/" + toyType + "-" + toyNumber + ".png"

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
                                    treePage.newToy.reduceToy();

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

                                        treePage.newToy = Qt.createComponent("Tree/Toy.qml").createObject(backgroundImage, {"z": 4, "toyType": toyType, "toyNumber": toyNumber});

                                        treePage.newToy.enlargeToy();

                                        treePage.newToy.x = toysItemMouseArea.pressX - treePage.newToy.width / 2;
                                        treePage.newToy.y = toysItemMouseArea.pressY - treePage.newToy.height;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    QueryDialog {
        id:               imageCapturedQueryDialog
        titleText:        "Info"
        icon:             "qrc:/resources/images/dialog_info.png"
        message:          "Image saved successfully"
        acceptButtonText: "OK"
    }

    QueryDialog {
        id:               imageCaptureFailedQueryDialog
        titleText:        "Error"
        icon:             "qrc:/resources/images/dialog_error.png"
        message:          "Could not save image"
        acceptButtonText: "OK"
    }

    Component.onCompleted: {
        if ((screen.displayWidth === 360 && screen.displayHeight === 640) ||
            (screen.displayWidth === 640 && screen.displayHeight === 360)) {
            treePage.imageDir = "360x640";
        } else if ((screen.displayWidth === 480 && screen.displayHeight === 854) ||
                   (screen.displayWidth === 854 && screen.displayHeight === 480)) {
            treePage.imageDir = "480x854";
        } else {
            treePage.imageDir = "360x640";
        }

        toysListModel.clear();

        for (var i = 1; i <= treePage.maxToyNum; i++) {
            toysListModel.append({"toyType": "toy", "toyNumber": i});
        }

        for (i = 1; i <= treePage.maxTwinkleNum; i++) {
            toysListModel.append({"toyType": "twinkle", "toyNumber": i});
        }

        audio.play();
    }
}
