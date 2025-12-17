#!/bin/bash

set -e

QT_VER=6.10.1
QT_ROOT=$HOME/Qt/$QT_VER/macos

rm -rf build

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QT_ROOT
cmake --build build --target all
cmake --build build --target pack
