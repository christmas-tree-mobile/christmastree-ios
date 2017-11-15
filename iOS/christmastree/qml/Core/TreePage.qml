import QtQuick 2.9
import QtQuick.Particles 2.0
import QtMultimedia 5.9

import "Dialog"
import "Tree"

Item {
    id: treePage

    property bool appInForeground:         Qt.application.active
    property bool pageActive:              false
    property bool interstitialActive:      AdMobHelper.interstitialActive
    property bool lastInterstitialActive:  false

    property int bannerViewHeight:         AdMobHelper.bannerViewHeight
    property int currentBackgroundNum:     1
    property int maxBackgroundNum:         3
    property int maxBackgroundNumWithSnow: 2
    property int currentTreeNum:           1
    property int maxTreeNum:               3
    property int maxToyNum:                37
    property int maxTwinkleNum:            7
    property int upperTreePointX:          160
    property int upperTreePointY:          50
    property int lowerLeftTreePointX:      20
    property int lowerLeftTreePointY:      490
    property int lowerRightTreePointX:     300
    property int lowerRightTreePointY:     490

    property var newToy:                   null

    onAppInForegroundChanged: {
        if (appInForeground && pageActive) {
            var background_num = mainWindow.getSetting("BackgroundNum", 1);
            var tree_num       = mainWindow.getSetting("TreeNum",       1);

            if (background_num <= maxBackgroundNum) {
                currentBackgroundNum = background_num;
            }
            if (tree_num <= maxTreeNum) {
                currentTreeNum = tree_num;
            }
        }
    }

    onPageActiveChanged: {
        if (appInForeground && pageActive) {
            var background_num = mainWindow.getSetting("BackgroundNum", 1);
            var tree_num       = mainWindow.getSetting("TreeNum",       1);

            if (background_num <= maxBackgroundNum) {
                currentBackgroundNum = background_num;
            }
            if (tree_num <= maxTreeNum) {
                currentTreeNum = tree_num;
            }
        }
    }

    onInterstitialActiveChanged: {
        if (!interstitialActive && lastInterstitialActive) {
            shareImage();
        }

        lastInterstitialActive = interstitialActive;
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

    function shareImage() {
        if (!backgroundImage.grabToImage(function (result) {
            result.saveToFile(ShareHelper.imageFilePath);

            ShareHelper.showShareToView();
        })) {
            console.log("grabToImage() failed");
        }
    }

    Audio {
        volume:   1.0
        muted:    !treePage.appInForeground || !treePage.pageActive || treePage.interstitialActive
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

        ParticleSystem {
            id:      particleSystem1
            running: treePage.appInForeground && treePage.pageActive &&
                     treePage.currentBackgroundNum <= treePage.maxBackgroundNumWithSnow
        }

        Emitter {
            anchors.fill: parent
            system:       particleSystem1
            lifeSpan:     1000

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          40
                magnitudeVariation: 20
            }

            ImageParticle {
                z:       5
                opacity: 0.75
                system:  particleSystem1
                source:  "qrc:/resources/images/tree/snowflake_1.png"
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

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          40
                magnitudeVariation: 20
            }

            ImageParticle {
                z:       5
                opacity: 0.75
                system:  particleSystem2
                source:  "qrc:/resources/images/tree/snowflake_2.png"
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

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          40
                magnitudeVariation: 20
            }

            ImageParticle {
                z:       5
                opacity: 0.75
                system:  particleSystem3
                source:  "qrc:/resources/images/tree/snowflake_3.png"
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

            velocity: AngleDirection {
                angle:              90
                angleVariation:     30
                magnitude:          40
                magnitudeVariation: 20
            }

            ImageParticle {
                z:       5
                opacity: 0.75
                system:  particleSystem4
                source:  "qrc:/resources/images/tree/snowflake_4.png"
            }
        }

        Row {
            id:                       buttonImageRow
            anchors.bottom:           parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            z:                        15
            spacing:                  16

            Image {
                id:     settingsButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/tree/button_settings.png"

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
                id:     captureButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/tree/button_capture.png"

                MouseArea {
                    id:           captureButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        if (mainWindow.fullVersion) {
                            treePage.shareImage();
                        } else {
                            purchaseDialog.open();
                        }
                    }
                }
            }

            Image {
                id:     toysButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/tree/button_toys.png"

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
            id:                   settingsListRectangle
            anchors.top:          parent.top
            anchors.bottom:       parent.bottom
            anchors.left:         parent.left
            anchors.topMargin:    bannerViewHeight      + 16
            anchors.bottomMargin: buttonImageRow.height + 16
            width:                96
            z:                    20
            clip:                 true
            color:                "black"
            opacity:              0.75
            visible:              false

            ListView {
                id:           settingsListView
                anchors.fill: parent
                orientation:  ListView.Vertical
                model:        settingsVisualDataModel

                VisualDataModel {
                    id: settingsVisualDataModel

                    model: ListModel {
                        id: settingsListModel
                    }

                    delegate: Image {
                        id:     settingsItemDelegate
                        width:  settingsListRectangle.width
                        height: sourceSize.width > 0 ? (width / sourceSize.width) * sourceSize.height : 0
                        source: settingType === "background" ? "qrc:/resources/images/tree/background_%1.png".arg(settingNumber) :
                                                               "qrc:/resources/images/tree/tree_%1_bg.png".arg(settingNumber)

                        MouseArea {
                            id:           settingsItemMouseArea
                            anchors.fill: parent

                            onClicked: {
                                if (settingType === "background") {
                                    treePage.resetParticleSystems();

                                    treePage.currentBackgroundNum = settingNumber;

                                    mainWindow.setSetting("BackgroundNum", treePage.currentBackgroundNum);
                                } else {
                                    treePage.currentTreeNum = settingNumber;

                                    mainWindow.setSetting("TreeNum", treePage.currentTreeNum);
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id:                   toysListRectangle
            anchors.top:          parent.top
            anchors.bottom:       parent.bottom
            anchors.right:        parent.right
            anchors.topMargin:    bannerViewHeight      + 16
            anchors.bottomMargin: buttonImageRow.height + 16
            width:                54
            z:                    20
            clip:                 true
            color:                "black"
            opacity:              0.75
            visible:              false

            ListView {
                id:           toysListView
                anchors.fill: parent
                orientation:  ListView.Vertical
                cacheBuffer:  (treePage.maxToyNum + treePage.maxTwinkleNum) * 256 // To prevent strange issue with "untouchable toys"
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
                                            treePage.newToy = component.createObject(backgroundImage, {"z": 4, "toyType": toyType, "toyNumber": toyNumber});

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
                }
            }
        }
    }

    PurchaseDialog {
        id: purchaseDialog
        z:  25

        onViewAd: {
            if (AdMobHelper.interstitialReady) {
                AdMobHelper.showInterstitial();
            } else {
                treePage.shareImage();
            }
        }

        onPurchaseFullVersion: {
            mainWindow.purchaseFullVersion();
        }

        onRestorePurchases: {
            mainWindow.restorePurchases();
        }
    }

    Component.onCompleted: {
        settingsListModel.clear();

        for (var i = 1; i <= treePage.maxBackgroundNum; i++) {
            settingsListModel.append({"settingType": "background", "settingNumber": i});
        }

        for (var i = 1; i <= treePage.maxTreeNum; i++) {
            settingsListModel.append({"settingType": "tree", "settingNumber": i});
        }

        toysListModel.clear();

        for (var i = 1; i <= treePage.maxToyNum; i++) {
            toysListModel.append({"toyType": "toy", "toyNumber": i});
        }

        for (i = 1; i <= treePage.maxTwinkleNum; i++) {
            toysListModel.append({"toyType": "twinkle", "toyNumber": i});
        }
    }
}
