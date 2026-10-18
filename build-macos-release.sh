#!/bin/bash

set -e

QT_VER=6.12.0
QT_ROOT=$HOME/Qt/$QT_VER/macos

BUILD=build
rm -rf $BUILD

cmake -S . -B $BUILD \
    -G Ninja \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$QT_ROOT
cmake --build $BUILD --target all
cmake --build $BUILD --target pack
