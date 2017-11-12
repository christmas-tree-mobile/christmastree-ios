import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id:              settingsPage
    anchors.fill:    parent
    orientationLock: PageOrientation.LockPortrait

    property int currentBackgroundNum: 1
    property int currentTreeNum:       1

    property string imageDir:          "360x640"

    function initSettings(background_num, tree_num) {
        currentBackgroundNum = background_num;
        currentTreeNum       = tree_num;

        if (currentBackgroundNum === 1) {
            background1Rectangle.border.color = "red";
            background2Rectangle.border.color = "transparent";
            background3Rectangle.border.color = "transparent";
        } else if (currentBackgroundNum === 2) {
            background1Rectangle.border.color = "transparent";
            background2Rectangle.border.color = "red";
            background3Rectangle.border.color = "transparent";
        } else {
            background1Rectangle.border.color = "transparent";
            background2Rectangle.border.color = "transparent";
            background3Rectangle.border.color = "red";
        }

        if (currentTreeNum === 1) {
            tree1Rectangle.border.color = "red";
            tree2Rectangle.border.color = "transparent";
            tree3Rectangle.border.color = "transparent";
        } else if (currentTreeNum === 2) {
            tree1Rectangle.border.color = "transparent";
            tree2Rectangle.border.color = "red";
            tree3Rectangle.border.color = "transparent";
        } else {
            tree1Rectangle.border.color = "transparent";
            tree2Rectangle.border.color = "transparent";
            tree3Rectangle.border.color = "red";
        }
    }

    Rectangle {
        id:             backgroundRectangle
        anchors.top:    parent.top
        anchors.bottom: bottomToolBar.top
        anchors.left:   parent.left
        anchors.right:  parent.right
        color:          "darkgray"

        Rectangle {
            id:            backgroundsRectangle
            anchors.top:   parent.top
            anchors.left:  parent.left
            anchors.right: parent.right
            height:        (parent.height - volumeRectangle.height) / 2
            clip:          true
            color:         "transparent"

            property int spacing:     8
            property int borderWidth: 4
            property int itemWidth:   (backgroundsRectangle.width - backgroundsRectangle.spacing * 2) / 3 - backgroundsRectangle.borderWidth * 2

            Rectangle {
                id:           background1Rectangle
                x:            backgroundsRectangle.borderWidth
                y:            backgroundsRectangle.borderWidth
                width:        background1Image.width
                height:       background1Image.height
                color:        "white"
                border.width: backgroundsRectangle.borderWidth
                border.color: "red"

                Image {
                    id:       background1Image
                    width:    backgroundsRectangle.itemWidth
                    height:   sourceSize.width !==0 && width !== 0 ? sourceSize.height / (sourceSize.width / width) : 0
                    source:   "../../images/" + treePage.imageDir + "/bg-1.png"
                    fillMode: Image.PreserveAspectFit
                    smooth:   true

                    MouseArea {
                        id:           background1MouseArea
                        anchors.fill: parent

                        onClicked: {
                            settingsPage.currentBackgroundNum = 1;

                            background1Rectangle.border.color = "red";
                            background2Rectangle.border.color = "transparent";
                            background3Rectangle.border.color = "transparent";
                        }
                    }
                }
            }

            Rectangle {
                id:           background2Rectangle
                x:            backgroundsRectangle.borderWidth * 3 + backgroundsRectangle.spacing + backgroundsRectangle.itemWidth
                y:            backgroundsRectangle.borderWidth
                width:        background2Image.width
                height:       background2Image.height
                color:        "white"
                border.width: backgroundsRectangle.borderWidth
                border.color: "transparent"

                Image {
                    id:       background2Image
                    width:    backgroundsRectangle.itemWidth
                    height:   sourceSize.width !==0 && width !== 0 ? sourceSize.height / (sourceSize.width / width) : 0
                    source:   "../../images/" + treePage.imageDir + "/bg-2.png"
                    fillMode: Image.PreserveAspectFit
                    smooth:   true

                    MouseArea {
                        id:           background2MouseArea
                        anchors.fill: parent

                        onClicked: {
                            settingsPage.currentBackgroundNum = 2;

                            background1Rectangle.border.color = "transparent";
                            background2Rectangle.border.color = "red";
                            background3Rectangle.border.color = "transparent";
                        }
                    }
                }
            }

            Rectangle {
                id:           background3Rectangle
                x:            backgroundsRectangle.borderWidth * 5 + backgroundsRectangle.spacing * 2 + backgroundsRectangle.itemWidth * 2
                y:            backgroundsRectangle.borderWidth
                width:        background3Image.width
                height:       background3Image.height
                color:        "white"
                border.width: backgroundsRectangle.borderWidth
                border.color: "transparent"

                Image {
                    id:       background3Image
                    width:    backgroundsRectangle.itemWidth
                    height:   sourceSize.width !==0 && width !== 0 ? sourceSize.height / (sourceSize.width / width) : 0
                    source:   "../../images/" + treePage.imageDir + "/bg-3.png"
                    fillMode: Image.PreserveAspectFit
                    smooth:   true

                    MouseArea {
                        id:           background3MouseArea
                        anchors.fill: parent

                        onClicked: {
                            settingsPage.currentBackgroundNum = 3;

                            background1Rectangle.border.color = "transparent";
                            background2Rectangle.border.color = "transparent";
                            background3Rectangle.border.color = "red";
                        }
                    }
                }
            }
        }

        Rectangle {
            id:            treesRectangle
            anchors.top:   backgroundsRectangle.bottom
            anchors.left:  parent.left
            anchors.right: parent.right
            height:        (parent.height - volumeRectangle.height) / 2
            clip:          true
            color:         "transparent"

            property int spacing:     8
            property int borderWidth: 4
            property int itemWidth:   (treesRectangle.width - treesRectangle.spacing * 2) / 3 - treesRectangle.borderWidth * 2

            Rectangle {
                id:           tree1Rectangle
                x:            treesRectangle.borderWidth
                y:            treesRectangle.borderWidth
                width:        tree1Image.width
                height:       tree1Image.height
                color:        "white"
                border.width: treesRectangle.borderWidth
                border.color: "red"

                Image {
                    id:       tree1Image
                    width:    treesRectangle.itemWidth
                    height:   sourceSize.width !==0 && width !== 0 ? sourceSize.height / (sourceSize.width / width) : 0
                    source:   "../../images/" + treePage.imageDir + "/tree-1-bg.png"
                    fillMode: Image.PreserveAspectFit
                    smooth:   true

                    MouseArea {
                        id:           tree1MouseArea
                        anchors.fill: parent

                        onClicked: {
                            settingsPage.currentTreeNum = 1;

                            tree1Rectangle.border.color = "red";
                            tree2Rectangle.border.color = "transparent";
                            tree3Rectangle.border.color = "transparent";
                        }
                    }
                }
            }

            Rectangle {
                id:           tree2Rectangle
                x:            treesRectangle.borderWidth * 3 + treesRectangle.spacing + treesRectangle.itemWidth
                y:            treesRectangle.borderWidth
                width:        tree2Image.width
                height:       tree2Image.height
                color:        "white"
                border.width: treesRectangle.borderWidth
                border.color: "transparent"

                Image {
                    id:       tree2Image
                    width:    treesRectangle.itemWidth
                    height:   sourceSize.width !==0 && width !== 0 ? sourceSize.height / (sourceSize.width / width) : 0
                    source:   "../../images/" + treePage.imageDir + "/tree-2-bg.png"
                    fillMode: Image.PreserveAspectFit
                    smooth:   true

                    MouseArea {
                        id:           tree2MouseArea
                        anchors.fill: parent

                        onClicked: {
                            settingsPage.currentTreeNum = 2;

                            tree1Rectangle.border.color = "transparent";
                            tree2Rectangle.border.color = "red";
                            tree3Rectangle.border.color = "transparent";
                        }
                    }
                }
            }

            Rectangle {
                id:           tree3Rectangle
                x:            treesRectangle.borderWidth * 5 + treesRectangle.spacing * 2 + treesRectangle.itemWidth * 2
                y:            treesRectangle.borderWidth
                width:        tree3Image.width
                height:       tree3Image.height
                color:        "white"
                border.width: treesRectangle.borderWidth
                border.color: "transparent"

                Image {
                    id:       tree3Image
                    width:    treesRectangle.itemWidth
                    height:   sourceSize.width !==0 && width !== 0 ? sourceSize.height / (sourceSize.width / width) : 0
                    source:   "../../images/" + treePage.imageDir + "/tree-3-bg.png"
                    fillMode: Image.PreserveAspectFit
                    smooth:   true

                    MouseArea {
                        id:           tree3MouseArea
                        anchors.fill: parent

                        onClicked: {
                            settingsPage.currentTreeNum = 3;

                            tree1Rectangle.border.color = "transparent";
                            tree2Rectangle.border.color = "transparent";
                            tree3Rectangle.border.color = "red";
                        }
                    }
                }
            }
        }

        Rectangle {
            id:             volumeRectangle
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            anchors.right:  parent.right
            height:         volumeLabelImage.height
            color:          "transparent"

            Image {
                id:             volumeLabelImage
                anchors.bottom: parent.bottom
                anchors.left:   parent.left
                width:          48
                height:         48
                source:         "qrc:/resources/images/volume.png"
            }

            Slider {
                id:             volumeSlider
                anchors.bottom: parent.bottom
                anchors.left:   volumeLabelImage.right
                anchors.right:  parent.right
                height:         volumeLabelImage.height
                orientation:    Qt.Horizontal
                minimumValue:   0.0
                maximumValue:   1.0
                value:          0.5
                stepSize:       0.1

                onValueChanged: {
                    treePage.setVolume(value);
                }
            }
        }
    }

    ToolBar {
        id:             bottomToolBar
        anchors.bottom: parent.bottom
        z:              1

        tools: ToolBarLayout {
            ToolButton {
                id:         settingsOkToolButton
                iconSource: "qrc:/resources/images/ok.png"
                flat:       true

                onClicked: {
                    mainWindow.setSetting("BackgroundNum", settingsPage.currentBackgroundNum);
                    mainWindow.setSetting("TreeNum",       settingsPage.currentTreeNum);

                    treePage.setArtwork(settingsPage.currentBackgroundNum, settingsPage.currentTreeNum);

                    mainPageStack.replace(treePage);
                }
            }
        }
    }

    Component.onCompleted: {
        if ((screen.displayWidth === 360 && screen.displayHeight === 640) ||
            (screen.displayWidth === 640 && screen.displayHeight === 360)) {
            settingsPage.imageDir = "360x640";
        } else if ((screen.displayWidth === 480 && screen.displayHeight === 854) ||
                   (screen.displayWidth === 854 && screen.displayHeight === 480)) {
            settingsPage.imageDir = "480x854";
        } else {
            settingsPage.imageDir = "360x640";
        }
    }
}
