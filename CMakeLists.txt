cmake_minimum_required(VERSION 3.30)

project(wol LANGUAGES CXX)
set(PROJECT_VERSION "1.0")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package (Qt6 COMPONENTS
    Core
    Qml
    Quick
    Svg
    Widgets
    REQUIRED)

file (GLOB_RECURSE SRCS src/*.cpp)
qt6_add_resources (RSCS qml.qrc)

add_executable ("${PROJECT_NAME}" MACOSX_BUNDLE ${SRCS} ${RSCS} "${CMAKE_SOURCE_DIR}/img/wol.icns")
set_source_files_properties ("${CMAKE_SOURCE_DIR}/img/wol.icns"
    PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.cristeab.wol"
    MACOSX_BUNDLE_INFO_STRING "Wake on LAN"
    MACOSX_BUNDLE_ICON_FILE "wol.icns"
    MACOSX_BUNDLE_BUNDLE_NAME "Wake on LAN"
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
    MACOSX_BUNDLE_LONG_VERSION_STRING ${PROJECT_VERSION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_COPYRIGHT "Copyright 2021 Bogdan Cristea. All rights reserved")
target_link_libraries (${PROJECT_NAME}
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
    Qt6::Svg
    Qt6::Widgets)

#installer setup
if (CMAKE_BUILD_TYPE MATCHES "^[Rr]elease")
    set(CPACK_PACKAGE_NAME "Wake on LAN")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Wake on LAN")
    set(CPACK_PACKAGE_DESCRIPTION_FILE ${CMAKE_SOURCE_DIR}/Copyright.txt)
    set(CPACK_PACKAGE_VERSION ${SOFTPHONE_VERSION})
    set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/README.md)
    set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/Copyright.txt)
    set(CPACK_PACKAGE_CONTACT "cristeab@gmail.com")
    set(CPACK_STRIP_FILES ${CMAKE_PROJECT_NAME})
    add_custom_target(pack COMMAND ${CMAKE_PREFIX_PATH}/bin/macdeployqt ${PROJECT_NAME}.app -qmldir=${CMAKE_SOURCE_DIR}/qml -no-strip -dmg)
    include(CPack)
endif ()
