#!/bin/bash

QT_VER=5.14.0
QT_ROOT=$HOME/Qt/$QT_VER/clang_64

rm -rf build
mkdir build

$QT_ROOT/bin/qmake wol.pro -spec macx-clang CONFIG+=release CONFIG+=x86_64 DESTDIR=build

