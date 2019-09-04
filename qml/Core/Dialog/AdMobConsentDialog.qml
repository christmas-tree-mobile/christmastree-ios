import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "../../Util.js" as UtilScript

Popup {
    id:               adMobConsentDialog
    anchors.centerIn: Overlay.overlay
    padding:          0
    modal:            true
    closePolicy:      Popup.NoAutoClose

    signal personalizedAdsSelected()
    signal nonPersonalizedAdsSelected()

    background: Rectangle {
        color: "transparent"

        Image {
            id:           backgroundImage
            anchors.fill: parent
            source:       "qrc:/resources/images/dialog/admob_consent_dialog.png"
            fillMode:     Image.PreserveAspectFit
        }
    }

    contentItem: Rectangle {
        implicitWidth:  UtilScript.pt(backgroundImage.sourceSize.width)
        implicitHeight: UtilScript.pt(backgroundImage.sourceSize.height)
        color:          "transparent"

        ColumnLayout {
            anchors.fill:         parent
            anchors.topMargin:    UtilScript.pt(20)
            anchors.bottomMargin: UtilScript.pt(20)
            anchors.leftMargin:   UtilScript.pt(10)
            anchors.rightMargin:  UtilScript.pt(10)
            spacing:              UtilScript.pt(8)

            Text {
                text:                qsTr("We keep this app free by showing ads. Ad network will <a href=\"https://policies.google.com/technologies/ads\">collect data and use a unique identifier on your device</a> to show you ads. <b>Do you allow to use your data to tailor ads for you?</b>")
                color:               "black"
                font.pointSize:      16
                font.family:         "Helvetica"
                horizontalAlignment: Text.AlignJustify
                verticalAlignment:   Text.AlignVCenter
                wrapMode:            Text.Wrap
                fontSizeMode:        Text.Fit
                minimumPointSize:    8
                textFormat:          Text.StyledText
                Layout.fillWidth:    true
                Layout.fillHeight:   true

                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }

            Rectangle {
                width:            UtilScript.pt(280)
                height:           UtilScript.pt(48)
                color:            "dodgerblue"
                radius:           UtilScript.pt(8)
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Text {
                    anchors.fill:        parent
                    anchors.margins:     UtilScript.pt(2)
                    text:                qsTr("Yes, show me relevant ads")
                    color:               "white"
                    font.pointSize:      16
                    font.family:         "Helvetica"
                    font.bold:           true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    wrapMode:            Text.NoWrap
                    fontSizeMode:        Text.Fit
                    minimumPointSize:    8
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        adMobConsentDialog.personalizedAdsSelected();
                        adMobConsentDialog.close();
                    }
                }
            }

            Rectangle {
                width:            UtilScript.pt(280)
                height:           UtilScript.pt(48)
                color:            "dodgerblue"
                radius:           UtilScript.pt(8)
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Text {
                    anchors.fill:        parent
                    anchors.margins:     UtilScript.pt(2)
                    text:                qsTr("No, show me ads that are less relevant")
                    color:               "white"
                    font.pointSize:      16
                    font.family:         "Helvetica"
                    font.bold:           true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    wrapMode:            Text.NoWrap
                    fontSizeMode:        Text.Fit
                    minimumPointSize:    8
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        adMobConsentDialog.nonPersonalizedAdsSelected();
                        adMobConsentDialog.close();
                    }
                }
            }
        }
    }
}
