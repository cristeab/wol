cmake_minimum_required(VERSION 3.1)

project(wol LANGUAGES NONE)

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
    add_custom_target(pack COMMAND ${CMAKE_PREFIX_PATH}/bin/macdeployqt ${CMAKE_PROJECT_NAME}.app -qmldir=${CMAKE_SOURCE_DIR}/qml -no-strip -dmg)
    include(CPack)
endif ()
