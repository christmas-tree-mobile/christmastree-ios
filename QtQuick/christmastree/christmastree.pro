TARGET = ChristmasTree
VERSION = 1.1.0

TEMPLATE = app
QT += core gui declarative
CONFIG += qt-components mobility
MOBILITY += multimedia

SOURCES += main.cpp \
    csapplication.cpp \
    capturehelper.cpp
HEADERS += \
    csapplication.h \
    capturehelper.h
RESOURCES += \
    christmastree.qrc
OTHER_FILES += \
    doc/help.html \
    images/snowflake-1.png \
    images/snowflake-2.png \
    images/snowflake-3.png \
    images/snowflake-4.png \
    images/help.png \
    images/settings.png \
    images/toys.png \
    images/toys-pressed.png \
    images/volume.png \
    images/capture.png \
    images/exit.png \
    images/ok.png \
    images/dialog_info.png \
    images/dialog_error.png \
    icon.png \
    icon.svg

symbian: {
    DEFINES += SYMBIAN_TARGET

    #TARGET.UID3 = 0xE29A4776
    TARGET.UID3 = 0x2004B229
    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x020000 0x8000000

    ICON = icon.svg

    # SIS header: name, uid, version
    packageheader = "$${LITERAL_HASH}{\"ChristmasTree\"}, (0x2004B229), 1, 1, 0, TYPE=SA"
    # Vendor info: localised and non-localised vendor names
    vendorinfo = "%{\"Oleg Derevenetz\"}" ":\"Oleg Derevenetz\""

    my_deployment.pkg_prerules = packageheader vendorinfo
    DEPLOYMENT += my_deployment

    # SIS installer header: uid
    DEPLOYMENT.installer_header = 0x2002CCCF
}

contains(MEEGO_EDITION,harmattan) {
    DEFINES += MEEGO_TARGET

    target.path = /opt/christmastree/bin

    launchericon.files = christmastree.svg
    launchericon.path = /usr/share/themes/base/meegotouch/icons/

    INSTALLS += target launchericon
}

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# QML deployment
folder_qml.source = qml/christmastree
folder_qml.target = qml
DEPLOYMENTFOLDERS = folder_qml

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

contains(MEEGO_EDITION,harmattan) {
    desktopfile.files = christmastree.desktop
    desktopfile.path = /usr/share/applications
    INSTALLS += desktopfile
}
