#!/bin/bash

MAJOR_VERSION=1.0
MINOR_VERSION=$(git rev-list --count HEAD)

QT_VER=5.14.0
QT_ROOT=$HOME/Qt/$QT_VER/clang_64
echo "QT version $QT_VER"

rm -rf build
mkdir build
cd build

$QT_ROOT/bin/qmake ../wol.pro -spec macx-clang CONFIG+=release CONFIG+=x86_64 DESTDIR=build DEFINES += APP_VERSION=\\\"${MAJOR_VERSION}.${MINOR_VERSION}\\\"
make -j

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QT_ROOT
make pack

