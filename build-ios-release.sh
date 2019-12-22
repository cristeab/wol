#!/bin/bash

QT_VER=5.14.0
QT_ROOT=$HOME/Qt/$QT_VER/ios

rm -rf build
mkdir build
cd build

$QT_ROOT/bin/qmake ../wol.pro CONFIG+=release DESTDIR=build
make -j
