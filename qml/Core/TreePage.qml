import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Particles 2.12
import QtMultimedia 5.12

import "Dialog"
import "Tree"

import "../Util.js" as UtilScript

Item {
    id: treePage

    readonly property bool appInForeground:           Qt.application.state === Qt.ApplicationActive
    readonly property bool pageActive:                StackView.status === StackView.Active

    readonly property int maxBackgroundNum:           3
    readonly property int maxBackgroundNumWithSnow:   2
    readonly property int maxTreeNum:                 3
    readonly property int maxToyNum:                  37
    readonly property int maxTwinkleNum:              7
    readonly property int upperTreePointXConfig:      0   // Coordinates relative to the center of source image
    readonly property int upperTreePointYConfig:     -240 // in source image original resolution
    readonly property int lowerLeftTreePointXConfig: -170
    readonly property int lowerLeftTreePointYConfig:  220
    readonly property int lowerRightTreePointXConfig: 170
    readonly property int lowerRightTreePointYConfig: 220
    readonly property int upperTreePointX:            pageUpperTreePointX(backgroundImage.sourceSize,
                                                                          backgroundImage.paintedWidth,
                                                                          upperTreePointXConfig)
    readonly property int upperTreePointY:            pageUpperTreePointY(backgroundImage.sourceSize,
                                                                          backgroundImage.paintedHeight,
                                                                          upperTreePointYConfig)
    readonly property int lowerLeftTreePointX:        pageLowerLeftTreePointX(backgroundImage.sourceSize,
                                                                              backgroundImage.paintedWidth,
                                                                              lowerLeftTreePointXConfig)
    readonly property int lowerLeftTreePointY:        pageLowerLeftTreePointY(backgroundImage.sourceSize,
                                                                              backgroundImage.paintedHeight,
                                                                              lowerLeftTreePointYConfig)
    readonly property int lowerRightTreePointX:       pageLowerRightTreePointX(backgroundImage.sourceSize,
                                                                               backgroundImage.paintedWidth,
                                                                               lowerRightTreePointXConfig)
    readonly property int lowerRightTreePointY:       pageLowerRightTreePointY(backgroundImage.sourceSize,
                                                                               backgroundImage.paintedHeight,
                                                                               lowerRightTreePointYConfig)

    property int currentBackgroundNum:                1
    property int currentTreeNum:                      1

    property var newToy:                              null

    onCurrentBackgroundNumChanged: {
        mainWindow.setSetting("BackgroundNum", currentBackgroundNum.toString(10));

        resetParticleSystems();
    }

    onCurrentTreeNumChanged: {
        mainWindow.setSetting("TreeNum", currentTreeNum.toString(10));
    }

    function pageUpperTreePointX(background_image_source_size, background_image_painted_width, upper_tree_point_x_config) {
        if (background_image_source_size.width > 0) {
            return (background_image_source_size.width / 2 + upper_tree_point_x_config) *
                   (background_image_painted_width / background_image_source_size.width);
        } else {
            return 0;
        }
    }

    function pageUpperTreePointY(background_image_source_size, background_image_painted_height, upper_tree_point_y_config) {
        if (background_image_source_size.height > 0) {
            return (background_image_source_size.height / 2 + upper_tree_point_y_config) *
                   (background_image_painted_height / background_image_source_size.height);
        } else {
            return 0;
        }
    }

    function pageLowerLeftTreePointX(background_image_source_size, background_image_painted_width, lower_left_tree_point_x_config) {
        if (background_image_source_size.width > 0) {
            return (background_image_source_size.width / 2 + lower_left_tree_point_x_config) *
                   (background_image_painted_width / background_image_source_size.width);
        } else {
            return 0;
        }
    }

    function pageLowerLeftTreePointY(background_image_source_size, background_image_painted_height, lower_left_tree_point_y_config) {
        if (background_image_source_size.height > 0) {
            return (background_image_source_size.height / 2 + lower_left_tree_point_y_config) *
                   (background_image_painted_height / background_image_source_size.height);
        } else {
            return 0;
        }
    }

    function pageLowerRightTreePointX(background_image_source_size, background_image_painted_width, lower_right_tree_point_x_config) {
        if (background_image_source_size.width > 0) {
            return (background_image_source_size.width / 2 + lower_right_tree_point_x_config) *
                   (background_image_painted_width / background_image_source_size.width);
        } else {
            return 0;
        }
    }

    function pageLowerRightTreePointY(background_image_source_size, background_image_painted_height, lower_right_tree_point_y_config) {
        if (background_image_source_size.height > 0) {
            return (background_image_source_size.height / 2 + lower_right_tree_point_y_config) *
                   (background_image_painted_height / background_image_source_size.height);
        } else {
            return 0;
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

    function resetParticleSystems() {
        particleSystem1.reset();
        particleSystem2.reset();
        particleSystem3.reset();
        particleSystem4.reset();
    }

    function captureImage() {
        waitRectangle.visible = true;

        if (!backgroundImage.grabToImage(function (result) {
            result.saveToFile(ShareHelper.imageFilePath);

            ShareHelper.showShareToView(ShareHelper.imageFilePath);

            waitRectangle.visible = false;
        })) {
            console.log("grabToImage() failed");

            waitRectangle.visible = false;
        }
    }

    Audio {
        volume:   1.0
        muted:    !treePage.appInForeground || !treePage.pageActive
        source:   "qrc:/resources/sound/tree/music.mp3"
        autoPlay: true
        loops:    Audio.Infinite

        onError: {
            console.log(errorString);
        }
    }

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:               backgroundImage
            anchors.centerIn: parent
            width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
            height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
            source:           "qrc:/resources/images/tree/background_%1.png".arg(treePage.currentBackgroundNum)
            fillMode:         Image.PreserveAspectCrop

            function imageWidth(src_width, src_height, dst_width, dst_height) {
                if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                    if (dst_width / dst_height < src_width / src_height) {
                        return src_width * dst_height / src_height;
                    } else {
                        return dst_width;
                    }
                } else {
                    return 0;
                }
            }

            function imageHeight(src_width, src_height, dst_width, dst_height) {
                if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                    if (dst_width / dst_height < src_width / src_height) {
                        return dst_height;
                    } else {
                        return src_height * dst_width / src_width;
                    }
                } else {
                    return 0;
                }
            }

            Image {
                id:               treeImageBg
                anchors.centerIn: parent
                z:                1
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/tree/tree_%1_bg.png".arg(treePage.currentTreeNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
                    }
                }
            }

            Image {
                id:               treeImageFg
                anchors.centerIn: parent
                z:                3
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/tree/tree_%1_fg.png".arg(treePage.currentTreeNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
                    }
                }
            }
        }

        ParticleSystem {
            id:      particleSystem1
            running: treePage.appInForeground && treePage.pageActive &&
                     treePage.currentBackgroundNum <= treePage.maxBackgroundNumWithSnow
        }

        Emitter {
            anchors.fill: parent
            system:       particleSystem1
            lifeSpan:     1000
            size:         UtilScript.pt(32)

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          UtilScript.pt(40)
                magnitudeVariation: UtilScript.pt(20)
            }

            ImageParticle {
                z:       1
                system:  particleSystem1
                source:  "qrc:/resources/images/tree/snowflake_1.png"
                opacity: 0.75
            }
        }

        ParticleSystem {
            id:      particleSystem2
            running: treePage.appInForeground && treePage.pageActive &&
                     treePage.currentBackgroundNum <= treePage.maxBackgroundNumWithSnow
        }

        Emitter {
            anchors.fill: parent
            system:       particleSystem2
            lifeSpan:     1000
            size:         UtilScript.pt(32)

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          UtilScript.pt(40)
                magnitudeVariation: UtilScript.pt(20)
            }

            ImageParticle {
                z:       1
                system:  particleSystem2
                source:  "qrc:/resources/images/tree/snowflake_2.png"
                opacity: 0.75
            }
        }

        ParticleSystem {
            id:      particleSystem3
            running: treePage.appInForeground && treePage.pageActive &&
                     treePage.currentBackgroundNum <= treePage.maxBackgroundNumWithSnow
        }

        Emitter {
            anchors.fill: parent
            system:       particleSystem3
            lifeSpan:     1000
            size:         UtilScript.pt(32)

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          UtilScript.pt(40)
                magnitudeVariation: UtilScript.pt(20)
            }

            ImageParticle {
                z:       1
                system:  particleSystem3
                source:  "qrc:/resources/images/tree/snowflake_3.png"
                opacity: 0.75
            }
        }

        ParticleSystem {
            id:      particleSystem4
            running: treePage.appInForeground && treePage.pageActive &&
                     treePage.currentBackgroundNum <= treePage.maxBackgroundNumWithSnow
        }

        Emitter {
            anchors.fill: parent
            system:       particleSystem4
            lifeSpan:     1000
            size:         UtilScript.pt(32)

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          UtilScript.pt(40)
                magnitudeVariation: UtilScript.pt(20)
            }

            ImageParticle {
                z:       1
                system:  particleSystem4
                source:  "qrc:/resources/images/tree/snowflake_4.png"
                opacity: 0.75
            }
        }

        Image {
            id:                 helpButtonImage
            anchors.top:        parent.top
            anchors.left:       parent.left
            anchors.topMargin:  UtilScript.pt(34)
            anchors.leftMargin: UtilScript.pt(8)
            z:                  5
            width:              UtilScript.pt(32)
            height:             UtilScript.pt(32)
            source:             "qrc:/resources/images/tree/button_help.png"
            fillMode:           Image.PreserveAspectFit

            MouseArea {
                id:           helpButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    helpDialog.open();
                }
            }
        }

        Row {
            id:                       buttonImageRow
            anchors.bottom:           parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin:     UtilScript.pt(30)
            z:                        5
            spacing:                  UtilScript.pt(16)

            Image {
                id:       settingsButtonImage
                width:    UtilScript.pt(64)
                height:   UtilScript.pt(64)
                source:   "qrc:/resources/images/tree/button_settings.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id:           settingsButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        if (settingsListRectangle.visible) {
                            settingsListRectangle.visible = false;
                            settingsButtonImage.source    = "qrc:/resources/images/tree/button_settings.png";
                        } else {
                            settingsListRectangle.visible = true;
                            settingsButtonImage.source    = "qrc:/resources/images/tree/button_settings_pressed.png";
                        }
                    }
                }
            }

            Image {
                id:       captureImageButtonImage
                width:    UtilScript.pt(64)
                height:   UtilScript.pt(64)
                source:   "qrc:/resources/images/tree/button_capture_image.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id:           captureImageButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        parentalGateDialog.open("IMAGE");
                    }
                }
            }

            Image {
                id:       captureGIFButtonImage
                width:    UtilScript.pt(64)
                height:   UtilScript.pt(64)
                source:   "qrc:/resources/images/tree/button_capture_gif.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id:           captureGIFButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        parentalGateDialog.open("GIF");
                    }
                }
            }

            Image {
                id:       toysButtonImage
                width:    UtilScript.pt(64)
                height:   UtilScript.pt(64)
                source:   "qrc:/resources/images/tree/button_toys.png"
                fillMode: Image.PreserveAspectFit

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
        }

        Rectangle {
            id:                     settingsListRectangle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:           parent.left
            z:                      6
            width:                  UtilScript.pt(96)
            height:                 Math.min(parent.height * 5 / 8, settingsListView.contentHeight)
            color:                  "black"
            clip:                   true
            opacity:                0.75
            visible:                false

            ListView {
                id:           settingsListView
                anchors.fill: parent
                orientation:  ListView.Vertical

                model: ListModel {
                    id: settingsListModel
                }

                delegate: Image {
                    id:       settingsItemDelegate
                    width:    settingsListRectangle.width
                    height:   sourceSize.width > 0 ? (width / sourceSize.width) * sourceSize.height : 0
                    source:   settingType === "background" ? "qrc:/resources/images/tree/background_%1.png".arg(settingNumber) :
                                                             "qrc:/resources/images/tree/tree_%1_bg.png".arg(settingNumber)
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        id:           settingsItemMouseArea
                        anchors.fill: parent

                        onClicked: {
                            if (settingType === "background") {
                                treePage.currentBackgroundNum = settingNumber;
                            } else {
                                treePage.currentTreeNum = settingNumber;
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }
        }

        Rectangle {
            id:                     toysListRectangle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:          parent.right
            z:                      6
            width:                  UtilScript.pt(54)
            height:                 Math.min(parent.height * 5 / 8, toysListView.contentHeight)
            color:                  "black"
            clip:                   true
            opacity:                0.75
            visible:                false

            ListView {
                id:           toysListView
                anchors.fill: parent
                orientation:  ListView.Vertical
                cacheBuffer:  (treePage.maxToyNum + treePage.maxTwinkleNum) * 256 // To prevent strange issue with "untouchable toys"

                model: ListModel {
                    id: toysListModel
                }

                delegate: Image {
                    id:       toysItemDelegate
                    width:    toysListRectangle.width
                    height:   sourceSize.width > 0 ? (width / sourceSize.width) * sourceSize.height : 0
                    source:   "qrc:/resources/images/tree/toys/%1_%2.png".arg(toyType).arg(toyNumber)
                    fillMode: Image.PreserveAspectFit

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

                                    var component = Qt.createComponent("Tree/Toy.qml");

                                    if (component.status === Component.Ready) {
                                        treePage.newToy = component.createObject(backgroundImage, {"z": 4, "treePage": treePage, "toyType": toyType, "toyNumber": toyNumber});

                                        treePage.newToy.enlargeToy();

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

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOff
                }
            }
        }

        Rectangle {
             id:           waitRectangle
             anchors.fill: parent
             z:            7
             color:        "black"
             opacity:      0.75
             visible:      false

             BusyIndicator {
                 anchors.centerIn: parent
                 running:          parent.visible
             }

             MultiPointTouchArea {
                 anchors.fill: parent
             }
         }
    }

    ParentalGateDialog {
        id: parentalGateDialog
        z:  1

        onPassedToCaptureImage: {
            treePage.captureImage();
        }

        onPassedToCaptureGIF: {
            captureGIFTimer.start();
        }
    }

    HelpDialog {
        id: helpDialog
        z:  1
    }

    Timer {
        id:               captureGIFTimer
        interval:         200
        repeat:           true
        triggeredOnStart: true

        readonly property int framesCount: 5

        property int frameNumber:          0

        onRunningChanged: {
            if (running) {
                waitRectangle.visible = true;

                frameNumber = 0;
            } else {
                if (frameNumber >= framesCount) {
                    if (GIFCreator.createGIF(framesCount, interval / 10)) {
                        ShareHelper.showShareToView(GIFCreator.gifFilePath);
                    } else {
                        console.log("createGIF() failed");
                    }
                }

                waitRectangle.visible = false;
            }
        }

        onTriggered: {
            if (frameNumber < framesCount) {
                var frame_number = frameNumber;

                if (!backgroundImage.grabToImage(function (result) {
                    result.saveToFile(GIFCreator.imageFilePathMask.arg(frame_number));
                })) {
                    console.log("grabToImage() failed for frame %1".arg(frame_number));
                }

                frameNumber = frameNumber + 1;
            } else {
                stop();
            }
        }
    }

    Connections {
        target: ShareHelper

        onShareToViewCompleted: {
            StoreHelper.requestReview();
        }
    }

    Component.onCompleted: {
        var background_num = parseInt(mainWindow.getSetting("BackgroundNum", "1"), 10);
        var tree_num       = parseInt(mainWindow.getSetting("TreeNum",       "1"), 10);

        if (background_num <= maxBackgroundNum) {
            currentBackgroundNum = background_num;
        }
        if (tree_num <= maxTreeNum) {
            currentTreeNum = tree_num;
        }

        settingsListModel.clear();

        for (var i = 1; i <= treePage.maxBackgroundNum; i++) {
            settingsListModel.append({"settingType": "background", "settingNumber": i});
        }

        for (var j = 1; j <= treePage.maxTreeNum; j++) {
            settingsListModel.append({"settingType": "tree", "settingNumber": j});
        }

        toysListModel.clear();

        for (var k = 1; k <= treePage.maxToyNum; k++) {
            toysListModel.append({"toyType": "toy", "toyNumber": k});
        }

        for (var n = 1; n <= treePage.maxTwinkleNum; n++) {
            toysListModel.append({"toyType": "twinkle", "toyNumber": n});
        }

        if (mainWindow.getSetting("ShowHelpOnStartup", "true") === "true") {
            helpDialog.open();

            mainWindow.setSetting("ShowHelpOnStartup", "false");
        }
    }
}
