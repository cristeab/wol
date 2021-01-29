#!/bin/bash

QT_VER=6.0.0
QT_ROOT=$HOME/Qt/$QT_VER/clang_64

rm -rf build
mkdir build
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QT_ROOT
make -j

mkdir -p wol.app/Contents/Frameworks
cp -rf $QT_ROOT/lib/QtQuickControls2Impl.framework wol.app/Contents/Frameworks
make pack

