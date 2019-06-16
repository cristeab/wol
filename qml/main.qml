import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

ApplicationWindow {
    visible: true
    width: 640
    height: 480

    Settings {
        id: settings
    }

    Column {
        id: header
        spacing: settings.verticalMargin
        anchors {
            top: parent.top
            topMargin: settings.verticalMargin
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: wolLabel
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Wake on LAN")
            font {
                bold: true
                pointSize: settings.headerPointSize
            }
        }
        Item {
            anchors.horizontalCenter: wolLabel.horizontalCenter
            height: settings.buttonHeight
            width: height
            Image {
                id: wolImg
                anchors.fill: parent
                source: "qrc:/img/cloud-on-off.svg"
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
            ColorOverlay {
                id: wolOverlay
                visible: true
                anchors.fill: wolImg
                source: wolImg
                color: settings.buttonPressedColor
            }
        }
    }
    Label {
        visible: 0 === listView.count
        anchors {
            top: header.bottom
            topMargin: settings.verticalMargin
            left: parent.left
            leftMargin: settings.horizontalMargin
            right: parent.right
            rightMargin: settings.horizontalMargin
        }
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pointSize: settings.textPointSize
        text: qsTr("Your MAC address list is empty.\nUse the add button above to add entries in this list.\nPress an item in the list to send a WOL packet.\nIn order to delete a list item swipe left, then press delete.")
    }
    ListView {
        id: listView
        anchors {
            top: header.bottom
            topMargin: settings.verticalMargin
            bottom: parent.bottom
        }
        clip: true
        boundsBehavior: ListView.StopAtBounds
        width: parent.width
        model: deviceList
        delegate: SwipeDelegate {
            id: delegateControl
            property bool blink: false
            width: parent.width
            height: settings.buttonHeight
            Row {
                id: delegateRow
                spacing: settings.horizontalMargin
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                Label {
                    width: 50
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: friendlyName
                    font.pointSize: settings.textPointSize
                    clip: true
                    elide: Text.ElideRight
                    color: delegateControl.blink ? settings.buttonPressedColor : settings.buttonReleasedColor
                }
                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text:  macAddress
                    font {
                        italic: true
                        pointSize: settings.textPointSize
                    }
                    clip: true
                    elide: Text.ElideRight
                    color: delegateControl.blink ? settings.buttonPressedColor : settings.buttonReleasedColor
                }
            }
            Rectangle {
                id: contentFrame
                property alias pressed: delegateControl.pressed
                color: "transparent"
                anchors {
                    left: delegateRow.left
                    leftMargin: -settings.horizontalMargin
                    right: delegateRow.right
                    rightMargin: -settings.horizontalMargin
                    verticalCenter: delegateRow.verticalCenter
                }
                height: delegateRow.height + settings.verticalMargin
                z: -1
                radius: 5
                border {
                    width: 1
                    color: contentFrame.pressed ? "lightgray" : "transparent"
                }
            }
            Timer {
                id: wolTimer
                property int count: 0
                interval: 500
                running: false
                triggeredOnStart: true
                repeat: true
                onTriggered: {
                    wolTimer.count += 1
                    if (wolTimer.count > 8) {
                        wolTimer.count = 0
                        wolTimer.running = false
                        delegateControl.blink = false
                    } else {
                        delegateControl.blink = !delegateControl.blink
                    }
                }
            }
            onClicked: {
                wolTimer.running = true
                deviceList.wol(macAddress)
            }
            //swipe gestures handling
            swipe.enabled: true
            ListView.onRemove: SequentialAnimation {
                PropertyAction {
                    target: delegateControl
                    property: "ListView.delayRemove"
                    value: true
                }
                NumberAnimation {
                    target: delegateControl
                    property: "height"
                    to: 0
                    easing.type: Easing.InOutQuad
                }
                PropertyAction {
                    target: delegateControl
                    property: "ListView.delayRemove"
                    value: false
                }
            }
            swipe.right: Rectangle {
                height: parent.height
                width: deleteLabel.width
                anchors.right: parent.right
                color: SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                Column {
                    SwipeDelegate.onClicked: listView.model.remove(index)
                    anchors.fill: parent
                    spacing: 0
                    Item {
                        height: 5
                        width: parent.width
                    }
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/2 - 6
                        width: height
                        source: "qrc:/img/trash-o.svg"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    Label {
                        id: deleteLabel
                        text: qsTr("Delete")
                        font.pointSize: settings.textPointSize
                        clip: true
                        elide: Text.ElideRight
                        verticalAlignment: Label.AlignVCenter
                        topPadding: 3
                        leftPadding: 12
                        rightPadding: 12
                    }
                }
            }
        }
    }
}
