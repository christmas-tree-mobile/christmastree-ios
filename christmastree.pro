TEMPLATE = app
TARGET = christmastree.4kids

QT += quick quickcontrols2 sql multimedia
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII

SOURCES += \
    src/contextguard.cpp \
    src/gifcreator.cpp \
    src/main.cpp

OBJECTIVE_SOURCES += \
    src/sharehelper.mm \
    src/storehelper.mm

HEADERS += \
    src/contextguard.h \
    src/gif.h \
    src/gifcreator.h \
    src/sharehelper.h \
    src/storehelper.h

RESOURCES += \
    qml.qrc \
    resources.qrc \
    translations.qrc

TRANSLATIONS += \
    translations/christmastree_de.ts \
    translations/christmastree_es.ts \
    translations/christmastree_fr.ts \
    translations/christmastree_it.ts \
    translations/christmastree_ru.ts \
    translations/christmastree_zh.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    CONFIG += qtquickcompiler

    INCLUDEPATH += $$PWD/ios/frameworks
    DEPENDPATH += $$PWD/ios/frameworks

    LIBS += -F $$PWD/ios/frameworks \
            -framework UIKit \
            -framework StoreKit

    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
}
