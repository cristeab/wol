TARGET = wol
TEMPLATE = app
VERSION = 1.0.0

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
    DEFINES += QT_NO_WARNING_OUTPUT
    DEFINES += QT_NO_INFO_OUTPUT
}

CONFIG += c++14

QT += core quick svg

HEADERS += src/devicelist.h \
           src/qmlhelpers.h \
           src/wol.h

SOURCES += src/devicelist.cpp \
           src/wol.cpp \
           src/main.cpp

RESOURCES += qml.qrc

OTHER_FILES += CMakeLists.txt \
               Copyright.txt \
               README.md \
               build-macos-release.sh \
               build-ios-release.sh \
               tools/gen_icns.sh

QMAKE_TARGET_COMPANY = Bogdan C.
QMAKE_TARGET_PRODUCT = Wol
QMAKE_TARGET_DESCRIPTION = Wake on LAN
QMAKE_TARGET_COPYRIGHT = Bogdan Cristea

macx {
    ICON = img/wol.icns
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.12
    QMAKE_TARGET_BUNDLE_PREFIX = "com.cristeab"

    #QMAKE_INFO_PLIST = FocusMe.plist
}

ios {
    QMAKE_TARGET_BUNDLE_PREFIX = com
    QMAKE_BUNDLE = cristeab.wol
    QMAKE_DEVELOPMENT_TEAM = FAARUB626Q
    QMAKE_INFO_PLIST = ios/Info.plist
    ios_icon.files = $$files($$PWD/ios/iconset/Icon*.png) $$PWD/ios/iconset/iTunesArtwork.png $$PWD/ios/iconset/iTunesArtwork@2x.png
    QMAKE_BUNDLE_DATA += ios_icon
}
