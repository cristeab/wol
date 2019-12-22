TARGET = wol
TEMPLATE = app
VERSION = 1.0.0.0

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
               README.md

