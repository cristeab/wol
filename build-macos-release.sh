#!/bin/bash

QT_VER=6.0.0
QT_ROOT=$HOME/Qt/$QT_VER/clang_64

rm -rf build
mkdir build
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$HOME/Qt/$QT_VER/clang_64
make -j

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QT_ROOT
make pack

