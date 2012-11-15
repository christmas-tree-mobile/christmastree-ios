import QtQuick 1.1
import QtMultimediaKit 1.1
import com.nokia.symbian 1.0
import Qt.labs.particles 1.0

import "Tree"

Page {
    id:              treePage
    anchors.fill:    parent
    orientationLock: PageOrientation.LockPortrait

    property int currentBackgroundNum: 1
    property int maxBackgroundNum:     1
    property int currentTreeNum:       1
    property int maxTreeNum:           1
    property int maxToysNum:           16
    property int maxTwinklesNum:       3

    property int upperTreePointX:      imageDir === "360x640" ? 180 : 240
    property int upperTreePointY:      imageDir === "360x640" ? 100 : 130
    property int lowerLeftTreePointX:  imageDir === "360x640" ? 30  : 40
    property int lowerLeftTreePointY:  imageDir === "360x640" ? 540 : 720
    property int lowerRightTreePointX: imageDir === "360x640" ? 330 : 440
    property int lowerRightTreePointY: imageDir === "360x640" ? 540 : 720

    property bool appInForeground:     true

    property string imageDir:          "360x640"

    property QtObject newToy:          null

    function initArtwork(background_num, tree_num) {
        if (background_num <= maxBackgroundNum) {
            currentBackgroundNum = background_num;
        }
        if (tree_num <= maxTreeNum) {
            currentTreeNum = tree_num;
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
            count:             10
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
            count:             10
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
            count:             10
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
            count:             10
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
                    helpPage.loadHelp();

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
                    if (treePage.currentBackgroundNum < treePage.maxBackgroundNum) {
                        treePage.currentBackgroundNum = treePage.currentBackgroundNum + 1;
                    } else {
                        treePage.currentBackgroundNum = 1;
                    }

                    mainWindow.setSetting("BackgroundNum", treePage.currentBackgroundNum);
                }
            }
        }

        Image {
            id:                     toysButtonImage
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:           parent.left
            width:                  48
            height:                 48
            z:                      15
            source:                 "qrc:/resources/images/toys.png"

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

        Slider {
            id:             volumeSlider
            anchors.top:    toysButtonImage.bottom
            anchors.bottom: volumeButtonImage.top
            anchors.left:   parent.left
            width:          volumeButtonImage.width
            z:              15
            orientation:    Qt.Vertical
            minimumValue:   0.0
            maximumValue:   1.0
            value:          0.5
            stepSize:       0.1
            inverted:       true
            visible:        false

            onValueChanged: {
                audio.volume = value;
            }
        }

        Image {
            id:             volumeButtonImage
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/volume.png"

            MouseArea {
                id:           volumeButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    if (volumeSlider.visible) {
                        volumeSlider.visible     = false;
                        volumeButtonImage.source = "qrc:/resources/images/volume.png";
                    } else {
                        volumeSlider.visible     = true;
                        volumeButtonImage.source = "qrc:/resources/images/volume-pressed.png";
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
                cacheBuffer:  treePage.maxToysNum * 256 // To prevent strange issue with "untouchable toys" on Symbian
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

                            onPressAndHold: {
                                toysItemMouseArea.preventStealing = true;

                                var mapped = mapToItem(backgroundImage, mouseX, mouseY);

                                treePage.newToy = Qt.createComponent("Tree/Toy.qml").createObject(backgroundImage, {"z": 4, "toyType": toyType, "toyNumber": toyNumber});

                                treePage.newToy.enlargeToy();

                                treePage.newToy.x = mapped.x - treePage.newToy.width  / 2;
                                treePage.newToy.y = mapped.y - treePage.newToy.height / 2;
                            }

                            onPositionChanged: {
                                var mapped = mapToItem(backgroundImage, mouseX, mouseY);

                                if (treePage.newToy !== null) {
                                    treePage.newToy.x = mapped.x - treePage.newToy.width  / 2;
                                    treePage.newToy.y = mapped.y - treePage.newToy.height / 2;
                                }
                            }

                            onReleased: {
                                toysItemMouseArea.preventStealing = false;

                                if (treePage.newToy !== null) {
                                    treePage.newToy.reduceToy();

                                    if (!treePage.validateToy(treePage.newToy.x + treePage.newToy.width / 2, treePage.newToy.y + treePage.newToy.height / 2)) {
                                        treePage.newToy.destroyToy();
                                    }

                                    treePage.newToy = null;
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

    Connections {
        target: CSApplication

        onAppInBackground: {
            treePage.appInForeground = false;
        }

        onAppInForeground: {
            treePage.appInForeground = true;
        }
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

        for (var i = 1; i <= treePage.maxToysNum; i++) {
            toysListModel.append({"toyType": "toy", "toyNumber": i});
        }

        for (var i = 1; i <= treePage.maxTwinklesNum; i++) {
            toysListModel.append({"toyType": "twinkle", "toyNumber": i});
        }

        audio.play();
    }
}
