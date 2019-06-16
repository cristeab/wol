import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    Column {
        id: header
        spacing: 20
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: wolLabel
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Wake on LAN")
            font {
                bold: true
                pointSize: 18
            }
        }
        Item {
            anchors.horizontalCenter: wolLabel.horizontalCenter
            height: 50
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
                visible: false
                anchors.fill: wolImg
                source: wolImg
                color: "#80a9ffff"
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
                    } else {
                        wolOverlay.visible = !wolOverlay.visible
                    }
                }
            }
        }
    }
    ListView {
        anchors {
            top: header.bottom
            topMargin: 20
            bottom: parent.bottom
        }
        clip: true
        boundsBehavior: ListView.StopAtBounds
        width: parent.width
        model: deviceList
        delegate: Item {
            width: parent.width
            height: 50
            Row {
                id: delegateRow
                spacing: 10
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                Label {
                    width: 50
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: friendlyName
                    font.pointSize: 14
                }
                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text:  macAddress
                    font {
                        italic: true
                        pointSize: 14
                    }
                }
            }
            Rectangle {
                id: contentFrame
                property alias pressed: delegateMouseArea.pressed
                color: "transparent"
                anchors {
                    left: delegateRow.left
                    leftMargin: -10
                    right: delegateRow.right
                    rightMargin: -10
                    verticalCenter: delegateRow.verticalCenter
                }
                height: delegateRow.height + 20
                z: -1
                radius: 5
                border {
                    width: 1
                    color: contentFrame.pressed ? "lightgray" : "transparent"
                }
            }
            MouseArea {
                id: delegateMouseArea
                anchors.fill: parent
                onClicked: {
                    wolTimer.running = true
                    deviceList.wol(macAddress)
                }
            }
        }
    }
}
