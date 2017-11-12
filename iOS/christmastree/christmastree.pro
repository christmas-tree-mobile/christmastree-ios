QT += quick sql multimedia purchasing
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS WEBRTC_POSIX

SOURCES += src/main.cpp
#    src/capturehelper.cpp

#OBJECTIVE_SOURCES += \
#    src/admobhelper.mm \
#    src/speechrecorder.mm

#HEADERS += \
#    src/capturehelper.h

RESOURCES += \
    qml.qrc \
    resources.qrc \
    translations.qrc

#TRANSLATIONS += \
#    translations/christmastree_ru.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
}

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
