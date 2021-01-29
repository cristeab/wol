pragma Singleton

import QtQuick 2.14

QtObject {
    readonly property bool isIOs: "ios" === Qt.platform.os
    readonly property bool isMacOs: "osx" === Qt.platform.os

    readonly property int verticalMargin: 20
    readonly property int horizontalMargin: 10
    readonly property int buttonHeight: 50
    readonly property int headerPointSize: 18
    readonly property int textPointSize: 14

    readonly property color buttonPressedColor: "#a9ffff"
    readonly property color buttonReleasedColor: "white"
    readonly property color swipeRemoveItemColor: "tomato"
    readonly property color swipeEditItemColor: "blue"

    readonly property int dialogWidth: 400
    readonly property int dialogHeight: 200
}
